//
//  HMPOICommentViewController.m
//  HalalMap
//
//  Created by 刘艳杰 on 16/5/8.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#import "HMPOICommentViewController.h"
#import "YSKeyboardScrollView.h"
#import "HMKeyWordsCollectionView.h"

@interface HMPOICommentViewController ()
<
UITextViewDelegate,
HMKeyWordsCollectionViewDelegate
>

@end

@implementation HMPOICommentViewController
{
    __weak IBOutlet UIView *_anochView;
    
    __weak IBOutlet YSKeyboardScrollView *_scrollView;
    __weak IBOutlet UIView *_containerView;
    
    __weak IBOutlet UILabel *_scoreLabel;
    
    __weak IBOutlet UILabel *_starLabel;
    
    __weak IBOutlet UIButton *_starBtn1;
    
    __weak IBOutlet UIButton *_starBtn2;
    
    __weak IBOutlet UIButton *_starBtn3;
    
    __weak IBOutlet UIButton *_starBtn4;
    
    __weak IBOutlet UIButton *_starBtn5;
    
    __weak IBOutlet UILabel *_contentLabel;
    
    __weak IBOutlet UIView *_textBackgroundView;
    
    __weak IBOutlet UILabel *_tipsLabel;
    
    __weak IBOutlet UITextView *_textView;
    
    __weak IBOutlet UILabel *_tagLabel;
    UIBarButtonItem * _rightBBI;
    
    __weak IBOutlet NSLayoutConstraint *_containerViewHeightConstraint;
    
    IBOutletCollection(UIButton) NSArray *_btn;
    
    NSMutableArray * _tagArray;
    
    NSInteger _score;
    
    NSMutableArray * _selectedTagArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tagArray = [[NSMutableArray alloc] init];
    _selectedTagArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = NSLocalizedString(@"评论", nil);
    _rightBBI = [self addBarButtonItemWithImageName:nil
                                              title:NSLocalizedString(@"提交",nil)
                                             action:@selector(publish)
                                  barButtonItemType:HMBarButtonTypeRight
                                         titleColor:[UIColor whiteColor]
                              highlightedTitleColor:nil
                                          titleFont:[HMFontHelper fontOfSize:18.0f]];

    [self configureUI];
    [self getTagData];
    _score = 0;
}

-(void)configureUI
{
    _scoreLabel.font =
    _contentLabel.font =
    _tagLabel.font =
    _textView.font =
    [HMFontHelper fontOfSize:16.0f];
    
    _starLabel.font =
    _tipsLabel.font =
    [HMFontHelper fontOfSize:14.0f];
    
    _textBackgroundView.layer.borderColor = HMBorderColor.CGColor;
    _textBackgroundView.layer.borderWidth = 0.5f;
    _textView.delegate = self;
    
    _containerViewHeightConstraint.constant = _tagLabel.bottom > _scrollView.height ? (_tagLabel.bottom + 20) : (_scrollView.height + 1);
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0) {
        _tipsLabel.hidden = YES;
    }
    else{
        _tipsLabel.hidden = NO;
    }
}

- (IBAction)starBtn:(UIButton *)sender
{
    if (sender.tag == 1 && sender.selected && _score == 1) {
        _score = 0;
        sender.selected = !sender.selected;
        _starLabel.text = @"0星";
        return;
    }
    if (_score == sender.tag) {
        return;
    }
    _score = sender.tag;
    [self btnDidSelected:sender.tag];
    _starLabel.text = [NSString stringWithFormat:@"%ld星", (long)sender.tag];
}

- (void)btnDidSelected:(NSInteger)tag
{
    for (int i = 0; i < _btn.count; i ++) {
        UIButton *button = _btn[i];
        if (button.tag <= tag) {
            button.selected = YES;
        }else if(button.tag < 10){
            button.selected = NO;
        }
    }
}


-(void)getTagData
{
    [HMNetwork getRequestWithPath:HMRequestTagList params:nil success:^(HMNetResponse *response) {
        NSArray * array = response.data;
    
        for (NSDictionary * dic in array) {
            HMKeyWordsCollectionViewItem * item = [[HMKeyWordsCollectionViewItem alloc] init];
            item.title = dic[@"tag"];
            item.itemId = dic[@"tag_guid"];
            [_tagArray addObject:item];
        }
        [self configureTagWithArray];
        
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    }];
}

-(void)configureTagWithArray
{
    HMKeyWordsCollectionView * keywordCollection = [HMKeyWordsCollectionView keyWordsCollectionViewWithItems:_tagArray maxWidth:SCREEN_WIDTH numberOfLines:0 type:HMKeyWordsCollectionViewTypeCommentTag];
    keywordCollection.backgroundColor = [UIColor whiteColor];
    keywordCollection.delegate = self;
    keywordCollection.userInteractionEnabled = YES;
    [_containerView addSubview:keywordCollection];

    
    keywordCollection.frame = CGRectMake(0, _tagLabel.bottom + 10, SCREEN_WIDTH, keywordCollection.height);
    [keywordCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(_tagLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(keywordCollection.height);
    }];
    _containerViewHeightConstraint.constant = keywordCollection.bottom > _scrollView.height ? (keywordCollection.bottom + 20) : (_scrollView.height + 1);
}

#pragma mark -  HMKeyWordsCollectionViewDelegate
-(void)HM_keyWordsCollectionView:(HMKeyWordsCollectionView *)keyWordsCollectionView didMultiselectChangedWithItems:(NSArray *)selectedItems
{
    [_selectedTagArray removeAllObjects];
    [_selectedTagArray addObjectsFromArray:selectedItems];
}


-(void)publish
{
    
    if (_textView.text == nil || _textView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"请填写评价内容", nil)];
        return;
    }
    [SVProgressHUD showWithStatus:NSLocalizedString(@"发表中...", nil)];
    _rightBBI.customView.userInteractionEnabled = NO;
    
    NSMutableArray * tags = [[NSMutableArray alloc] init];
    for (HMKeyWordsCollectionViewItem * item in _selectedTagArray) {
        [tags addObject:item.itemId];
    }
    
    WS(weakSelf);
    NSDictionary * params = @{
                              @"comment" : _textView.text.length != 0 ? _textView.text : @"",
                              @"stars" : [NSString stringWithFormat:@"%ld", (long)_score],
                              @"tags" : _selectedTagArray.count == 0 ? @"" :[NSString stringWithFormat:@"%@", tranJSON(tags)]
                              };
    [HMNetwork postRequestWithPath:HMRequestPublishComment(self.poi_guid) params:params success:^(HMNetResponse *response) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"发表成功", nil)];
        [weakSelf performSelector:@selector(popViewController) withObject:nil afterDelay:1.0f];
        _rightBBI.customView.userInteractionEnabled = YES;
    } failure:^(HMNetResponse *response, NSString *errorMsg) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
        _rightBBI.customView.userInteractionEnabled = YES;
    }];
 
}

-(void)popViewController
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentSuccess)]) {
        [self.delegate commentSuccess];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
