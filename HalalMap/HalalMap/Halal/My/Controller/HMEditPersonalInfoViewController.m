//
//  HMEditPersonalInfoViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/22.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMEditPersonalInfoViewController.h"
#import "HMChangeNameViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "HMEditPersonalInfoCell.h"
#import "HMEditPersonalInfoHeaderCell.h"
#import "HMDatePickerView.h"
#import "MMPickerView.h"

typedef enum : NSUInteger {
    HMMyCellTypeName = 0,
    HMMyCellTypeSignature,
    HMMyCellTypeSex,
    HMMyCellTypeNation,
    HMMyCellTypeArea,
    HMMyCellTypeBirthday
} HMMyCellType;

typedef enum : NSUInteger {
    HMMyActionSheetTypeImage = 1,
    HMMyActionSheetTypeSex,
} HMMyActionSheetType;

@interface HMEditPersonalInfoViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate,
HMDatePickerViewDelegate,
HMChangeNameViewControllerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@end

@implementation HMEditPersonalInfoViewController
{
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray  * _titlesArray;
    NSString * _name;
    NSString * _signature;//个人签名
    NSString * _sex;
    NSString * _nation;//民族
    NSString * _address;
    NSString * _birthday;
    UIImage  * _headerImage;
    
    NSIndexPath * _changeIndexpath;
    NSString * _imagePath;
    NSMutableArray  * _raceArray;//民族
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"个人资料", nil);
    _titlesArray = [[NSMutableArray alloc] initWithObjects:@"昵称", @"个人签名", @"性别", @"民族", @"地区", @"生日", nil];
    _name = HMRunDataShare.userModel.nickname;
    _signature = HMRunDataShare.userModel.signature;
    _sex = HMRunDataShare.userModel.gender;
    _nation = HMRunDataShare.userModel.race;
    _address = @"洛阳市洛宁省";
    _birthday = HMRunDataShare.userModel.birthday;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HMEditPersonalInfoCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([HMEditPersonalInfoCell class])];
     [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HMEditPersonalInfoHeaderCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([HMEditPersonalInfoHeaderCell class])];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HMEditPersonalInfoHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMEditPersonalInfoHeaderCell class])];
        [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:HMRunDataShare.userModel.avatar] placeholderImage:nil];
        return cell;
    }
    else{
        HMEditPersonalInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMEditPersonalInfoCell class])];
        NSString * content;
        switch (indexPath.row) {
            case HMMyCellTypeName:
            {
                content = _name;
            }
                break;
            case HMMyCellTypeSignature:
            {
                content = _signature;
            }
                break;
            case HMMyCellTypeSex:
            {
                content = _sex;
            }
                break;
            case HMMyCellTypeNation:
            {
                content = _nation;
            }
                break;
            case HMMyCellTypeArea:
            {
                content = _address;
            }
                break;
            case HMMyCellTypeBirthday:
            {
                content = _birthday;
            }
                break;
            default:
                break;
        }
        [cell configureWithTitle:_titlesArray[indexPath.row] content:content];
        return cell;
    }
    return [UITableViewCell new];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else{
        return 6;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    else{
        return 50;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self headClick];
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case HMMyCellTypeName:
            case HMMyCellTypeSignature:
            {
                HMChangeNameViewController * changeNameVC = [HMHelper xibWithViewControllerClass:[HMChangeNameViewController class]];
                changeNameVC.delegate = self;
                _changeIndexpath = indexPath;
                if (indexPath.row == HMMyCellTypeName) {
                    changeNameVC.title = NSLocalizedString(@"修改昵称", nil);
                    changeNameVC.oldText = _name;
                }
                else{
                    changeNameVC.title = NSLocalizedString(@"修改个人签名", nil);
                    changeNameVC.oldText = _signature;
                }
                [self.navigationController pushViewController:changeNameVC animated:YES];
            }
                break;
            case HMMyCellTypeSex:
            {
                UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", nil];
                actionSheet.tag = HMMyActionSheetTypeSex;
                [actionSheet showInView:self.view];
            }
                break;
            case HMMyCellTypeNation:
            {
                [self setRace];
            }
                break;
            case HMMyCellTypeArea:
            {
                
            }
                break;
            case HMMyCellTypeBirthday:
            {
                [self showData];
            }
                break;
            default:
                break;
        }
    }
}

