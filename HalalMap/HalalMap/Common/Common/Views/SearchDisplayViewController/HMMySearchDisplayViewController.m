//
//  HMMySearchDisplayViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/5.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMMySearchDisplayViewController.h"

@implementation HMMySearchDisplayViewController

- (void)setActive:(BOOL)visible animated:(BOOL)animated;
{
    if(self.active == visible) return;
    [self.searchContentsController.navigationController setNavigationBarHidden:YES animated:NO];
    [super setActive:visible animated:animated];
    [self.searchContentsController.navigationController setNavigationBarHidden:NO animated:NO];
    if (visible) {
        [self.searchBar becomeFirstResponder];
    } else {
        [self.searchBar resignFirstResponder];
    }
}


@end
