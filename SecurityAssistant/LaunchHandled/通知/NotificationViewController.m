//
//  NotificationViewController.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/1.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotiScrollView.h"
#import "UsersViewController.h"

//#define Parameter() []

@interface NotificationViewController ()
@property (nonatomic) NSString *notiName;
@property (nonatomic) NSString *recipient;
@property (nonatomic) NSString *endDate;
@property (nonatomic) NSString *contents;
@property (nonatomic) NSMutableArray *caches;
@end

@implementation NotificationViewController

- (instancetype)init{
    
    if ((self = [super init])) {
        self.title = @"消息编辑";
        [self.navigationItem setRightItemWithTarget:self title:@"提交" action:@selector(eventWithFinish) image:nil];
    }
    return self;
}

- (void)back
{
    [self popViewController];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

   WEAKSELF
    NotiScrollView *mineView = [NotiScrollView showInView:self.view];
    /*
     任务名称
     */
    mineView.notiName = ^(NSString *notiName)
    {
        weakSelf.notiName = notiName;
        NSLog(@"notiName = %@",notiName);
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
     结束时间年月日
     */
    mineView.endDate = ^(NSString *endDate)
    {
        weakSelf.endDate = endDate;
        NSLog(@"endDate = %@",endDate);
    };
    

    /*
     内容
     */
    mineView.contents = ^(NSString *contents)
    {
        weakSelf.contents = contents;
        NSLog(@"endDateForHMS = %@",contents);
    };

    /*
     跳联系人
     */
    mineView.pushInContacts =^(void(^contactsDatas)(id)){
        [weakSelf pushViewController:[[UsersViewController alloc] initWithParameters:[[NetDown shareTaskDataMgr] userInfo] caches:weakSelf.caches selected:^(id datas)
                                      {
                                          [weakSelf contactsDatasBlock:contactsDatas selectedWithDatas:datas];
                                      }]];
    };
    
    
    // Do any additional setup after loading the view.
}

- (void)contactsDatasBlock:(void(^)(id))contactsDatasBlock selectedWithDatas:(id)datas
{
    contactsDatasBlock(datas);
    _caches = datas;
}



- (void)eventWithFinish
{

    NSUInteger one = _notiName.length;
    NSUInteger two = _contents.length;
    NSUInteger three = _endDate.length;
    NSUInteger four = _recipient.length;
    
    if (!one || !two || !three || !four) {
        [self.view makeToast:@"请完善所填信息"];
        return;
    }
    
    WEAKSELF
    [self showAlertView:^(NSInteger index)
     {
         [weakSelf submit];
     }title:@"确认提交" message:nil];

}

- (void)submit
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *date = [formatter stringFromDate:[NSDate new]] ;
    [SVProgressHUD showWithStatus:@"提交中"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *values = @[_notiName,
                            _contents,
                            @"31",
                            @"1",
                            @"1",
                            @"工作提示",
                            date,
                            date,
                            _endDate,
                            @"-1",
                            [[NetDown shareTaskDataMgr] userInfo][@"userid"],
                            _recipient,
                            @"",
                            @"0"
                            ];
        
        BOOL success = [[NetUp shareTaskDataMgr] LaunchMsg:values];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (success)
            {
                [self.view.window makeToast:@"提交成功"];
                [self back];
            }
            else
            {
                [self.view.window makeToast:@"提交失败"];
            }
        });
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
