//
//  MySettingTableViewController.m
//  SecurityAssistant
//
//  Created by kevin on 16/3/4.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "MySettingTableViewController.h"
#import "MySettingTableViewCell.h"
#import "LoginViewController.h"


@interface MySettingTableViewController ()<UIActionSheetDelegate>{
    NSArray *tableArray;
    NSArray *imgTableArray;
}

@end

@implementation MySettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tableArray=[[NSArray alloc] initWithObjects:@"个人信息",@"缓存管理",@"退出", nil];
    imgTableArray=[[NSArray alloc] initWithObjects:@"tabbar_03_selected",@"set_07",@"set_06", nil];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MySettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MySettingTableViewCell"];
    cell.title.text=[tableArray objectAtIndex:indexPath.row];

    cell.img.image = [UIImage imageNamed:[imgTableArray objectAtIndex:indexPath.row]];
     cell.img.contentMode = UIViewContentModeScaleAspectFit;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [self performSegueWithIdentifier:@"SeguetoCounterInfo"sender:self];
    }
//    if(indexPath.row ==1){
//        [self performSegueWithIdentifier:@"SeguetoTask"sender:self];
//    }
//    
    if(indexPath.row == 1){
               //清理缓存
        [self performSegueWithIdentifier:@"SeguetoCache"sender:self];
    }
    if(indexPath.row == 2){
        UIAlertView *counterAlertView=[[UIAlertView alloc] initWithTitle:@"警告" message:@"您确定要登出此账户吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [counterAlertView show];
       // alertView.tag=1;
    //[self performSegueWithIdentifier:@"SeguetoMySetting" sender:self];
//        for (UIViewController *temp in self.navigationController.viewControllers) {
//            if ([temp isKindOfClass:[LoginViewController class]]) {
//                [self.navigationController popToViewController:temp animated:YES];
//            }
//        }

    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        
    }
    else if(buttonIndex == 1){
        UIStoryboard *mainStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *mainViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        [self presentViewController:mainViewController animated:YES completion:nil];
    }
}
////单个文件的大小
//+(float)fileSizeAtPath:(NSString *)path{
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    if([fileManager fileExistsAtPath:path]){
//        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
//        return size/1024.0/1024.0;
//    }
//    return 0;
//}
////遍历文件夹获得文件夹大小，返回多少M
//+(float)folderSizeAtPath:(NSString *)path{
//    NSFileManager *fileManager=[NSFileManager defaultManager];
//    float folderSize;
//    if ([fileManager fileExistsAtPath:path]) {
//        NSArray *childerFiles=[fileManager subpathsAtPath:path];
//        for (NSString *fileName in childerFiles) {
//            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
//            folderSize +=[self fileSizeAtPath:absolutePath];
//        }
//        //SDWebImage框架自身计算缓存的实现
//        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
//        return folderSize;
//    }
//    return 0;
//}
//
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
