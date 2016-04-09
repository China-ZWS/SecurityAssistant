//
//  FileAddView.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/4.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "FileAddView.h"
#import "BasePhotoPickerManager.h"
#import "RecoderViewController.h"
@interface FileAddCell : BaseCollectionViewCell
@end

@implementation FileAddCell


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        _imageView = [UIImageView new];
        _imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = CGRectMake(0, 0, self.width, self.height);
}

- (void)setDatas:(id)datas index:(NSInteger)index
{
    
    UIImage *image = nil;
    if ([datas count] == index)
    {
        image = img(@"add_icon.png");
    }
    
    else if ([datas[index][@"type"] isEqualToString:@"image"])
    {
        image = datas[index ][@"file"];
    }
    else if ([datas[index ][@"type"] isEqualToString:@"video"])
    {
        image = img(@"ic_file_video_img.png");
    }
    else if ([datas[index][@"type"] isEqualToString:@"audio"])
    {
        image = img(@"ic_file_audio_img.png");
    }
    _imageView.image = image;
}

@end

@interface FileAddView()
<UICollectionViewDelegate, UICollectionViewDataSource>
{
    void (^_success)(id datas);
    void (^_refreshHeight)();
    NSMutableArray *_files;
    NSInteger _filesIndex;
}
@end

static CGRect _rect;
@implementation FileAddView

- (void)dealloc
{
    NSLog(@"%@",self);
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if ((self = [super initWithFrame:frame collectionViewLayout:layout])) {
        _files = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        
        [self registerClass:[FileAddCell class] forCellWithReuseIdentifier:@"cell"];
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
    }
    return self;
}

+ (UICollectionViewFlowLayout *)segmentBarLayout
{
    UICollectionViewFlowLayout *segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (CGRectGetWidth(_rect) - 24) / 4 ;
    segmentBarLayout.itemSize = CGSizeMake(width,width);
    segmentBarLayout.minimumLineSpacing = 5;
    segmentBarLayout.minimumInteritemSpacing = 0;
    return segmentBarLayout;
}


+ (id)showViewRect:(CGRect)rect
{
    _rect = rect;
    FileAddView *addView = [[FileAddView alloc] initWithFrame:rect collectionViewLayout:[self segmentBarLayout]] ;
    return addView;
}

+ (id)showInViewWithframe:(CGRect)frame success:(void(^)(id datas))success refreshHeight:(void(^)())refreshHeight;
{
    FileAddView *addView = [FileAddView showViewRect:frame];
    addView->_success = success;
    addView->_refreshHeight = refreshHeight;
    
    return addView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _files.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FileAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setDatas:_files index:indexPath.row];
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(eventWWithLong:)];
    [cell addGestureRecognizer:recognizer];
    recognizer.minimumPressDuration = 1.0f;
    recognizer.view.tag = indexPath.row;
    
    return cell;
}

- (void)eventWWithLong:(UILongPressGestureRecognizer *)recognizer
{
    if (!_files.count) {
        return;
    }
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            _filesIndex = recognizer.view.tag;
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:(id<UIActionSheetDelegate>)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
            [sheet showInView:self];
        }
            
            break;
            
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [_files removeObjectAtIndex:_filesIndex];
        [self reloadData];
    }
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _files.count)
    {
        if (_files.count >= 9)
        {
            [self makeToast:@"最多上传9张"];
            return;
        }
        [self handlePanFrom];
    }
    else
    {
        NSDictionary *dic = _files[indexPath.row];
        if ([dic[@"type"] isEqualToString:@"image"])
        {
            [[VariableStore sharedInstance] showImageView:nil fromUrl:[NSURL fileURLWithPath:dic[@"path"]]];

        }
        else if ([dic[@"type"] isEqualToString:@"video"])
        {
            [[VariableStore sharedInstance] playMedia:[NSURL fileURLWithPath:dic[@"path"]]];
        }
        else if ([dic[@"type"] isEqualToString:@"audio"])
        {
            [[VariableStore sharedInstance] playMedia:[NSURL fileURLWithPath:dic[@"path"]]];
        }

    }
}

- (void)handlePanFrom
{
    __weak FileAddView *safeSelf = self;
    [[BasePhotoPickerManager shared] showActionSheetInView:self fromController:[self setViewController] completion:^(id datas)
     {
         [safeSelf completion:datas];
     }
     
     
                                                otherBlock:^(void(^other)(NSString*)){
                                                    
                                                    RecoderViewController *avrecodeviewcontroller=[[RecoderViewController alloc]init];
                                                    
                                                    avrecodeviewcontroller.AVRecoderSuncessBlock = ^(RecoderViewController *recoderview,NSString *pathString){
                                                        other(pathString);
                                                    };
                                                    [[safeSelf setViewController] presentViewController:avrecodeviewcontroller animated:YES completion:nil];
                                                }
                                               cancelBlock:^{
                                                   
                                               }];
    
    //    avrecodeviewcontroller.AVRecoderSuncessBlock = ^(RecoderViewController *aqrvc,NSString *pathString){
    //     //                                                        OutPutString = pathString
    //     [avrecodeviewcontroller dismissViewControllerAnimated:NO completion:nil];
    //                                                         };
    
    //  [self presentViewController:qrcodevc animated:YES completion:nil];
}

- (void)completion:(id)datas
{
    [_files addObject:datas];
    [self reloadData];
    _success(_files);
    NSInteger row = floor(_files.count / 4.0) + 1;
    CGRect rect = self.frame;
    rect.size.height = (CGRectGetWidth(_rect) - 24) / 4  * row + (row - 1) * 5;
    self.frame = rect;
    _refreshHeight();
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