-(void)showData
{
    HMDatePickerView * datePickerView = [[HMDatePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    datePickerView.delegate = self;
    UIDatePicker * datePicker = datePickerView.datePicker;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    if (nil == _birthday || [_birthday isEqualToString:@""])
//    {
//        NSString *tmpBirthday = [NSString stringWithFormat:@"%@", @"1980-01-01"];
//        datePicker.date = [dateFormatter dateFromString:tmpBirthday] ;
//    } else {
//        NSString *tmpBirthday = [NSString stringWithFormat:@"%@", _bornLabel.text];
//        if (tmpBirthday > 0)
//        {
//            datePicker.date = [dateFormatter dateFromString:tmpBirthday];
//        }
//    }
    NSString *dateString=@"1900-01-01";
    NSDateFormatter *birthdayFormatter = [[NSDateFormatter alloc] init];
    [birthdayFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *birthDate = [dateFormatter dateFromString:dateString];
    datePicker.minimumDate = birthDate;
    datePicker.maximumDate = [NSDate date];
    [HM_AppWindow addSubview:datePickerView];
    [datePickerView show:YES];

}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        switch (actionSheet.tag) {
            case HMMyActionSheetTypeImage:
            {
                
            }
                break;
            case HMMyActionSheetTypeSex:
            {
                //性别，0代表男，1代表女
                [self updateInfoWithKey:@"gender" value:[NSString stringWithFormat:@"%ld", (long)buttonIndex] success:^{
                    HMRunDataShare.userModel.gender = [NSString stringWithFormat:@"%ld", buttonIndex];
                    [HMRunDataShare userInfoSynchronize];
                    _sex = HMRunDataShare.userModel.gender;
                    [_tableView beginUpdates];
                    [_tableView reloadRow:HMMyCellTypeSex inSection:1 withRowAnimation:UITableViewRowAnimationAutomatic];
                    [_tableView endUpdates];
                }];
            }
                break;
            default:
                break;
        }
    }
}


#pragma mark - HMDatePickerViewDelegate
-(void)confirmWithDatePickerView:(UIDatePicker *)sender
{
    [self updateInfoWithKey:@"birthday" value:[NSString stringWithFormat:@"%f", [sender.date timeIntervalSince1970]] success:^{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        HMRunDataShare.userModel.birthday = [dateFormatter stringFromDate:sender.date];
        [HMRunDataShare userInfoSynchronize];
        _birthday = HMRunDataShare.userModel.birthday;
        [_tableView beginUpdates];
        [_tableView reloadRow:HMMyCellTypeBirthday inSection:1 withRowAnimation:UITableViewRowAnimationAutomatic];
        [_tableView endUpdates];
  
    }];
}


#pragma mark - headClick
- (void)headClick
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"上传头像", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照", nil), NSLocalizedString(@"从相册选择", nil),nil];
    [as showInView:[UIApplication sharedApplication].keyWindow withCompletionHandler:^(NSInteger buttonIndex) {
        if (buttonIndex == 2) {
            return;
        }
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.allowsEditing = YES;
        ipc.delegate = self;
        if (buttonIndex == 0) {
            if (isIOS7) {
                if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied) {
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"请在iPhone的“设置－隐私－相机”选项中，允许钛媒体访问您的相机。", nil) delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alertView show];
                    return;
                }
            }
            if (TARGET_IPHONE_SIMULATOR){
                return;
            }
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else if (buttonIndex == 1){
            ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        [self presentViewController:ipc animated:YES completion:^{
            
        }];
    }];
}

