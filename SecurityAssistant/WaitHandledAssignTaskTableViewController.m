//
//  WaitHandledAssignTaskTableViewController.m
//  SecurityAssistant
//
//  Created by talkweb on 16/3/9.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "WaitHandledAssignTaskTableViewController.h"
#import "WaitHandledAssignTaskTableViewCell.h"
#import "NetDown.h"
#import "WaitHandledDailyTaskDetailsTableViewController.h"

@interface WaitHandledAssignTaskTableViewController (){
    NSArray *sortedKeys;
}

@end

@implementation WaitHandledAssignTaskTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sortedKeys = [[[NetDown shareTaskDataMgr] assignTaskDic] keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
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
//    return [[NetDown shareTaskDataMgr] assignTaskDic].count;
    return [sortedKeys count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WaitHandledAssignTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];

//    NSDictionary * dict = [[[NetDown shareTaskDataMgr] assignTaskDic]objectForKey:[[[[NetDown shareTaskDataMgr] assignTaskDic] allKeys] objectAtIndex:indexPath.row]];
//    
//    NSDictionary *assignDict = [dict objectForKey:@"task"];
    
    NSDictionary *assignTaskDict = [[[NetDown shareTaskDataMgr] assignTaskDic]objectForKey:[sortedKeys objectAtIndex:indexPath.row]];
//    NSDictionary *assignTaskDict = [[[NetDown shareTaskDataMgr] assignTaskDic]objectForKey:[[[[NetDown shareTaskDataMgr] assignTaskDic] allKeys] objectAtIndex:indexPath.row]];
    NSMutableDictionary *dict = [[VariableStore sharedInstance] getWaitHandledData:assignTaskDict];
    NSDictionary *taskDict = [dict objectForKey:@"task"];
    
    
    cell.indexLabel.layer.masksToBounds = YES;
    cell.indexLabel.layer.cornerRadius = cell.indexLabel.bounds.size.width / 2;
    cell.indexLabel.backgroundColor = [VariableStore getSystemBackgroundColor];
    cell.indexLabel.textColor = [UIColor whiteColor];
    cell.indexLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    
    cell.titleLabel.text = [taskDict objectForKey:@"c_task_name"];
//    cell.timeLabel.text = [taskDict objectForKey:@"c_end_time"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:[taskDict objectForKey:@"c_end_time"]];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"截止时间 MM月dd日 HH:mm"];
    cell.timeLabel.text = [formatter1 stringFromDate:date];
    cell.overdueLabel.hidden = [date timeIntervalSinceNow] > 0.0;
    cell.overdueLabel.textColor = [VariableStore getSystemWarnTextColor];
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
///委派任务 与 日常任务共用 执行任务 界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dict = [[[NetDown shareTaskDataMgr] assignTaskDic] objectForKey:[sortedKeys objectAtIndex:indexPath.row]];
    [self performSegueWithIdentifier:@"detailsSegue" sender:dict];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WaitHandledDailyTaskDetailsTableViewController *controller = segue.destinationViewController;
    controller.isCustomize = YES;
    controller.taskDict = sender;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
