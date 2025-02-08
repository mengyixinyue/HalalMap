//
//  HMDiseaseFilterTableViewController.m
//  newPatient
//
//  Created by  on 15/8/21.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "HMSelectAreaViewController.h"

#import "HMAreaFilterCell.h"
#import "HMDistanceCell.h"
#import "HMSortCell.h"

@interface HMSelectAreaViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@end

@implementation HMSelectAreaViewController
{
    UITableView             * _leftTableView;
    UITableView             * _rightTableView;
    
    NSMutableArray          * _leftDataArray;
    NSMutableArray          * _rightDataArray;
    
    NSIndexPath             * _leftSelectIndexPath;
    CategoryType            _categoryType;
    
    CGFloat                 _leftTableWidth;
}

-(id)initWithType:(CategoryType)categoryType
{
    self = [super init];
    if (self) {
        _categoryType = categoryType;
        switch (_categoryType) {
            case CategoryTypeArea:
                _leftTableWidth = SCREEN_WIDTH / 2.0f;
                break;
                case CategoryTypeSort:
                _leftTableWidth = SCREEN_WIDTH;
                break;
                
            default:
                break;
        }
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


-(void)getData{
    if (![self netIsConnected]) {
        return;
    }
    if (_categoryType == CategoryTypeArea) {
        [self getAreaCategory];
    }
    else if(_categoryType == CategoryTypeSort){
        [self getSortCategory];
    }
   
}

-(void)getAreaCategory
{
  
    
//    [_netWork getDistrictsAndBusinessAreasByCityOnCompletion:^(id result) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [_emptyView stopAnimating];
//        _emptyView.hidden = YES;
//        if (result && [result isKindOfClass:[NSArray class]]) {
//            _leftTableView.hidden = NO;
//            _rightTableView.hidden = NO;
//            [_leftDataArray removeAllObjects];
//            [_rightDataArray removeAllObjects];
//            
//            [_leftDataArray addObjectsFromArray:result];
//            HMHumanCategoryModel * model = _leftDataArray[_leftSelectIndexPath.row];
//            _rightDataArray = [NSMutableArray arrayWithArray:model.diseaseInfos];
//            
//            [_leftTableView reloadData];
//            [_rightTableView reloadData];
//            [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
//        }
//        else{
//            [SVProgressHUD showErrorWithStatus:ERROR_MSG_DATAERROR];
//        }

//    } fail:^(NSError *err, id result) {
//        [SVProgressHUD dismiss];
//        [_emptyView stopAnimating];
//        _emptyView.hidden = NO;
//        if (result && [result isKindOfClass:[NSString class]]) {
//            [SVProgressHUD showErrorWithStatus:result];
//        }
//        else{
//            [SVProgressHUD showErrorWithStatus:ERROR_MSG_DATAERROR];
//        }
//    }];
}

-(void)getSortCategory
{
//    [_netWork diseaseGetFacultyCategoryDiseaseListWithSuccess:^(id result) {
//        [SVProgressHUD dismiss];
//        [_emptyView stopAnimating];
//        _emptyView.hidden = YES;
//        if (result && [result isKindOfClass:[NSArray class]] && ((NSArray *)result).count != 0) {
//            _leftTableView.hidden = NO;
//            _rightTableView.hidden = NO;
//            [_leftDataArray removeAllObjects];
//            [_rightDataArray removeAllObjects];
//            
//            [_leftDataArray addObjectsFromArray:result];
//            HMDiseaseCategoryModel * model = _leftDataArray[_leftSelectIndexPath.row];
//            _rightDataArray = [NSMutableArray arrayWithArray:model.diseaseInfos];
//            
//            [_leftTableView reloadData];
//            [_rightTableView reloadData];
//            [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
//        }
//        else{
//            [SVProgressHUD showErrorWithStatus:ERROR_MSG_DATAERROR];
//        }
//    } fail:^(NSError *err, id result) {
//        [SVProgressHUD dismiss];
//        [_emptyView stopAnimating];
//        _emptyView.hidden = NO;
//        if (result && [result isKindOfClass:[NSString class]]) {
//            [SVProgressHUD showErrorWithStatus:result];
//        }
//        else{
//            [SVProgressHUD showErrorWithStatus:ERROR_MSG_DATAERROR];
//        }
//    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initialUI];
    _leftDataArray = [[NSMutableArray alloc] initWithCapacity:42];
    _rightDataArray = [[NSMutableArray alloc] initWithCapacity:42];
    
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    if (_rightTableView) {
        [_rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }

    _leftSelectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self getData];

}

-(void)initialUI
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _leftTableWidth, self.view.height) style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.backgroundColor = COLOR_WITH_RGB(242, 242, 242);
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_leftTableView];
        UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
        _leftTableView.tableFooterView = view;
        _leftTableView.showsVerticalScrollIndicator = NO;
    }
    
    if (_categoryType == CategoryTypeArea) {
        if (!_rightTableView && _leftTableWidth != SCREEN_WIDTH) {
            _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(_leftTableView.right, 0, SCREEN_WIDTH - _leftTableView.right, self.view.height) style:UITableViewStylePlain];
            _rightTableView.delegate = self;
            _rightTableView.dataSource = self;
            _rightTableView.backgroundColor = [UIColor whiteColor];
            _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:_rightTableView];
            
            UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
            _rightTableView.tableFooterView = view;
            _rightTableView.allowsMultipleSelection = NO;
            _rightTableView.showsVerticalScrollIndicator = NO;
        }
    }
    
