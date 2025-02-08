//
//  HMPublishFeedViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/5.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMPublishFeedViewController.h"
#import "YSKeyboardScrollView.h"
#import "HMImageCell.h"
#import "HMAddCell.h"
#import "HMSelectAddressView.h"
#import "HMSelectAddressEntranceView.h"
#import "HMSelectPrivateView.h"
#import "ZCSelectPicsViewController.h"
#import "HMSelectRestaurantViewController.h"

#import "ZCImageInfoModel.h"
#import "HMSelectRestaurantModel.h"

#define HMPublishHorizonMargin  (15)
#define HMPublishTopMargin      (15)
#define HMPublishVerticlePadding    (10)


@interface HMPublishFeedViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UITextViewDelegate,
UIActionSheetDelegate,
HMSelectAddressViewDelegate,
HMSelectAddressEntranceViewDelegate,
HMSelectPrivateViewDelegate,
HMImageCellDelegate,
ZCSelectPicsViewControllerDelegate,
HMSelectRestaurantViewControllerDelegate
>
@end

@implementation HMPublishFeedViewController
{
    YSKeyboardScrollView * _scrollView;
    UIView               * _containerView;
    UITextView           * _textView;
    UILabel              * _tipsLabel;
    UICollectionView     * _collectionView;
    HMSelectAddressView  * _selectedAddressView;
    HMSelectAddressEntranceView * _selectAddressEntranceView;
    HMSelectPrivateView  * _selectPrivateView;
    NSMutableArray       * _imagesArray;
    NSMutableArray       * _imagesPaths;
    BOOL                 _isSelectedRestaurant;
    BOOL                 _privateInfo;
    HMSelectRestaurantModel * _restaurantModel;
}

-(id)init
{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self initialUI];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"晒清真", nil);
    [self addBarButtonItemWithImageName:nil
                                  title:@"发布"
                                 action:@selector(publish)
                      barButtonItemType:HMBarButtonTypeRight
                             titleColor:[UIColor whiteColor]
                  highlightedTitleColor:nil
                              titleFont:[HMFontHelper fontOfSize:18.0f]];
    [self addBarButtonItemWithImageName:nil
                                  title:@"取消"
                                 action:@selector(cancel)
                      barButtonItemType:HMBarButtonTypeLeft
                             titleColor:[UIColor whiteColor]
                  highlightedTitleColor:nil
                              titleFont:[HMFontHelper fontOfSize:18.0f]];
    _imagesArray = [[NSMutableArray alloc] init];
    _imagesPaths =[[NSMutableArray alloc] init];
    _isSelectedRestaurant = YES;
    _privateInfo = YES;
}

-(void)initialUI
{
    __weak typeof(self) _self = self;
    _scrollView = [[YSKeyboardScrollView alloc] init];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        make.width.equalTo(_self.view);
        make.height.equalTo(_self.view);
    }];
    
    _containerView = [[UIView alloc] init];
    [_scrollView addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        make.width.equalTo(_self.view);
    }];
    
    
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.delegate = self;
    _textView.font = [HMFontHelper fontOfSize:18.0f];
    [_containerView addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(HMPublishHorizonMargin);
        make.top.mas_equalTo(HMPublishTopMargin);
        make.right.mas_equalTo(-HMPublishHorizonMargin);
        make.height.mas_equalTo(100);
    }];
    
    _tipsLabel = [[UILabel alloc] init];
    [_containerView addSubview:_tipsLabel];
    [_containerView sendSubviewToBack:_tipsLabel];
    _tipsLabel.textColor = HMGrayColor;
    _tipsLabel.font = [HMFontHelper fontOfSize:18.0f];
    _tipsLabel.text = @"说点什么吧...";
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(_textView).with.offset(5);
        make.height.mas_equalTo(_tipsLabel.font.lineHeight);
        make.width.mas_equalTo(@100);
    }];

    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake(80, 80);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_containerView addSubview:_collectionView];
    [_collectionView registerNib:[UINib nibWithNibName:@"HMImageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([HMImageCell class])];
    [_collectionView registerNib:[UINib nibWithNibName:@"HMAddCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([HMAddCell class])];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(HMPublishHorizonMargin);
        make.width.mas_equalTo(80 * 3 + 10);
        make.top.equalTo(_textView.mas_bottom).with.offset(HMPublishVerticlePadding);
        make.height.mas_equalTo(100);
    }];

    _selectedAddressView = [HMHelper xibWithClass:[HMSelectAddressView class]];
    [_containerView addSubview:_selectedAddressView];
    _selectedAddressView.delegate = self;
    
    [_selectedAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_collectionView.mas_bottom).with.offset(10);
        make.height.mas_equalTo(@50);
        make.left.and.right.equalTo(@0);
    }];
    
    _selectAddressEntranceView = [HMHelper xibWithClass:[HMSelectAddressEntranceView class]];
    [_containerView addSubview:_selectAddressEntranceView];
    _selectAddressEntranceView.delegate = self;
    [_selectAddressEntranceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(@0);
        make.top.mas_equalTo(_selectedAddressView.mas_bottom);
        make.height.mas_equalTo(@50);
    }];
    
    _selectPrivateView = [HMHelper xibWithClass:[HMSelectPrivateView class]];
    [_containerView addSubview:_selectPrivateView];
    _selectPrivateView.delegate = self;
    [_selectPrivateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(@0);
        make.top.equalTo(_selectAddressEntranceView.mas_bottom);
        make.height.mas_equalTo(@50);
    }];
    
    [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_selectPrivateView).with.offset(10);
    }];
    
    [_containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_self.view.mas_bottom).priorityLow();
        make.height.mas_greaterThanOrEqualTo(_selectPrivateView.bottom);
    }];
}

