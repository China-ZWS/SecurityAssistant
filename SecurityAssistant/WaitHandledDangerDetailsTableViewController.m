//
//  WaitHandledDangerDetailsTableViewController.m
//  SecurityAssistant
//
//  Created by talkweb on 16/3/17.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "WaitHandledDangerDetailsTableViewController.h"
#import "MeHandleViewController.h"
#import "RectificationViewController.h"
#import "GoOnFeedbackViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "KeyboardToolBar.h"
#import "MBProgressHUD.h"
#import "WaitHandledTableViewController.h"
#import "WaitHandledDangerDetailsStandardFooterViewController.h"
#import "WaitHandledDangerDetailsRemarkFooterViewController.h"
#import "WaitHandledDangerDetailsContentTableViewCell.h"
#import "WaitHandledDangerDetailsProcessTableViewCell.h"
#import "WaitHandledDangerDetailsResultTableViewCell.h"

#define TABLE_SECTION_NUMBER 3

@interface WaitHandledDangerDetailsTableViewController ()<MBProgressHUDDelegate,WaitHandledDangerDetailsStandardFooterDelegate>{
    
    MPMoviePlayerViewController *playerViewController;
    WaitHandledDangerDetailsStandardFooterViewController *standardFooterViewController;
    WaitHandledDangerDetailsRemarkFooterViewController *remarkFooterViewController;
    
    NSMutableArray *contentArray;
    NSMutableArray *processArray;
    NSMutableArray *resultArray;
}

@end

@implementation WaitHandledDangerDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSDictionary *errinfoDict = [_errDict objectForKey:@"errinfo"];
    int feedbackId = [[errinfoDict objectForKey:@"c_cur_feedback_id"] intValue];
    contentArray = [NSMutableArray new];
    processArray = [NSMutableArray new];
    resultArray = [NSMutableArray new];
    BOOL isClose = [[errinfoDict objectForKey:@"c_isclose"] boolValue];
    for (NSDictionary *d in [_errDict objectForKey:@"feedbackinfos"]) {
        BOOL level = [[d objectForKey:@"c_level"] boolValue];
        int cid = [[d objectForKey:@"c_id"] intValue];
        if(!level)
            [contentArray addObject:d];
        else
            [processArray addObject:d];
        
        if(isClose && cid == feedbackId)
            [resultArray addObject:d];
    }
//    //"status" //隐患类型 0 执行 1 验证 2 评价
    int status = [[_errDict objectForKey:@"status"] intValue];
    if(status){
        UIBarButtonItem *rightButton=[[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitCompletion)];
        [rightButton setTintColor:[UIColor whiteColor]];
        [self.navigationItem setRightBarButtonItem:rightButton];
    }
    
    standardFooterViewController = [[WaitHandledDangerDetailsStandardFooterViewController alloc] initWithNibName:@"WaitHandledDangerDetailsStandardFooterViewController" bundle:nil];
    standardFooterViewController.delegate=self;
    remarkFooterViewController = [[WaitHandledDangerDetailsRemarkFooterViewController alloc] initWithNibName:@"WaitHandledDangerDetailsRemarkFooterViewController" bundle:nil];
}

