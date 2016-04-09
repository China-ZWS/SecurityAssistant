//
//  WaitHandledAssignTaskDetailsTableViewCell.h
//  SecurityAssistant
//
//  Created by talkweb on 16/3/28.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineLabel.h"

@interface WaitHandledAssignTaskDetailsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *stepButton;
//@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIImageView *actionImageView;
@property (weak, nonatomic) IBOutlet LineLabel *actionLabel;
@property (weak, nonatomic) IBOutlet UITextField *actionTextInput;
@property (weak, nonatomic) IBOutlet UILabel *actionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@property (weak, nonatomic) IBOutlet UISwitch *normalSwitch;

@end
