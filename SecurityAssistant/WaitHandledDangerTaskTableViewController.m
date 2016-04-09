//
//  WaitHandledDangerTaskTableViewController.m
//  SecurityAssistant
//
//  Created by talkweb on 16/3/9.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "WaitHandledDangerTaskTableViewController.h"
#import "WaitHandledDangerTaskTableViewCell.h"
#import "NetDown.h"
#import "WaitHandledDangerDetailsTableViewController.h"

@interface WaitHandledDangerTaskTableViewController (){
    NSArray *sortedKeys;
}

@end

@implementation WaitHandledDangerTaskTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sortedKeys = [[[NetDown shareTaskDataMgr] fbTaskDic] keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *time1 = [formatter dateFromString:[[obj1 objectForKey:@"errinfo"] objectForKey:@"c_cur_feedback_time"]];
        NSDate *time2 = [formatter dateFromString:[[obj2 objectForKey:@"errinfo"] objectForKey:@"c_cur_feedback_time"]];
        
        if([time1 timeIntervalSinceDate:time2] > 0.0){
            return (NSComparisonResult)NSOrderedDescending;
        }
        if([time1 timeIntervalSinceDate:time2] < 0.0){
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [[NetDown shareTaskDataMgr] fbTaskDic].count;
    return [sortedKeys count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WaitHandledDangerTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
//    NSDictionary *dict = [[[NetDown shareTaskDataMgr] fbTaskDic] objectForKey:[[[[NetDown shareTaskDataMgr] fbTaskDic] allKeys] objectAtIndex:indexPath.row]];
    NSDictionary *dict = [[[NetDown shareTaskDataMgr] fbTaskDic] objectForKey:[sortedKeys objectAtIndex:indexPath.row]];
    
    NSDictionary *errinfoDict = [dict objectForKey:@"errinfo"];
    
    cell.titleLabel.text = [errinfoDict objectForKey:@"c_err_name"];
//    cell.timeLabel.text = [errinfoDict objectForKey:@"c_cur_feedback_time"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:[errinfoDict objectForKey:@"c_cur_feedback_time"]];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"反馈时间 MM月dd日 HH:mm"];
    cell.timeLabel.text = [formatter1 stringFromDate:date];
//    cell.overdueLabel.hidden = [date timeIntervalSinceNow] > 0.0;
//    cell.overdueLabel.textColor = [VariableStore getSystemWarnTextColor];
    cell.indexLabel.layer.masksToBounds = YES;
    cell.indexLabel.layer.cornerRadius = cell.indexLabel.bounds.size.width / 2;
    cell.indexLabel.backgroundColor = [VariableStore getSystemBackgroundColor];
    cell.indexLabel.textColor = [UIColor whiteColor];
    cell.indexLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
    //"status" //隐患类型 0 执行 1 验证 2 评价
    int status = [[dict objectForKey:@"status"] intValue];
    switch (status) {
        case 0:{
            cell.statueLabel.text = @"待执行";
            cell.statueLabel.textColor = [VariableStore getSystemWarnTextColor];
            break;
        }
        case 1:{
            cell.statueLabel.text = @"待验证";
            cell.statueLabel.textColor = [VariableStore getSystemTureTextColor];
            break;
        }
        case 2:{
            cell.statueLabel.text = @"待评价";
            cell.statueLabel.textColor = [VariableStore getSystemTureTextColor];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [[[NetDown shareTaskDataMgr] fbTaskDic] objectForKey:[sortedKeys objectAtIndex:indexPath.row]];
    [self performSegueWithIdentifier:@"detailsSegue" sender:dict];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WaitHandledDangerDetailsTableViewController *controller = segue.destinationViewController;
    controller.errDict = (NSDictionary*)sender;
}

@end
