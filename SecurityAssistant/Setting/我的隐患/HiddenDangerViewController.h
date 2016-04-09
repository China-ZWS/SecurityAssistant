//
//  HiddenDangerViewController.h
//  SecurityAssistant
//
//  Created by kevin on 16/3/2.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HiddenDangerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *dangerTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dangerSegment;
- (IBAction)HiddenDanger:(id)sender;

@end
