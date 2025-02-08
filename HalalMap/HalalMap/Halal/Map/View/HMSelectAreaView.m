//
//  HMSelectAreaView.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/4/6.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMSelectAreaView.h"

#import "HMDistanceCell.h"
#import "HMBusinessAreaCell.h"

#import "HMDistrictModel.h"

#define kTransitionTime 0.3


typedef void (^ FilterFinishBlock)(NSInteger selectedDistrictIndex, NSInteger selectedBuAreaIndxe);
typedef void(^FilterFailBlock)();

@interface HMSelectAreaView ()
<
UITableViewDataSource,
UITableViewDelegate,
UIGestureRecognizerDelegate
>

@property (nonatomic, strong) NSMutableArray              *leftDataArray;
@property (nonatomic, strong) NSMutableArray              *rightDataArray;
@property (nonatomic, strong) NSIndexPath                 *leftSelectIndexPath;
@property (nonatomic, copy) FilterFinishBlock             finishBlock;
@property (nonatomic, copy) FilterFailBlock               failBlock;

@end

@implementation HMSelectAreaView
{
    __weak IBOutlet UITableView *_leftTableView;
    __weak IBOutlet UITableView *_rightTableView;
    __weak IBOutlet UIView *_backgroundView;
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    _leftDataArray = [[NSMutableArray alloc] initWithCapacity:42];
    _rightDataArray = [[NSMutableArray alloc] initWithCapacity:42];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _rightTableView.dataSource = self;
    _rightTableView.delegate = self;
    _leftTableView.backgroundColor = COLOR_WITH_RGB(242, 242, 242);
    _leftTableView.showsVerticalScrollIndicator = NO;
    
     _rightTableView.backgroundColor = [UIColor whiteColor];
    _rightTableView.showsVerticalScrollIndicator = NO;
    
    [_rightTableView registerNib:[UINib nibWithNibName:@"HMBusinessAreaCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([HMBusinessAreaCell class])];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_backgroundView addGestureRecognizer:tap];

}

-(void)showSelectAreaInView:(UIView *)view
                   WithData:(NSArray *)array
      selectedDistrictIndex:(NSInteger)selectedDistrictIndex
        selectedBuAreaIndex:(NSInteger)selectedBuAreaIndex
                finishBolck:(void(^) (NSInteger selectedDistrictIndex, NSInteger selectedBuAreaIndex))finishBlock
                  failBlock:(void(^)())failBlock
{
    [self.leftDataArray setArray:array];
    if (self.leftDataArray.count > 0) {
        HMDistrictModel * model = self.leftDataArray[selectedDistrictIndex];
        [self.rightDataArray setArray:model.businessAreas];
    }
    self.finishBlock = finishBlock;
    self.failBlock = failBlock;
    self.frame = CGRectMake(0, 0, view.width, view.height);
    [view addSubview:self];
    [view bringSubviewToFront:self];
    _leftSelectIndexPath = [NSIndexPath indexPathForRow:selectedDistrictIndex inSection:0];
    [_leftTableView reloadData];
    [_rightTableView reloadData];

    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedDistrictIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    [_rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedBuAreaIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    [self show];
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
        self.finishBlock(_leftSelectIndexPath.row, indexPath.row);
        [self hide];
    }
    
}

-(void)tapClick:(UITapGestureRecognizer *)tap
{
    [self hide];
}


- (void)show
{
    CATransition *animation = [CATransition animation];
    
    [animation setDuration:kTransitionTime];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setType:kCATransitionFade];
    _backgroundView.alpha = 0.5;
    
    [self.layer addAnimation:animation forKey:nil];
}

- (void)hide
{
    [UIView animateWithDuration:0.23 animations:^{
        _backgroundView.alpha = 0;
        self.failBlock;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
