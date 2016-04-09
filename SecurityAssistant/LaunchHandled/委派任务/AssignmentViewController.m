//
//  AssignmentViewController.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/1.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "AssignmentViewController.h"
#import "AssignmentScrollView.h"
#import "UsersViewController.h"

@interface AssignmentViewController ()
@property (nonatomic) NSString *assignmentName;
@property (nonatomic) NSString *recipient;
@property (nonatomic) NSString *cc;
@property (nonatomic) NSString *startDate;
@property (nonatomic) NSString *endDate;
@property (nonatomic) NSString *contents;
@property (nonatomic) NSArray *files;
@property (nonatomic) NSMutableArray *cachesForCCDatas;
@property (nonatomic) NSMutableArray *cachesForRecipientDatas;


@end

@implementation AssignmentViewController

- (instancetype)init
{
    if ((self = [super init])) {
        [self.navigationItem setRightItemWithTarget:self title:@"提交" action:@selector(eventWithFinish) image:nil];
        self.title = @"发起新的任务";
        _cc = @"";
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

    AssignmentScrollView *mineView = [AssignmentScrollView showInView:self.view];
    /*
     任务名称
     */
    mineView.assignmentName = ^(NSString *assignmentName)
    {
        weakSelf.assignmentName = assignmentName;
        NSLog(@"safeAssignmentName = %@",assignmentName);
        
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
     开始时间
     */
    mineView.startDate = ^(NSString *startDate)
    {
        weakSelf.startDate = startDate;
        NSLog(@"startDate = %@",startDate);
    };
    
    /*
     结束时间
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
     取证
     */
    mineView.files = ^(NSArray *files)
    {
        weakSelf.files = files;
        NSLog(@"safeFiles = %@",files);
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

    
    // Do any additional setup after loading the view.
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)eventWithFinish
{
    NSUInteger one = _assignmentName.length;
    NSUInteger two = _recipient.length;
    NSUInteger three = _startDate.length;
    NSUInteger four = _endDate.length;
    NSInteger five = _files.count;
    
    
    if (!one || !two || !three || !four || !five)
    {
        [SVProgressHUD showInfoWithStatus:@"请完善所填信息"];
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

- (void)submit
{
    [SVProgressHUD showWithStatus:@"提交中"];
    NSString *uuids  = [self uuids];

    DLog(@"%@,,,,%@",_startDate,_endDate);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *values = @[@"20",_assignmentName,@"1",_startDate,_endDate,_recipient,[[NetDown shareTaskDataMgr] userInfo][@"userid"],_contents,_cc,uuids];
        
        BOOL success = [[NetUp shareTaskDataMgr] LaunchTask:values FileList:_files];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (success)
            {
                [self.view.window makeToast:@"提交成功"];
                [self back];
            }
            else
            {
                
            }
        });
    });
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
