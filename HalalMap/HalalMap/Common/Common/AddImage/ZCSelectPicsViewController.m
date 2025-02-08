//
//  ZCAddPicsAndTextFeedViewContr.m
//  Outing
//
//  Created by yj on 14-9-30.
//  Copyright (c) 2014年 zhengchen. All rights reserved.
//

#import "ZCSelectPicsViewController.h"
#import "MJPhotoForLocalImage.h"

#define kSelectPicItemDis       4
#define kSelectPicColumns       4

@interface ZCSelectPicsViewController ()

@end

@implementation ZCSelectPicsViewController
{
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (instancetype)initWithOriginSelectedNum:(NSInteger)originSelecteNum
{
    self = [super init];
    if (self) {
        _originSelectedNum = originSelecteNum;
    }
    return self;
}

- (void)setTopBar
{
    BSUIBarButtonItem *leftBBI = [[BSUIBarButtonItem alloc] initWithTitle:@"取消" setType:BSUIBarButtonItemBack setTarget:self setAction:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftBBI;
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0, 0, 100, 44);
    [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"area_down.png"] forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"area_up.png"] forState:UIControlStateSelected];
    [titleBtn addTarget:self action:@selector(changeAlbum:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
}

- (void)instantiateDataSourceAndCollectionView
{
    _assets = [NSMutableArray array];
    _selectedAssetsArray = [NSMutableArray array];
    _selectdIdentifiersArray = [NSMutableArray array];
    _photosArray = [NSMutableArray array];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = kSelectPicItemDis;
    flowLayout.minimumInteritemSpacing = kSelectPicItemDis;
    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH - 2 * kSelectPicItemDis, kSelectPicItemDis);
    flowLayout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH - 2 * kSelectPicItemDis, kSelectPicItemDis);
    CGFloat imgWidth = (SCREEN_WIDTH - kSelectPicItemDis * (kSelectPicColumns + 1))/kSelectPicColumns;
    flowLayout.itemSize = CGSizeMake(imgWidth, imgWidth);

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kSelectPicItemDis, 0, SCREEN_WIDTH - 2*kSelectPicItemDis, SCREEN_HEIGHT_NOBAR) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[ZCPhotoItemCell class] forCellWithReuseIdentifier:@"photoItemCell"];
    [self.view addSubview:_collectionView];
    
}

- (void)addSelectAlbumTableView
{
    if (!_bgAlphaView) {
        _bgAlphaView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0 - SCREEN_HEIGHT_NOBAR - 49, self.view.width, SCREEN_HEIGHT_NOBAR + 49)];
        _bgAlphaView.backgroundColor = COLOR_WITH_ARGB(1, 1, 1, 0.6);
        [_bgAlphaView addTarget:self action:@selector(bgAlphaViewClicked:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_bgAlphaView];
    }

    if (!_selectAlbumTableView) {
        _selectAlbumTableView = [[ZCSelectAlbumTableView alloc] initWithFrame:CGRectMake(0, -kSelectAlbumTableViewHeight, SCREEN_WIDTH, kSelectAlbumTableViewHeight)];
        _selectAlbumTableView.selectDelegate = self;
        [self.view addSubview:_selectAlbumTableView];
        [self.view showLoadingMeg:@"请稍候..."];
        [_selectAlbumTableView addPicToGroup];
    }

}

