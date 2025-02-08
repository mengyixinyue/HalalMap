//
//  HMKeyWordsCollectionView.m
//  newPatient
//
//  Created by  on 15/11/16.
//  Copyright © 2015年 . All rights reserved.
//

#import "HMKeyWordsCollectionView.h"

#define __keywords_collection_view_index_to_tag(index) (index + 1000)
#define __keywords_collection_view_tag_to_index(tag)   (tag - 1000)


typedef NS_ENUM(NSInteger, ActionType) {
    ActionTypeNone = 0,    //只是展示
    ActionTypeClick,       //按钮
    ActionTypeRadio,       //单选
    ActionTypeMultiselect, //多选
};

typedef NS_ENUM(NSInteger, ShowType) {
    ShowTypeDefault = 0,        //展示不下换行，不拉伸
    ShowTypeAspectFill,         //展示不下换行，拉伸 不留空
};


@interface HMKeyWordsCollectionView ()
{

    NSArray *_items;
    NSArray *_dataSource;   //根据UI处理后的数据源展现用

    HMKeyWordsCollectionViewType _type;

    ActionType _actionType;
    ShowType _showType;

    CGFloat _maxWidth;
    NSInteger _numberOfLines;          //当前传入
    NSInteger _totalNumberOfLines;     //共计

    CGFloat _topMargin;
    CGFloat _bottomMargin;
    CGFloat _leftMargin;
    CGFloat _rightMargin;

    CGFloat _itemsHorizontalSpace;   //上下两行间距
    CGFloat _itemsVerticalSpace;     //左右两间距
    CGFloat _itemInnerLeftSpace;      //字距描边的距离
    CGFloat _itemInnerRightSpace;

    CGFloat _itemHeight;

    UIFont *_textFont;
    UIColor *_itemBackgroundColor;

    CGFloat _borderWidth;
    CGFloat _cornerRadius;
    
    //normal
    UIColor *_textColor;
    UIColor *_borderColor;
    NSString *_normalImagePath;          //背景图 （不含描边）
    UIEdgeInsets _normalImageCapInsets;
    
    //highlighted
    UIColor *_highLightedTextColor;
    NSString *_highLightedImagePath;     //高亮图 （不含描边）
    UIEdgeInsets _highLightedImageCapInsets;
    
    //selected
    UIColor *_selectedTextColor;
    UIColor *_selectedBorderColor;
    NSString *_selectedImagePath;        //选中图 （不含描边）
    UIEdgeInsets _selectedImageCapInsets;

    NSInteger _lastSelectIndex;        //For Radio
    NSMutableSet *_selectedSet;        //For Multiselect
    
}


- (void)p_configSettingWithType:(HMKeyWordsCollectionViewType)type;
- (void)p_initSubviews;

- (NSArray<NSArray<NSString *>*> *)p_dealItemsToDataSource:(NSArray<HMKeyWordsCollectionViewItem *> *)items numberOfLines:(NSInteger)numberOfLines;
- (CGFloat)p_itemWidthWithString:(NSString *)string;
- (CGFloat)p_calculateHeightWithNumberOfLines:(NSInteger) numberOfLines;
    

@end


@implementation HMKeyWordsCollectionView

#pragma mark - life cycle

- (instancetype)initWithItems:(NSArray *)items maxWidth:(CGFloat)maxWidth numberOfLines:(NSInteger)numberOfLines type:(HMKeyWordsCollectionViewType)type {
    
    if (self = [super init])
    {
        self.userInteractionEnabled = YES;
        _items = items;
        _type = type;
        
        _maxWidth = maxWidth;
        _numberOfLines = numberOfLines;
        
        [self p_configSettingWithType:type];
        
        if (_items.count > 0 && maxWidth > 0)
        {
            _dataSource = [self p_dealItemsToDataSource:_items numberOfLines:0];
            _totalNumberOfLines = _dataSource.count;
            if (_numberOfLines <= 0 || _numberOfLines > _totalNumberOfLines)
                _numberOfLines = _totalNumberOfLines;
            
            [self p_initSubviews];
        }
    }
    return self;
}


