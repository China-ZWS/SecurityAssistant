//
//  CacheManagerTableViewController.m
//  SecurityAssistant
//
//  Created by kevin on 16/3/16.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "CacheManagerTableViewController.h"
#import "VariableStore.h"

@interface CacheManagerTableViewController ()<UIActionSheetDelegate>{
    NSArray *tableArray;
    float videosize;
    float picsize;
    float total;
}

@end

@implementation CacheManagerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     tableArray=[[NSArray alloc] initWithObjects:@"清空图片缓存",@"清空视频和录音缓存",@"清空所有缓存", nil];
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
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cachemanager" forIndexPath:indexPath];
    cell.textLabel.text=[tableArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor=[VariableStore getSystemBackgroundColor];
    //displayname posiname orgname
    
    if (indexPath.row==0) {
        //获取tmp目录文件大小，主要是录音和视频
        
 picsize=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2fM",picsize];
    }
    if (indexPath.row==1) {
        //获取图片缓存，在SDWebImage框架自身计算缓存的实现
       videosize=[self folderSizeAtPath:NSTemporaryDirectory()];
       cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2fM",videosize];
    }
    if (indexPath.row==2) {
        //总大小
        total=[self folderSizeAtPath:NSTemporaryDirectory()]+[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;

        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2fM",total];
    }
    
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"确定要删除图片缓存数据" delegate:self cancelButtonTitle:@"取 消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        actionSheet.tag=11;
        [actionSheet showInView:self.view];
    }
    if(indexPath.row == 1){
        
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"确定要删除录音和视频数据" delegate:self cancelButtonTitle:@"取 消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        actionSheet.tag=22;
        [actionSheet showInView:self.view];

    }
    if(indexPath.row == 2){
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"确定要删除所有缓存数据" delegate:self cancelButtonTitle:@"取 消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        actionSheet.tag=33;
        [actionSheet showInView:self.view];
        
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==11) {
        if(buttonIndex == 0 ){
            [self clearPictuerCache];
        }

    }
    if (actionSheet.tag==22) {
        if(buttonIndex == 0 ){
            [self clearAudioCache];
        }
    }
    if (actionSheet.tag==33) {
        if(buttonIndex == 0 ){
            [self clearAllCache];
        }
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
//通常用于删除缓存的时，计算缓存大小

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
-(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
//    [[SDImageCache sharedImageCache] cleanDisk];
}
-(void)clearPictuerCache{
    [[SDImageCache sharedImageCache] clearDisk];
    [self.tableView reloadData];
}
-(void)clearAudioCache{
     [self clearCache:NSTemporaryDirectory()];
    [self.tableView reloadData];
}
-(void)clearAllCache{
    [[SDImageCache sharedImageCache] clearDisk];
    [self clearCache:NSTemporaryDirectory()];
    [self.tableView reloadData];

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
