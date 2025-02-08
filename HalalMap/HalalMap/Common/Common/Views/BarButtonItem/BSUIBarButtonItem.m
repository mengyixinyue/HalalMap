//
//  BSUIBarButtonItem.m
//  BSValue2
//
//  Created by Rainbow on 12/31/10.
//  Copyright 2010 iTotemStudio. All rights reserved.
//

#import "BSUIBarButtonItem.h"

//@interface TMTNavButton : UIButton
//
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event;
//
//@end
//
//@implementation TMTNavButton
//
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    
//}
//
//@end

@implementation BSUIBarButtonItem 

-(id)initWithImage:(NSString *)backImage side:(BSUIBarButtonItemSide) side setTarget:(id)target setAction:(SEL)action  forControlEvents:(UIControlEvents)event
{
	if (self = [super init]) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
        if (backImage) {
            NSMutableString *muStr = [NSMutableString stringWithString:backImage];
            //搜索icon.png
            //搜索icon－高亮.png
            if (muStr && muStr.length > 4) {
                [muStr insertString:@"_高亮" atIndex:[muStr length] - 4];
            }
            [button setImage:[UIImage imageNamed:muStr] forState:UIControlStateHighlighted];
        }
        button.frame = CGRectMake(0, -10, 45, 30);
		[button addTarget:target action:action forControlEvents:event];
		self.customView = button;
        if (isIOS7) {
            if (side == BSUIBarButtonItemLeft) {
                button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
                if ([backImage isEqualToString:@"backArrow.png"]) {
                    button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
                }
            }
            else {
                button.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
            }
        }
	}
	return self;
}
-(id)initWithTitle:(NSString *)title setType:(BSUIBarButtonItemType)buttonType 
		 setTarget:(id)target setAction:(SEL)action  forControlEvents:(UIControlEvents)event
{
	if (self = [super init]) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		
		
		button.frame = CGRectMake(0, 0, 59, 32);
		[button addTarget:target action:action forControlEvents:event];
		
		[button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:[title length] > 2 ? 14 : 16];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
        
        if (buttonType == BSUIBarButtonItemNormal) {
            button.frame = CGRectMake(0, 0, 45, 30);
            if ([title length] == 4) {
                button.frame = CGRectMake(0, 0, 68, 30);
            }
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
            
        }
        else if(buttonType == BSUIBarButtonItemBack){
            button.frame = CGRectMake(0, 0, 45, 30);
            if ([title length] == 4) {
                button.frame = CGRectMake(0, 0, 68, 30);
            }
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        }
		self.customView = button;
	}
	return self;
}

@end
