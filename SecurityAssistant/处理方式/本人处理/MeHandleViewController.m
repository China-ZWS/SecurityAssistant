//
//  MeHandleViewController.m
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/13.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "MeHandleViewController.h"
#import "MeHandleScrollview.h"
#import "UsersViewController.h"
#import "WaitHandledTableViewController.h"

@interface MeHandleViewController ()
@property (nonatomic) NSString *contents;
@property (nonatomic) NSArray *files;
@property (nonatomic) NSString *certifier;
@property (nonatomic) NSMutableArray *cachesForCertifierDatas;
@end

@implementation MeHandleViewController

- (instancetype)initWithParameters:(id)parameters
{
    if ((self = [super initWithParameters:parameters])) {
        [self.navigationItem setRightItemWithTarget:self title:@"提交" action:@selector(eventWithFinish) image:nil];
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
    MeHandleScrollView *mineView = [MeHandleScrollView showInView:self.view];
    
    /*
     内容
     */
    mineView.contents = ^(NSString *contents)
    {
        weakSelf.contents = contents;
        NSLog(@"endDateForHMS = %@",contents);
    };

    /*
     验收人
     */
    mineView.certifier = ^(NSString *certifier)
    {
        weakSelf.certifier = certifier;
        NSLog(@"certifier = %@",certifier);
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
     跳验收人
     */
    mineView.pushInCertifier =^(void(^contactsDatas)(id)){
        [weakSelf pushViewController:[[UsersViewController alloc] initWithParameters:[[NetDown shareTaskDataMgr] userInfo] caches:weakSelf.cachesForCertifierDatas selected:^(id datas)
                                      {
                                          contactsDatas(datas);
                                          weakSelf.cachesForCertifierDatas = datas;
                                      }]];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)eventWithFinish
{
    NSUInteger one = _contents.length;
    NSInteger two = _files.count;
    NSUInteger three = _certifier.length;
    
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *values = @[_parameters[@"errinfo"][@"c_err_id"],_parameters[@"errinfo"][@"c_cur_feedback_id"],@"1",[[NetDown shareTaskDataMgr] userInfo][@"userid"],c_tracefun_ids,uuids,_contents,_certifier,@""];
        
        BOOL success = [[NetUp shareTaskDataMgr] UpExptTask:values FileList:_files TaskType:1];
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
