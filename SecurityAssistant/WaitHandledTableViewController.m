//
//  WaitHandledTableViewController.m
//  SecurityAssistant
//
//  Created by talkweb on 16/2/24.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "WaitHandledTableViewController.h"
#import "WaitHandledTableViewCell.h"

#import "VariableStore.h"
#import "NetDown.h"
#import "MBProgressHUD.h"
#import "NoticeTableViewController.h"

#import "WaitHandledDailyTaskTableViewController.h"
#import "WaitHandledAssignTaskTableViewController.h"
#import "WaitHandledDangerTaskTableViewController.h"
#import "MJRefresh.h"

@interface WaitHandledTableViewController ()<MBProgressHUDDelegate>{
    NSArray *tableArray;

}

@end

@implementation WaitHandledTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"待 办";
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    tableArray = [[NSArray alloc] initWithObjects:@"日常任务",@"隐患任务",@"委派任务",@"消息通知", nil];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    _isFresh = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_isFresh)
        [self.tableView.header beginRefreshing];
    _isFresh=NO;
}

-(void)refreshData{
    [[NetDown shareTaskDataMgr] getAllServerTask]; //刷新日程与委派任务
    [[NetDown shareTaskDataMgr] getAllServerMsg];  //刷新消息
    [[NetDown shareTaskDataMgr] getFbList];        //刷新隐患
//    [self.tableView reloadData];
    NSDictionary *taskDict = [[NetDown shareTaskDataMgr] dayTaskDic];
    NSDictionary *msgDict = [[NetDown shareTaskDataMgr] msgDic];
    NSDictionary *fbDict = [[NetDown shareTaskDataMgr] fbTaskDic];
    NSDictionary *assDict = [[NetDown shareTaskDataMgr] assignTaskDic];
    

    WaitHandledTableViewCell *cellDay = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    WaitHandledTableViewCell *cellFb = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    WaitHandledTableViewCell *cellAss = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    WaitHandledTableViewCell *cellMsg = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if([taskDict allKeys].count > 0){
            cellDay.badgeBackgroundView.hidden=NO;
            cellDay.badgeLabel.hidden=NO;
            cellDay.badgeLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[taskDict allKeys].count];
            
            NSString *timeString = [[[taskDict objectForKey:[[taskDict allKeys] lastObject]] objectForKey:@"task"] objectForKey:@"c_confirm_time"];;
            timeString = [timeString substringWithRange:NSMakeRange(5, 11)];
//            cellDay.titleTimeLabel.text = timeString;
//            cellDay.titleTimeLabel.hidden=NO;
        }
        else{
            cellDay.badgeBackgroundView.hidden=YES;
            cellDay.badgeLabel.hidden=YES;
//            cellDay.titleTimeLabel.hidden=YES;
        }
        
        if([fbDict allKeys].count > 0){
            cellFb.badgeBackgroundView.hidden=NO;
            cellFb.badgeLabel.hidden=NO;
            cellFb.badgeLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[fbDict allKeys].count];
            NSString *timeString =[[[fbDict objectForKey:[[fbDict allKeys] lastObject]] objectForKey:@"errinfo"] objectForKey:@"c_cur_feedback_time"];
            timeString = [timeString substringWithRange:NSMakeRange(5, 11)];
//            cellFb.titleTimeLabel.text = timeString;
//            cellFb.titleTimeLabel.hidden=NO;
        }
        else{
            cellFb.badgeBackgroundView.hidden=YES;
            cellFb.badgeLabel.hidden=YES;
//            cellFb.titleTimeLabel.hidden=YES;
        }
        
        if([assDict allKeys].count > 0){
            cellAss.badgeBackgroundView.hidden=NO;
            cellAss.badgeLabel.hidden=NO;
            cellAss.badgeLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[assDict allKeys].count];
            
            NSString *timeString = [[[assDict objectForKey:[[assDict allKeys] lastObject]] objectForKey:@"task"] objectForKey:@"c_confirm_time"];
            
            timeString = [timeString substringWithRange:NSMakeRange(5, 11)];
//            cellAss.titleTimeLabel.text = timeString;
//            cellAss.titleTimeLabel.hidden=NO;
        }
        else{
            cellAss.badgeBackgroundView.hidden=YES;
            cellAss.badgeLabel.hidden=YES;
//            cellAss.titleTimeLabel.hidden=YES;
        }
        
        if([msgDict allKeys].count > 0){
            cellMsg.badgeBackgroundView.hidden=NO;
            cellMsg.badgeLabel.hidden=NO;
            
            int i = 0;
            for (NSString *key in [msgDict allKeys]) {
                NSDictionary *d = [msgDict objectForKey:key];
                BOOL flag = [[d objectForKey:@"bRead"] boolValue];
                if(!flag)
                    i++;
            }
            
            if(i > 0){
                cellMsg.badgeLabel.text = [NSString stringWithFormat:@"%d",i];
            }
            else{
                cellMsg.badgeLabel.hidden = YES;
                cellMsg.badgeBackgroundView.hidden = YES;
            }
            
            NSString *timeString = [[msgDict objectForKey:[[msgDict allKeys] lastObject]] objectForKey:@"c_recieved_time"];
            timeString = [timeString substringWithRange:NSMakeRange(5, 11)];
//            cellMsg.titleTimeLabel.text = timeString;
//            cellMsg.titleTimeLabel.hidden=NO;
        }
        else{
            cellMsg.badgeBackgroundView.hidden=YES;
            cellMsg.badgeLabel.hidden=YES;
//            cellMsg.titleTimeLabel.hidden=YES;
        }
    });
    
    [self.tableView.header endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .1f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WaitHandledTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    cell.titleLabel.text = [tableArray objectAtIndex:indexPath.row];
    NSString *imageName = @"";
    switch (indexPath.row) {
        case 0:
            imageName = @"wh_01";
            break;
        case 1:
            imageName = @"trouble_task";
            break;
        case 2:
            imageName = @"wh_03";
            break;
        case 3:
            imageName = @"wh_04";
            break;
        default:
            break;
    }
    cell.titleImageView.image = [UIImage imageNamed:imageName];
    cell.titleImageView.contentMode = UIViewContentModeScaleAspectFit;
        
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"dailySegue" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"dangerSegue" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"assignSegue" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"noticeSegue" sender:self];
            break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

-(void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
}
@end
