//
//  JoinSequenceViewController.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 2. 15..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

// TODO : Title or tab bar indicator or arrow indicator should be added

import UIKit

fileprivate let segueToMainID = "toMain"

class JoinSequenceViewController: UIViewController {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containedPageViewController: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    weak var pageCurlDelegate: UIPageViewControllerPageCurl?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func curlToNext(_ sender: UIButton) {
        // TODO : indicatore is not updated.
        if sender.currentTitle == "다음" {
            pageCurlDelegate?.nextButtonTouched(in: self)
            self.nextButton.setTitle(pageCurlDelegate?.nextButtonTitle(in: self), for: .normal)
        }
            // "완료"
        else {
            performSegue(withIdentifier: segueToMainID, sender: self)
        }
        
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let joinSequencePageViewController = segue.destination as? JoinSequencePageViewController {
            joinSequencePageViewController.pageControlDelegate = self
            self.pageCurlDelegate = joinSequencePageViewController
        }
    }
}

extension JoinSequenceViewController: UIPageViewControllerPageControl {
    
    func joinSequencePageViewController(_ joinSequencePageViewController: JoinSequencePageViewController,
                                didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    
    func joinSequencePageViewController(_ joinSequencePageViewController: JoinSequencePageViewController,
                                didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
}

protocol UIPageViewControllerPageCurl: NSObjectProtocol {
    
    /**
     Called when the next button touched
     
     - parameter parentViewController: the JoinSequenceViewController instance
     */
    func nextButtonTouched(in parentViewController: JoinSequenceViewController)
    
    /**
     Called when the next button tilte to be set
     
     - parameter parentViewController: the JoinSequenceViewController instance
     */
    func nextButtonTitle(in parentViewController: JoinSequenceViewController) -> String
}