#pragma mark - UICollectionViewDataSource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row + 1 <= _imagesArray.count) {
        HMImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HMImageCell class]) forIndexPath:indexPath];
        [cell configureWithModel:_imagesArray[indexPath.row]];
        cell.delegate = self;
        return cell;
    }
    else{
        HMAddCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HMAddCell class]) forIndexPath:indexPath];
        return cell;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_imagesArray.count >= 9) {
        return _imagesArray.count;
    }
    else{
        return _imagesArray.count + 1;
    }
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _imagesArray.count) {
        NSLog(@"加");
        ZCSelectPicsViewController *spVC = [[ZCSelectPicsViewController alloc] initWithOriginSelectedNum:_imagesArray.count];
        spVC.delegate = self;
        HMBaseNavigationController *nav = [[HMBaseNavigationController alloc] initWithRootViewController:spVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0) {
        _tipsLabel.hidden = YES;
    }
    else{
        _tipsLabel.hidden = NO;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 1500) {
        [self.view showLoadingMeg:NSLocalizedString(@"描述文字字数不能超过1500字符", nil) time:ERRORMESSAGESHOWTIME];
        return NO;
    }
    return YES;
}

#pragma mark - HMImageCellDelegate
-(void)deleteImage:(HMImageCell *)imageCell
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除图片？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    __weak HMPublishFeedViewController * weakSelf = self;
    [alertView showWithCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            NSIndexPath * indexPath = [_collectionView indexPathForCell:imageCell];
            [_imagesArray removeObjectAtIndex:indexPath.row];
            [_imagesPaths removeObjectAtIndex:indexPath.row];
            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
            [weakSelf updateImageView];
        }
    }];
   
}

