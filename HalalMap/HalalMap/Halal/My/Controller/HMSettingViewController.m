//
//  HMSettingViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/24.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMSettingViewController.h"
#import "HMEditPersonalInfoViewController.h"
#import "HMChangePasswordViewController.h"
#import "HMAboutViewController.h"
#import "HMFeedbackViewController.h"

#import "HMEditPersonalInfoCell.h"

#import "SDImageCache.h"

#import "HMSettingModel.h"

@interface HMSettingViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIActionSheetDelegate
>

@end

@implementation HMSettingViewController
{
    __weak IBOutlet UITableView * _tableView;
    NSMutableArray              * _titlesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"设置", nil);
    
    [self getDate];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HMEditPersonalInfoCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([HMEditPersonalInfoCell class])];
}

-(void)getDate
{
    if (!_titlesArray) {
        _titlesArray = [[NSMutableArray alloc] init];
    }
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    if ([HMRunData isLogin]) {
        HMSettingModel * model1 = [HMSettingModel settingModelWithType:HMSettingTypePersonalInfo title:NSLocalizedString(@"个人资料设置", nil)];
        HMSettingModel * model2 = [HMSettingModel settingModelWithType:HMSettingTypeChangePassword title:NSLocalizedString(@"修改密码", nil)];
        [array addObjectsFromArray:@[model1, model2]];
    }
    HMSettingModel * model3 = [HMSettingModel settingModelWithType:HMSettingTypeHomePageShowType title:NSLocalizedString(@"首页默认显示形式", nil)];
    HMSettingModel * model4 = [HMSettingModel settingModelWithType:HMSettingTypeClearCache title:NSLocalizedString(@"清除缓存", nil)];
    [array addObjectsFromArray:@[model3, model4]];
    
    [_titlesArray addObject:array];
    
    
    HMSettingModel * model5 = [HMSettingModel settingModelWithType:HMSettingTypeSuggest title:NSLocalizedString(@"意见与建议", nil)];
    HMSettingModel * model6 = [HMSettingModel settingModelWithType:HMSettingTypeGotoComment title:NSLocalizedString(@"五星好评", nil)];
    HMSettingModel * model7 = [HMSettingModel settingModelWithType:HMSettingTypeAbout title:NSLocalizedString(@"关于", nil)];
    
    NSArray * array2 = @[model5, model6, model7];
    [_titlesArray addObject:array2];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr = [_titlesArray objectAtIndex:section];
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMEditPersonalInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMEditPersonalInfoCell class])];
    HMSettingModel * model = _titlesArray[indexPath.section][indexPath.row];
    
    if (model.settingType == HMSettingTypeHomePageShowType) {
        NSInteger type = [[USERDEFAULT objectForKey:HMHomePageShowTypeKey] integerValue];
        if (type == HMHomePageShowTypeList)
        {
            [cell configureWithTitle:model.title content:@"列表"];
        }
        else{
            [cell configureWithTitle:model.title content:@"地图"];
        }
    }else{
        [cell configureWithTitle:model.title content:@" "];
    }
    return cell;
    return [UITableViewCell new];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titlesArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section != _titlesArray.count - 1) {
        UIView * view = [[UIView alloc] init];
        return view;
    }
    else{
        if (![HMRunData isLogin]) {
            UIView * view = [[UIView alloc] init];
            return view;
        }
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 213)];
        footerView.userInteractionEnabled = YES;
        UIButton * logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        logoutBtn.frame = CGRectMake(20, 50, SCREEN_WIDTH - 40, 40);
        [logoutBtn addTarget:self action:@selector(logoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [logoutBtn setTitle:@"切换账号" forState:UIControlStateNormal];
        [logoutBtn setTitleColor:COLOR_WITH_RGB(231, 66, 89) forState:UIControlStateNormal];
        [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        logoutBtn.layer.borderColor = COLOR_WITH_RGB(231, 66, 89).CGColor;
        [logoutBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [logoutBtn setBackgroundColor:COLOR_WITH_RGB(231, 66, 89) forState:UIControlStateHighlighted];
        logoutBtn.layer.borderWidth = 0.5f;
        logoutBtn.layer.cornerRadius = 8;
        
        [footerView addSubview:logoutBtn];
        logoutBtn.clipsToBounds = YES;
        footerView.layer.shouldRasterize = YES;
        footerView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        footerView.bounds = [UIScreen mainScreen].bounds;
        return footerView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _titlesArray.count - 1) {
        return 213;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HMSettingModel * model = _titlesArray[indexPath.section][indexPath.row];
    switch (model.settingType) {
        case HMSettingTypePersonalInfo://个人资料
        {
            [self gotoEditPersonInfo];
        }
            break;
        case HMSettingTypeChangePassword://修改密码
        {
            [self gotoChangePW];
        }
            break;
        case HMSettingTypeHomePageShowType://首页默认显示形式
        {
            [self changeHomePageTypeWithRow:indexPath.row];
        }
            break;
        case HMSettingTypeClearCache://清除缓存
        {
            [self clearCache];
        }
            break;
        case HMSettingTypeSuggest://意见与建议
        {
            [self gotoFeedback];
        }
            break;
        case HMSettingTypeGotoComment://五星好评
        {
            [self gotoAppStore];
        }
            break;
        case HMSettingTypeAbout://关于
        {
            [self gotoAbout];
        }
            break;
        default:
            break;
    }
}

//修改密码
-(void)gotoChangePW
{
    HMChangePasswordViewController * changePWVC = [HMHelper xibWithViewControllerClass:[HMChangePasswordViewController class]];
    [self.navigationController pushViewController:changePWVC animated:YES];
}

//个人资料
-(void)gotoEditPersonInfo
{
    HMEditPersonalInfoViewController * editPersonInfoVC = [HMHelper xibWithViewControllerClass:[HMEditPersonalInfoViewController class]];
    [self.navigationController pushViewController:editPersonInfoVC animated:YES];
}

//清除缓存
-(void)clearCache
{
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [[SDImageCache sharedImageCache] clearMemory];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"清除成功", nil)];
    }];
}

//修改首页展示方式
-(void)changeHomePageTypeWithRow:(NSInteger)row
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"首页默认显示形式", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:NSLocalizedString(@"地图", nil), NSLocalizedString(@"列表", nil), nil];
    sheet.tag = row;
    [sheet showInView:self.view];
    
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        [USERDEFAULT setObject:[NSNumber numberWithInteger:buttonIndex + 1] forKey:HMHomePageShowTypeKey];
        UserDefaultSynchronize;
        
        [_tableView beginUpdates];
        
        [_tableView reloadRow:actionSheet.tag inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
        [_tableView endUpdates];
    }
}

//五星好评
-(void)gotoAppStore
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:HMitunesUrl]];
}

//意见与反馈
-(void)gotoFeedback
{
    HMFeedbackViewController * feedbackVC = [HMHelper xibWithViewControllerClass:[HMFeedbackViewController class]];
    [self.navigationController pushViewController:feedbackVC animated:YES];
}

//关于
-(void)gotoAbout
{
    HMAboutViewController * aboutVC = [HMHelper xibWithViewControllerClass:[HMAboutViewController class]];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

-(void)logoutBtnClick:(UIButton *)btn
{
    [HMRunDataShare logout];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
