//
//  ChannelSelectingViewController.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 1. 20..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

private let cellReuseIdentifier = "channelSection"


class ChannelSelectingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var channelTableView: UITableView!
    
    let channels2: [String : [String]] = [
        "뮤지컬" : ["뮤지컬 팬텀", "삼총사", "뮤지컬 엘리자벳", "록키호러쇼", "위키드", "뮤지컬 팬텀", "삼총사", "뮤지컬 엘리자벳", "록키호러쇼", "위키드"],
        "야구" : ["넥센 히어로즈", "삼성 라이온즈", "두산 베어스", "한화 이글스", "엘지 트윈스", "넥센 히어로즈", "삼성 라이온즈", "두산 베어스", "한화 이글스", "엘지 트윈스"],
        "대학" : ["고려대학교", "국민대학교", "서울대학교", "연세대학교", "조선대학교", "홍익대학교", "이화여자대학교", "서강대학교", "중앙대학교", "인하대학교"],
        "뷰티" : ["이니스프리", "아모레퍼시픽", "미미박스", "더페이스샵", "후", "샤넬", "에뛰드하우스", "입생로랑"]
    ]
    
    let channels: [String : [ChannelID]] = [
        "뮤지컬" : [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        "야구" : [11, 12, 13, 14, 15, 16, 17, 18, 19, 20],
        "대학" : [21, 22, 23, 24, 25, 26, 27, 28, 29, 30],
        "뷰티" : [31, 32, 33, 34, 35, 36, 37, 38, 39, 40]
        //,"축제" : [41, 42, 43, 44, 45, 46, 47, 48, 49, 50]
    ]
    
    var channelStore : [Channel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        channelTableView.delegate = self
        channelTableView.dataSource = self
        channelTableView.register(UINib.init(nibName: "ChannelTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        channelTableView.rowHeight = channelCollectionViewCellHeight + channelTableViewCellPadding * 2
        channelTableView.allowsSelection = false
        
        for section in 0..<channels.keys.count {
            for id in Array(channels.values)[section] {
                EventDataController.shared.getChannel(withID: id, completion: { (channel) in
                    self.channelStore.append(channel)
                    
                    if let cell = self.channelTableView.cellForRow(at: IndexPath(row: section, section: 0)) as? ChannelTableViewCell {
                        cell.channels.append(channel)
                        cell.collectionView.reloadData()//insertItems(at: [IndexPath(item: cell.collectionView.numberOfItems(inSection: 0) - 1 , section: 0 )])
                    }
                    self.channelTableView.reloadData()
                })
            }
        }
        
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
    // MARK: _ TableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChannelTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ChannelTableViewCell
        cell.channels = []
        cell.collectionView.reloadData()
        cell.allowsMultipleSelection = true
        for id in Array(channels.values)[indexPath.section] {
            let filtered = self.channelStore.filter({ (channel) -> Bool in
                return channel.id == id
            })
            cell.channels.append(contentsOf: filtered)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(channels.keys)[section]
    }
    
    // MARK: _ TableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
}
