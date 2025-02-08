//
//  BSImageContentViewController.m
//  BSValue
//
//  Created by 谷硕 on 11-7-8.
//  Copyright 2011 iTotemStudio. All rights reserved.
//

#import "BSImageContentViewController.h"
#import "BSUIBarButtonItem.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "MJPhotoBrowser.h"
#import "MJPhotoForLocalImage.h"
#import "SDWebImageManager+MJ.h"
#import "MJPhotoViewForLocalImage.h"

#define kPadding 10
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

@interface BSImageContentViewController()<MJPhotoViewForLocalImageDelegate>
{
    // 滚动的view
	UIScrollView *_photoScrollView;
    // 所有的图片view
	NSMutableSet *_visiblePhotoViews;
    NSMutableSet *_reusablePhotoViews;
    // 工具条
    MJPhotoToolbarForLocalImage *_toolbar;

    // 一开始的状态栏
    BOOL _statusBarHiddenInited;

    UIView *_bgView;
}

@end

@implementation BSImageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

- (void)goBack
{
    if ([self.delegate respondsToSelector:@selector(BSImageContentViewControllerDidDismiss)]) {
        [self.delegate BSImageContentViewControllerDidDismiss];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (isIOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[UIFont boldSystemFontOfSize:18.0f],UITextAttributeFont,[UIColor clearColor],UITextAttributeTextShadowColor, CGPointMake(0, 0),UITextAttributeTextShadowOffset, nil]];

    if (currentDeviceVersion >= 7.0) {
        self.navigationController.navigationBar.barTintColor = COLOR_WITH_ARGB(0, 33, 69, 0.4);
    }
    
    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
    self.view.backgroundColor = [UIColor blackColor];
    self.wantsFullScreenLayout = YES;
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    [self.view addSubview:_bgView];
    
    [self createScrollView];
    [self createToolbar];
    [self showPhotos];

    BSUIBarButtonItem *leftBBI = [[BSUIBarButtonItem alloc] initWithImage:currentDeviceVersion >= 7.0 ?  @"backArrow.png" : @"返回.png" side:BSUIBarButtonItemLeft setTarget:self setAction:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn = (UIButton *)leftBBI.customView;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    self.navigationItem.leftBarButtonItem = leftBBI;
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(0, 0, 45, 30);
    [selectBtn setImage:[UIImage imageNamed:@"发布feed_图片未选中.png"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"发布feed_图片选中.png"] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBBI = [[UIBarButtonItem alloc] initWithCustomView:selectBtn];
    self.navigationItem.rightBarButtonItem = rightBBI;
    _selectBtn = selectBtn;
    
    MJPhotoForLocalImage *currentPhoto = _photos[_currentPhotoIndex];
    _selectBtn.selected = currentPhoto.selected;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 私有方法
#pragma mark 创建工具条
- (void)createToolbar
{
    CGFloat barHeight = 44;
    CGFloat barY = _bgView.frame.size.height - barHeight;
    _toolbar = [[MJPhotoToolbarForLocalImage alloc] initWithFrame:CGRectMake(0, barY, self.view.frame.size.width, barHeight)];
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _toolbar.userInteractionEnabled = YES;
    _toolbar.delegate = self;
    [_toolbar setCompleteNum:_selectdIdentifiersArray.count];
    [_bgView addSubview:_toolbar];

    [self updateTollbarState];
}

#pragma mark 创建UIScrollView
- (void)createScrollView
{
    CGRect frame = _bgView.bounds;
    frame.origin.x -= kPadding;
    frame.size.width += (2 * kPadding);
	_photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
	_photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_photoScrollView.pagingEnabled = YES;
	_photoScrollView.delegate = self;
	_photoScrollView.showsHorizontalScrollIndicator = NO;
	_photoScrollView.showsVerticalScrollIndicator = NO;
	_photoScrollView.backgroundColor = [UIColor clearColor];
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
	[_bgView addSubview:_photoScrollView];
    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;

    if (photos.count > 1) {
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
    }

    for (int i = 0; i<_photos.count; i++) {
        MJPhotoForLocalImage *photo = _photos[i];
        photo.index = i;
        photo.firstShow = i == _currentPhotoIndex;
    }
}
#pragma mark 设置选中的图片
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    for (int i = 0; i<_photos.count; i++) {
        MJPhotoForLocalImage *photo = _photos[i];
        photo.firstShow = i == currentPhotoIndex;
    }

    if ([self isViewLoaded]) {
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.frame.size.width, 0);

        // 显示所有的相片
        [self showPhotos];
    }
}

#pragma mark - MJPhotoView代理
- (void)photoViewSingleTap:(MJPhotoViewForLocalImage *)photoView
{
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    _toolbar.hidden = !_toolbar.hidden;
}

- (void)photoViewImageFinishLoad:(MJPhotoViewForLocalImage *)photoView
{
//    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}

#pragma mark 显示照片
- (void)showPhotos
{
    // 只有一张图片
    if (_photos.count == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }

    CGRect visibleBounds = _photoScrollView.bounds;
	int firstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+kPadding*2) / CGRectGetWidth(visibleBounds));
	int lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-kPadding*2-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = _photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = _photos.count - 1;

	// 回收不再显示的ImageView
    NSInteger photoViewIndex;
	for (MJPhotoViewForLocalImage *photoView in _visiblePhotoViews) {
        photoViewIndex = kPhotoViewIndex(photoView);
		if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
			[_reusablePhotoViews addObject:photoView];
			[photoView removeFromSuperview];
		}
	}

	[_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }

	for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
		if (![self isShowingPhotoViewAtIndex:index]) {
			[self showPhotoViewAtIndex:index];
		}
	}
}

