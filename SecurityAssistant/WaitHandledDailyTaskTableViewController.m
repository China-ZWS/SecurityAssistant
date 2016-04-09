//
//  WaitHandledDailyTaskTableViewController.m
//  SecurityAssistant
//
//  Created by talkweb on 16/3/9.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "WaitHandledDailyTaskTableViewController.h"
#import "WaitHandledDailyTaskTableViewCell.h"
#import "NetDown.h"
#import "WaitHandledDailyTaskDetailsTableViewController.h"

@interface WaitHandledDailyTaskTableViewController (){
    NSArray *sortedKeys;
}

@end

@implementation WaitHandledDailyTaskTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sortedKeys = [[[NetDown shareTaskDataMgr] dayTaskDic] keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *time1 = [formatter dateFromString:[[obj1 objectForKey:@"task"] objectForKey:@"c_end_time"]];
        NSDate *time2 = [formatter dateFromString:[[obj2 objectForKey:@"task"] objectForKey:@"c_end_time"]];
        
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
-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
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
//    return [[[NetDown shareTaskDataMgr] dayTaskDic] allKeys].count;
    return [sortedKeys count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WaitHandledDailyTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
//    NSDictionary *dayTaskDict = [[[NetDown shareTaskDataMgr] dayTaskDic] objectForKey:[[[[NetDown shareTaskDataMgr] dayTaskDic] allKeys] objectAtIndex:indexPath.row]];
    
    NSDictionary *dayTaskDict = [[[NetDown shareTaskDataMgr] dayTaskDic] objectForKey:[sortedKeys objectAtIndex:indexPath.row]];
    
    NSMutableDictionary *dict = [[VariableStore sharedInstance] getWaitHandledData:dayTaskDict];
    
    NSDictionary *taskDict = [dict objectForKey:@"task"];
    
    cell.indexLabel.layer.masksToBounds = YES;
    cell.indexLabel.layer.cornerRadius = cell.indexLabel.bounds.size.width / 2;
    cell.indexLabel.backgroundColor = [VariableStore getSystemBackgroundColor];
    cell.indexLabel.textColor = [UIColor whiteColor];
    cell.indexLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
    cell.titleLabel.text = [taskDict objectForKey:@"c_task_name"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:[taskDict objectForKey:@"c_end_time"]];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"截止时间 MM月dd日 HH:mm"];
    cell.timeLabel.text = [formatter1 stringFromDate:date];
    cell.overdueLabel.hidden = [date timeIntervalSinceNow] > 0.0;
    cell.overdueLabel.textColor = [VariableStore getSystemWarnTextColor];
    //"2016-03-31 16:45:00"
    
    //"status" //隐患类型 0 执行 1 验证 2 评价
    int status = [[dict objectForKey:@"status"] intValue];
    if(!status){
        cell.statueLabel.text = @"待执行";
        cell.statueLabel.textColor = [VariableStore getSystemWarnTextColor];
    }
    else{
        cell.statueLabel.text = @"进行中";
        cell.statueLabel.textColor = [VariableStore getSystemTureTextColor];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSMutableDictionary *dict = [[[NetDown shareTaskDataMgr] dayTaskDic] objectForKey:[[[[NetDown shareTaskDataMgr] dayTaskDic] allKeys] objectAtIndex:indexPath.row]];
    
     NSDictionary *dict = [[[NetDown shareTaskDataMgr] dayTaskDic] objectForKey:[sortedKeys objectAtIndex:indexPath.row]];
    [self performSegueWithIdentifier:@"detailsSegue" sender:dict];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WaitHandledDailyTaskDetailsTableViewController *controller = segue.destinationViewController;
    controller.taskDict = sender;
}

@end
