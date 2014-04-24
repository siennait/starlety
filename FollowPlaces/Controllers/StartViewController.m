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
//@property (retain,nonatomic) TopAuditionsViewController* pageContentTopAuditionsViewController ;
//@property (retain,nonatomic) NewAuditionsViewController* pageContentNewAuditionsViewController;
//@property (retain,nonatomic) RecordViewController *pageContentRecordViewController;
//@property (retain,nonatomic) MyAuditionsViewController *pageContentMyAuditionsViewController;
//@property (retain,nonatomic) SettingsTableViewController *pageContentSettingsViewController;
@end

@implementation StartViewController
    //TopAuditionsViewController *pageContentTopAuditionsViewController;
//@synthesize pageContentTopAuditionsViewController;
//@synthesize pageContentNewAuditionsViewController;
//@synthesize pageContentRecordViewController;
//@synthesize pageContentMyAuditionsViewController;
//@synthesize pageContentSettingsViewController;

static TopAuditionsViewController *pageContentTopAuditionsViewController ;
static NewAuditionsViewController *pageContentNewAuditionsViewController;
static RecordViewController *pageContentRecordViewController;
static MyAuditionsViewController *pageContentMyAuditionsViewController;
static SettingsTableViewController *pageContentSettingsViewController;


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
    //NewAuditionsViewController *pageContentNewAuditionsViewController = [self viewControllerAtIndex:1];
    //RecordViewController *pageContentRecordViewController = [self viewControllerAtIndex:2];
    //MyAuditionsViewController *pageContentMyAuditionsViewController = [self viewControllerAtIndex:3];
    //SettingsTableViewController *pageContentSettingsViewController = [self viewControllerAtIndex:4];
    NSArray *viewControllers = @[startingViewController];//,pageContentNewAuditionsViewController,pageContentRecordViewController,pageContentMyAuditionsViewController,pageContentSettingsViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    //self.pageViewController.doubleSided = YES;
    //self.pageViewController.childViewControllers
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
            //if(pageContentTopAuditionsViewController==nil)
            //{
                TopAuditionsViewController *pageContentTopAuditionsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TopAuditionsViewController"];
                pageContentTopAuditionsViewController.TopStarletyLogoFile = @"StarletyTopForIphone.png";
                pageContentTopAuditionsViewController.QueryData = @"&sortBy=ApplauseCount";
                pageContentTopAuditionsViewController.pageIndex = index;
                return pageContentTopAuditionsViewController;
            //}
            //return pageContentTopAuditionsViewController;
    }
    else
        if(index==1)
        {
            //if(pageContentNewAuditionsViewController==nil)
            //{
                NewAuditionsViewController *pageContentNewAuditionsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewAuditionsViewController"];
                [pageContentNewAuditionsViewController.TopStarletyLogo setImage:[UIImage imageNamed:@"StarletyNewForIphone.png"]];
            
                pageContentNewAuditionsViewController.TopStarletyLogoFile = @"StarletyNewForIphone.png";
                pageContentNewAuditionsViewController.QueryData = @"";
                pageContentNewAuditionsViewController.pageIndex = index;
                return pageContentNewAuditionsViewController;
            //}
            //return pageContentNewAuditionsViewController;
        }
        else
                if(index==2)
                {
                    //if(pageContentRecordViewController==nil)
                    //{
                        RecordViewController* pageContentRecordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordViewController"];
                        pageContentRecordViewController.pageIndex = index;
                        return pageContentRecordViewController;
                    //}
                    return pageContentRecordViewController;
                }
                else
                    if(index==3)
                    {
                        //if(pageContentMyAuditionsViewController==nil)
                        //{
                            MyAuditionsViewController* pageContentMyAuditionsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAuditionsViewController"] ;
                            [pageContentMyAuditionsViewController.TopStarletyLogo setImage:[UIImage imageNamed:@"MyStarletyForIphone.png"]];
                        
                            pageContentMyAuditionsViewController.TopStarletyLogoFile = @"MyStarletyForIphone.png";
                            pageContentMyAuditionsViewController.QueryData = [NSString stringWithFormat:@"&userId=%@",[LoginInfo sharedInstance].userId];
                        
                            pageContentMyAuditionsViewController.pageIndex = index;
                        //}
                        return pageContentMyAuditionsViewController;
                    }
                    else
                        //if(index==4)
                        {
                            //if(pageContentSettingsViewController==nil)
                            //{
                                SettingsTableViewController* pageContentSettingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsTableViewController"];
                                pageContentSettingsViewController.pageIndex = index;
                            //}
                            return pageContentSettingsViewController;
                        }

   
    if(pageContentTopAuditionsViewController==nil)
    {
        TopAuditionsViewController* pageContentTopAuditionsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AuditionsViewController"];
        pageContentTopAuditionsViewController.TopStarletyLogoFile = @"StarletyTopForIphone.png";
        pageContentTopAuditionsViewController.QueryData = @"&sortBy=ApplauseCount";
        pageContentTopAuditionsViewController.pageIndex = index;
    }
    return pageContentTopAuditionsViewController;
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
