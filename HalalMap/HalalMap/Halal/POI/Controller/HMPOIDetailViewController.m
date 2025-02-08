//
//  HMPOIDetailViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/23.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMPOIDetailViewController.h"
#import "HMPOICommentListViewController.h"
#import "HMGPSViewController.h"
#import "HMPOIPicListViewController.h"
#import "HMAddPicsViewController.h"
#import "HMModifyPOIViewController.h"
#import "HMPOICommentViewController.h"

#import "HMCommentCell.h"
#import "HMStarView.h"

#import "HMPOIDetailModel.h"
#import "HMCommentModel.h"

@interface HMPOIDetailViewController ()
<
HMCommentCellDelegate,
UIGestureRecognizerDelegate,
UIActionSheetDelegate,
HMPOICommentViewControllerDelegate
>

@end

@implementation HMPOIDetailViewController
{
    __weak IBOutlet UIScrollView *_scrollview;
    __weak IBOutlet UIView *_containerView;
    
    __weak IBOutlet UIImageView *_poiImageView;//图片
    
    
    __weak IBOutlet UILabel *_moreLabel;

    __weak IBOutlet UILabel *_nameLabel;//餐厅名字
    
    __weak IBOutlet UIImageView *_drinkImageView;//禁止售酒图片

    __weak IBOutlet UIView *_starBackgroundView;//星星等级
    HMStarView * _starView;
    __weak IBOutlet NSLayoutConstraint *_starViewHeightConstaint;
    __weak IBOutlet NSLayoutConstraint *_starViewWidthConstraint;
    
    
    __weak IBOutlet UIView *_addressView;
    __weak IBOutlet UILabel *_addressLabel;//地址
    __weak IBOutlet UIView *_addressBottomLineView;
    
    __weak IBOutlet UIView *_telephoneView;
    __weak IBOutlet UILabel *_telephoneLabel;//电话
//    __weak IBOutlet NSLayoutConstraint *_telephontHeightConstraint;

    
    __weak IBOutlet UIButton *_editInfoBtn;//完善或纠正信息
    
    __weak IBOutlet UILabel *_commentNumLabel;//评论个数
    __weak IBOutlet UIControl *_commentNumControl;
    __weak IBOutlet UIView *_commentBackgroundView;
    
    __weak IBOutlet UIView *_commentView;
    __weak IBOutlet NSLayoutConstraint *_commenViewHeightConstraint;
    
    __weak IBOutlet UIView *_bottomView;
    
    
    __weak IBOutlet UIButton *_favoriteBtn;
    
    __weak IBOutlet NSLayoutConstraint *_contraintViewHeightConstraint;

    HMPOIDetailModel * _model;
    
    
    HMCommentCell *_lastCommentCell;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"详情", nil);
    
    
    [self addBarButtonItemWithImageName:@"share"
                                  title:nil
                                 action:@selector(share)
                      barButtonItemType:HMBarButtonTypeRight
                             titleColor:nil
                  highlightedTitleColor:nil
                              titleFont:nil];

    
    _nameLabel.font = [HMFontHelper fontOfSize:18.0f];
    _addressLabel.font = [HMFontHelper fontOfSize:14.0f];
    WS(weakSelf);
    UITapGestureRecognizer * addressTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf gotoGPS];
    }];
    [_addressView addGestureRecognizer:addressTap];
    
    _telephoneLabel.font = [HMFontHelper fontOfSize:14.0f];
    
    UITapGestureRecognizer * telePhoneTap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf telephone];
    }];
    [_telephoneView addGestureRecognizer:telePhoneTap];
    
    _editInfoBtn.titleLabel.font = [HMFontHelper fontOfSize:14.0f];
    _commentNumLabel.font = [HMFontHelper fontOfSize:14.0f];
    _moreLabel.font = [HMFontHelper fontOfSize:10.0f];
    
    _poiImageView.layer.borderColor = HMBorderColor.CGColor;
    _poiImageView.layer.borderWidth = 0.5f;
    _poiImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf poiImageViewClick];
    }];
    [_poiImageView addGestureRecognizer:tap];
    
    _starBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    _starBackgroundView.autoresizesSubviews = NO;
   
    _starView = [HMHelper xibWithClass:[HMStarView class]];
    [_starBackgroundView addSubview:_starView];
    _starViewWidthConstraint.constant = [_starView width];
    _starViewHeightConstaint.constant = [_starView height];
    CGSize size = CGSizeMake(_starView.width, _starView.height);
    [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_starBackgroundView);
        make.width.mas_equalTo(size);
    }];
    
    _starViewHeightConstaint.constant = size.height;
    _starViewWidthConstraint.constant = size.width;

    [self.view layoutIfNeeded];
    
    
    [self getData];
}

