//
//  HMSelectCityViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/15.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMSelectCityViewController.h"
#import "HMSelectCityHeaderFooterView.h"
#import "HMSelectRestaurantViewController.h"
#import "HMLocationManager.h"
//#import "AMapLocationCommonObj.h"


#import "HMSelectCityCell.h"
#import "HMLocationCell.h"

#import "HMCitiesModel.h"


@interface HMSelectCityViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UISearchBarDelegate,
UISearchDisplayDelegate,
HMLocationCellDelegate
>

@end

@implementation HMSelectCityViewController
{
    __weak IBOutlet UISearchBar *_searchBar;
    __weak IBOutlet UITableView *_tableView;
    IBOutlet UISearchDisplayController *_searchDisplayController;
    NSMutableArray      * _dataArray;
    NSMutableArray      * _resultDataArray;
    NSMutableArray      * _indexsArray;
    NSMutableDictionary * _indexDic;
    HMAddressModel      * _addressModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getCurrentLocation];

    self.navigationItem.title = NSLocalizedString(@"选择城市", nil);
    _dataArray = [NSMutableArray array];
    _resultDataArray = [NSMutableArray arrayWithCapacity:0];
    _indexsArray = [NSMutableArray arrayWithCapacity:0];
    _indexDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionIndexColor = HMMainColor;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    [_tableView registerNib:[UINib nibWithNibName:@"HMSelectCityCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([HMSelectCityCell class])];
    [_tableView registerNib:[UINib nibWithNibName:@"HMLocationCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([HMLocationCell class])];
    [_searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"HMSelectCityCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([HMSelectCityCell class])];
    [_tableView registerNib:[UINib nibWithNibName:@"HMSelectCityHeaderFooterView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:NSStringFromClass([HMSelectCityHeaderFooterView class])];
    _searchDisplayController.delegate = self;
    _searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getData];
}

-(void)getCurrentLocation
{
    [[HMLocationManager sharedLocationManager] getCurrentLocationwithSuccess:^(HMAddressModel *addressModel) {
        _addressModel = addressModel;
        if ([_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]) {
            dispatch_async_on_main_queue(^{
                [_tableView beginUpdates];
                [_tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationAutomatic];
                [_tableView endUpdates];
            });
        }
    } fail:^(NSError *error, CLLocation *location) {
        
    }];
}

-(void)getData
{
    [SVProgressHUD show];
    __weak typeof(self) _self = self;

    [HMNetwork getRequestWithPath:HMRequestCities
                           params:nil
                       modelClass:[HMCitiesModel class]
                          success:^(id object, HMNetPageInfo *pageInfo) {
                              [SVProgressHUD dismiss];
                              if ([object isKindOfClass:[NSArray class]]) {
                                  [_dataArray addObjectsFromArray:object];
                                  [_self handle];
                                  [_tableView reloadData];
                              }
                          }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        if (indexPath.section == 0) {
            HMLocationCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMLocationCell class])];
            cell.delegate = self;
            if (_addressModel) {
                [cell configureWithAddressModel:_addressModel];
            }
            return cell;
        }
        else{
            HMSelectCityCell * cell = [tableView  dequeueReusableCellWithIdentifier:NSStringFromClass([HMSelectCityCell class])];
            NSArray * tmpArray = _indexDic[_indexsArray[indexPath.section]];
            HMCitiesModel * model = tmpArray[indexPath.row];
            if (indexPath.row == tmpArray.count - 1) {
                [cell congfigureWithTitle:model.city_name isHideBottomLine:YES];
            }
            else
            {
                [cell congfigureWithTitle:model.city_name isHideBottomLine:NO];
            }
            return cell;
        }
    }
    else{
        HMSelectCityCell * cell = [tableView  dequeueReusableCellWithIdentifier:NSStringFromClass([HMSelectCityCell class])];
        HMCitiesModel * model = _resultDataArray[indexPath.row];
        if (indexPath.row == _resultDataArray.count - 1) {
            [cell congfigureWithTitle:model.city_name isHideBottomLine:YES];
        }
        else
        {
            [cell congfigureWithTitle:model.city_name isHideBottomLine:NO];
        }
        return cell;
    }
    return [UITableViewCell new];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        HMSelectCityHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([HMSelectCityHeaderFooterView class])];
        headerView.contentView.backgroundColor = [UIColor whiteColor];
        
        NSString * title;
            if (section == 0) {
                title = @"当前定位城市";
            }
            else
            {
                title = _indexsArray[section];
            }
        [headerView configureWithTitle:title];
        
        return headerView;
    }
    else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        return 30.0f;
    }
    else{
        return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        if (_indexsArray.count == 0) {
            return 0;
        }
        return _indexsArray.count;
    }
    else{
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        if (section == 0) {
            return 1;
        }
        else{
            NSArray * tmpArray = _indexDic[_indexsArray[section]];
            return tmpArray.count;
        }
    }
    else{
        return _resultDataArray.count;
    }
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == _tableView) {
        return _indexsArray;
    }
    return nil;
}

