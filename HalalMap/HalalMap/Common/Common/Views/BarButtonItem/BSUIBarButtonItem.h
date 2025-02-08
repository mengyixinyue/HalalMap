//
//  BSUIBarButtonItem.h
//  BSValue2
//
//  Created by Rainbow on 12/31/10.
//  Copyright 2010 iTotemStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
	BSUIBarButtonItemLeft = 0,
	BSUIBarButtonItemRight
}BSUIBarButtonItemSide;

typedef enum
{
	BSUIBarButtonItemBack = 0,
	BSUIBarButtonItemNormal
}BSUIBarButtonItemType;

@interface BSUIBarButtonItem : UIBarButtonItem {
	
}
-(id)initWithImage:(NSString *)backImage side:(BSUIBarButtonItemSide) side setTarget:(id)target setAction:(SEL)action  forControlEvents:(UIControlEvents)event;
-(id)initWithTitle:(NSString *)title setType:(BSUIBarButtonItemType)buttonType 
		 setTarget:(id)target setAction:(SEL)action  forControlEvents:(UIControlEvents)event;
@end
