//
//  SafetyViewController.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/1.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "SafetyViewController.h"
#import "SafetyScrollView.h"
#import "UsersViewController.h"
#import "SYQRCodeViewController.h"
#import "WaitHandledTableViewController.h"
#import "WaitHandledDailyTaskDetailsTableViewController.h"
@interface SafetyViewController ()
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *recipient;
@property (nonatomic) NSString *cc;
@property (nonatomic) NSDictionary *hazardSourcesme;
@property (nonatomic) NSString *occurDate;
@property (nonatomic) NSString *processingDate;
@property (nonatomic) NSString *code;
@property (nonatomic) NSString *contents;
@property (nonatomic) NSArray *files;
@property (nonatomic) NSMutableArray *cachesForCCDatas;
@property (nonatomic) NSMutableArray *cachesForRecipientDatas;


@end


@implementation SafetyViewController

- (instancetype)init{
    if ((self = [super init])) {
        self.title = @"安全隐患发起";
        [self.navigationItem setRightItemWithTarget:self title:@"提交" action:@selector(eventWithFinish) image:nil];
        _cc = @"";
        _hazardSourcesme = @{@"area":@""};
        _code = @"";
    }
    return self;
}

- (void)back
{
    UIViewController *controller = self.navigationController.viewControllers[0];
    if ([controller isKindOfClass:[WaitHandledTableViewController class]]) {
        WaitHandledTableViewController *waitHandled = (WaitHandledTableViewController *)controller;
        [waitHandled setIsFresh:YES];
    }
    [self popViewController];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    SafetyScrollView *mineView = [SafetyScrollView showInView:self.view];
    mineView.datas = _parameters;
    
    WEAKSELF
    /*
     主题名称
     */
    mineView.name = ^(NSString *name)
    {
        weakSelf.name = name;
        NSLog(@"name = %@",name);
    };
    
    /*
     安全隐患
     */
    mineView.hazardSourcesme = ^(NSDictionary *dic)
    {
        weakSelf.hazardSourcesme = dic;
        NSLog(@"hazardSourcesme = %@",dic);
    };

    /*
     发生时间年月日
     */
    mineView.occurDate = ^(NSString *occurDate)
    {
        weakSelf.occurDate = occurDate;
        NSLog(@"occurDate = %@",occurDate);
    };
    
    /*
    /*
     二维码结果
     */
    mineView.code = ^(void(^scanCodeBlock)(NSString *))
    {
        SYQRCodeViewController *qrcodevc = [[SYQRCodeViewController alloc] init];
        qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){
            
            scanCodeBlock(qrString);
        };
        [weakSelf presentViewController:qrcodevc];
    };
    mineView.resultCode = ^(NSString *resultCode)
    {
        NSLog(@"11 %@",resultCode);
        weakSelf.code = resultCode;
    };
    /*
     反馈内容
     */
    mineView.contents = ^(NSString *contents)
    {
        weakSelf.contents = contents;
        NSLog(@"contents = %@",contents);
    };

    /*
     取证
     */
    mineView.files = ^(NSArray *files)
    {
        weakSelf.files = files;
        NSLog(@"safeFiles = %@",files);
    };

    
    /*
     接送人
     */
    mineView.recipient = ^(NSString *recipient)
    {
        weakSelf.recipient = recipient;
        NSLog(@"recipient = %@",recipient);
    };
    
    /*
     抄送人
     */
    mineView.cc = ^(NSString *cc)
    {
        weakSelf.cc = cc;
        NSLog(@"cc = %@",cc);
    };

    
    /*
     发生时间
     */
    mineView.processingDate = ^(NSString *processingDate)
    {
        weakSelf.processingDate = processingDate;
        NSLog(@"processingDate = %@",processingDate);
    };
    
    
    /*
     跳接收人
     */
    mineView.pushInRecipient =^(void(^contactsDatas)(id)){
        [weakSelf pushViewController:[[UsersViewController alloc] initWithParameters:[[NetDown shareTaskDataMgr] userInfo] caches:weakSelf.cachesForRecipientDatas selected:^(id datas)
                                      {
                                          contactsDatas(datas);
                                          weakSelf.cachesForRecipientDatas = datas;
                                      }]];
    };
    
    /*
     跳抄送人
     */
    mineView.pushInCC =^(void(^contactsDatas)(id)){
        [weakSelf pushViewController:[[UsersViewController alloc] initWithParameters:[[NetDown shareTaskDataMgr] userInfo] caches:weakSelf.cachesForCCDatas selected:^(id datas)
                                      {
                                          contactsDatas(datas);
                                          weakSelf.cachesForCCDatas = datas;
                                      }]];
    };
}


