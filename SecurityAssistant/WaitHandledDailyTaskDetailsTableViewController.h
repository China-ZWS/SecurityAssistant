//
//  WaitHandledDailyTaskDetailsTableViewController.h
//  SecurityAssistant
//
//  Created by talkweb on 16/3/10.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitHandledDailyTaskDetailsTableViewController : UITableViewController

@property(nonatomic,weak)NSDictionary *taskDict;
@property(nonatomic,assign)BOOL isCustomize;
@property(nonatomic,assign)BOOL isSubmitErrorLaunch;

@end