- (void)addToolBar
{
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT_NOBAR, self.view.width, 49)];
    toolBar.backgroundColor = COLOR_WITH_ARGB(255, 255, 255, 0.9);
    [self.view addSubview:toolBar];
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(0, 0, 37, 32);
    cameraBtn.centerX = toolBar.width/2;
    cameraBtn.centerY = toolBar.height/2;
    [cameraBtn setImage:[UIImage imageNamed:@"take_photo.png"] forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(cameraClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:cameraBtn];
    
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneBtn.frame = CGRectMake(toolBar.width - 75, 12, 56, 49 - 12 * 2);
    _doneBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    _doneBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_doneBtn setBackgroundColor:HMMainColor forState:UIControlStateNormal];
    [_doneBtn setBackgroundColor:[HMMainColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [_doneBtn setTitle:@"完成(0)" forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_doneBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:_doneBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self setTopBar];
    [self instantiateDataSourceAndCollectionView];
    [self addToolBar];
    [self addSelectAlbumTableView];
}

#pragma mark - UITableViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _assets.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * photoItemCell = @"photoItemCell";
    ZCPhotoItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoItemCell forIndexPath:indexPath];
    cell.clickDelegate = self;
    MJPhotoForLocalImage *photo = _photosArray[indexPath.row];
    [cell configureWithAsset:photo.asset selected:photo.selected];
    return cell;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BSImageContentViewController *controller = [[BSImageContentViewController alloc] init];
    controller.delegate = self;
    controller.photos = _photosArray;
    controller.selectdIdentifiersArray = _selectdIdentifiersArray;
    controller.selectedAssetsArray = _selectedAssetsArray;
    controller.currentPhotoIndex = indexPath.row;
    controller.originSelectedNum = _originSelectedNum;
    HMBaseNavigationController *nav = [[HMBaseNavigationController alloc] initWithRootViewController:controller];
    [self  presentViewController:nav animated:YES completion:nil];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(BOOL)ZCPhotoItemCell:(ZCPhotoItemCell *)cell didSelect:(BOOL)select
{
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
    ALAsset *asset = _assets[indexPath.row];
    NSURL *identifier = [asset valueForProperty:ALAssetPropertyAssetURL];
    if (select) {
        if (_selectdIdentifiersArray.count >= 9 - _originSelectedNum) {
            NSString *message = [NSString stringWithFormat:@"您最多只能选择%ld张",9-_originSelectedNum];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
        else
        {
            if (![_selectdIdentifiersArray containsObject:identifier]) {
                [_selectdIdentifiersArray addObject:identifier];
                [_selectedAssetsArray addObject:asset];
            }
            [_doneBtn setTitle:[NSString stringWithFormat:@"完成(%ld)",_selectdIdentifiersArray.count] forState:UIControlStateNormal];
            [self synchronizePhotos];
            return YES;
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
        [_doneBtn setTitle:[NSString stringWithFormat:@"完成(%ld)",_selectdIdentifiersArray.count] forState:UIControlStateNormal];
        [self synchronizePhotos];
        return YES;
    }
}

- (void)synchronizePhotos
{
    [_photosArray removeAllObjects];
    for (ALAsset *asset in _assets) {
        NSURL *identifier = [asset valueForProperty:ALAssetPropertyAssetURL];
        if (identifier) {
            MJPhotoForLocalImage *photo = [[MJPhotoForLocalImage alloc] init];
            photo.asset = asset;
            photo.selected = [_selectdIdentifiersArray containsObject:identifier];
            [_photosArray addObject:photo];
        }
    }
}

#pragma mark - click

- (void)cancel:(UIButton *)sender
{
    UIViewController *aController = self.presentingViewController;
    [self dismissViewControllerAnimated:NO completion:^{
        [aController dismissViewControllerAnimated:NO completion:nil];
    }];
    return;
    
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你确定要退出发布？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
//        if (buttonIndex == 1) {
//            UIViewController *aController = self.presentingViewController;
//            [self dismissViewControllerAnimated:NO completion:^{
//                [aController dismissViewControllerAnimated:NO completion:nil];
//            }];
//        }
//    }];

}

- (void)changeAlbum:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        _bgAlphaView.top = 20;
        [UIView animateWithDuration:0.2 animations:^{
            _bgAlphaView.alpha = 0.5;
            _selectAlbumTableView.top = 20;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                _selectAlbumTableView.top = 0;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 animations:^{
            _bgAlphaView.alpha = 0;
            _selectAlbumTableView.top = -_selectAlbumTableView.height;
        } completion:^(BOOL finished) {
            _bgAlphaView.top = -SCREEN_HEIGHT_NOBAR - 49;
        }];
    }

}

- (void)bgAlphaViewClicked:(UIControl *)sender
{
    [self changeAlbum:(UIButton *)self.navigationItem.titleView];
}

#pragma mark - ZCSelectAlbumTableViewDelegate
- (void)ZCSelectAlbumTableView:(ZCSelectAlbumTableView *)tableView didSelectAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    [self changeAlbum:(UIButton *)self.navigationItem.titleView];
    [self reloadWithAssetsGroup:assetsGroup];
}