#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(int)index
{
    MJPhotoViewForLocalImage *photoView = [self dequeueReusablePhotoView];


    // 调整当期页的frame
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2 * kPadding);
    photoViewFrame.origin.x = (bounds.size.width * index) + kPadding;


    if (!photoView) { // 添加新的图片view
        photoView = [[MJPhotoViewForLocalImage alloc] initWithFrame:photoViewFrame];
        photoView.photoViewDelegate = self;
    }
    photoView.tag = kPhotoViewTagOffset + index;

    MJPhotoForLocalImage *photo = _photos[index];
    photoView.frame = photoViewFrame;
    photoView.photo = photo;

    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];

//    [self loadImageNearIndex:index];
}

#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
	for (MJPhotoViewForLocalImage *photoView in _visiblePhotoViews) {
		if (kPhotoViewIndex(photoView) == index) {
            return YES;
        }
    }
	return  NO;
}

#pragma mark 循环利用某个view
- (MJPhotoViewForLocalImage *)dequeueReusablePhotoView
{
    MJPhotoViewForLocalImage *photoView = [_reusablePhotoViews anyObject];
	if (photoView) {
		[_reusablePhotoViews removeObject:photoView];
	}
	return photoView;
}

#pragma mark 更新toolbar状态
- (void)updateTollbarState
{
    _currentPhotoIndex = (_photoScrollView.contentOffset.x + _photoScrollView.width/2) / _photoScrollView.frame.size.width;
//    _toolbar.currentPhotoIndex = _currentPhotoIndex;
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld",_currentPhotoIndex + 1,_photos.count];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateTollbarState];
    MJPhotoForLocalImage *currentPhoto = _photos[_currentPhotoIndex];
    _selectBtn.selected = currentPhoto.selected;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self showPhotos];
//    [self updateTollbarState];
    if (_toolbar.hidden && _currentPhotoIndex > 0 &&  _currentPhotoIndex == self.photos.count - 1 ) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        _toolbar.hidden = NO;
    }
}

- (void)select:(UIButton *)sender
{
    sender.selected = !sender.selected;
    MJPhotoForLocalImage *photo = _photos[_currentPhotoIndex];
    photo.selected = sender.selected;
    
    ALAsset *asset = photo.asset;
    NSURL *identifier = [asset valueForProperty:ALAssetPropertyAssetURL];
    if (photo.selected) {
        if (_selectdIdentifiersArray.count >= 9 - _originSelectedNum) {
            NSString *message = [NSString stringWithFormat:@"您最多只能选择%ld张",9-_originSelectedNum];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            sender.selected = NO;
            photo.selected = NO;
            return;
        }
        else
        {
            [sender peng];
            if (![_selectdIdentifiersArray containsObject:identifier]) {
                [_selectdIdentifiersArray addObject:identifier];
                [_selectedAssetsArray addObject:asset];
            }
            [_toolbar setCompleteNum:_selectdIdentifiersArray.count];
            return;
        }
    }
    else
    {
        if ([_selectdIdentifiersArray containsObject:identifier]) {
            [_selectdIdentifiersArray removeObject:identifier];
            for (int i = 0; i < _selectedAssetsArray.count; i++) {
                ALAsset *asset = _selectedAssetsArray[i];
                if ([[[asset valueForProperty:ALAssetPropertyAssetURL] description] isEqualToString:[identifier description]] ) {
                    [_selectedAssetsArray removeObject:asset];
                    [_selectdIdentifiersArray removeObject:identifier];
                    break;
                }
            }
        }
        [_toolbar setCompleteNum:_selectdIdentifiersArray.count];
    }
}

#pragma mark - MJPhotoToolbarForLocalImageDelegate
- (void)MJPhotoToolbarForLocalImageDidClickComplete
{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(BSImageContentViewControllerDidComplete)]) {
            [self.delegate BSImageContentViewControllerDidComplete];
        }
    }];
}

@end
