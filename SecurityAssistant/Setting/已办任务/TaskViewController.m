//
//  TaskViewController.m
//  SecurityAssistant
//
//  Created by kevin on 16/3/2.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskTableViewCell.h"

#import "NetDown.h"
@interface TaskViewController ()
@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.taskTableView.dataSource=self;[self.reportWebView loadRequest:
    NSDictionary *infoData=[[NetDown shareTaskDataMgr] userInfo];
    NSString *urlString= [[NSString alloc]initWithFormat:@"http://%@:%@/TWPASS/mobile/taskAndErr/taskAndErr.html?userId=%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"preference_ip"],[[NSUserDefaults standardUserDefaults] stringForKey:@"preference_port"],[infoData objectForKey:@"userid"]];
    [self.taskWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [self.taskWebview setScalesPageToFit:YES];
    
    
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // return [tableArray count];
//    return 2;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    static NSString *tableSampleIdentifier = @"reuseIdentifier";
////    
////    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableSampleIdentifier];
////    
////    if (cell == nil) {
////        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableSampleIdentifier];
////    }
//     TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskTableViewCell"];
//    cell.numberTitle.text=@"1";
//    cell.taskTitle.text=@"消防栓检查20160226";
//  
//    
//    // Configure the cell...
//    
//    
//    return cell;
//}
//
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