//建立索引栏和section的关联
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == _tableView) {
        if (title == UITableViewIndexSearch) {
            [_tableView scrollRectToVisible:_searchBar.frame animated:YES];
            return -1;
        }
        return [_indexsArray indexOfObject:title] - 1;
    }
    return 0;
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [_searchBar setShowsCancelButton:YES];
    if (isIOS7) {
        UIView *view = _searchBar.subviews[0];
        for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
                UIButton *cancelBtn = (UIButton *)subView;
                [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
                cancelBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [cancelBtn setTitleColor:HMMainColor forState:UIControlStateNormal];
                [cancelBtn setTitleColor:[HMMainColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
            }
            if ([subView isKindOfClass: NSClassFromString(@"UISearchBarBackground")])
            {
            }
            if ([subView isKindOfClass:[UITextField class]]) {
                UITextField *tf = (UITextField *)subView;
                tf.returnKeyType = UIReturnKeySearch;
                tf.layer.borderColor = [UIColor lightGrayColor].CGColor;
                tf.layer.borderWidth = 0.5;
            }
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(nullable NSString *)searchString
{
    [_resultDataArray removeAllObjects];
    if ([[_indexDic allKeys] containsObject:[searchString uppercaseString]]) {
        [_resultDataArray addObjectsFromArray:[_indexDic objectForKey:[searchString uppercaseString]]];
    }
    else{
        for (HMCitiesModel * model in _dataArray) {
            if([[model.city_name_pinyin uppercaseString] isEqualToString:[searchString uppercaseString]] || [model.city_name isEqualToString:searchString] || [model.city_name containsString:searchString]){
                [_resultDataArray addObject:model];
            }
        }
    }
    if (_resultDataArray.count == 0) {
        UITableView *tableView1 = self.searchDisplayController.searchResultsTableView;
        
        for( UIView *subview in tableView1.subviews ) {
            
            if( [subview class] == [UILabel class] ) {
                
                UILabel *lbl = (UILabel*)subview; // sv changed to subview.
                
                lbl.text = @"没有结果";
                
            }
            
        }
    }
    return YES;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}

- (void)handle
{
    [_indexDic removeAllObjects];
    [_indexsArray removeAllObjects];
    
    for (HMCitiesModel * model in _dataArray) {
        NSString *strFirLetter = [[model.city_name_pinyin substringToIndex:1] uppercaseString];
        if ([[_indexDic allKeys] containsObject:strFirLetter]) {
            [[_indexDic objectForKey:strFirLetter] addObject:model];
        }
        else{
            NSMutableArray*tempArray=[NSMutableArray arrayWithCapacity:0];
            [tempArray addObject:model];
            [_indexDic setObject:tempArray forKey:strFirLetter];
        }
    }
    [_indexsArray addObjectsFromArray:[_indexDic allKeys]];
    [_indexsArray setArray:[_indexsArray sortedArrayUsingFunction:cmp context:NULL hint:nil]];
    [_indexsArray insertObject:UITableViewIndexSearch atIndex:0];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectCityWithModel:)]) {
        if (tableView == _tableView) {
            if (indexPath.section == 0 && indexPath.row == 0) {
                if (_addressModel) {
                    [self.delegate selectCityWithModel:_addressModel.city];
                }
            }
            else{
                NSArray * tmpArray = _indexDic[_indexsArray[indexPath.section]];
                [self.delegate selectCityWithModel:tmpArray[indexPath.row]];
            }
        }
        else{
            [self.delegate selectCityWithModel:_resultDataArray[indexPath.row]];
        }
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//构建数组排序方法SEL
//NSInteger cmp(id, id, void *);
NSInteger cmp(NSString * a, NSString* b, void * p)
{
    if([a compare:b] == 1){
        return NSOrderedDescending;//(1)
    }else
        return  NSOrderedAscending;//(-1)
}

#pragma mark - HMLocationCellDelegate
-(void)reflashLocationWithCell:(HMLocationCell *)cell
{
    [self getCurrentLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