///验证与评价的提交
-(void)submitCompletion{
    if(remarkFooterViewController.remarkTextView.text.length < 1){
        [self showMsg:@"您还没有描述验证情况！"];
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"信息提示" message:@"您确定提交当前任务验证！" delegate:self cancelButtonTitle:@"取 消" otherButtonTitles:@"确 定", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex)
        [self submitResult];
}
-(void)submitResult{
    /*
     "c_err_id" ; 异常id
     "c_feedback_id" ;
     "verify_status" ; 验证状态 1不通过 2通过
     "verify_result" ; 验证内容
     "verify_userid" ; 验证用户id
     */
    NSDictionary *errinfoDict = [_errDict objectForKey:@"errinfo"];
    
    NSMutableArray *array = [NSMutableArray new];
    [array addObject:[errinfoDict objectForKey:@"c_err_id"]];
    [array addObject:[errinfoDict objectForKey:@"c_cur_feedback_id"]];
    [array addObject:remarkFooterViewController.swRemark.on?@"2":@"1"];
    [array addObject:remarkFooterViewController.remarkTextView.text];
    [array addObject:[[[NetDown shareTaskDataMgr] userInfo] objectForKey:@"userid"]];
    
    BOOL flag = [[NetUp shareTaskDataMgr] ErrorVerify:array];
    if(!flag){
        [self showMsg:@"提交信息错误！"];
        return;
    }
    [self showMsg:@"提交成功！"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        WaitHandledTableViewController *controller = self.navigationController.viewControllers[0];
        [controller setIsFresh:YES];
        [[NetDown shareTaskDataMgr] delUpTask:[errinfoDict objectForKey:@"c_err_id"] TaskType:2];
        [self.navigationController popToViewController:controller animated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TABLE_SECTION_NUMBER;
}
// section 0: 隐患反馈信息 section 1: 整改安排信息 section 2:隐患处理结果
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [contentArray count];
        case 1:
            return [processArray count];
        case 2:
            return [resultArray count];
        default:
            return 0;

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 420;

        case 1:
            return 360;

        case 2:
            return 320;

        default:
            return 0;

    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section < TABLE_SECTION_NUMBER - 1)
        return .1f;
    return 160;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section < 2){
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }
    //    //"status" //隐患类型 0 执行 1 验证 2 评价
    int status = [[_errDict objectForKey:@"status"] intValue];
    if(!status)
        return standardFooterViewController.view;
    return remarkFooterViewController.view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *refdataArray = [_errDict objectForKey:@"refdata"];
    
    if(indexPath.section == 0){
        WaitHandledDangerDetailsContentTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"WaitHandledDangerDetailsContentTableViewCell" owner:self options:nil] firstObject];
        
        NSDictionary *feedbackinfoDict = [contentArray objectAtIndex:indexPath.row];
        NSString *no = [feedbackinfoDict objectForKey:@"c_lotno"];

        NSDictionary *errinfoDict = [_errDict objectForKey:@"errinfo"];
        cell.lbTitle.text = [errinfoDict objectForKey:@"c_err_name"];
        cell.lbArea.text = [errinfoDict objectForKey:@"c_area_name"];
        cell.lbTime.text = [VariableStore getFormaterDateString:[errinfoDict objectForKey:@"c_occur_time"]];
        cell.lbSuggestTime.text = [VariableStore getFormaterDateString:[errinfoDict objectForKey:@"c_suggestend_time"]];

        cell.lbFeedbackUser.text = [feedbackinfoDict objectForKey:@"c_from_username"];
        cell.lbReceiveUser.text = [feedbackinfoDict objectForKey:@"c_to_username"];
        cell.lbCCUser.text = [feedbackinfoDict objectForKey:@"c_cc_usernames"];
        cell.lbFeedbackTime.text = [VariableStore getFormaterDateString:[feedbackinfoDict objectForKey:@"c_feedback_time"]];
        
        NSMutableArray *videnceArray = [NSMutableArray new];
        for (NSDictionary *d in refdataArray) {
            int isfile = [[d objectForKey:@"c_isfile"] intValue];
            int funid = [[d objectForKey:@"c_tracefunid"] intValue];
            
            if([no isEqualToString:[d objectForKey:@"c_record_lotno"]]){
                if(isfile)
                    [videnceArray addObject:d];
                else if(funid == 10)
                    cell.txtFeedbackContent.text = [d objectForKey:@"c_value"];
            }
            
        }
        
        cell.array = videnceArray;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section == 1){
        WaitHandledDangerDetailsProcessTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"WaitHandledDangerDetailsProcessTableViewCell" owner:self options:nil] firstObject];
        
        NSDictionary *feedbackinfoDict = [processArray objectAtIndex:indexPath.row];
        NSString *no = [feedbackinfoDict objectForKey:@"c_lotno"];
        
        cell.lbFeedbackUser.text = [feedbackinfoDict objectForKey:@"c_from_username"];
        cell.lbReceiveUser.text = [feedbackinfoDict objectForKey:@"c_to_username"];
        cell.lbCCUser.text = [feedbackinfoDict objectForKey:@"c_cc_usernames"];
        cell.lbFeedbackTime.text = [VariableStore getFormaterDateString:[feedbackinfoDict objectForKey:@"c_feedback_time"]];
        cell.lbPeriodTime.text = [VariableStore getFormaterDateString:[feedbackinfoDict objectForKey:@"c_end_time"]];
        NSMutableArray *videnceArray = [NSMutableArray new];
        for (NSDictionary *d in refdataArray) {
            int isfile = [[d objectForKey:@"c_isfile"] intValue];
            int funid = [[d objectForKey:@"c_tracefunid"] intValue];
            
            if([no isEqualToString:[d objectForKey:@"c_record_lotno"]]){
                if(isfile)
                    [videnceArray addObject:d];
                else if(funid == 10)
                    cell.txtFeedbackContent.text = [d objectForKey:@"c_value"];
            }
            
        }
        
        cell.array = videnceArray;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        WaitHandledDangerDetailsResultTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"WaitHandledDangerDetailsResultTableViewCell" owner:self options:nil] firstObject];
        NSDictionary *errinfoDict = [_errDict objectForKey:@"errinfo"];
        NSDictionary *feedbackinfoDict = [resultArray objectAtIndex:indexPath.row];
