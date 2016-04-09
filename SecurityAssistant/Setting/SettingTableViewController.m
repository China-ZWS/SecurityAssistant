//
//  SettingTableViewController.m
//  SecurityAssistant
//
//  Created by kevin on 16/3/2.
//  Copyright © 2016年 talkweb. All rights reserved.
//


#import "SettingTableViewController.h"
#import "SettingTableViewCell.h"
#import "HiddenDangerViewController.h"
#import "TaskViewController.h"
#import "SYQRCodeViewController.h"
#import "QRCodeOutPutViewController.h"
#import "MySettingTableViewController.h"
#import "VariableStore.h"
#import <AVFoundation/AVFoundation.h>

@interface SettingTableViewController ()
<AVCaptureMetadataOutputObjectsDelegate>
{
    NSArray *tableArray;
    NSArray *imgTableArray;
    NSString *OutPutString;
}

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    tableArray=[[NSArray alloc] initWithObjects:@"我的隐患",@"我的已办",@"扫二维码",@"设置", nil];
   imgTableArray=[[NSArray alloc] initWithObjects:@"trouble_task",@"wh_01",@"scan_icon",@"set_03", nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .1f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell"];
    cell.setTitle.text=[tableArray objectAtIndex:indexPath.row];
//     cell.headImage.image = [UIImage imageNamed:@"设置（首页-图标1）"];
    //NSString *imgString=[ objectAtIndex:indexPath.row]
     cell.headImage.image = [UIImage imageNamed:[imgTableArray objectAtIndex:indexPath.row]];
     cell.headImage.contentMode = UIViewContentModeScaleAspectFit;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [self performSegueWithIdentifier:@"SeguetoDanger"sender:self];
    }
    if(indexPath.row ==1){
        [self performSegueWithIdentifier:@"SeguetoTask"sender:self];
    }
    
    if(indexPath.row == 2){
        //扫描二维码
        [self saomiaoAction];
        
    }
    if(indexPath.row == 3){
       [self performSegueWithIdentifier:@"SeguetoMySetting" sender:self];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
#pragma mark - 扫描二维码
-(void)saomiaoAction
{
    
    SYQRCodeViewController *qrcodevc = [[SYQRCodeViewController alloc] init];
    qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){
        OutPutString = qrString;
        [self performSegueWithIdentifier:@"SeguetoQRCodeResult"sender:self];
    };
    [self presentViewController:qrcodevc animated:YES completion:nil];

}
//-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
//    if (metadataObjects.count>0) {
//        //[session stopRunning];
//        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
//        //输出扫描字符串
//        NSLog(@"%@",metadataObject.stringValue);
//    }
//}
//
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"SeguetoDanger"]){
        HiddenDangerViewController *controller =segue.destinationViewController;
        controller.hidesBottomBarWhenPushed=YES;
    }
    if([segue.identifier isEqualToString:@"SeguetoTask"]){
        TaskViewController *controller =segue.destinationViewController;
        controller.hidesBottomBarWhenPushed=YES;
    }
    
    if([segue.identifier isEqualToString:@"SeguetoQRCodeResult"]){
        QRCodeOutPutViewController *controller =segue.destinationViewController;
        controller.recipeString=OutPutString;
        controller.hidesBottomBarWhenPushed=YES;
    }
    if([segue.identifier isEqualToString:@"SeguetoMySetting"]){
        MySettingTableViewController *controller =segue.destinationViewController;
        controller.hidesBottomBarWhenPushed=YES;
    }

}


@end
