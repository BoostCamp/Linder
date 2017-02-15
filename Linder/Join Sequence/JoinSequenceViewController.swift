//
//  JoinSequenceViewController.swift
//  Pastel
//
//  Created by 박종훈 on 2017. 2. 15..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

class JoinSequenceViewController: UIViewController {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containedPageViewController: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func curlToNext(_ sender: Any) {
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let joinPageViewController = segue.destination as? JoinPageViewController {
            if segue.identifier == "curlToNextPage" {
                if let currentViewController = joinPageViewController.presentingViewController {
                    if let nextViewController = joinPageViewController.pageViewController(joinPageViewController, viewControllerAfter: currentViewController) {
                        joinPageViewController.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
                    } else {
                        performSegue(withIdentifier: "toMain", sender: self)
                    }
                }
            }
            joinPageViewController.pageControlDelegate = self
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension JoinSequenceViewController: UIPageViewControllerPageControl {
    
    func joinPageViewController(_ joinPageViewController: JoinPageViewController,
                                didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    
    func joinPageViewController(_ joinPageViewController: JoinPageViewController,
                                didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
}

//class