- (void)eventWithFinish
{
    NSUInteger one = _name.length;
    NSUInteger two = _occurDate.length;
    NSUInteger three = _contents.length;
    NSInteger four = _files.count;
    NSUInteger five = _recipient.length;
    NSUInteger six = _processingDate.length;

    if (!one || !two || !three || !four || !five || !six)
    {
        [self.view.window makeToast:@"请完善所填信息"];
        return;
    }
    
    WEAKSELF
    [self showAlertView:^(NSInteger index)
     {
         [weakSelf submit];
     }title:@"确认提交" message:nil];
    

}

- (NSString *)uuids
{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in _files)
    {
        [arr addObject:dic[@"uuid"]];
    }
    return [arr componentsJoinedByString:@","];
}

- (NSString *)getC_tracefun_ids
{
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSDictionary *dic in _files)
    {
        if ([dic[@"type"] isEqualToString:@"image"]) {
            [arr addObject:@"1"];
        }
        else if ([dic[@"type"] isEqualToString:@"audio"] )
        {
            [arr addObject:@"2"];
        }
        else if ([dic[@"type"] isEqualToString:@"video"])
        {
            [arr addObject:@"3"];
        }
        else
        {
            [arr addObject:@"4"];
        }
    }
    return [arr componentsJoinedByString:@","];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submit
{
    
    NSString *uuids  = [self uuids];
    
    NSString *c_tracefun_ids = [self getC_tracefun_ids];

    [SVProgressHUD showWithStatus:@"提交中"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *date = [[formatter stringFromDate:[NSDate new]] stringByAppendingString:@":00"];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *values = @[@"2",//1.异常类型->c_err_kind
                            @"",//2.任务id(任务类型要传)->c_task_id
                            _name,//3.主题->c_err_name
                            @"0",//4.异常类型->c_err_type
                            @"1",//5.异常等级->c_err_level
                            @"1",//6.管理板块->c_manage_section
                            @"0",//7.活动节点 ID->c_actnode_id
                            _occurDate,//8.发生时间->c_occur_time
                            date,//9发起时间->c_report_time
                            _processingDate,//10.完成节点时间->c_end_time
                            @"0",//11.是否自己完成->c_isbyself
                            @"0",//12.处理方式选项->c_deal_type
                            [[NetDown shareTaskDataMgr] userInfo][@"userid"],//13.发起人->c_from_user_id
                            _recipient,//14,接收人->c_to_user_id
                            _cc,//15,抄送人->c_cc_user_ids
                            _contents,//16,报告信息->c_report_des
                            c_tracefun_ids, //17,记录方式id->c_tracefun_ids
                            uuids,//18,文件 ID 集合->c_file_ids
                            @"",//19,处置信息->c_handle_des
                            @"",//20,记录方式 ID->c_handle_tracefun_ids
                            @"",//21,文件 ID 集合->c_handle_file_ids
                            @"",//22,c_chk_person
                            @"",//23.c_eva_person
                            @"",//24.c_object_list
                            _hazardSourcesme[@"area"]//25
                            ];
        
        BOOL success = [[NetUp shareTaskDataMgr] LauchExptTask:values FileList:_files];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (success)
            {
                [self.view.window makeToast:@"提交成功"];
                
                UIViewController *controller = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
                if ([controller isKindOfClass:[WaitHandledDailyTaskDetailsTableViewController class]]) {
                    WaitHandledDailyTaskDetailsTableViewController *waitHandled = (WaitHandledDailyTaskDetailsTableViewController *)controller;
                    [waitHandled setIsSubmitErrorLaunch:YES];
                }
//
//                [self hasClass];
                [self back];
            }
            else
            {
                [self.view.window makeToast:@"提交失败"];
            }
        });
    });

}

- (void)hasClass
{
    for (UIViewController* next = self; next; next =
         next.parentViewController)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[WaitHandledDailyTaskDetailsTableViewController
                                          class]])
        {
            WaitHandledDailyTaskDetailsTableViewController *ctr = (WaitHandledDailyTaskDetailsTableViewController *)nextResponder;
            [ctr setIsSubmitErrorLaunch:YES];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
