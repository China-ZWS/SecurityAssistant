//
//  HiddenDangerViewController.m
//  SecurityAssistant
//
//  Created by kevin on 16/3/2.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "HiddenDangerViewController.h"
#import "HIddenDangerTableViewCell.h"
#import "NetDown.h"
#import "DetailTaskWebViewController.h"

@interface HiddenDangerViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableDictionary *dataDic;
     NSArray *dataArray;
    NSString *passString;
}

@end

@implementation HiddenDangerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dangerTableView.delegate=self;
    self.dangerTableView.dataSource=self;
    
    self.dangerSegment.selectedSegmentIndex=0;
    self.dangerSegment.tintColor = [VariableStore getSystemBackgroundColor];
  //  dataDic= [NSMutableDictionary initWithCapacity:10];
     [[NetDown shareTaskDataMgr] getFBTrackInfo:1];
    dataArray=[[NetDown shareTaskDataMgr] fbTrackArray];
    // Do any additional setup after loading the view.
    self.dangerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"HIddenDangerTableViewCell";
    HIddenDangerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HIddenDangerTableViewCell" owner:nil options:nil]lastObject];
    }

    NSDictionary *dict=[dataArray objectAtIndex:indexPath.row];
    // Configure the cell...
    
//    HIddenDangerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HIddenDangerTableViewCell"];
//    cell.numberTitle.layer.borderWidth  =0.2f;
// cell.numberTitle.layer.borderColor  = [VariableStore getSystemBackgroundColor].CGColor;
    cell.numberTitle.backgroundColor = [VariableStore getSystemBackgroundColor];
    cell.numberTitle.layer.masksToBounds = YES;
    cell.numberTitle.clipsToBounds = YES;
    //cell.numberTitle.layer.cornerRadius = 5.0f;
    cell.numberTitle.layer.cornerRadius = 15.0f;;
    cell.numberTitle.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    cell.detailTitle.text=[dict objectForKey:@"c_err_name"];//c_err_name 异常名称
    cell.nameTitle.text=[dict objectForKey:@"c_writer_name"];//c_writer_name反馈人姓名
    NSString *timeString = [dict objectForKey:@"c_upload_time"];//c_upload_time上传时间
    cell.timeTitle.text= [timeString substringWithRange:NSMakeRange(5, 11)];
    cell.safeTitle.text=[dict objectForKey:@"c_manage_section_name"];//c_manage_section_name管理板块名称
    NSString *iscloseString;
    if ([[dict objectForKey:@"c_isclose"] isEqualToString:@"0"]) {
        iscloseString=@"未完成";
        cell.statusTitle.textColor=[UIColor redColor];
    } else {
         iscloseString=@"完成";
         cell.statusTitle.textColor=[VariableStore getSystemBackgroundColor];
    }
    cell.statusTitle.text=iscloseString;//c_isclose 是否处理 0 未完成 1 完成
    
//    cell.itemName.text = [tableArray objectAtIndex:indexPath.row];
//    NSString *imageName=[NSString stringWithFormat:@"设置（首页-图标%d）",indexPath.row+1];
//    cell.itemImage.image = [UIImage imageNamed:imageName];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//设置cell点击效果
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 取消选中状态
  // [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if(indexPath.row == 0){
    passString=[[dataArray objectAtIndex:indexPath.row]objectForKey:@"c_err_id"];
       [self performSegueWithIdentifier:@"SeguetoDetailDanger"sender:self];
//    }
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SeguetoDetailDanger"]){
        DetailTaskWebViewController *controller =segue.destinationViewController;
        controller.recpString=passString;
      // controller.hidesBottomBarWhenPushed=YES;
    }

    
    }

 
- (IBAction)HiddenDanger:(id)sender {
    NSInteger selectedIndex= self.dangerSegment.selectedSegmentIndex;
   NSLog(@"Segment %ldselected\n", (long)selectedIndex);
    
    if (selectedIndex==0) {
        [[NetDown shareTaskDataMgr] getFBTrackInfo:1];//获取我反馈
    }
    if (selectedIndex==1) {
         [[NetDown shareTaskDataMgr] getFBTrackInfo:2];//获取我处理
    }
    if (selectedIndex==2) {
         [[NetDown shareTaskDataMgr] getFBTrackInfo:3];//获取我抄送
    }
    [self reloadData];
}
-(void)reloadData{
    //[dataArray init];
  dataArray=[[NetDown shareTaskDataMgr] fbTrackArray];
    [self.dangerTableView reloadData];
}
@end
