//
//  HMSelectDistrictViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/21.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMSelectDistrictViewController.h"

#import "HMBusinessAreaCell.h"
#import "HMDistanceCell.h"

#import "HMDistrictModel.h"

@interface HMSelectDistrictViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@end

@implementation HMSelectDistrictViewController
{
    __weak IBOutlet UITableView *_leftTableView;
    __weak IBOutlet UITableView *_rightTableView;
    NSMutableArray              *_leftDataArray;
    NSMutableArray              *_rightDataArray;
    NSIndexPath                 *_leftSelectIndexPath;
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
    self.navigationItem.title = NSLocalizedString(@"选择区域或商圈", nil);
    _leftDataArray = [[NSMutableArray alloc] initWithCapacity:42];
    _rightDataArray = [[NSMutableArray alloc] initWithCapacity:42];
//    _leftTableView.delegate = self;
//    _leftTableView.dataSource = self;
//    _rightTableView.dataSource = self;
//    _rightTableView.delegate = self;
    _leftTableView.backgroundColor = COLOR_WITH_RGB(242, 242, 242);
    _leftTableView.showsVerticalScrollIndicator = NO;
    
    _rightTableView.backgroundColor = [UIColor whiteColor];
    _rightTableView.showsVerticalScrollIndicator = NO;
    
    [_rightTableView registerNib:[UINib nibWithNibName:@"HMBusinessAreaCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([HMBusinessAreaCell class])];
    [self getDistricsdata];

}

//获取区县商圈数据
-(void)getDistricsdata
{
    [HMNetwork getRequestWithPath:HMRequestDistrictsAndBusinessAreas(@"33")
                           params:nil
                       modelClass:[HMDistrictModel class]
                          success:^(id object, HMNetPageInfo *pageInfo) {
                              [_leftDataArray removeAllObjects];
                              if ([object isKindOfClass:[NSArray class]] && ((NSArray *) object).count != 0) {
                                  [_leftDataArray addObjectsFromArray:object];
                                  [_leftTableView reloadData];
                                  [self tableView:_leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                              }
                          }];
}


#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView) {
        
        HMDistanceCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMDistanceCell class])];
        if (cell == nil) {
            cell = [[HMDistanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HMDistanceCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell configureWithModel:_leftDataArray[indexPath.row]];
        return cell;
    }
    else if (tableView == _rightTableView){
        HMBusinessAreaCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMBusinessAreaCell class])];
        [cell configureWithModel:_rightDataArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [UITableViewCell new];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTableView) {
        return _leftDataArray.count;
    }
    else if (tableView == _rightTableView){
        return _rightDataArray.count;
    }
    return 0;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView) {
        _leftSelectIndexPath = indexPath;
        
        HMDistrictModel * model = _leftDataArray[_leftSelectIndexPath.row];
        _rightDataArray = [NSMutableArray arrayWithArray:model.businessAreas];
        
        [_rightTableView reloadData];
        [_rightTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else{
        [_rightTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        HMBusinessAreaModel * model = _rightDataArray[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectDistrictWithDistrictModel:businessModel:)]) {
            HMDistrictModel * districtModel = _leftDataArray[_leftSelectIndexPath.row];
            [self.delegate selectDistrictWithDistrictModel:districtModel businessModel:model];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
