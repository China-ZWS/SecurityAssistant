//
//  NoticeDetailsViewController.m
//  SecurityAssistant
//
//  Created by talkweb on 16/3/1.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "NoticeDetailsViewController.h"

@interface NoticeDetailsViewController (){
    
    __weak IBOutlet UILabel *lbTitle;
    __weak IBOutlet UILabel *lbComeFrom;
    __weak IBOutlet UILabel *lbSendTime;
//    __weak IBOutlet UILabel *lbReceiveTime;
    __weak IBOutlet UILabel *lbSender;
//    __weak IBOutlet UILabel *lbContent;
    __weak IBOutlet UITextView *txtContent;
    
}

@end

@implementation NoticeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    txtContent.layer.borderColor = [UIColor lightGrayColor].CGColor;
    txtContent.layer.borderWidth = .3f;
    txtContent.layer.masksToBounds = YES;
    txtContent.layer.cornerRadius = 5;
    
    NSDictionary *dict = [_msgDict objectForKey:@"message"];
    
    lbTitle.text = [dict objectForKey:@"c_msg_title"];
    lbComeFrom.text = [dict objectForKey:@"c_from"];
    lbSendTime.text = [_msgDict objectForKey:@"c_recieved_time"];
    lbSender.text = [dict objectForKey:@"c_sender_name"];
    txtContent.text = [dict objectForKey:@"c_msg_content"];
}
-(void)viewWillLayoutSubviews{
    txtContent.font = [UIFont systemFontOfSize:16];
    txtContent.textColor = [UIColor darkGrayColor];
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