#pragma mark - event response

-(void)itemClickAction:(UIButton *)btn
{
    switch (_actionType) {
        case ActionTypeNone:
        {
            // nothing
        }
            break;
            
        case ActionTypeClick:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(HM_keyWordsCollectionView:didClickedWithIndex:item:)])
            {
                [self.delegate HM_keyWordsCollectionView:self didClickedWithIndex:__keywords_collection_view_tag_to_index(btn.tag) item:[_items objectAtIndex2:__keywords_collection_view_tag_to_index(btn.tag)]];
            }
        }
            break;
            
        case ActionTypeRadio:
        {
            HMKeyWordsCollectionViewItem *item = [_items objectAtIndex2:__keywords_collection_view_tag_to_index(btn.tag)];
            HMKeyWordsCollectionViewItem *lastSelectedItem = [_items objectAtIndex2:_lastSelectIndex];
            
            if (item.selected)  //--->非选中
            {
                btn.selected = NO;
                item.selected = NO;
                btn.layer.borderColor = item.selected ? _selectedBorderColor.CGColor : _borderColor.CGColor;
                _lastSelectIndex = -1;
            }
            else    //--->选中
            {
                if (lastSelectedItem)
                {
                    UIButton *lastSelectedButton = (UIButton *)[self viewWithTag:__keywords_collection_view_index_to_tag(_lastSelectIndex)];
                    lastSelectedButton.selected = NO;
                    lastSelectedItem.selected = NO;
                    lastSelectedButton.layer.borderColor = lastSelectedItem.selected ? _selectedBorderColor.CGColor : _borderColor.CGColor;
                    _lastSelectIndex = -1;
                }
                btn.selected = YES;
                item.selected = YES;
                btn.layer.borderColor = item.selected ? _selectedBorderColor.CGColor : _borderColor.CGColor;
                _lastSelectIndex = __keywords_collection_view_tag_to_index(btn.tag);
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(HM_keyWordsCollectionView:didRadioedWithIndex:item:)])
                {
                    [self.delegate HM_keyWordsCollectionView:self didRadioedWithIndex:_lastSelectIndex item:[_items objectAtIndex2:_lastSelectIndex]];
                }
            }
        }
            break;
            
        case ActionTypeMultiselect:
        {
            
            HMKeyWordsCollectionViewItem *item = [_items objectAtIndex2:__keywords_collection_view_tag_to_index(btn.tag)];
            
            if ([_selectedSet containsObject:item])  //----->非选中
            {
                btn.selected = NO;
                item.selected = NO;
                btn.layer.borderColor = item.selected ? _selectedBorderColor.CGColor : _borderColor.CGColor;
                [_selectedSet removeObject:item];
            }
            else   //－－－－－－> 选中
            {
                btn.selected = YES;
                item.selected = YES;
                btn.layer.borderColor = item.selected ? _selectedBorderColor.CGColor : _borderColor.CGColor;
                [_selectedSet addObject:item];
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(HM_keyWordsCollectionView:didMultiselectChangedWithItems:)])
            {
                [self.delegate HM_keyWordsCollectionView:self didMultiselectChangedWithItems:[_selectedSet allObjects]];
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - public methods
+ (instancetype)keyWordsCollectionViewWithItems:(NSArray *)items maxWidth:(CGFloat)maxWidth numberOfLines:(NSInteger)numberOfLines type:(HMKeyWordsCollectionViewType) type{
    
    return [[HMKeyWordsCollectionView alloc]initWithItems:items maxWidth:maxWidth numberOfLines:numberOfLines type:type];
}


+ (CGFloat) heightWithNumberOfLines:(NSInteger)numberOfLines maxWidth:(CGFloat)maxWidth type:(HMKeyWordsCollectionViewType)type {
    
    HMKeyWordsCollectionView *collectionView = [HMKeyWordsCollectionView keyWordsCollectionViewWithItems:nil maxWidth:maxWidth numberOfLines:numberOfLines type:type];
    return [collectionView p_calculateHeightWithNumberOfLines:numberOfLines];
}

- (CGFloat)refreshForNumberOfLines:(NSInteger)lines {
    
    if (lines <= 0 || lines > _totalNumberOfLines)
        lines = _totalNumberOfLines;
    
    if (lines != _numberOfLines)
    {
        _numberOfLines = lines;
        
        self.frame = CGRectMake(0, 0, _maxWidth, _topMargin + _numberOfLines * (_itemHeight + _itemsVerticalSpace) - _itemsVerticalSpace + _bottomMargin);
        
        for (UIView *subView in self.subviews)
            subView.hidden = (subView.frame.origin.y + subView.height) > self.height;
    }
    return self.height;
}


- (void)setItemSelectedAtIndex:(NSInteger)index isSelected:(BOOL)isSelected needCallBack:(BOOL)needCallBack{
    
    if (index < 0 || index >= _items.count)
        return;
    
    // 单选
    if (_actionType == ActionTypeRadio)
    {
        HMKeyWordsCollectionViewItem *item = [_items objectAtIndex2:index];
        HMKeyWordsCollectionViewItem *lastSelectedItem = [_items objectAtIndex2:_lastSelectIndex];
        
        if (isSelected) {   //－－－－－－>选中
            
            if (item.selected == isSelected) {  //当前选中 不用处理
                
                if (needCallBack && self.delegate && [self.delegate respondsToSelector:@selector(HM_keyWordsCollectionView:didRadioedWithIndex:item:)])
                {
                    [self.delegate HM_keyWordsCollectionView:self didRadioedWithIndex:_lastSelectIndex item:[_items objectAtIndex2:_lastSelectIndex]];
                }
                return;
            }
            else
            {
                if (lastSelectedItem)     //有其它选中－－－－－>选中
                {
                    
                    UIButton *lastSelectedButton = [self viewWithTag:__keywords_collection_view_index_to_tag(_lastSelectIndex)];
                    lastSelectedButton.selected = NO;
                    lastSelectedItem.selected = NO;
                    lastSelectedButton.layer.borderColor = lastSelectedItem.selected ? _selectedBorderColor.CGColor : _borderColor.CGColor;
                    _lastSelectIndex = -1;
                }
                
                UIButton *selectedButton = [self viewWithTag:__keywords_collection_view_index_to_tag(index)];
                selectedButton.selected = YES;
                item.selected = YES;
                selectedButton.layer.borderColor = item.selected ? _selectedBorderColor.CGColor : _borderColor.CGColor;
                _lastSelectIndex = index;
                
                if (needCallBack && self.delegate && [self.delegate respondsToSelector:@selector(HM_keyWordsCollectionView:didRadioedWithIndex:item:)])
                {
                    [self.delegate HM_keyWordsCollectionView:self didRadioedWithIndex:_lastSelectIndex item:[_items objectAtIndex2:_lastSelectIndex]];
                }
            }
        }
        else
        {
            UIButton *selectedButton = [self viewWithTag:__keywords_collection_view_index_to_tag(index)];
            selectedButton.selected = NO;
            item.selected = NO;
            selectedButton.layer.borderColor = item.selected ? _selectedBorderColor.CGColor : _borderColor.CGColor;
            _lastSelectIndex = -1;
        }
    }
    
    //多选
    if (_actionType == ActionTypeMultiselect)
    {
        HMKeyWordsCollectionViewItem *item = [_items objectAtIndex2:index];
        UIButton *selectedButton = [self viewWithTag:__keywords_collection_view_index_to_tag(index)];
        
        if ([_selectedSet containsObject:item] && !isSelected)    //----->非选中
        {
            selectedButton.selected = NO;
            item.selected = NO;
            selectedButton.layer.borderColor = item.selected ? _selectedBorderColor.CGColor : _borderColor.CGColor;
            [_selectedSet removeObject:item];
            
            if (needCallBack && self.delegate && [self.delegate respondsToSelector:@selector(HM_keyWordsCollectionView:didMultiselectChangedWithItems:)])
            {
                [self.delegate HM_keyWordsCollectionView:self didMultiselectChangedWithItems:[_selectedSet allObjects]];
            }
        }
        
        if (![_selectedSet containsObject:item] && isSelected)   //－－－－－－> 选中
        {
            selectedButton.selected = YES;
            item.selected = YES;
            selectedButton.layer.borderColor = item.selected ? _selectedBorderColor.CGColor : _borderColor.CGColor;
            [_selectedSet addObject:item];
            
            if (needCallBack && self.delegate && [self.delegate respondsToSelector:@selector(HM_keyWordsCollectionView:didMultiselectChangedWithItems:)])
            {
                [self.delegate HM_keyWordsCollectionView:self didMultiselectChangedWithItems:[_selectedSet allObjects]];
            }
        }
    }
}

- (NSInteger)currentNumberOfLines {
    
    return _numberOfLines;
}


- (NSInteger)noLimitedNumberOfLines{
    
    return [[self p_dealItemsToDataSource:_items numberOfLines:0] count];
}

- (CGFloat)heightWithNumberOfLines:(NSInteger) numberOfLines {
    
    if ( numberOfLines < 0 || numberOfLines > _dataSource.count)
    {
        numberOfLines = 0;
    }
    
    NSInteger calculateLines = numberOfLines == 0 ? _dataSource.count : numberOfLines;
    
    return  _topMargin + calculateLines * (_itemHeight + _itemsVerticalSpace) - _itemsVerticalSpace + _bottomMargin;
}


#pragma mark - private methods
//各业务类型在这修改需要的UI参数
- (void)p_configSettingWithType:(HMKeyWordsCollectionViewType)type {
    
    switch (type) {
            
        case HMKeyWordsCollectionViewTypeDefault:
        {
            _actionType = ActionTypeNone;
            _showType = ShowTypeDefault;
            
            _topMargin = 15;
            _bottomMargin = 15;
            _leftMargin = 15;
            _rightMargin = 5;
            
            _itemsHorizontalSpace = 10;
            _itemsVerticalSpace = 10;
            _itemInnerLeftSpace = 8;
            _itemInnerRightSpace = 8;
            
            _itemHeight = 25.f;
            
            _textFont = [UIFont systemFontOfSize:12.f];
            _itemBackgroundColor = [UIColor whiteColor];
             _highLightedTextColor = [UIColor whiteColor];
            _borderWidth = 0.5;
            _cornerRadius = 3;
            
            _textColor = COLOR_WITH_RGB(128, 128, 128);
            _borderColor = HMBorderColor;
            self.backgroundColor = [UIColor whiteColor];
        }
            break;
            
      
            
        case HMKeyWordsCollectionViewTypeCommentTag:
        {
            
            _actionType = ActionTypeMultiselect;
            _showType = ShowTypeDefault;
            
            _topMargin = 15;
            _bottomMargin = 15;
            _leftMargin = 15;
            _rightMargin = 5;
            
            _itemsHorizontalSpace = 10;
            _itemsVerticalSpace = 10;
            _itemInnerLeftSpace = 8;
            _itemInnerRightSpace = 8;
            
            _itemHeight = 25.f;
            
            _textFont = [UIFont systemFontOfSize:12.f];
            _itemBackgroundColor = [UIColor whiteColor];
            _highLightedTextColor = [UIColor whiteColor];
            _selectedTextColor = [UIColor whiteColor];
            _borderWidth = 0.5;
            _cornerRadius = 3;
            
            _textColor = COLOR_WITH_RGB(128, 128, 128);
            _borderColor = HMBorderColor;
            self.backgroundColor = [UIColor whiteColor];
        }
            break;
            
        case HMKeyWordsCollectionViewTypeDoctorExperience:
        {
            
            _actionType = ActionTypeRadio;
            _showType = ShowTypeDefault;
            
            _topMargin = 15;
            _bottomMargin = 15;
            _leftMargin = 15;
            _rightMargin = 15;
            
            _itemsHorizontalSpace = 10;
            _itemsVerticalSpace = 10;
            _itemInnerLeftSpace = 8;
            _itemInnerRightSpace = 8;
            
            _itemHeight = 30.f;
            
            _textFont = [UIFont systemFontOfSize:12.f];
            _itemBackgroundColor = [UIColor whiteColor];
            _borderWidth = 0.5;
            _cornerRadius = 3;
            self.backgroundColor = [UIColor whiteColor];
            /*
            _textColor = [UIColor colorWithHex:0x969696];
            _borderColor = [UIColor colorWithHex:0xdcdcdc];
            
            _highLightedTextColor = [UIColor colorWithHex:0x4ba2ed];
            _highLightedImagePath = @"btn_category_highLighted";
            _highLightedImageCapInsets = UIEdgeInsetsMake(6, 6, 6, 6);
            
            _selectedTextColor = [UIColor colorWithHex:0x4ba2ed];
            _selectedBorderColor = [UIColor colorWithHex:0x4ba2ed];
            _selectedImagePath = @"icon_btn_category_selected";
             */
            _selectedImageCapInsets = UIEdgeInsetsMake(0, 0, 14, 14);
        }
            break;
        case HMKeyWordsCollectionViewTypeDisease:
        {
            _actionType = ActionTypeClick;
            _showType = ShowTypeAspectFill;
            
            _topMargin = 0;
            _bottomMargin = 15;
            _leftMargin = 15;
            _rightMargin = 15;
            
            _itemsHorizontalSpace = 4;
            _itemsVerticalSpace = 5;
            _itemInnerLeftSpace = 9;
            _itemInnerRightSpace = 9;
            
            _itemHeight = 25.f;
            
             /*
            _textFont = [UIFont systemFontOfSize:13.f];
            _itemBackgroundColor = [UIColor colorWithHex:0xd2e6ff];
            _borderWidth = 0;
            _cornerRadius = 0;
            self.backgroundColor = [UIColor whiteColor];
            
            _textColor = [UIColor colorWithHex:0x006ec8];
            
            _highLightedTextColor = [UIColor colorWithHex:0x006ec8];
              */
        }
            break;

        case HMKeyWordsCollectionViewTypeDiseaseRecommend:
        {
            
            _actionType = ActionTypeClick;
            _showType = ShowTypeDefault;
            
            _topMargin = 15;
            _bottomMargin = 15;
            _leftMargin = 15;
            _rightMargin = 15;
            
            _itemsHorizontalSpace = 15;
            _itemsVerticalSpace = 15;
            _itemInnerLeftSpace = 10;
            _itemInnerRightSpace = 10;
            
            _itemHeight = 39.0f;
            
            _textFont = [UIFont systemFontOfSize:12.f];
            _itemBackgroundColor = [UIColor whiteColor];
            _borderWidth = 0.5;
            _cornerRadius = 3;
             /*
            _textColor = [UIColor colorWithHex:0x646464];
            _borderColor = [UIColor colorWithHex:0xdcdcdc];
              */
            
            self.backgroundColor = [UIColor whiteColor];
        }
            break;
        default:
            break;
    }
}

- (void)p_initSubviews {
    
    self.frame = CGRectMake(0, 0, _maxWidth, _topMargin + _numberOfLines * (_itemHeight + _itemsVerticalSpace) - _itemsVerticalSpace + _bottomMargin);
    
    _lastSelectIndex = -1;
    
    __block NSInteger buttonTag = __keywords_collection_view_index_to_tag(0);  //tag 相当于数组的下标
    
    [_dataSource enumerateObjectsUsingBlock:^(id  obj1, NSUInteger idx1, BOOL * stop1) {
        
        if ([obj1 isKindOfClass:[NSArray class]])
        {
            NSArray *itemsOneLine = (NSArray *)obj1;
            
            __block CGFloat currentX = _leftMargin;
            
            CGFloat extraWidth = 0;
            
            if (_showType == ShowTypeAspectFill)
            {
                __block CGFloat totalItemsWidth = 0;
                [itemsOneLine enumerateObjectsUsingBlock:^(id  obj2, NSUInteger idx2, BOOL * stop2) {
                    NSString *title = (NSString *)obj2;
                    totalItemsWidth += [self p_itemWidthWithString:title];
                }];
                totalItemsWidth += _itemsHorizontalSpace * (itemsOneLine.count - 1);
                
                extraWidth =  (_maxWidth -_leftMargin -_rightMargin - totalItemsWidth) / itemsOneLine.count;
                MAX(0, extraWidth);
            }
            
            [itemsOneLine enumerateObjectsUsingBlock:^(id  obj2, NSUInteger idx2, BOOL * stop2) {
                
                if ([obj2 isKindOfClass:[NSString class]])
                {
                    NSString *title = (NSString *)obj2;

                    CGFloat itemWidth = [self p_itemWidthWithString:title] + extraWidth;
                    
                    CGRect itemRect = CGRectMake(currentX,
                                                 _topMargin + idx1 * (_itemHeight + _itemsVerticalSpace),
                                                 itemWidth,
                                                 _itemHeight);
                    
                    UIImage *normalImage = [[UIImage imageNamed:_normalImagePath] resizableImageWithCapInsets:_normalImageCapInsets];
                    UIImage *highLightImage = [[UIImage imageNamed:_highLightedImagePath] resizableImageWithCapInsets:_highLightedImageCapInsets];
                    UIImage *selectedImage = [[UIImage imageNamed:_selectedImagePath] resizableImageWithCapInsets:_selectedImageCapInsets];
                    if (_selectedImagePath) {
                        selectedImage = [[UIImage imageNamed:_selectedImagePath] resizableImageWithCapInsets:_selectedImageCapInsets];
                    }
                    else{
                        selectedImage = [UIImage imageWithColor:HMMainColor size:itemRect.size];
                    }
                    
                    
                    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    aButton.frame = itemRect;
                    
                    aButton.layer.borderColor = _borderColor.CGColor;
                    aButton.layer.cornerRadius = _cornerRadius;
                    aButton.layer.borderWidth = _borderWidth;
                    
                    [aButton setBackgroundImage:normalImage forState:UIControlStateNormal];
                    [aButton setBackgroundImage:highLightImage forState:UIControlStateHighlighted];
                    [aButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
                  
                    if (_type == HMKeyWordsCollectionViewTypeDisease) {
                        aButton.backgroundColor = _itemBackgroundColor;
                    }
                    
                    aButton.titleEdgeInsets = UIEdgeInsetsMake(0,_itemInnerLeftSpace,0,_itemInnerRightSpace);
                    if (_type == HMKeyWordsCollectionViewTypeDiseaseRecommend){
                        aButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                    }else {
                        aButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
                    }
                    aButton.titleLabel.font = _textFont;
                    [aButton setTitle:title forState:UIControlStateNormal];
                    [aButton setTitleColor:_textColor forState:UIControlStateNormal];
                    [aButton setTitleColor:_highLightedTextColor forState:UIControlStateHighlighted];
                    [aButton setTitleColor:_selectedTextColor forState:UIControlStateSelected];
                    
                    [aButton addTarget:self action:@selector(itemClickAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:aButton];
                    
                    
                    currentX += aButton.width + _itemsHorizontalSpace;
                    
                    aButton.tag = buttonTag;
                    aButton.enabled = _actionType != ActionTypeNone;
                    if (idx1 >= _numberOfLines)
                        aButton.hidden = YES;
                    
                    HMKeyWordsCollectionViewItem *item = [_items objectAtIndex2:__keywords_collection_view_tag_to_index(buttonTag)];
                    if (_actionType == ActionTypeRadio)
                    {
                        aButton.selected = item.selected;
                        if (item.selected)
                            _lastSelectIndex = __keywords_collection_view_tag_to_index(buttonTag);
                        
                        aButton.layer.borderColor = item.selected ? _selectedBorderColor.CGColor : _borderColor.CGColor;
                    }
                    
                    if (_actionType == ActionTypeMultiselect)
                    {
                        _selectedSet = [NSMutableSet set];
                        
                        aButton.selected = item.selected;
                        if (item.selected) {
                            [_selectedSet addObject:item];
                        }
                        aButton.layer.borderColor = item.selected ? _selectedBorderColor.CGColor : _borderColor.CGColor;
                    }
                    buttonTag++;
                }
            }];
        }
    }];
}

//  @return
//  @[
//      @[@"xxxxx",@"sssss"],
//      @[@"xxxxxxxxxxxxxx"]
//    ]
- (NSArray<NSArray<NSString *>*> *)p_dealItemsToDataSource:(NSArray<HMKeyWordsCollectionViewItem *> *)items numberOfLines:(NSInteger)numberOfLines
{
    __block NSMutableArray *resultItems = [NSMutableArray array];
    
    __block NSMutableArray *currentLineArray = [NSMutableArray array];
    __block CGFloat currentWith = 0;
    
    
    [items enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * stop) {
        
        if ([obj isKindOfClass:[HMKeyWordsCollectionViewItem class]])
        {
            HMKeyWordsCollectionViewItem *item = (HMKeyWordsCollectionViewItem *)obj;
            
            CGFloat itemWidth = [self p_itemWidthWithString:item.title];
            //在本行
            if (currentWith + itemWidth <= (_maxWidth - _leftMargin - _rightMargin))
            {
                currentWith += itemWidth + _itemsHorizontalSpace;
                [currentLineArray addObject:item.title];
            }
            else //换行
            {
                [resultItems addObject:[NSArray arrayWithArray:currentLineArray]];
                [currentLineArray removeAllObjects];
                currentWith = 0;
                
                //下一行第一个
                currentWith += itemWidth + _itemsHorizontalSpace;
                [currentLineArray addObject:item.title];
            }
            
            if (resultItems.count > numberOfLines && numberOfLines > 0)  //够了
            {
                [resultItems removeLastObject];
                *stop = YES;
            }
        }
    }];
    
    if (currentLineArray.count > 0 && ((resultItems.count < numberOfLines && numberOfLines > 0) || numberOfLines <= 0))
    {
        [resultItems addObject:currentLineArray];
    }
    return [NSArray arrayWithArray:resultItems];
}


- (CGFloat)p_itemWidthWithString:(NSString *)string {
    
    CGFloat maxItemWidth = _maxWidth - _leftMargin - _rightMargin - _itemInnerLeftSpace - _itemInnerRightSpace;
    
    return ([string sizeAutoFitIOS7WithFont:_textFont constrainedToSize:CGSizeMake(maxItemWidth, MAXFLOAT) lineBreakMode:NSLineBreakByTruncatingMiddle].width + _itemInnerLeftSpace + _itemInnerRightSpace);
//    ([string size2FitWithFont:_textFont containerWidth:maxItemWidth lineBreakModel:NSLineBreakByTruncatingMiddle mutableLines:NO].width + _itemInnerLeftSpace + _itemInnerRightSpace);
}

- (CGFloat)p_calculateHeightWithNumberOfLines:(NSInteger) numberOfLines { //跟数据源没关系 可无限行
    
    if (numberOfLines < 0)
        numberOfLines = 0;
    
    return  _topMargin + numberOfLines * (_itemHeight + _itemsVerticalSpace) - _itemsVerticalSpace + _bottomMargin;
}

@end



#pragma mark - HMKeyWordsCollectionViewItem

@implementation HMKeyWordsCollectionViewItem

@end








