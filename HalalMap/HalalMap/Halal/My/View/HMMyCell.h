//
//  HMMyCell.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/20.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMMyCell : UITableViewCell

-(void)configureWithTitle:(NSString *)title imageName:(NSString *)imageName isLastCell:(BOOL)isLastCell messageCount:(NSString *)messageCount;

@end
