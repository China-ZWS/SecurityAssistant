//
//  WaitHandledAssignTaskDetailsTableViewController.m
//  SecurityAssistant
//
//  Created by talkweb on 16/4/7.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "WaitHandledAssignTaskDetailsTableViewController.h"
#import "WaitHandledDangerDetailsContentCollectionViewCell.h"

@interface WaitHandledAssignTaskDetailsTableViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    
    __weak IBOutlet UILabel *lbCreator;
    __weak IBOutlet UILabel *lbCreatTime;
    __weak IBOutlet UILabel *lbRemark;
    __weak IBOutlet UICollectionView *cvAttachment;
    
}

@end

@implementation WaitHandledAssignTaskDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //task
    //attachments
    NSDictionary *dict = [_taskDict objectForKey:@"task"];
    lbCreator.text = [dict objectForKey:@"c_confirm_username"];
    lbCreatTime.text = [VariableStore getFormaterDateString:[dict objectForKey:@"c_confirm_time"]];
    lbRemark.text = [dict objectForKey:@"c_remark"];
    
    [cvAttachment registerClass:[WaitHandledDangerDetailsContentCollectionViewCell class] forCellWithReuseIdentifier:@"reuseIdentifier"];
    [cvAttachment registerNib:[UINib nibWithNibName:@"WaitHandledDangerDetailsContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"reuseIdentifier"];
    cvAttachment.dataSource = self;
    cvAttachment.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - CollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[_taskDict objectForKey:@"attachments"] count];
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 0, 0);//分别为上、左、下、右
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50,50);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WaitHandledDangerDetailsContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    //"c_isfile" = 1;  c_value ＝ "url"  c_tracefunid = 0 反馈内容 1 语音,2 图片,3 视频
    NSDictionary *dict = [[_taskDict objectForKey:@"attachments"] objectAtIndex:indexPath.row];
    cell.url = [dict objectForKey:@"c_file_path"];
    cell.typeId = [[dict objectForKey:@"c_file_type"] intValue];
    
    switch (cell.typeId) {
        case 2:
            cell.itemImageView.image = [UIImage imageNamed:@"ic_file_audio_img"];
            break;
        case 1:{
            [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:cell.url] placeholderImage:[UIImage imageNamed: @"no_img"] options:SDWebImageProgressiveDownload];
        }
            break;
        case 3:
            cell.itemImageView.image = [UIImage imageNamed: @"ic_file_video_img"];
            break;
        default:
            break;
    }
    
    
    return cell;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [[_taskDict objectForKey:@"attachments"] objectAtIndex:indexPath.row];
    
    int typeId = [[dict objectForKey:@"c_file_type"] intValue];
    switch (typeId) {
        case 2:
            [[VariableStore sharedInstance]playMedia:[NSURL URLWithString:[dict objectForKey:@"c_file_path"]]];
            break;
        case 1:
        {
            WaitHandledDangerDetailsContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
            [[VariableStore sharedInstance] showImageView:cell.itemImageView fromUrl:[NSURL URLWithString:[dict objectForKey:@"c_file_path"]]];
        }
            break;
        case 3:
            [[VariableStore sharedInstance]playMedia:[NSURL URLWithString:[dict objectForKey:@"c_file_path"]]];
            break;
        default:
            break;
    }
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
