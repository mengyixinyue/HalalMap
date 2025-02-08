//
//  MJPhotoToolbarForLocalImage.h
//  Outing
//
//  Created by yj on 14/12/11.
//  Copyright (c) 2014年 zhengchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJPhotoToolbarForLocalImage;
@protocol MJPhotoToolbarForLocalImageDelegate <NSObject>

- (void)MJPhotoToolbarForLocalImageDidClickComplete;

@end

@interface MJPhotoToolbarForLocalImage : UIView
{
    UIButton *_doneBtn;
    
}

@property (nonatomic,assign) id<MJPhotoToolbarForLocalImageDelegate>delegate;

- (void)setCompleteNum:(NSInteger)completeNum;

@end