#pragma mark - HMSelectAddressViewDelegate
-(void)selectAddressView:(HMSelectAddressView *)selectAddressView isSelectedRestaurant:(BOOL)isSelectedRestaurant
{
    _isSelectedRestaurant = isSelectedRestaurant;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    if (isSelectedRestaurant) {
        [_selectAddressEntranceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
        }];
    }
    else{
        [_selectAddressEntranceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
    _selectAddressEntranceView.hidden = !isSelectedRestaurant;
    [_containerView layoutIfNeeded];
    [UIView commitAnimations];
}

#pragma mark - HMSelectAddressEntranceViewDelegate
-(void)selectAddressEntranceView:(HMSelectAddressEntranceView *)entranceView
{
    NSLog(@"选择餐厅地址");
    HMSelectRestaurantViewController * reportPOIVC = [[HMSelectRestaurantViewController alloc] initWithNibName:@"HMSelectRestaurantViewController" bundle:[NSBundle mainBundle]];
    reportPOIVC.delegate = self;
    [self.navigationController pushViewController:reportPOIVC animated:YES];
}

#pragma mark - HMSelectPrivateViewDelegate
-(void)privateInfo:(BOOL)privateInfo selectPrivateView:(HMSelectPrivateView *)selectPrivateView
{
    _privateInfo = privateInfo;
    if (privateInfo) {
        NSLog(@"公开");
    }
    else{
        NSLog(@"不公开");
    }
}

#pragma mark - HMSelectRestaurantViewControllerDelegate 选择餐厅
-(void)selectRestaurantWithModel:(HMSelectRestaurantModel *)restaurantModel
{
    _restaurantModel = restaurantModel;
    _selectAddressEntranceView.selectedRestaurantLabel.text = _restaurantModel.poi_name;
}

#pragma mark - ZCSelectPicsViewControllerDelegate
-(void)ZCSelectPicsViewController:(ZCSelectPicsViewController *)controller didFinishPickingAssets:(NSArray *)assets
{
    
    if (assets.count == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            [_collectionView reloadData];
        } completion:^(BOOL finished) {
            [self updateImageView];
        }];
        return;
    }
    NSArray *mediaInfoArray = (NSArray *)assets;
    if (mediaInfoArray.count) {
        for (int i = 0; i < mediaInfoArray.count; i++) {
            NSDictionary *info = mediaInfoArray[i];
            UIImage *originalImage = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
            originalImage = [originalImage fixOrientation];
            
            ZCImageInfoModel *imageModel = [[ZCImageInfoModel alloc] init];
            
            __block NSString *name = nil;
            NSURL *imageUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
            ALAssetsLibrary *library = [HMHelper defaultAssetsLibrary];
            [library assetForURL:imageUrl resultBlock:^(ALAsset *asset) {
                if (asset) {
                    NSDate *createDate = [asset valueForProperty:ALAssetPropertyDate];
                    name = [NSString stringWithFormat:@"%@.jpg",[createDate stringWithFormat:[NSDate timestampFormatString]]];
                }
                if (!name) {
                    name = [NSString stringWithFormat:@"%@.jpg",[[NSDate date] stringWithFormat:[NSDate timestampFormatString]]];
                }
                //将压缩后的图片写入沙盒
                NSString *path = [[HMHelper imageSavePath] stringByAppendingPathComponent:name];
                NSData *savedData = nil;
                NSFileManager *fm = [NSFileManager defaultManager];
                if (![fm fileExistsAtPath:path]) {
                    //将图片压缩至200k以下
                    savedData = [originalImage compressBelowKNum:200.0];
                    [savedData writeToFile:path atomically:YES];
                }
                else
                {
                    path = [path substringToIndex:path.length-5];
                    path = [NSString stringWithFormat:@"%@-%d.jpg",path,(int)[[NSDate date] timeIntervalSince1970]];
                    savedData = [originalImage compressBelowKNum:200.0];
                    [savedData writeToFile:path atomically:YES];
                }
                
                UIImage *savedImg = [UIImage imageWithContentsOfFile:path];
                
                imageModel.imagePath = path;
                imageModel.imageName = name;
                imageModel.imageWidth = [NSString stringWithFormat:@"%f",savedImg.size.width];
                imageModel.imageHeight = [NSString stringWithFormat:@"%f",savedImg.size.height];
                
                [_imagesArray addObject:imageModel];
                [_imagesPaths addObject:path];
                if (i == mediaInfoArray.count - 1) {
                    //布局
                    [_collectionView reloadData];
                    [self updateImageView];
                }
                
            } failureBlock:^(NSError *error) {
                
            }];
        }
        
    }
}



-(void)updateImageView
{
    CGFloat height = 0;
    if (_imagesArray.count != 9) {
        NSInteger lines = (_imagesArray.count + 1) / 3 + ((_imagesArray.count + 1 ) % 3 == 0 ? 0 : 1);
        height = lines * 80 + (lines - 1) * 5;
    }
    else{
        height = 3 * 80 + 2 * 5;
    }
    [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [_containerView layoutIfNeeded];
    [UIView commitAnimations];
}

-(void)publish
{
    NSLog(@"发布");
    WS(weakSelf);
    if (![HMRunData isLogin]) {
        [self loginSuccess:^{
            [weakSelf publishFeed];
        } inViewnControll:self];
    }
    else{
        [self publishFeed];
    }
}

-(void)publishFeed
{
    [self.view endEditing:YES];
    if (_imagesPaths.count == 0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"至少上传一张图片哦", nil)];
        return;
    }
    [SVProgressHUD show];
    
    NSString * poiGuid;
    if (_isSelectedRestaurant) {
        if (_restaurantModel) {
            poiGuid =_restaurantModel.poi_guid;
        }
        else{
            poiGuid = @"";
        }
    }
    else{
        poiGuid = @"";
    }
    
    NSDictionary * params = @{
                              @"feed_description" : _textView.text ? _textView.text : @"",//可选，feed的描述
                              @"feed_is_in_restaurant" : _isSelectedRestaurant ? @"1" : @"0",//必选，美食是否来自餐馆
                              @"feed_is_public" : _privateInfo ? @"1" : @"0",//必选，该feed是否公开
                              @"feed_related_poi_guid" : poiGuid//可选，feed关联的poi的唯一标识
                              };
    [HMNetwork multipartPostImagesWithPath:HMRequestPublishFeed params:params imagesPaths:_imagesPaths onProgress:^(double progress) {
        [SVProgressHUD showProgress:progress status:NSLocalizedString(@"发布中...", nil)];
    } success:^(HMNetResponse *response) {
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        HMRunDataShare.needReflashMyFeed = YES;
        [self performSelector:@selector(cancel) withObject:nil afterDelay:0.5];
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];

}

-(void)cancel
{
    NSLog(@"取消");
    [self.navigationController popViewControllerAnimated:YES];
}

@end
