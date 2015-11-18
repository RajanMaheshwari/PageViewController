//
//  ViewController.swift
//  PageViewWithSwipe
//
//  Created by Rajan Maheshwari on 02/09/15.
//  Copyright (c) 2015 rajanmaheshwari. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource,UIPageViewControllerDelegate , UIScrollViewDelegate {

    var pageViewController:UIPageViewController!
    var navigationView:UIView!
    var selectionBar:UIView!
    var buttonText:NSArray!
    var pageScrollView:UIScrollView!
    var currentPageIndex:NSInteger = 0
    var isPageScrollingFlag:Bool = false
    var hasAppearedFlag:Bool = false
    var viewControllerArray:NSArray!
    
    var X_BUFFER:CGFloat = 0.0; //%%% the number of pixels on either side of the segment
    var Y_BUFFER:CGFloat = 14.0; //%%% number of pixels on top of the segment
    var HEIGHT:CGFloat = 40.0; //%%% height of the segment
    
    //%%% customizeable selector bar attributes (the black bar under the buttons)
    var BOUNCE_BUFFER:CGFloat = 0.0; //%%% adds bounce to the selection bar when you scroll
    var ANIMATION_SPEED:CGFloat = 0.5; //%%% the number of seconds it takes to complete the animation
    var SELECTOR_Y_BUFFER:CGFloat = 37.5; //%%% the y-value of the bar that shows what page you are on (0 is the top)
    var SELECTOR_HEIGHT:CGFloat = 2.5; //%%% thickness of the selector bar
    
    var X_OFFSET:CGFloat = 0.0; //%%% for some reason there's a little bit of a glitchy offset.  I'm going to look for a better workaround in the future

    var SELECTED_POSITION:CGFloat = 0.0
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    func initialize(){
        
        self.currentPageIndex = 0;
        self.isPageScrollingFlag = false;
        self.hasAppearedFlag = false;

        
        let firstVC = self.storyboard?.instantiateViewControllerWithIdentifier("FirstViewController") as! FirstViewController
        
        let secondVC = self.storyboard?.instantiateViewControllerWithIdentifier("SecondViewController") as! SecondViewController
        
        let thirdVC = self.storyboard?.instantiateViewControllerWithIdentifier("ThirdViewController") as! ThirdViewController
        
        viewControllerArray = [firstVC,secondVC,thirdVC]
        
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        
        
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self;
        
        self.pageViewController.view.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height)
        
        
         let initialViewController : UIViewController! = viewControllerArray.objectAtIndex(self.currentPageIndex) as! UIViewController
        
        
        SELECTED_POSITION = (self.view.frame.size.width - 2 * X_BUFFER)/CGFloat(viewControllerArray.count) * CGFloat(self.currentPageIndex)
        
        let viewControllers: NSArray? = NSArray(objects: initialViewController)

        pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated:true, completion: nil)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        self.syncScrollView()
        
        if (!self.hasAppearedFlag) {
            
            self.setupSegmentButtons()
            self.hasAppearedFlag = true
        }

        

        

        
    }
    func setupSegmentButtons(){
        navigationView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, (self.navigationController?.navigationBar.frame.size.height)! - 4))
        //navigationView.backgroundColor = UIColor.redColor()
        navigationView.layoutIfNeeded()
        let numControllers:NSInteger = viewControllerArray.count
        if(buttonText == nil)
        {
            buttonText = NSArray(objects: "First","Second","Third")
        }
        
        let buttonWidth:CGFloat = self.view.frame.size.width/CGFloat(numControllers)
        for (var i = 0; i < numControllers; i++) {
            
            
            let button:UIButton = UIButton(frame: CGRectMake( CGFloat(i) * buttonWidth, 0, buttonWidth, 40))
            button.addTarget(self, action: "tapSegmentButtonAction:", forControlEvents: .TouchUpInside)
            navigationView.addSubview(button)
            button.tag = i
//            if(i == 2){
//            button.backgroundColor = UIColor.blackColor()
//            }
//            else if i == 1
//            {
//                button.backgroundColor = UIColor.blueColor()
//
//            }
//            else
//            {
//                button.backgroundColor = UIColor.grayColor()
//            }
//            
            button.titleLabel?.font = UIFont(name: "Helvetica", size: 14)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.setTitle(buttonText.objectAtIndex(i) as? String, forState: .Normal)
            
        }
        
        self.view.addSubview(navigationView)
        self.setupSelector()
    }
    
    
    
    func setupSelector(){

        selectionBar = UIView(frame: CGRectMake(X_BUFFER - X_OFFSET + SELECTED_POSITION , SELECTOR_Y_BUFFER, (self.view.frame.size.width - 2 * X_BUFFER)/CGFloat(viewControllerArray.count), SELECTOR_HEIGHT))

        selectionBar.backgroundColor = UIColor.brownColor()
        selectionBar.alpha = 0.8
        navigationView.addSubview(selectionBar)
        
        
        //println("selection bar frame initial \(selectionBar.frame)")


 
}
    

    func syncScrollView() {
        
        for view in pageViewController.view.subviews {
            
            if view.isKindOfClass(UIScrollView){
                
                self.pageScrollView = view as! UIScrollView;
                self.pageScrollView.delegate = self;
                
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let xFromCenter : CGFloat = self.view.frame.size.width-scrollView.contentOffset.x;

        
        
        let xCoors : CGFloat = X_BUFFER + selectionBar.frame.size.width * CGFloat(currentPageIndex) - X_OFFSET
        _ = selectionBar.frame

        if(CGFloat(xCoors)-xFromCenter / CGFloat(viewControllerArray.count) > self.view.frame.size.width - selectionBar.frame.width)
        {
            
            selectionBar.frame = CGRectMake(self.view.frame.size.width - selectionBar.frame.width, selectionBar.frame.origin.y, selectionBar.frame.size.width, selectionBar.frame.size.height);
        }
        else if(CGFloat(xCoors)-xFromCenter / CGFloat(viewControllerArray.count) < 0)
        {
            
            selectionBar.frame = CGRectMake(0, selectionBar.frame.origin.y, selectionBar.frame.size.width, selectionBar.frame.size.height);
        }

        else
        {
        
       selectionBar.frame = CGRectMake(CGFloat(xCoors)-xFromCenter/CGFloat(viewControllerArray.count), selectionBar.frame.origin.y, selectionBar.frame.size.width, selectionBar.frame.size.height);
        }
       // println("selection bar frame \(selectionBar.frame)")
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isPageScrollingFlag = false
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        isPageScrollingFlag = true
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?{
        
        
        var index : NSInteger = viewControllerArray.indexOfObject(viewController)
        
        if index == NSNotFound{
            return nil
        }
        
        index++
        if index == viewControllerArray.count{
            return nil
        }
        
        
        
        return viewControllerArray.objectAtIndex(index) as? UIViewController
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?{
        
        var index : NSInteger = viewControllerArray.indexOfObject(viewController)
        
        if index == NSNotFound || index == 0{
            return nil
        }
        
        index--
        return viewControllerArray.objectAtIndex(index) as? UIViewController
        
    }

    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return viewControllerArray.count
        
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int{
        
        return 0
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        
        currentPageIndex = viewControllerArray.indexOfObject(pageViewController.viewControllers!.last!)
        
    }

    
    
    func tapSegmentButtonAction(button:UIButton) {
        
        if (!self.isPageScrollingFlag) {
            
            let tempIndex : NSInteger = self.currentPageIndex
            
            weak var weakSelf = self
            
            if button.tag > tempIndex {
                
                for (var i = tempIndex+1; i<=button.tag; i++) {
                    
                    let initialViewController : UIViewController! = viewControllerArray.objectAtIndex(i) as! UIViewController
                    
                    let viewControllers: NSArray? = NSArray(objects: initialViewController)
                    
                    pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: {(complete : Bool) in
                        
                        if complete{
                            
                            weakSelf!.updateCurrentPageIndex(button.tag)
                            
                        }
                    })
                }
                
            }else if button.tag < tempIndex{
                
                for (var i = tempIndex-1; i>=button.tag; i--) {
                    
                    let initialViewController : UIViewController! = viewControllerArray.objectAtIndex(i) as! UIViewController
                    
                    let viewControllers: NSArray? = NSArray(objects: initialViewController)
                    
                    pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Reverse, animated: true, completion: {(complete : Bool) in
                        
                        if complete{
                            
                            weakSelf!.updateCurrentPageIndex(button.tag)
                            
                        }
                    })
                }
            }
            
            
        }
    }
    
    
    func updateCurrentPageIndex(newIndex : Int) {
        
        self.currentPageIndex = newIndex;
        
        
    }

    @IBAction func itemClicked(sender: AnyObject) {
        
        let prof = self.storyboard?.instantiateViewControllerWithIdentifier("ProfViewController") as! ProfViewController
        
        self.navigationController?.pushViewController(prof, animated: true)
    }
}