//    _leftTableView.hidden = YES;
//    _rightTableView.hidden = YES;
}

#pragma mark - UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_categoryType) {
        case CategoryTypeArea:
        {
            if (tableView == _leftTableView) {
                HMAreaFilterCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMAreaFilterCell class])];
                if (!cell) {
                    cell = [[HMAreaFilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HMAreaFilterCell class])];
                }
                [cell configureWithModel:nil];
                //        [cell configureWithModel:_leftDataArray[indexPath.row]];
                return cell;
            }
            else if (tableView == _rightTableView){
                HMDistanceCell * selectCell = [_rightTableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMDistanceCell class])];
                if (!selectCell) {
                    selectCell = [[HMDistanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HMDistanceCell class])];
                    selectCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [selectCell configureWithModel:nil];
                if (indexPath.row == 0 && indexPath.section == 0) {
                    [_rightTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                    selectCell.selected = YES;
                }

                //        [selectCell configureWithModel:_rightDataArray[indexPath.row]];
                return selectCell;
            }
        }
            break;
        case CategoryTypeSort:
        {
            HMSortCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMSortCell class])];
            if (!cell) {
                cell = [[HMSortCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([HMSortCell class])];
            }
            if (indexPath.row == 0 && indexPath.section == 0) {
                [_leftTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                cell.selected = YES;
            }
            cell.textLabel.text = @"离我最近";

            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 10;
    
//    if (tableView == _leftTableView) {
//        return _leftDataArray.count;
//    }
//    else if (tableView == _rightTableView){
//        return _rightDataArray.count;
//    }
//    return 0;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView) {
        return [HMAreaFilterCell height];
    }
    else if (tableView == _rightTableView){
        return [HMDistanceCell height];
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView) {
        _leftSelectIndexPath = indexPath;
        if (_categoryType == CategoryTypeArea) {
//            HMHumanCategoryModel * model = _leftDataArray[_leftSelectIndexPath.row];
//            _rightDataArray = [NSMutableArray arrayWithArray:model.diseaseInfos];
        }
        else{
//            HMDiseaseCategoryModel * model = _leftDataArray[_leftSelectIndexPath.row];
//            _rightDataArray = [NSMutableArray arrayWithArray:model.diseaseInfos];
        }
        [_rightTableView reloadData];
        [_rightTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else{

        [_rightTableView deselectRowAtIndexPath:indexPath animated:YES];
        [_rightTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        NSLog(@"选择右边tableView");
    }
}

#pragma mark - HMEmptyViewDelegate
-(void)reLoadData
{
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _leftTableView.frame = CGRectMake(0, 0, _leftTableWidth, self.view.height);
    _rightTableView.frame = CGRectMake(_leftTableView.right, 0, SCREEN_WIDTH - _leftTableView.right, self.view.height);
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
