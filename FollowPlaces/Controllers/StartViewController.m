//
//  StartViewController.m
//  Starlety
//
//  Created by Luchian Chivoiu on 08/03/2014.
//  Copyright (c) 2014 Luchian Chivoiu. All rights reserved.
//

#import "StartViewController.h"
#import "TopAuditionsViewController.h"
#import "RecordViewController.h"
#import "SettingsTableViewController.h"

#define ControllersCount 5
@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Create the data model
    _pageTitles = @[@"Top Talents", @"New Talents"
                    , @"Share Your Talent", @"My Posts", @"Settings"];
//    _pageImages = @[@"page1.png", @"page2.png", @"page3.png", @"page4.png"];
   
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    TopAuditionsViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+40 );

    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startWalkthrough:(id)sender {
    TopAuditionsViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if ((index >= ControllersCount)) {
        return nil;
    }
    if(index==0)
    {
            TopAuditionsViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TopAuditionsViewController"];
            pageContentViewController.TopStarletyLogoFile = @"StarletyTopForIphone.png";
            pageContentViewController.QueryData = @"&sortBy=ApplauseCount";
            pageContentViewController.pageIndex = index;
            return pageContentViewController;
    }
    else
        if(index==1)
        {
            NewAuditionsViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewAuditionsViewController"];
            [pageContentViewController.TopStarletyLogo setImage:[UIImage imageNamed:@"StarletyNewForIphone.png"]];
            
            pageContentViewController.TopStarletyLogoFile = @"StarletyNewForIphone.png";
            pageContentViewController.QueryData = @"";
            pageContentViewController.pageIndex = index;
            return pageContentViewController;
        }
        else

                if(index==2)
                {
                    RecordViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordViewController"];
                    pageContentViewController.pageIndex = index;
                    return pageContentViewController;
                }
                else
                    if(index==3)
                    {
                        MyAuditionsViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAuditionsViewController"];
                        [pageContentViewController.TopStarletyLogo setImage:[UIImage imageNamed:@"MyStarletyForIphone.png"]];
                        
                        pageContentViewController.TopStarletyLogoFile = @"MyStarletyForIphone.png";
                        pageContentViewController.QueryData = [NSString stringWithFormat:@"&userId=%@",[LoginInfo sharedInstance].userId];
                        
                        pageContentViewController.pageIndex = index;
                        return pageContentViewController;
                    }
                    else
                        if(index==4)
                        {
                            SettingsTableViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsTableViewController"];
                            pageContentViewController.pageIndex = index;
                            return pageContentViewController;
                        }

   
    TopAuditionsViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AuditionsViewController"];
    pageContentViewController.TopStarletyLogoFile = @"StarletyTopForIphone.png";
    pageContentViewController.QueryData = @"&sortBy=ApplauseCount";
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TopAuditionsViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TopAuditionsViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == ControllersCount){
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return ControllersCount;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
