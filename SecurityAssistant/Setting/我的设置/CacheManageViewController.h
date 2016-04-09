//
//  CacheManageViewController.h
//  SecurityAssistant
//
//  Created by kevin on 16/3/21.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"
@interface CacheManageViewController : UIViewController<PNChartDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cacheMenage;
@property (weak, nonatomic) IBOutlet UILabel *cacheTip;
@property (strong,nonatomic) PNPieChart *pieChart;
- (IBAction)ClearAplicationCache:(id)sender;
@end
