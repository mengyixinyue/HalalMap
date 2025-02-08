//
//  HMAddPicsViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/19.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMAddPicsViewController.h"
#import "HMImageCell.h"
#import "HMAddCell.h"
#import "ZCSelectPicsViewController.h"
#import "ZCImageInfoModel.h"

@interface HMAddPicsViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIActionSheetDelegate,
HMImageCellDelegate,
ZCSelectPicsViewControllerDelegate
>
@end

@implementation HMAddPicsViewController
{
    __weak IBOutlet UICollectionView *_collectionView;
    NSMutableArray      * _imagesArray;
    NSMutableArray      * _imagesPaths;
    UIBarButtonItem     * _rightBBI;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isMovingToParentViewController) {
        [self collectionView:_collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title =  NSLocalizedString(@"上传图片", nil);
    
    _rightBBI = [self addBarButtonItemWithImageName:nil
                                  title:@"上传"
                                 action:@selector(publish)
                      barButtonItemType:HMBarButtonTypeRight
                             titleColor:[UIColor whiteColor]
                  highlightedTitleColor:nil
                              titleFont:[HMFontHelper fontOfSize:18.0f]];
    
    _imagesArray = [[NSMutableArray alloc] init];
    _imagesPaths = [[NSMutableArray alloc] init];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 15;//同一行 cell与cell之间的间距
    layout.minimumLineSpacing = 15;//行与行之间的间距
    CGFloat width = (_collectionView.width - 5 * 15) / 4.0f;
    layout.itemSize = CGSizeMake( width, width * 4  / 5.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView.collectionViewLayout = layout;
    [_collectionView registerNib:[UINib nibWithNibName:@"HMImageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([HMImageCell class])];
    [_collectionView registerNib:[UINib nibWithNibName:@"HMAddCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:NSStringFromClass([HMAddCell class])];
}

#pragma mark  - UICollectionViewDataSource
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
    if (_imagesArray == 0) {
        _rightBBI.enabled = NO;
    }
    else{
        _rightBBI.enabled = YES;
    }
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


#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (_collectionView.width - 5 * 15) / 4.0f;
    return CGSizeMake( width, width * 4  / 5.0f);
}

#pragma mark - HMImageCellDelegate
-(void)deleteImage:(HMImageCell *)imageCell
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除图片？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView showWithCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            NSIndexPath * indexPath = [_collectionView indexPathForCell:imageCell];
            [_imagesArray removeObjectAtIndex:indexPath.row];
            [_imagesPaths removeObjectAtIndex:indexPath.row];
            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
    }];
    
}

#pragma mark - ZCSelectPicsViewControllerDelegate
-(void)ZCSelectPicsViewController:(ZCSelectPicsViewController *)controller didFinishPickingAssets:(NSArray *)assets
{
    
    if (assets.count == 0) {
        [_collectionView reloadData];
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
                }
                
            } failureBlock:^(NSError *error) {
                
            }];
        }
        
    }
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 0, 15);
}

-(void)publish
{
    _rightBBI.customView.userInteractionEnabled = NO;
    WS(weakSelf);
    [HMNetwork multipartPostImagesWithPath:HMRequestPostPOIImages(_poi_guid) params:nil imagesPaths:_imagesPaths onProgress:^(double progress) {
        [SVProgressHUD showProgress:progress status:NSLocalizedString(@"上传中", nil)];
    } success:^(HMNetResponse *response) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"上传成功", nil)];
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(reflashPicList)]) {
            [weakSelf.delegate reflashPicList];
        }
        [weakSelf performSelector:@selector(popVC) withObject:nil afterDelay:0.5];
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
        _rightBBI.customView.userInteractionEnabled = YES;
    }];
}

-(void)popVC
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
