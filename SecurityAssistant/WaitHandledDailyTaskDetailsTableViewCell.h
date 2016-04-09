//
//  WaitHandledDailyTaskDetailsTableViewCell.h
//  SecurityAssistant
//
//  Created by talkweb on 16/3/10.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineLabel.h"

@interface WaitHandledDailyTaskDetailsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *stepButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIImageView *actionImageView;
@property (weak, nonatomic) IBOutlet LineLabel *actionLabel;
@property (weak, nonatomic) IBOutlet UITextField *actionTextInput;
@property (weak, nonatomic) IBOutlet UILabel *actionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@property (weak, nonatomic) IBOutlet UISwitch *normalSwitch;

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;


@end
