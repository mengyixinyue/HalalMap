//
//  HMAboutViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/5/7.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMAboutViewController.h"

@interface HMAboutViewController ()

@end

@implementation HMAboutViewController
{
    
    __weak IBOutlet UIView *_anchorView;
    
    __weak IBOutlet NSLayoutConstraint *_anchorViewHeight;
    
    __weak IBOutlet NSLayoutConstraint *_anchorViewWidth;
    
    __weak IBOutlet UIScrollView *_scrollView;
    
    __weak IBOutlet UIView *_containerView;
    
    __weak IBOutlet UILabel *_versionLabel;
    
      YYLabel *_contentLabel;
    
      YYLabel *_telePhoneLabel;
    
      YYLabel *_qqLabel;
      YYLabel *_emailLabel;
}

//
//-(void)awakeFromNib
//{
//    [super awakeFromNib];
//    [self configureUI];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"关于", nil);
    [self configureUI];

}

-(void)configureUI
{
    _versionLabel.font = [HMFontHelper fontOfSize:14.0f];
    _versionLabel.text = [NSString stringWithFormat:@"清真地图v%@", currentShortVersionString];
    
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.font = [HMFontHelper fontOfSize:16.0f];
        _contentLabel.numberOfLines = 0;
        [_containerView addSubview:_contentLabel];
    }
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_versionLabel.mas_bottom).with.offset(25);
    }];
    
    
    NSString * contentString = @"		清真地图初期致力于通过平台收集、用户上传、分享清真美食等方式沉淀餐厅数据、建立全面立体的清真餐厅数据库，让出门在外的多斯堤能快速找到清真餐厅。\n\n		如果您对清真地图有任何建议或者在使用过程中有任何不满意的地方，非常希望您能联系我们，以便我们增加更加有用的功能和优化清真地图。\n\n		清真地图由个人开发者开发，欢迎有相同志趣的多斯堤能参与进来。";
    
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attributedStr setLineSpacing:7];
    [attributedStr setFont:[HMFontHelper fontOfSize:16.0f]];
    attributedStr.color = HMBlackColor;
    _contentLabel.attributedText =attributedStr;

    YYTextLayout * layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) text:attributedStr];
    _contentLabel.size = layout.textBoundingSize;
    _contentLabel.textLayout = layout;


    
    WS(weakSelf);
    if (!_telePhoneLabel) {
        _telePhoneLabel = [[YYLabel alloc] init];
        [_containerView addSubview:_telePhoneLabel];
        _telePhoneLabel.font = [HMFontHelper fontOfSize:16.0f];
    }
    [_telePhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(_contentLabel.mas_bottom).with.offset(7);
    }];
    
    NSString * telephoneStr = @"联系电话：13520317263";
    NSMutableAttributedString * telephoneAttributedStr = [[NSMutableAttributedString alloc] initWithString:telephoneStr];
    [telephoneAttributedStr setFont:[HMFontHelper fontOfSize:16.0f]];
    telephoneAttributedStr.color = HMBlackColor;
    NSRange telephoneRange = [telephoneStr rangeOfString:@"13520317263"];
    [telephoneAttributedStr setTextHighlightRange:telephoneRange color:HMMainColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [weakSelf telephone];
    }];
    
    _telePhoneLabel.attributedText = telephoneAttributedStr;
    
    YYTextLayout * telephoneLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT) text:telephoneAttributedStr];
    _telePhoneLabel.size = telephoneLayout.textBoundingSize;
    _telePhoneLabel.textLayout = telephoneLayout;

    
    
    if (!_qqLabel) {
        _qqLabel = [[YYLabel alloc] init];
        [_containerView addSubview:_qqLabel];
        _qqLabel.font = [HMFontHelper fontOfSize:16.0f];
    }

    [_qqLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_telePhoneLabel.mas_left);
        make.right.equalTo(_telePhoneLabel.mas_right);
        make.top.equalTo(_telePhoneLabel.mas_bottom).offset(7);
    }];
    
    NSString * qqStr = @"联系QQ： 1220279363";
    NSMutableAttributedString * qqAttributedStr = [[NSMutableAttributedString alloc] initWithString:qqStr];
    [qqAttributedStr setFont:[HMFontHelper fontOfSize:16.0f]];
    qqAttributedStr.color = HMBlackColor;
    NSRange qqRange = [qqStr rangeOfString:@"1220279363"];
    [qqAttributedStr setTextHighlightRange:qqRange color:HMMainColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [weakSelf qq];
    }];
    
    _qqLabel.attributedText = qqAttributedStr;
    
    YYTextLayout * qqLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT) text:qqAttributedStr];
    _qqLabel.size = qqLayout.textBoundingSize;
    _qqLabel.textLayout = qqLayout;
    
    
    if (!_emailLabel) {
        _emailLabel = [[YYLabel alloc] init];
        _emailLabel.font = [HMFontHelper fontOfSize:16.0f];
        [_containerView addSubview:_emailLabel];
    }
    [_emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_telePhoneLabel.mas_left);
        make.right.equalTo(_telePhoneLabel.mas_right);
        make.top.equalTo(_qqLabel.mas_bottom).offset(7);
    }];
    
    NSString * emailStr = @"联系邮箱：zcy.0538@163.com";
    NSMutableAttributedString * emailAttributedStr = [[NSMutableAttributedString alloc] initWithString:emailStr];
    [emailAttributedStr setFont:[HMFontHelper fontOfSize:16.0f]];
    emailAttributedStr.color = HMBlackColor;
    NSRange emailRange = [emailStr rangeOfString:@"zcy.0538@163.com"];
    [emailAttributedStr setTextHighlightRange:emailRange color:HMMainColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [weakSelf email];
    }];
    
    _emailLabel.attributedText = emailAttributedStr;
    YYTextLayout * emailLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(SCREEN_WIDTH - 50, MAXFLOAT) text:emailAttributedStr];
    _emailLabel.size = emailLayout.textBoundingSize;
    _emailLabel.textLayout = emailLayout;
    
    
    _anchorViewHeight.constant = (_emailLabel.bottom) > _scrollView.height ? (_emailLabel.bottom + 10) : (_scrollView.height + 1);
    [self.view layoutIfNeeded];
}

-(void)telephone
{
    
}

-(void)qq
{
    
}


-(void)email
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
