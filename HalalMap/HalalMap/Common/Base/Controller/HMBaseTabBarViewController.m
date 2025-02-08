//
//  HMBaseTabBarViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 15/9/29.
//  Copyright © 2015年 halalMap. All rights reserved.
//

#import "HMBaseTabBarViewController.h"
#import "HMBaseNavigationController.h"

#import "HMMyViewController.h"
#import "HMHomePageViewController.h"
#import "HMFoundViewController.h"

@interface HMBaseTabBarViewController ()

@end

@implementation HMBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initialVC];
}

-(void)initialVC
{
    NSArray * array = @[
                        [HMHomePageViewController class],
                        [HMFoundViewController class],
                        [HMMyViewController class],
                        ];
    
    NSArray * title = @[
                        @"清真地图",
                        @"发现",
                        @"我的"
                        ];
    
    NSArray * normalImageArr = @[
                                 @"tab_map_normal.png",
                                 @"tab_discover_normal.png",
                                 @"tab_my_normal.png"
                                 ];
    NSArray * selectedImageArr = @[
                                   @"tab_map_selected.png",
                                   @"tab_discover_selected.png",
                                   @"tab_my_selected.png"
                                   ];
    NSMutableArray * viewControllers = [[NSMutableArray alloc] initWithCapacity:42];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController * vc;
//        if (obj == [HMHomePageViewController class]) {
//            vc = [HMHelper xibWithViewControllerClass:[HMHomePageViewController class]];
//        }
//        else{
        vc = [[obj alloc] init];
//        }
        HMBaseNavigationController * nav = [[HMBaseNavigationController alloc] initWithRootViewController:vc];
        UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:title[idx]
                                                            image:[UIImage imageNamed:normalImageArr[idx]]
                                                    selectedImage:[UIImage imageNamed:selectedImageArr[idx]]];
        nav.tabBarItem = item;
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      COLOR_WITH_RGB(128, 128, 128), NSForegroundColorAttributeName,
                                      [HMFontHelper fontOfSize:10.0f],NSFontAttributeName,
                                      nil]
                            forState:UIControlStateNormal];
        
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      HMMainColor, NSForegroundColorAttributeName,
                                      [HMFontHelper fontOfSize:10.0f],NSFontAttributeName,
                                      nil]
                            forState:UIControlStateSelected];
        
        [viewControllers addObject:nav];
    }];
    self.viewControllers = viewControllers;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
