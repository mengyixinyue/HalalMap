//
//  ZCSelectAlbumTableView.m
//  Outing
//
//  Created by yj on 14-10-3.
//  Copyright (c) 2014年 zhengchen. All rights reserved.
//

#import "ZCSelectAlbumTableView.h"

#import "QBImagePickerGroupCell.h"

@implementation ZCSelectAlbumTableView

- (id)initWithFrame:(CGRect)frame ALAssetsFilter:(ALAssetsFilter *)filter
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        /* Check sources */
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        
        _assetsLibrary = [self.class defaultAssetsLibrary];
        _assetsGroups = [NSMutableArray array];
        
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        _filter = filter;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame ALAssetsFilter:[ALAssetsFilter allPhotos]];
}


+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (void)addPicToGroup
{
    void (^assetsGroupsEnumerationBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *assetsGroup, BOOL *stop) {
        [assetsGroup setAssetsFilter:_filter];
        if(assetsGroup.numberOfAssets > 0) {
            [_assetsGroups addObject:assetsGroup];
            if (_assetsGroups.count == 1) {
                if ([self.selectDelegate respondsToSelector:@selector(ZCSelectAlbumTableViewDidLoadFirstGroup)]) {
                    [self.selectDelegate ZCSelectAlbumTableViewDidLoadFirstGroup];
                }
            }
            [self reloadData];
            self.height = MIN(self.contentSize.height, SCREEN_HEIGHT * 3/5) ;
            self.frame = CGRectMake(0, -self.height, SCREEN_WIDTH, self.height);
        }
        else
        {
            if ([self.selectDelegate respondsToSelector:@selector(ZCSelectAlbumTableViewDidLoadFirstGroup)]) {
                [self.selectDelegate ZCSelectAlbumTableViewDidLoadFirstGroup];
            }
        }
    };
    
    void (^assetsGroupsFailureBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    };
    
    // Enumerate Camera Roll
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Photo Stream
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Album
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Event
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupEvent usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Faces
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupFaces usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    QBImagePickerGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[QBImagePickerGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ALAssetsGroup *assetsGroup = [_assetsGroups objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageWithCGImage:assetsGroup.posterImage];
    if ([[assetsGroup valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"Camera Roll"]) {
        cell.titleLabel.text = @"相机胶卷";

    }
    else
    {
        cell.titleLabel.text = [NSString stringWithFormat:@"%@", [assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
    }
    cell.countLabel.text = [NSString stringWithFormat:@"(%ld)", assetsGroup.numberOfAssets];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ALAssetsGroup *assetsGroup = [_assetsGroups objectAtIndex:indexPath.row];
    if ([self.selectDelegate respondsToSelector:@selector(ZCSelectAlbumTableView:didSelectAssetsGroup:)]) {
        [self.selectDelegate ZCSelectAlbumTableView:self didSelectAssetsGroup:assetsGroup];
    }
}

@end
