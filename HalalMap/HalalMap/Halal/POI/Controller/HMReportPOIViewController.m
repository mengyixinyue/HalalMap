//
//  HMReportPOIViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/14.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMReportPOIViewController.h"
#import "HMImageCell.h"
#import "HMAddCell.h"
#import "HMSelectAddressView.h"
#import "HMSelectAddressEntranceView.h"
#import "HMSelectPrivateView.h"
#import "ZCSelectPicsViewController.h"
#import "YSKeyboardScrollView.h"
#import "HMSelectCityViewController.h"
#import "HMSelectAddressViewController.h"

#import "ZCImageInfoModel.h"

#define HMReportPOIHorizonMargin  (15)
#define HMReportPOIVerticlePadding    (10)

@interface HMReportPOIViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UITextViewDelegate,
UIActionSheetDelegate,
HMImageCellDelegate,
ZCSelectPicsViewControllerDelegate,
HMSelectAddressViewControllerDelegate
>
@end

@implementation HMReportPOIViewController
{
    
    __weak IBOutlet YSKeyboardScrollView *_scrollView;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UITextField *_nameTextField;
    __weak IBOutlet UIView *_nameTextFieldBancgroundView;
    __weak IBOutlet UILabel *_addressLabel;
    __weak IBOutlet UIButton *_selectedAddressBtn;
    __weak IBOutlet UITextView *_textView;
    __weak IBOutlet UISwitch *_sellWineSwitch;
    __weak IBOutlet UILabel *_sellWineLabel;
    __weak IBOutlet UISwitch *_halalSwitch;
    __weak IBOutlet UILabel *_halaLabel;
    __weak IBOutlet UILabel *_addPicLabel;
    UICollectionView    * _collectionView;
    NSMutableArray      * _imagesArray;
    NSMutableArray      * _imagesPaths;
    __weak IBOutlet UIView *_containerView;
    
    __weak IBOutlet UIView *_scrollViewAchorView;
    __weak IBOutlet NSLayoutConstraint *_containerViewHeightConstraint;
    HMAddressModel          * _currentAddressModel;
    UIBarButtonItem         * _rightBBI;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"上报餐厅", nil);
    _rightBBI = [self addBarButtonItemWithImageName:nil
                                  title:@"提交"
                                 action:@selector(publish)
                      barButtonItemType:HMBarButtonTypeRight
                             titleColor:[UIColor whiteColor]
                  highlightedTitleColor:nil
                              titleFont:[HMFontHelper fontOfSize:18.0f]];
    _imagesArray = [[NSMutableArray alloc] init];
    _imagesPaths = [[NSMutableArray alloc] init];
    [self initialUI];
    
}


-(void)initialUI
{
    _nameLabel.font =
    _addressLabel.font =
    _textView.font =
    _sellWineLabel.font =
    _halaLabel.font =
    _addPicLabel.font =
    [HMFontHelper fontOfSize:16.0f];
    _nameTextFieldBancgroundView.layer.borderColor = HMBorderColor.CGColor;
    _nameTextFieldBancgroundView.layer.borderWidth = 0.5f;
    
    _textView.layer.borderWidth = 0.5f;
    _textView.layer.borderColor = HMBorderColor.CGColor;
    
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
        make.left.mas_equalTo(HMReportPOIHorizonMargin);
        make.width.mas_equalTo(80 * 3 + 10);
        make.top.equalTo(_addPicLabel.mas_bottom).with.offset(HMReportPOIVerticlePadding);
        make.height.mas_equalTo(100);
    }];
    
    _containerViewHeightConstraint.constant = _collectionView.bottom > _scrollView.height ? (_collectionView.bottom + 20) : (_scrollView.height + 1);
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

#pragma mark - HMImageCellDelegate
-(void)deleteImage:(HMImageCell *)imageCell
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除图片？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    __weak HMReportPOIViewController * weakSelf = self;
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
    _containerViewHeightConstraint.constant = (_collectionView.top + height) > _scrollView.height ? (_collectionView.top + height + 20) : (_scrollView.height + 1);
    [self.view layoutIfNeeded];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 1500) {
        [self.view showLoadingMeg:NSLocalizedString(@"描述文字字数不能超过1500字符", nil) time:ERRORMESSAGESHOWTIME];
        return NO;
    }
    return YES;
}

- (IBAction)selectAddressBtn:(UIButton *)sender
{
    NSLog(@"地图选点");
    HMSelectAddressViewController * selectAddressVC = [HMHelper xibWithViewControllerClass:[HMSelectAddressViewController class]];
    selectAddressVC.delegate = self;
    [self.navigationController pushViewController:selectAddressVC animated:YES];
}


-(void)publish
{
    NSLog(@"提交");
    if (_nameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"没有填写餐厅名字"];
        return;
    }
    
    if (_textView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"没有填写餐厅地址"];
        return;
    }
    _rightBBI.customView.userInteractionEnabled = NO;
    
    NSDictionary * params = @{
                              @"poi_name" : _nameTextField.text,
                              @"poi_address" : _textView.text,
                              @"poi_lon" : _currentAddressModel.lon,
                              @"poi_lat" : _currentAddressModel.lat,
                              @"poi_is_avoid_drink" : _sellWineSwitch.on ? @"1" : @"0",
                              @"poi_is_halal_certified" : _halalSwitch.on ? @"1" : @"0",
                              @"city_guid" : _currentAddressModel.city.city_guid
                              };
    WS(weakSelf);
    [SVProgressHUD show];
    [HMNetwork postRequestWithPath:HMRequestAddPOI params:params success:^(HMNetResponse *response) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"上报成功", nil)];
        if ([response.data isKindOfClass:[NSDictionary class]] && [response.data objectForKey:@"poi_guid"]) {
            [weakSelf updatImagesWithPOIguid:[response.data objectForKey:@"poi_guid"]];
        }
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
        _rightBBI.customView.userInteractionEnabled = YES;
    }];

}

-(void)updatImagesWithPOIguid:(NSString *)poi_guid
{
    if (_imagesArray.count == 0) {
        [self popVC];
        return;
    }
    WS(weakSelf);
    [HMNetwork multipartPostImagesWithPath:HMRequestPostPOIImages(poi_guid) params:nil imagesPaths:_imagesPaths onProgress:^(double progress) {
        [SVProgressHUD showProgress:progress status:NSLocalizedString(@"上传图片中", nil)];
    } success:^(HMNetResponse *response) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"图片上传成功", nil)];
        [weakSelf performSelector:@selector(popVC) withObject:nil afterDelay:0.5];
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
        _rightBBI.customView.userInteractionEnabled = YES;
    }];
}

-(void)popVC
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - HMSelectAddressViewControllerDelegate
-(void)selectAddressWithAddressModel:(HMAddressModel *)addressModel
{
    _currentAddressModel = addressModel;
    _textView.text = _currentAddressModel.address;
}



-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
