//
//  LDEventViewController.swift
//  Pastel
//
//  Created by 박종훈 on 2017. 2. 11..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit
import EventKitUI

class LDEventViewController: EKEventViewController {

    override func viewDidLoad() {
        self.navigationController?.view.backgroundColor = .white
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = UIRectEdge.bottom
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: true)
        super.viewWillDisappear(animated)
    }
}
