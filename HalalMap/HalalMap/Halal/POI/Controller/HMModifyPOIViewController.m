//
//  HMModifyPOIViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/20.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMModifyPOIViewController.h"
#import "HMSelectAddressViewController.h"
#import "HMSelectDistrictViewController.h"

#import "YSKeyboardScrollView.h"

@interface HMModifyPOIViewController ()
<
UIGestureRecognizerDelegate,
HMSelectAddressViewControllerDelegate,
HMSelectDistrictViewControllerDelegate
>
@end

@implementation HMModifyPOIViewController
{
    __weak IBOutlet YSKeyboardScrollView *_scrollView;
    
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UITextField *_nameTextField;
    __weak IBOutlet UIView *_nameTextFieldBancgroundView;
    
    __weak IBOutlet UILabel *_addressLabel;
    __weak IBOutlet UIButton *_selectedAddressBtn;
    
    __weak IBOutlet UITextView *_textView;
    
    
    __weak IBOutlet UILabel *_districtLabel;//区域商圈
    __weak IBOutlet UIView *_districtView;
    __weak IBOutlet UILabel *_districtDetailLabel;
    
    
    __weak IBOutlet UISwitch *_sellWineSwitch;
    __weak IBOutlet UILabel *_sellWineLabel;
    
    __weak IBOutlet UISwitch *_halalSwitch;
    __weak IBOutlet UILabel *_halaLabel;
    
    
    __weak IBOutlet UILabel *_phoneLabel;
    __weak IBOutlet UIView *_phoneTextFieldBanckgroundView;
    __weak IBOutlet UITextField *_phoneTextField;

    __weak IBOutlet UIView *_containerView;
    
    __weak IBOutlet UIView *_scrollViewAchorView;
    __weak IBOutlet NSLayoutConstraint *_containerViewHeightConstraint;
    HMAddressModel          * _currentAddressModel;
    HMBusinessAreaModel     * _businessAreaModel;
    HMDistrictModel         * _districtModel;
    UIBarButtonItem         * _rightBBI;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"完善活纠正信息", nil);
    _rightBBI = [self addBarButtonItemWithImageName:nil
                                              title:@"提交"
                                             action:@selector(publish)
                                  barButtonItemType:HMBarButtonTypeRight
                                         titleColor:[UIColor whiteColor]
                              highlightedTitleColor:nil
                                          titleFont:[HMFontHelper fontOfSize:18.0f]];
    
    [self initialUI];
    
    WS(weakSelf);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf selctDistrict];
    }];
    [_districtView addGestureRecognizer:tap];
    _currentAddressModel = [[HMAddressModel alloc] init];
    _districtModel = [[HMDistrictModel alloc] init];
    _businessAreaModel = [[HMBusinessAreaModel alloc] init];
    
    _nameTextField.text = _poidDetailModel.poi_name;
    _currentAddressModel.lon = _poidDetailModel.poi_lon;
    _currentAddressModel.lat = _poidDetailModel.poi_lat;
    _textView.text = _poidDetailModel.poi_address;
    _sellWineSwitch.on = [_poidDetailModel.poi_is_avoid_drink isEqualToString:@"1"];
    _halalSwitch.on = [_poidDetailModel.poi_is_halal_certified isEqualToString:@"1"];
    _phoneTextField.text = _poidDetailModel.poi_telephone;
}

-(void)setPoidDetailModel:(HMPOIDetailModel *)poidDetailModel
{
    _poidDetailModel = poidDetailModel;
}

-(void)initialUI
{
    _nameLabel.font =
    _addressLabel.font =
    _textView.font =
    _districtLabel.font =
    _sellWineLabel.font =
    _halaLabel.font =
    _phoneLabel.font =
    _districtDetailLabel.font = 
    [HMFontHelper fontOfSize:16.0f];
    _nameTextFieldBancgroundView.layer.borderColor = HMBorderColor.CGColor;
    _nameTextFieldBancgroundView.layer.borderWidth = 0.5f;
    
    _phoneTextFieldBanckgroundView.layer.borderColor = HMBorderColor.CGColor;
    _phoneTextFieldBanckgroundView.layer.borderWidth = 0.5f;
    
    
    _textView.layer.borderWidth = 0.5f;
    _textView.layer.borderColor = HMBorderColor.CGColor;
    
    
    _containerViewHeightConstraint.constant = _phoneTextFieldBanckgroundView.bottom > _scrollView.height ? (_phoneTextFieldBanckgroundView.bottom + 20) : (_scrollView.height + 1);
}

- (IBAction)selectAddressBtn:(UIButton *)sender
{
    NSLog(@"地图选点");
    HMSelectAddressViewController * selectAddressVC = [HMHelper xibWithViewControllerClass:[HMSelectAddressViewController class]];
    selectAddressVC.delegate = self;
    [self.navigationController pushViewController:selectAddressVC animated:YES];
}

#pragma mark - HMSelectAddressViewControllerDelegate
-(void)selectAddressWithAddressModel:(HMAddressModel *)addressModel
{
    _currentAddressModel = addressModel;
    _textView.text = _currentAddressModel.address;
}

#pragma mark - 选择商圈
-(void)selctDistrict
{
    NSLog(@"选择商圈");
    HMSelectDistrictViewController * selectDistrictVC = [HMHelper xibWithViewControllerClass:[HMSelectDistrictViewController class]];
    selectDistrictVC.delegate = self;
    [self.navigationController pushViewController:selectDistrictVC animated:YES];
}

#pragma mark - HMSelectDistrictViewControllerDelegate
-(void)selectDistrictWithDistrictModel:(HMDistrictModel *)districtModel businessModel:(HMBusinessAreaModel *)businessModel
{
    _districtModel = districtModel;
    _businessAreaModel = businessModel;
    _districtDetailLabel.text = [NSString stringWithFormat:@"%@ %@", _districtModel.district_name, _businessAreaModel.businessArea_name];
}


-(void)publish
{
    if (_nameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"没有填写餐厅名字"];
        return;
    }
    
    if (_textView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"没有填写餐厅地址"];
        return;
    }
    _rightBBI.customView.userInteractionEnabled = NO;
    
    if ([HMRunData isLogin]) {
        [self modifyPOI];
    }
    else{
        WS(weakSelf);
        [self loginSuccess:^{
            [weakSelf modifyPOI];
        } inViewnControll:self];
    }
    
}

-(void)modifyPOI
{
    NSDictionary * params = @{
                              @"poi_guid" : _poidDetailModel.poi_guid,
                              @"poi_name" : _nameTextField.text,
                              @"poi_address" : _textView.text,
                              @"poi_lon" : _currentAddressModel.lon,
                              @"poi_lat" : _currentAddressModel.lat,
                              @"poi_is_avoid_drink" : _sellWineSwitch.on ? @"1" : @"0",
                              @"poi_is_halal_certified" : _halalSwitch.on ? @"1" : @"0",
                              @"ad_guid" : _districtModel.district_guid,//区县id
                              @"b_area_guid" : _businessAreaModel.businessArea_guid,//商圈id
                              @"poi_telephone" : _phoneTextField.text
                              };
    WS(weakSelf);
    [SVProgressHUD show];
    [HMNetwork postRequestWithPath:HMRequestModifyPOI(_poidDetailModel.poi_guid) params:params success:^(HMNetResponse *response) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"提交成功，通过审核后会以消息形式通知您", nil)];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
        _rightBBI.customView.userInteractionEnabled = YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
