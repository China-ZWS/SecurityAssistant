//
//  TaskTableViewCell.h
//  SecurityAssistant
//
//  Created by kevin on 16/3/2.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberTitle;
@property (weak, nonatomic) IBOutlet UILabel *taskTitle;

@end