//ipc delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];

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
            savedData = [image compressBelowKNum:200.0];
            [savedData writeToFile:path atomically:YES];
        }
        else
        {
            path = [path substringToIndex:path.length-5];
            _imagePath = [NSString stringWithFormat:@"%@-%d.jpg",path,(int)[[NSDate date] timeIntervalSince1970]];
            savedData = [image compressBelowKNum:200.0];
            [savedData writeToFile:_imagePath atomically:YES];
        }
        
        UIImage *savedImg = [UIImage imageWithContentsOfFile:_imagePath];
        _headerImage = savedImg;
    } failureBlock:^(NSError *error) {
        
    }];
    [picker dismissViewControllerAnimated:YES completion:^{
        if([HMHelper netIsConnectedWithShowErrorMsg:YES])
        {
            [self changeHeaderImage];
            
        }
    }];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - HMChangeNameViewControllerDelegate
-(void)changeNameWithNewText:(NSString *)newText
{
    NSString * key;
    if (_changeIndexpath.section == 1) {
        if (_changeIndexpath.row == HMMyCellTypeName) {
            key = @"nickname";
        }
        else if (_changeIndexpath.row == HMMyCellTypeSignature)
        {
            key = @"signature";
        }
    }
    [self updateInfoWithKey:key value:newText success:^{
        if (_changeIndexpath.row == HMMyCellTypeName) {
            HMRunDataShare.userModel.nickname = newText;
        }
        else if (_changeIndexpath.row == HMMyCellTypeSignature)
        {
            HMRunDataShare.userModel.signature = newText;
        }
    
        [HMRunDataShare userInfoSynchronize];
        _name = HMRunDataShare.userModel.nickname;
        _signature = HMRunDataShare.userModel.signature;
        
        [_tableView beginUpdates];
        [_tableView reloadRow:_changeIndexpath.row inSection:1 withRowAnimation:UITableViewRowAnimationAutomatic];
        [_tableView endUpdates];

    }];
}

#pragma mark - 接口请求
-(void)updateInfoWithKey:(NSString *)key value:(NSString *)value success:(void (^)(void))success
{
    [SVProgressHUD show];
    NSDictionary * params = @{ key : value};
    [HMNetwork postRequestWithPath:HMRequestEditPersonInfo params:params success:^(HMNetResponse *response) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"更新成功", nil)];
        if (success) {
            success();
        }
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
}

-(void)changeHeaderImage
{
    [SVProgressHUD show];
    
    [HMNetwork postHeadImagesWithPath:HMRequestChangeHeaderImage params:nil imagesPath:_imagePath onProgress:^(double progress) {
        [SVProgressHUD showProgress:progress];
    } success:^(HMNetResponse *response) {
        
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"更新成功", nil)];
        HMRunDataShare.userModel.avatar = [response.data objectForKey:@"avatar"];
        [HMRunDataShare userInfoSynchronize];
        _imagePath = HMRunDataShare.userModel.avatar;
        
        [_tableView beginUpdates];
        [_tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
        [_tableView endUpdates];

    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];

    }];
}


//请求民族
-(void)getRaceListWithSuccess:(void (^)(void))success
{
    [SVProgressHUD show];
    [HMNetwork getRequestWithPath:HMRequestRacesList params:nil success:^(HMNetResponse *response) {
        [SVProgressHUD dismiss];
        _raceArray = [[NSMutableArray alloc] initWithArray:response.data];
        if (success) {
            success();
        }
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
}

-(void)setRace
{
    if (_raceArray.count != 0) {
        [self showRacePickerView];
    }
    else{
        WS(weakSelf);
        [self getRaceListWithSuccess:^{
            [weakSelf showRacePickerView];
        }];
    }
}

-(void)showRacePickerView
{
    WS(weakSelf);
    [MMPickerView showPickerViewInView:self.view withStrings:_raceArray withOptions:nil completion:^(NSString *selectedString) {
        if (![HMRunDataShare.userModel.race isEqualToString:selectedString]) {
            [weakSelf updateRace:selectedString];
        }
    }];
}

-(void)updateRace:(NSString *)race
{
    [self updateInfoWithKey:@"race" value:race success:^{
        
        HMRunDataShare.userModel.race = race;
        [HMRunDataShare userInfoSynchronize];
        _nation = race;
        [_tableView beginUpdates];
        [_tableView reloadRow:HMMyCellTypeNation inSection:1 withRowAnimation:UITableViewRowAnimationAutomatic];
        [_tableView endUpdates];

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