-(void)getData
{
    [SVProgressHUD show];
    [HMNetwork getRequestWithPath:HMRequestPOIDetail(_poi_guid)
                           params:nil
                       modelClass:[HMPOIDetailModel class]
                          success:^(id object, HMNetPageInfo *pageInfo) {
                              [SVProgressHUD dismiss];
                              _model = object;
                              [self configureUI];
                          }];
  
}


-(void)configureUI
{
    [_poiImageView sd_setImageWithURL:[NSURL URLWithString:_model.poi_photo.thumb_url] placeholderImage:nil];
    _nameLabel.text = _model.poi_name;
    [_starView configureWithScore:[_model.poi_stars floatValue]];
    
    _drinkImageView.hidden = [_model.poi_is_avoid_drink intValue];
    _addressLabel.text = _model.poi_address;
    if (_model.poi_telephone || _model.poi_telephone.length != 0) {
        _telephoneLabel.text = _model.poi_telephone;
//        _telephontHeightConstraint.constant = 55;
        _addressBottomLineView.hidden = NO;
        _telephoneView.hidden = NO;
    }
    else{
//        _telephontHeightConstraint.constant = 0;
//        _telephoneLabel.text = @"";
        _addressBottomLineView.hidden = YES;
        _telephoneView.hidden = YES;
    }
    
    CGFloat allHeight = _commentNumControl.bottom;
    
    if ([_model.comment_count isEqualToString:@"0"]) {
        allHeight = 0;
        _commentBackgroundView.hidden = YES;
        
    }
    else{
        _commentNumLabel.text = [NSString stringWithFormat:@"共%@条评论", _model.comment_count];
        for (int i =0; i < _model.comments.count; i ++) {
            HMCommentCell * cell = [HMHelper xibWithClass:[HMCommentCell class]];
            [_commentView addSubview:cell];
            __weak HMCommentCell * weakLastCell = _lastCommentCell;
            __weak UIView *weakCommentView = _commentView;
            __weak HMCommentCell * weakCell = cell;
            [cell.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(weakCell);
            }];
            if (!_lastCommentCell) {
                [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.equalTo(weakCommentView);
                }];
            }
            else{
                [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(weakCommentView);
                    make.top.equalTo(weakLastCell.mas_bottom);
                }];
                
            }
            cell.delegate = self;
            cell.tag = i + 100;
            [cell configureWithModel:_model.comments[i]];
           
            _lastCommentCell = cell;

        }
        
//        _commenViewHeightConstraint.constant = _lastCommentCell.bottom;
        _commentBackgroundView.hidden = NO;
    }
    
    if ([_model.is_current_user_favorited isEqualToString:@"1"]) {
        _favoriteBtn.selected = YES;
    }
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}


-(void)gotoGPS
{
    HMGPSViewController * gpsVC = [HMHelper xibWithViewControllerClass:[HMGPSViewController class]];
    gpsVC.model = _model;
    [self.navigationController pushViewController:gpsVC animated:YES];
}

-(void)telephone
{
    if (_model && _model.poi_telephone) {
        NSArray * telePhones = [_model.poi_telephone componentsSeparatedByString:@";"];
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"拨打电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        for (NSString * str in telePhones) {
            [actionSheet addButtonWithTitle:str];
        }
        [actionSheet showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSArray * telePhones = [_model.poi_telephone componentsSeparatedByString:@";"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [telePhones objectAtIndex:buttonIndex - 1]]]];
    }
}

#pragma mark - HMCommentCellDelegate
-(void)clickHeaderImageViewWithCommentCell:(HMCommentCell *)cell
{
    NSLog(@"用户信息");
}

#pragma mark - 查看更多图片
- (void)poiImageViewClick
{
    HMPOIPicListViewController * picListVC = [HMHelper xibWithViewControllerClass:[HMPOIPicListViewController class]];
    picListVC.poi_guid = _model.poi_guid;
    [self.navigationController pushViewController:picListVC animated:YES];
}

