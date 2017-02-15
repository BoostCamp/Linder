//
//  SearchViewController.swift
//  Linder
//
//  Created by 박종훈 on 2017. 2. 6..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit
import EventKit

fileprivate let channelsCellID: String = "channelsCell"
fileprivate let calendarCellID: String = "calendarCell"
fileprivate let scheduleCellID: String = "scheduleCell"

fileprivate let segueToEventDetail: String = "toEventDetail"

enum SearchScope: String {
    case all = "전체"
    case channel = "채널"
    case event = "캘린더"
    case schedule = "일정"
    
    static let allScopes = [all, channel, event, schedule]
    static let rawValues: [String] = allScopes.map { (scope) -> String in
        return scope.rawValue
    }
}

enum SearchMode {
    case normal, searching , searched
}

// TODO : Come back to not search mode, hide scope bar

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var scopeControl: UISegmentedControl!
    @IBOutlet weak var maskingView: UIView!
    
    var _searchMode: SearchMode = .normal
    var searchMode: SearchMode {
        get { return _searchMode }
        set (newMode) {
            _searchMode = newMode
            switch newMode {
            case .normal:
                maskingView.isHidden = true
                scopeControl.isHidden = true
            case .searching:
                maskingView.isHidden = false
                scopeControl.isHidden = true
            case .searched:
                maskingView.isHidden = true
                scopeControl.isHidden = false
            }
        }
    }
    
    var scope: SearchScope = .all
    
    let eventDC = EventDataController.shared

    var recommandedChannels: [String] = ["뮤지컬 팬텀", "삼총사", "뮤지컬 엘리자벳", "록키호러쇼", "위키드", "넥센 히어로즈", "삼성 라이온즈", "예시 채넣", "한화 이글스", "엘지 트윈스"]
    var searchedChannels: [String] = []
    
    var recommandedEvents: [Event] = []
    var searchedEvents: [Event] = []
    
    var schedules: [Schedule] = []
    var searchedSchedules: [Schedule] = []
    
    // For Event add
    var ldEventStore: EKEventStore?
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Table View
        self.tableView.register(UINib(nibName: "ChannelTableViewCell", bundle: nil), forCellReuseIdentifier: channelsCellID)
        self.tableView.register(UINib(nibName: "CalendarTableViewCell", bundle: nil), forCellReuseIdentifier: calendarCellID)
        self.tableView.register(UINib(nibName: "ScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: scheduleCellID)

        // Setup the searchField
        self.searchField.delegate = self
        
        // Navigation bar revise
        guard let navigationController = self.navigationController else {
            debugPrint("view will appear guard else")
            return
        }
        navigationController.navigationBar.shadowImage = #imageLiteral(resourceName: "TransparentPixel")
        navigationController.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "Pixel"), for: .default)
        
        // Search icon resize
        let itemToNavigationRatio: CGFloat = 0.6
        
        let navigationBarHeight = navigationController.navigationBar.frame.size.height
        let postItemHeight = itemToNavigationRatio * navigationBarHeight
        
        let preImage = self.navigationItem.leftBarButtonItem?.image
        let postImage = preImage?.resize(newHeight: postItemHeight)
        
        self.navigationItem.leftBarButtonItem?.image = postImage?.withRenderingMode(.alwaysOriginal)
        
        // Scope Control appearence
        scopeControl.setBackgroundImage(nil, for: .normal, barMetrics: .default)
        scopeControl.setBackgroundImage(nil, for: .selected, barMetrics: .default)
        
        let selectedTitleAttributes = [
            NSForegroundColorAttributeName : UIColor.ldPuple,
            NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue // TODO : background 로 구현
            ] as [String : Any]
        
        let normalTitleAttributes = [
            NSForegroundColorAttributeName : UIColor.ldPupleLight,
            NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue // TODO : background 로 구현
            ] as [String : Any]
        
        scopeControl.setTitleTextAttributes(selectedTitleAttributes, for: .selected)
        scopeControl.setTitleTextAttributes(normalTitleAttributes, for: .normal)
        scopeControl.isHidden = true
        
        // Load Recommand Data
        recommandedEvents = eventDC.getRecommandedEvents()
        schedules = eventDC.schedules
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndex = tableView.indexPathForSelectedRow {
            let cell = tableView.cellForRow(at: selectedIndex)
            cell?.setSelected(false, animated: true)
        }
        
        self.maskingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.endSearch)))
        self.maskingView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchMode == .searched ? 3 : 2 // one for updated channel, the other for recommanded calendars
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchMode == .searched {
            switch scope {
            case .all :
                return SearchScope.rawValues[section + 1]
            default :
                return nil
            }
        } else {
            let sectionTitles = ["최근 업데이트", "추천 캘린더"]
            return sectionTitles[section]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 : // for channels
            if searchMode == .normal {
                return recommandedChannels.isEmpty ? 0 : 1
            }
            if [SearchScope.all, SearchScope.channel].contains(scope) {
                return searchedChannels.isEmpty ? 0 : 1
            }
            return 0
        case 1 : // for calendars
            if searchMode == .searched {
                if [SearchScope.all, SearchScope.event].contains(scope) { return searchedEvents.count }
                return 0
            }
            return recommandedEvents.count
        case 2 : // for searched schedule
            if searchMode == .searched && [SearchScope.all, SearchScope.schedule].contains(scope) { return searchedSchedules.count }
            return 0
        default :
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 : // for channels
            let channels = searchMode == .searched ? searchedChannels : recommandedChannels
            let cell = tableView.dequeueReusableCell(withIdentifier: channelsCellID, for: indexPath) as! ChannelTableViewCell
            
            // TODO : set Data Source For inner collectionView
            cell.channels = channels.map({ (title) -> Channel in
                Channel(title: title, thumbnail: #imageLiteral(resourceName: "channel"))
            })
            cell.allowsMultipleSelection = false
            cell.containerVC = self
            return cell
            
        case 1 : // for calendars
            let cell = tableView.dequeueReusableCell(withIdentifier: calendarCellID, for: indexPath) as! CalendarTableViewCell
            let event = (searchMode == .searched) ? searchedEvents[indexPath.row] : recommandedEvents[indexPath.row]
            cell.eventNameLabel.text = event.title
            if let startDate = event.startDate {
                cell.startDateLabel.text = String(date: startDate)
            }
            if let endDate = event.endDate {
                cell.endDateLabel.text = String(date: endDate)
            }
            cell.locationLabel.text = String(locationList: event.locationList)
            
            return cell
            
        default : // for schedules
            let cell = tableView.dequeueReusableCell(withIdentifier: scheduleCellID, for: indexPath) as! ScheduleTableViewCell
            // TODO : Set Schedule cell
            cell.schedule = searchedSchedules[indexPath.row]

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.scope == .all || self.searchMode == .normal { return 32 }
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0 : // for channels
            return channelCollectionViewCellHeight + channelTableViewCellPadding * 2
        case 1 : // for calendars
            return calendarTableViewCellHeight
        default : // for events
            return scheduleTableViewCellHeight
        }
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0 : // channel cell
            return false
        default:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1, 2:
            performSegue(withIdentifier: segueToEventDetail, sender: self)
        default:
            assert(true, "only calendar section can be selected")
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueID = segue.identifier else {
            return
        }
        switch segueID {
        case segueToEventDetail :
            let destinationVC = segue.destination as! EventDetailViewController
            let selectedCellIndex = self.tableView.indexPathForSelectedRow
            if let selectedCell = self.tableView.cellForRow(at: selectedCellIndex!) as? CalendarTableViewCell {
                destinationVC.eventID = selectedCell.event.id
            }
            if let selectedCell = self.tableView.cellForRow(at: selectedCellIndex!) as? ScheduleTableViewCell {
                destinationVC.eventID = (selectedCell.schedule?.eventID) ?? .empty
            }
            
        default:
            return
        }
    }
    
    func updateSearchTable(_ text: String = "", scope: SearchScope = .all) {
        getSearchResult(text: text, scope: scope)
        self.tableView.reloadData()
        if (scope == .all || scope == .channel) { //&& !searchedChannels.isEmpty {
            if let channelCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ChannelTableViewCell {
                channelCell.channelCollectionView.reloadData()
            }
            
        }
    }
    
    func getSearchResult(text: String, scope: SearchScope) {
        // TODO : 검색어 결과를 dict key : 검색어 value: 검색결과 로 두고 scope만 바꾸었을 때는 따로 불러 들이지 않도록.
        switch scope {
        case .all :
            getSearchResult(text: text, scope: .channel)
            getSearchResult(text: text, scope: .event)
            getSearchResult(text: text, scope: .schedule)
        case .channel :
            // TODO :
            searchedChannels = recommandedChannels.filter({( channel : String) -> Bool in
                return channel.lowercased().contains(text.lowercased())
            })
            break
        case .event :
            searchedEvents = recommandedEvents.filter({ (event : Event) -> Bool in
                return event.title.lowercased().contains(text.lowercased())
            })
            break
        case .schedule :
            searchedSchedules = schedules.filter({ (schedule : Schedule) -> Bool in
                return schedule.name.lowercased().contains(text.lowercased())
            })
            break
        }
    }
    
    @IBAction func scopeChanged(_ sender: Any) {
        let scopeIndex = self.scopeControl.selectedSegmentIndex
        guard let scopeText = self.scopeControl.titleForSegment(at: scopeIndex) else {
            return print("Scope with no title")
        }
        scope = SearchScope(rawValue: scopeText)!
        updateSearchTable(searchField.text!, scope: scope)
    }
    
    @IBAction func filterTouched(_ sender: Any) {
        // temp
        self.searchMode = .normal
        self.searchField.resignFirstResponder()
        self.updateSearchTable(scope: .all)
    }
    
    func endSearch() {
        self.searchField.resignFirstResponder()
        self.searchMode = (self.tableView.numberOfSections == 2) ? .normal : .searched
    }
}

extension SearchViewController: UITextFieldDelegate {
    // MARK: - UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMode = .searched
        updateSearchTable(textField.text!, scope: scope)
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchMode = .searching
        //self.scopeControl.center.y += 10
        //TODO : on click masking view. go to normal mode
        //TODO : Show category bar
        return true
    }
}
