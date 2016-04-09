//
//  CacheManageViewController.m
//  SecurityAssistant
//
//  Created by kevin on 16/3/21.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "CacheManageViewController.h"
#import "PNChart.h"
#include <sys/param.h>
#include <sys/mount.h>
@interface CacheManageViewController (){
    float appsize;
    float leftsize;
    float total;
    float totalPer;
    float appPer;
    float leftPer;
   
}

@end

@implementation CacheManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    total=[self getTotalDiskSize];
    appsize=[self getApplicationSize];
    
    leftsize=[self getAvailableDiskSize];
    totalPer=((total-appsize-leftsize)/total)*100 ;
    leftPer=(leftsize/total)*100;
    appPer=(appsize/total)*100;
    
    NSLog(@"%@",[NSString stringWithFormat:@"%.2fM",total]);
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNRed description:@"企安易"],
                       [PNPieChartDataItem dataItemWithValue:20 color:PNBlue description:@"可用"],
                       [PNPieChartDataItem dataItemWithValue:70 color:PNGreen description:@"其他"],
                       ];
    
   self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 100, 20.0, 200.0, 200.0) items:items];
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:12.0];
    [self.pieChart strokeChart];
    
    [self.view addSubview:self.pieChart];
    
    self.cacheMenage.text=[NSString stringWithFormat:@"可清理临时缓存文件%1.fM",[self folderSizeAtPath:NSTemporaryDirectory()]+[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];
    self.cacheTip.text=[NSString stringWithFormat:@"企易安仅占据少量的存储空间，建议清理手机中其他应用和数据"];
//    self.cacheTip.text=[NSString stringWithFormat:@"企易安仅占据%3.f%%的存储空间，建议清理手机中其他应用和数据",appPer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(float)getTotalDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return freeSpace/(1024.0*1024.0);
}


-(float)getAvailableDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    //以M为单位
    return freeSpace/(1024.0*1024.0);
}

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
//APP的占用大小，所用目录容量的和
- (float)getApplicationSize{
    // 获取沙盒主目录路径
    NSString *homeDir = NSHomeDirectory();
    // 获取Documents目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    // 获取Caches目录路径 
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [cachePaths objectAtIndex:0];
    // 获取tmp目录路径3
    NSString *tmpDir =  NSTemporaryDirectory();
    return [self folderSizeAtPath:homeDir]+[self folderSizeAtPath:docDir]+[self folderSizeAtPath:cachesDir]+[self folderSizeAtPath:tmpDir];
}
-(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件3
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    //    [[SDImageCache sharedImageCache] cleanDisk];
}
-(void)clearAllCache{
    //方法名clearDisk 才能清理不是cleanDisk
    [[SDImageCache sharedImageCache] clearDisk];
    [self clearCache:NSTemporaryDirectory()];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}


- (IBAction)ClearAplicationCache:(id)sender {
    [self clearAllCache];
    NSLog(@"...%f...%f",[self folderSizeAtPath:NSTemporaryDirectory()],[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0);
    self.cacheMenage.text=[NSString stringWithFormat:@"可清理临时缓存文件%1.fM",[self folderSizeAtPath:NSTemporaryDirectory()]+[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];
        [self.pieChart strokeChart];
    

}
@end