#pragma mark - 完善或纠正信息
- (IBAction)gotoEditInfo:(id)sender
{
    [self modigyPOI];
}

-(void)modigyPOI
{
    HMModifyPOIViewController * modifyPOIVC = [HMHelper xibWithViewControllerClass:[HMModifyPOIViewController class]];
    modifyPOIVC.poidDetailModel = _model;
    [self.navigationController pushViewController:modifyPOIVC animated:YES];
}


#pragma mark - 去查看更多评论
- (IBAction)gotoCommentList:(UIButton *)sender
{
    HMPOICommentListViewController * poiCommentListVC = [[HMPOICommentListViewController alloc] initWithNibName:NSStringFromClass([HMPOICommentListViewController class]) bundle:[NSBundle mainBundle]];
    poiCommentListVC.poi_guid = _model.poi_guid;
    [self.navigationController pushViewController:poiCommentListVC animated:YES];
}


#pragma mark - 收藏
- (IBAction)favoriteBtnClick:(UIButton *)sender
{
    NSLog(@"%@", HMRunDataShare.userModel.api_token);
    if ([HMRunData isLogin]) {
        [self favorite];
    }
    else{
        [self loginSuccess:^{
            [self favorite];
        } inViewnControll:self];
    }
}

-(void)favorite
{
    [SVProgressHUD show];
    _favoriteBtn.userInteractionEnabled = NO;
    if (_favoriteBtn.selected) {
        [HMNetwork deleteRequestWithPath:HMRequestFavoritePOI(_poi_guid) params:nil success:^(HMNetResponse *response) {
            _favoriteBtn.userInteractionEnabled = YES;
            HMRunDataShare.needReflashMyPOI  = YES;
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"取消收藏成功", nil)];
            _favoriteBtn.selected = !_favoriteBtn.selected;
        } failure:^(HMNetResponse *response, NSString *errorMsg) {
            _favoriteBtn.userInteractionEnabled = YES;
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }];
    }
    else{
        [HMNetwork postRequestWithPath:HMRequestFavoritePOI(_poi_guid) params:nil success:^(HMNetResponse *response) {
            _favoriteBtn.userInteractionEnabled = YES;
            HMRunDataShare.needReflashMyPOI  = YES;
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"收藏成功", nil)];
            _favoriteBtn.selected = !_favoriteBtn.selected;
        } failure:^(HMNetResponse *response, NSString *errorMsg) {
            _favoriteBtn.userInteractionEnabled = YES;
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }];
    }
}

#pragma mark- 传图片
- (IBAction)gotoUploadPic:(UIButton *)sender
{
    HMAddPicsViewController * addPicsVC = [HMHelper xibWithViewControllerClass:[HMAddPicsViewController class]];
    addPicsVC.poi_guid = _model.poi_guid;
    [self.navigationController pushViewController:addPicsVC animated:YES];
}

#pragma mark - 评论
- (IBAction)gotoComment:(UIButton *)sender
{
    if ([HMRunData isLogin]) {
        [self gotoCommentVC];
    }else{
        WS(weakSelf);
        [self loginSuccess:^{
            [weakSelf gotoCommentVC];
        } inViewnControll:self];
    }
   
}

-(void)gotoCommentVC
{
    HMPOICommentViewController * poiCommentVC = [HMHelper xibWithViewControllerClass:[HMPOICommentViewController class]];
    poiCommentVC.poi_guid = _model.poi_guid;
    poiCommentVC.delegate = self;
    [self.navigationController pushViewController:poiCommentVC animated:YES];
}

#pragma mark - 分享
-(void)share
{
    
}

#pragma mark - HMPOICommentViewControllerDelegate
-(void)commentSuccess
{
    [self getData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _commenViewHeightConstraint.constant = CGRectGetMaxY(_lastCommentCell.frame);
//    + _commentBackgroundView.top;
    
    CGFloat height = CGRectGetMaxY(_commentBackgroundView.frame);
    if (height > self.view.height - _bottomView.height) {
        _contraintViewHeightConstraint.constant = height + 1;
    }
    else{
        _contraintViewHeightConstraint.constant = self.view.height - _bottomView.height + 1;

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
