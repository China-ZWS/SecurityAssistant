//
//  WaitHandledDangerDetailsProcessTableViewCell.m
//  SecurityAssistant
//
//  Created by talkweb on 16/4/1.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "WaitHandledDangerDetailsProcessTableViewCell.h"
#import "WaitHandledDangerDetailsContentCollectionViewCell.h"

@implementation WaitHandledDangerDetailsProcessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_cvObtainVidence registerClass:[WaitHandledDangerDetailsContentCollectionViewCell class] forCellWithReuseIdentifier:@"reuseIdentifier"];
    [_cvObtainVidence registerNib:[UINib nibWithNibName:@"WaitHandledDangerDetailsContentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"reuseIdentifier"];
    _cvObtainVidence.dataSource = self;
    _cvObtainVidence.delegate = self;

}
-(void)layoutSubviews{
    _txtFeedbackContent.font = [UIFont systemFontOfSize:17];
    _txtFeedbackContent.textColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - CollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_array count];
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
    NSDictionary *dict = [_array objectAtIndex:indexPath.row];
    cell.url = [dict objectForKey:@"c_value"];
    cell.typeId = [[dict objectForKey:@"c_tracefunid"] intValue];
    
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
    NSDictionary *dict = [_array objectAtIndex:indexPath.row];
    
    int typeId = [[dict objectForKey:@"c_tracefunid"] intValue];
    switch (typeId) {
        case 2:
            [[VariableStore sharedInstance]playMedia:[NSURL URLWithString:[dict objectForKey:@"c_value"]]];
            break;
        case 1:
        {
            WaitHandledDangerDetailsContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
            [[VariableStore sharedInstance] showImageView:cell.itemImageView fromUrl:[NSURL URLWithString:[dict objectForKey:@"c_value"]]];
        }
            break;
        case 3:
            [[VariableStore sharedInstance]playMedia:[NSURL URLWithString:[dict objectForKey:@"c_value"]]];
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
