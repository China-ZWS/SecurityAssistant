//
//  HIddenDangerTableViewCell.h
//  SecurityAssistant
//
//  Created by kevin on 16/3/3.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HIddenDangerTableViewCell : UITableViewCell
/**
 *   cell.numberTitle
 cell.detailTitle
 cell.nameTitle.text=@"姜英";
 cell.timeTitle.text=@"2015-11-04";
 cell.safeTitle.text=@"安全";
 cell.statusTitle.text=@"未完成";
 */
@property (weak, nonatomic) IBOutlet UILabel *numberTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UILabel *nameTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeTitle;
@property (weak, nonatomic) IBOutlet UILabel *safeTitle;
@property (weak, nonatomic) IBOutlet UILabel *statusTitle;


@end
