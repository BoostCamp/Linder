//
//  JoinSequencePageViewController.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 2. 6..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

class JoinSequencePageViewController: UIPageViewController {
    
    weak var pageControlDelegate: UIPageViewControllerPageControl?

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newViewController(ID: "AgeAndGender"),
                self.newViewController(ID: "Interest"),
                self.newViewController(ID: "Region"),
                self.newViewController(ID: "Channel"),]
    }()
    
    private func newViewController(ID: String) -> UIViewController {
        return UIStoryboard(name: "JoinSequence", bundle: nil) .
            instantiateViewController(withIdentifier: ID)
    }
}

extension JoinSequencePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            debugPrint("ERROR!!: Current Join Sequence Page Index not found")
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            debugPrint("Join Sequence Ended. Move To Main")
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            debugPrint("ERROR!! : Request Join Sequence Page Out Of Index")
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    // Belows are for presenting indication in this page view controller's view
//    // The number of items reflected in the page indicator.
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return orderedViewControllers.count
//    }
//    
//    // The selected item reflected in the page indicator.
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        guard let firstViewController = viewControllers?.first,
//            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
//                return 0
//        }
//        
//        return firstViewControllerIndex
//    }
}

extension JoinSequencePageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.index(of: firstViewController) {
            pageControlDelegate?.joinSequencePageViewController(self,
                                                         didUpdatePageIndex: index)
        }
    }
    
}

extension JoinSequencePageViewController: UIPageViewControllerPageCurl {
    
    func nextButtonTouched(in parentViewController: JoinSequenceViewController) {
        if let currentViewController = self.viewControllers?.last {
            if let nextViewController = self.pageViewController(self, viewControllerAfter: currentViewController) {
                self.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    func nextButtonTitle(in parentViewController: JoinSequenceViewController) -> String {
        if let currentViewController = self.viewControllers?.last {
            if self.pageViewController(self, viewControllerAfter: currentViewController) != nil {
                return "다음"
            }
        }
        return "완료"
    }

}

protocol UIPageViewControllerPageControl: NSObjectProtocol {
    
    /**
     Called when the number of pages is updated.
     
     - parameter joinSequencePageViewController: the JoinSequencePageViewController instance
     - parameter count: the total number of pages.
     */
    func joinSequencePageViewController(_ joinSequencePageViewController: JoinSequencePageViewController,
                                    didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter joinSequencePageViewController: the JoinSequencePageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func joinSequencePageViewController(_ joinSequencePageViewController: JoinSequencePageViewController,
                                    didUpdatePageIndex index: Int)
    
}