- (void)ZCSelectAlbumTableViewDidLoadFirstGroup
{
    if (_selectAlbumTableView.assetsGroups.count) {
        [self reloadWithAssetsGroup:_selectAlbumTableView.assetsGroups[0]];
    }
    else
    {
        [self.view hideLoading];
    }
}

#pragma mark - reload
- (void)reloadWithAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    if (assetsGroup == self.assetsGroup) {
        return;
    }
    [_assets removeAllObjects];
    self.assetsGroup = assetsGroup;
    [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result) {
            [_assets addObject:result];
        }
    }];
    UIButton *titleBtn = (UIButton *)self.navigationItem.titleView;
    if ([[assetsGroup valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"Camera Roll"]) {
        [titleBtn setTitle:@"相机胶卷" forState:UIControlStateNormal];
    }
    else
    {
        [titleBtn setTitle:[assetsGroup valueForProperty:ALAssetsGroupPropertyName] forState:UIControlStateNormal];
    }
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGFloat kPadding = 5;
    [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -titleBtn.imageView.size.width, 0, titleBtn.imageView.size.width)];
    [titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, titleBtn.titleLabel.bounds.size.width + kPadding, 0, -titleBtn.titleLabel.bounds.size.width - kPadding)];
    
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_assets.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    [self.view hideLoading];
    [self synchronizePhotos];
}

- (void)cameraClick:(UIButton *)sender
{
    if (_selectdIdentifiersArray.count >= 9 - _originSelectedNum) {
        NSString *message = [NSString stringWithFormat:@"您最多只能选择%ld张",9-_originSelectedNum];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //拍照
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    if (TARGET_IPHONE_SIMULATOR){
        return;
    }
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:ipc animated:YES completion:^{
        
    }];
}

- (NSDictionary *)mediaInfoFromAsset:(ALAsset *)asset
{
    NSMutableDictionary *mediaInfo = [NSMutableDictionary dictionary];
    [mediaInfo setObject:[asset valueForProperty:ALAssetPropertyType] forKey:@"UIImagePickerControllerMediaType"];
    [mediaInfo setObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]] forKey:@"UIImagePickerControllerOriginalImage"];
    [mediaInfo setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:@"UIImagePickerControllerReferenceURL"];
    return mediaInfo;
}

#pragma mark - done
- (void)done:(UIButton *)sender
{
    if (_selectedAssetsArray.count > 0) {
        [HM_KEY_WINDOW showLoadingMeg:@"正在处理..."];
    }
    if ([self.delegate respondsToSelector:@selector(ZCSelectPicsViewController:didFinishPickingAssets:)]) {
        NSMutableArray *infos = [NSMutableArray array];
        for(ALAsset *asset in _selectedAssetsArray) {
            [infos addObject:[self mediaInfoFromAsset:asset]];
        }
        [self.delegate ZCSelectPicsViewController:self didFinishPickingAssets:infos];
        [self dismissViewControllerAnimated:NO completion:^{
            [HM_KEY_WINDOW hideLoading];
        }];
    }
    else
    {
        [HM_KEY_WINDOW hideLoading];
    }
}


//ipc delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([self.delegate respondsToSelector:@selector(ZCSelectPicsViewController:didFinishPickingAssets:)]) {
        [self.view showLoadingMeg:@"正在处理..."];

        NSMutableArray *infos = [NSMutableArray array];
        
        for(ALAsset *asset in _selectedAssetsArray) {
            [infos addObject:[self mediaInfoFromAsset:asset]];
        }
        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:info];
        [infos addObject:muDic];
        [self.delegate ZCSelectPicsViewController:self didFinishPickingAssets:infos];
        [self dismissViewControllerAnimated:NO completion:^{
            [self dismissViewControllerAnimated:YES completion:^{
                [self.view hideLoading];
            }];
        }];
    }
}

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

#pragma mark - BSImageContentViewController
- (void)BSImageContentViewControllerDidDismiss
{
    [_collectionView reloadData];
    [_doneBtn setTitle:[NSString stringWithFormat:@"完成(%ld)",_selectdIdentifiersArray.count] forState:UIControlStateNormal];
    [self synchronizePhotos];
}

- (void)BSImageContentViewControllerDidComplete
{
    _doneBtn.userInteractionEnabled = NO;
    _collectionView.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    [self done:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
