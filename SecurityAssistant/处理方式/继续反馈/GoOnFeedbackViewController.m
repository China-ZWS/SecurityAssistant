//
//  GoOnFeedbackViewController.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/14.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "GoOnFeedbackViewController.h"
#import "GoOnFeedbackScrollView.h"
#import "UsersViewController.h"
#import "WaitHandledTableViewController.h"

@interface GoOnFeedbackViewController ()
@property (nonatomic) NSString *recipient;
@property (nonatomic) NSString *cc;
@property (nonatomic) NSString *contents;
@property (nonatomic) NSArray *files;

@property (nonatomic) NSMutableArray *cachesForCCDatas;
@property (nonatomic) NSMutableArray *cachesForRecipientDatas;

@end

@implementation GoOnFeedbackViewController

- (instancetype)initWithParameters:(id)parameters
{
    if ((self = [super initWithParameters:parameters])) {
        [self.navigationItem setRightItemWithTarget:self title:@"提交" action:@selector(eventWithFinish) image:nil];
        _cc = @"";
    }
    return self;
}

- (void)back
{
    WaitHandledTableViewController *controller = self.navigationController.viewControllers[0];
    [controller setIsFresh:YES];
    [self.navigationController popToViewController:controller animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WEAKSELF
    GoOnFeedbackScrollView *mineView = [GoOnFeedbackScrollView showInView:self.view];
    
    
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
     内容
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
        NSLog(@"files = %@",files);
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
    NSUInteger one = _recipient.length;
    NSUInteger two = _contents.length;
    NSInteger three = _files.count;
    
    if (!one || !two || !three)
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

- (void)submit
{
    
    NSString *uuids  = [self uuids];
    NSString *c_tracefun_ids = [self getC_tracefun_ids];

    [SVProgressHUD showWithStatus:@"提交中"];
    
//    _parameters[@"errinfo"][@"c_err_id"],_parameters[@"errinfo"][@"c_cur_feedback_id"],@"2",
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *values = @[_parameters[@"errinfo"][@"c_err_id"],_parameters[@"errinfo"][@"c_cur_feedback_id"],@"0",[_parameters[@"feedbackinfos"]lastObject][@"c_end_time"],[[NetDown shareTaskDataMgr] userInfo][@"userid"],_recipient,_cc,c_tracefun_ids,uuids,_contents];
        
        BOOL success = [[NetUp shareTaskDataMgr] UpExptTask:values FileList:_files TaskType:3];
        
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
