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

@interface MeHandleViewController ()
@property (nonatomic) NSString *contents;
@property (nonatomic) NSArray *files;
@property (nonatomic) NSString *certifier;
@property (nonatomic) NSString *appraiser;
@property (nonatomic) NSMutableArray *cachesForCertifierDatas;
@property (nonatomic) NSMutableArray *cachesForAppraiserDatas;
@end

@implementation MeHandleViewController

- (instancetype)init
{
    if ((self = [super init])) {
        [self.navigationItem setRightItemWithTarget:self title:@"提交" action:@selector(eventWithFinish) image:nil];
    }
    return self;
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
     评价人
     */
    mineView.appraiser = ^(NSString *appraiser)
    {
        weakSelf.appraiser = appraiser;
        NSLog(@"appraiser = %@",appraiser);
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
    mineView.pushInCertifier =^(void(^contactsDatas)(id)){
        [weakSelf pushViewController:[[UsersViewController alloc] initWithParameters:[[NetDown shareTaskDataMgr] userInfo] caches:weakSelf.cachesForCertifierDatas selected:^(id datas)
                                      {
                                          contactsDatas(datas);
                                          weakSelf.cachesForCertifierDatas = datas;
                                      }]];
    };
    
    /*
     跳抄送人
     */
    mineView.pushInAppraiser =^(void(^contactsDatas)(id)){
        [weakSelf pushViewController:[[UsersViewController alloc] initWithParameters:[[NetDown shareTaskDataMgr] userInfo] caches:weakSelf.cachesForAppraiserDatas selected:^(id datas)
                                      {
                                          contactsDatas(datas);
                                          weakSelf.cachesForAppraiserDatas = datas;
                                      }]];
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)eventWithFinish
{

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
