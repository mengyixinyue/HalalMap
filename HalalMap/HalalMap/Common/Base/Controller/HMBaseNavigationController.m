//
//  HMBaseNavigationController.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/9/29.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMBaseNavigationController.h"

@interface HMBaseNavigationController ()

@end

@implementation HMBaseNavigationController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIColor * color = [UIColor whiteColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          color, NSForegroundColorAttributeName,
                          [HMFontHelper fontOfSize:18.0f], NSFontAttributeName,
                          nil];
    self.navigationBar.titleTextAttributes = dict;
    
    if ([[[UIDevice currentDevice]systemVersion] floatValue] <= 7.0) {
        UIImage *bgImg = [UIImage imageWithColor:HMMainColor size:CGSizeMake(1,1)] ;
        [self.navigationBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
    }else{
        UIImage *bgImgIos7 = [UIImage imageWithColor:HMMainColor size:CGSizeMake(1,1)] ;
        [self.navigationBar setBackgroundImage:bgImgIos7 forBarMetrics:UIBarMetricsDefault];
    }
    self.interactivePopGestureRecognizer.enabled = YES; 
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//  不是主tabBar上的控制器push时都隐藏tabbar
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
