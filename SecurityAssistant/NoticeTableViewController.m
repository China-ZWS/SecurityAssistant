//
//  NoticeTableViewController.m
//  SecurityAssistant
//
//  Created by talkweb on 16/3/1.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "NoticeTableViewController.h"
#import "NoticeTableViewCell.h"
#import "NetDown.h"
#import "NoticeDetailsViewController.h"
#import "WaitHandledTableViewController.h"

@interface NoticeTableViewController ()

@end

@implementation NoticeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    WaitHandledTableViewController *controller = self.navigationController.viewControllers[0];
//    [controller setIsFresh:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NetDown shareTaskDataMgr] getAllServerMsg];  //刷新消息
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
    return [[NetDown shareTaskDataMgr] msgDic].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    NSDictionary *dict = [[[NetDown shareTaskDataMgr] msgDic] objectForKey:[[[[NetDown shareTaskDataMgr] msgDic] allKeys] objectAtIndex:indexPath.row]];
    NSDictionary *msgDict = [dict objectForKey:@"message"];
    
    
    cell.titleLabel.text = [msgDict objectForKey:@"c_msg_title"];
    cell.msgComeFromLabel.text = [msgDict objectForKey:@"c_from"];
    
    NSString *timeString = [dict objectForKey:@"c_recieved_time"];
//    timeString = [timeString substringToIndex:timeString.length -2];
    cell.timeLabel.text = [timeString substringWithRange:NSMakeRange(5, 11)];
    BOOL flag = [[dict objectForKey:@"bRead"] boolValue];
    cell.statueLabel.text = flag ? @"已读":@"未读";
    cell.statueLabel.textColor = flag ? [UIColor lightGrayColor]:[UIColor redColor];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeString];
    
    NSTimeInterval time = [date timeIntervalSinceNow];
//    NSString *sstring = [NSString stringWithFormat:@"%02li:%02li:%02li",
//                        lround(floor(time / 3600.)) % 100 * -1,
//                        lround(floor(time / 60.)) % 60 * -1,
//                        lround(floor(time)) % 60 * -1];
//    
//    NSLog(@"time:%@ %@",timeString,sstring);
    
    long int h = lround(floor(time / 3600.)) % 100 * -1;
    long int m = lround(floor(time / 60.)) % 60 * -1;
    long int s = lround(floor(time)) % 60 * -1;
    NSString *string = @"";
    
    if(!h && !m){
        string = [NSString stringWithFormat:@"%02li秒前",s];
    }
    else if(!h){
        string = [NSString stringWithFormat:@"%02li分钟前",m];
    }
    else{
        string = [NSString stringWithFormat:@"%02li小时%02li分钟前",h,m];
    }
    
    cell.timeIntervalLabel.text = string;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [[[NetDown shareTaskDataMgr] msgDic] objectForKey:[[[[NetDown shareTaskDataMgr] msgDic] allKeys] objectAtIndex:indexPath.row]];
    NSDictionary *msgDict = [dict objectForKey:@"message"];
    BOOL flag = [[dict objectForKey:@"bRead"] boolValue];
    if(!flag){
        [[NetDown shareTaskDataMgr] msgStateChange:[msgDict objectForKey:@"c_msg_id"] READ:YES];
        WaitHandledTableViewController *controller = self.navigationController.viewControllers[0];
        [controller setIsFresh:YES];
    }
    
    [self performSegueWithIdentifier:@"noticeDetailsSegue" sender:[[[NetDown shareTaskDataMgr] msgDic] objectForKey:[[[[NetDown shareTaskDataMgr] msgDic] allKeys] objectAtIndex:indexPath.row]]];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NoticeDetailsViewController *controller = segue.destinationViewController;
    controller.msgDict = (NSDictionary*)sender;
}


@end
