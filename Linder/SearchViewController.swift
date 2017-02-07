//
//  SearchViewController.swift
//  Linder
//
//  Created by 박종훈 on 2017. 2. 7..
//  Copyright © 2017년 Linder. All rights reserved.
//

import UIKit

fileprivate let channelsCellReuseIdentifier: String = "channelsCell"
fileprivate let calendarCellReuseIdentifier: String = "calendarCell"

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var recommandedEvents: [Event] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        // one for updated channel, the other for recommanded calendars
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitles = ["최근 업데이트", "추천 캘린더"]
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 : // for updated channels
            return 1
        default : // for recommanded calendars
            return recommandedEvents.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 : // for updated channels
            let cell = tableView.dequeueReusableCell(withIdentifier: channelsCellReuseIdentifier, for: indexPath)
            return cell
            
            
        default : // for recommanded calendars
            let cell = tableView.dequeueReusableCell(withIdentifier: calendarCellReuseIdentifier, for: indexPath)
            let event = recommandedEvents[indexPath.row]
            return cell
        }
    }

}
