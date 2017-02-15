//
//  JoinPageViewController.swift
//  Linder
//
//  Created by 박종훈 on 2017. 2. 6..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import UIKit

class JoinPageViewController: UIPageViewController {
    
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
        return [self.newViewController(ID: "Interest"),
                self.newViewController(ID: "Channel")]
    }()
    
    private func newViewController(ID: String) -> UIViewController {
        return UIStoryboard(name: "JoinSequence", bundle: nil) .
            instantiateViewController(withIdentifier: ID)
    }
}

extension JoinPageViewController: UIPageViewControllerDataSource {
    
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
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
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

extension JoinPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.index(of: firstViewController) {
            pageControlDelegate?.joinPageViewController(self,
                                                         didUpdatePageIndex: index)
        }
    }
    
}

protocol UIPageViewControllerPageControl: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter joinPageViewController: the JoinPageViewController instance
     - parameter count: the total number of pages.
     */
    func joinPageViewController(_ joinPageViewController: JoinPageViewController,
                                    didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter joinPageViewController: the JoinPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func joinPageViewController(_ joinPageViewController: JoinPageViewController,
                                    didUpdatePageIndex index: Int)
    
}
