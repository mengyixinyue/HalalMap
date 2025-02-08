//
//  HMKeyWordsCollectionView.h
//  newPatient
//
//  Created by on 15/11/16.
//  Copyright © 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, HMKeyWordsCollectionViewType) {
    HMKeyWordsCollectionViewTypeDefault = 0,
    HMKeyWordsCollectionViewTypeCommentTag,       //医生黄页服务之星  Click
    HMKeyWordsCollectionViewTypeDoctorExperience,  //医生经验分布  Radio
    HMKeyWordsCollectionViewTypeDisease,           //首页 常见疾病 Click
    HMKeyWordsCollectionViewTypeDiseaseRecommend,  //对症医生相关疾病 Click
    // to be continue
};



@interface HMKeyWordsCollectionViewItem : NSObject

@property (nonatomic, copy)     NSString *  title;
@property (nonatomic, assign)   BOOL        selected;   //是否选中(radio or multi-select)

//业务层传参
@property (copy, nonatomic)     NSString *  itemId;     //业务层需要的ID 可不写
@property (strong, nonatomic)   id          sender;     //业务层需要的参数 可不写

@end





@protocol HMKeyWordsCollectionViewDelegate;



@interface HMKeyWordsCollectionView : UIView


@property (weak, nonatomic) id<HMKeyWordsCollectionViewDelegate> delegate;


+ (instancetype)keyWordsCollectionViewWithItems:(NSArray<HMKeyWordsCollectionViewItem *> *)items maxWidth:(CGFloat)maxWidth numberOfLines:(NSInteger)numberOfLines type:(HMKeyWordsCollectionViewType) type;

+ (CGFloat) heightWithNumberOfLines:(NSInteger)numberOfLines maxWidth:(CGFloat)maxWidth type:(HMKeyWordsCollectionViewType)type;

- (NSInteger)currentNumberOfLines;
- (NSInteger)noLimitedNumberOfLines; //不限制最大行数
- (CGFloat)heightWithNumberOfLines:(NSInteger) numberOfLines;

//刷新
- (CGFloat)refreshForNumberOfLines:(NSInteger)lines;
- (void)setItemSelectedAtIndex:(NSInteger)index isSelected:(BOOL)isSelected needCallBack:(BOOL)needCallBack;  //单选 多选都适用


@end



@protocol HMKeyWordsCollectionViewDelegate <NSObject>

-(void)HM_keyWordsCollectionView:(HMKeyWordsCollectionView *)keyWordsCollectionView didClickedWithIndex:(NSInteger)index item:(HMKeyWordsCollectionViewItem *)item;

-(void)HM_keyWordsCollectionView:(HMKeyWordsCollectionView *)keyWordsCollectionView didRadioedWithIndex:(NSInteger)index item:(HMKeyWordsCollectionViewItem *)item;   //单选选中了哪那一个，不需要刷数据源

-(void)HM_keyWordsCollectionView:(HMKeyWordsCollectionView *)keyWordsCollectionView didMultiselectChangedWithItems:(NSArray *)selectedItems;   //多选选中的  可能为空数组

@end