//        NSString *no = [feedbackinfoDict objectForKey:@"c_lotno"];
        //处理方式选项：0任选（自己处置;安排整改;继续反馈）;1接收确认; 2必须自己处置
        int type = [[feedbackinfoDict objectForKey:@"c_deal_type"] intValue];
        cell.lbProcessStatue.text = type == 2 ? @"安排整改" : @"继续反馈";
        cell.lbProcessor.text = [feedbackinfoDict objectForKey:@"c_from_username"];
        cell.lbProcessor.text = [VariableStore getFormaterDateString:[errinfoDict objectForKey:@"c_write_time"]];
        
//        NSString *path = [[errinfoDict objectForKey:@"c_feedback_path"]];
        NSMutableArray *videnceArray = [NSMutableArray new];
        for (NSDictionary *d in refdataArray) {
            int isfile = [[d objectForKey:@"c_isfile"] intValue];
            int funid = [[d objectForKey:@"c_tracefunid"] intValue];
            int recordType = [[d objectForKey:@"c_record_type"] intValue];
            
            if(recordType == 10){
                if(isfile){
                    [videnceArray addObject:d];
                }
                else if (funid == 10){
                    cell.txtProcessMark.text = [d objectForKey:@"c_value"];
                }
            }
            else if(isfile){
                [videnceArray addObject:d];
            }
        }
        
        cell.array = videnceArray;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
//    return [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
}

#pragma mark - MBProgressHUD Delegate
-(void)showMsg:(NSString*)msg{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD =[[MBProgressHUD alloc] initWithView:window];
    [window addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.labelText = msg;
    [HUD show:YES];
    [HUD hide:YES afterDelay:1];
}
-(void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
    hud = nil;
}

#pragma mark - 处理隐患相关事宜
///// 本人处理
-(void)processIdeal{
[self.navigationController pushViewController:[[MeHandleViewController alloc] initWithParameters:_errDict] animated:YES];
}
///// 安排整改
-(void)processMake{
    [self.navigationController pushViewController:[[RectificationViewController alloc] initWithParameters:_errDict] animated:YES];
}
///// 继续反馈
-(void)processContinue{
[self.navigationController pushViewController:[[GoOnFeedbackViewController alloc] initWithParameters:_errDict] animated:YES];
}
@end
