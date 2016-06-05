//
//  ViewController.swift
//  testScroll
//
//  Created by Kyle Kirkland on 6/4/16.
//  Copyright © 2016 KirklandCreative. All rights reserved.
//

import UIKit

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var secretScrollView: UIScrollView!
    
    @IBOutlet weak var tableViewTopSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchBarExpanded = false
    
    var refreshControl: UIRefreshControl?
    
    var isScrolling = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.refresh(_:)), forControlEvents: .ValueChanged)
        //tableView.tableHeaderView = refreshControl
        tableView.addSubview(refreshControl)
        var frame = refreshControl.frame
        frame.origin.y += 44.0
        refreshControl.frame = frame
        self.refreshControl = refreshControl
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
       // self.secretScrollView.delegate = self;
        self.secretScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, self.tableView.contentSize.height)
        //self.tableView.addGestureRecognizer(self.secretScrollView.panGestureRecognizer)
        //self.tableView.panGestureRecognizer.enabled = false
        
        self.secretScrollView.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        isScrolling = true
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        
        delay(2.0) {
            self.refreshControl?.endRefreshing()
        }
     /*   var frame = refreshControl.frame
        frame.origin.y += 44.0
        refreshControl.frame = frame*/
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
       // if (scrollView == secretScrollView) { //ignore collection view scrolling callbacks
            let contentOffset = scrollView.contentOffset;
           // let collOffset = self.tableView.contentOffset;
            
            if searchBarExpanded {
                
                var inset = self.tableView.contentInset
                print(inset.top)

                if inset.top < 44.0 {
                   // let refreshControl = UIRefreshControl()
                    //refreshControl.addTarget(self, action: #selector(ViewController.refresh(_:)), forControlEvents: .ValueChanged)
                      inset.top = 44.0
                     self.tableView.contentInset = inset
                    // self.secretScrollView.contentInset = inset
                    //tableView.addSubview(refreshControl)
                   // self.refreshControl = refreshControl
                }
                
                if contentOffset.y <= 0 {
                    
                    if !isScrolling && self.tableView.contentInset.top == 0.0 {
                        let newOffset = CGPointMake(0, min(-44.0, contentOffset.y))
                        tableView.contentOffset = newOffset
                        return
                    } else if !isScrolling && self.tableView.contentInset.top == 44.0  {
                        let newOffset = CGPointMake(0, min(0.0, contentOffset.y))
                        tableView.contentOffset = newOffset
                        return
                    }
                    
                    if contentOffset.y > -44.0 {
                        print("Search expanded greater than 44.0")
                        let progress = abs(contentOffset.y) / 44.0
                        let searchTranslate = min(44, 44*(progress))
                        self.searchBar.transform = CGAffineTransformMakeTranslation(0, searchTranslate)
                        
                        if progress <= 0.0 {
                            searchBarExpanded = false
                            return
                        }

                    }
                    
                } else {
                    if searchBarExpanded {
                        self.searchBar.transform = CGAffineTransformIdentity
                        searchBarExpanded = false
                    }
                }
                
                let offSetY = contentOffset.y
                tableView.contentOffset = contentOffset;
                return
            }
            
            
            //print(collOffset)
            if contentOffset.y < 0 {
                let progress = abs(contentOffset.y)/44
              //  print("progress: \(progress)")
                
                if contentOffset.y < -44.0 {
                //    print("inset: \(tableView.contentInset.top)")
                    if tableView.contentInset.top != 44.0 {
                        var inset = self.tableView.contentInset
                      //  inset.top = 44.0
                       // self.tableView.contentInset = inset
                        //self.tableView.transform  = CGAffineTransformMakeTranslation(0, 44)
                    }
                }
                
                let searchTranslate = min(44, 44*progress)
                
                if searchTranslate == 44 {
                    searchBarExpanded = true
                    self.searchBar.transform = CGAffineTransformMakeTranslation(0, searchTranslate)
                    return
                }
                self.searchBar.transform = CGAffineTransformMakeTranslation(0, searchTranslate)

            } else {
                let progress = (contentOffset.x / scrollView.bounds.size.width);
                print(contentOffset)
        
                //  contentOffset!.x = contentOffset.x
                //  contentOffset!.y = 0
                
               // tableView.contentOffset = contentOffset;
            }
            tableView.contentOffset = contentOffset;

            //  CGFloat progress = fmod((contentOffset.x / scrollView.bounds.size.width),1);

       // }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if searchBarExpanded {
            let offSetY = min( -44.0, max(-44.0, targetContentOffset.memory.y))
        
            //scrollView.setContentOffset(CGPointMake(0, offSetY), animated: true)
        }
        
        isScrolling = false
    }


}

