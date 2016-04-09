//
//  VariableStore.m
//  SecurityAssistant
//
//  Created by talkweb on 16/3/3.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "VariableStore.h"
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>


@interface VariableStore(){
    MPMoviePlayerViewController *playerViewController;
}

@end

@implementation VariableStore

+ (VariableStore *)sharedInstance
{
    static VariableStore *myInstance = nil;
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
    }
    return myInstance;
}
//16进制颜色(html颜色值)字符串转为UIColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
+(NSString *) getServerUrl{
    return [NSString stringWithFormat:@"http://%@:%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"preference_ip"],[[NSUserDefaults standardUserDefaults] stringForKey:@"preference_port"]];
}
+(UIColor*)getSystemBackgroundColor{
    return [VariableStore hexStringToColor:@"#3e92f4"];
}
+(UIColor*)getSystemTureTextColor{
    return [VariableStore hexStringToColor:@"#59beae"];
}
+(UIColor*)getSystemWarnTextColor{
    return [VariableStore hexStringToColor:@"#ef3a69"];
}

+ (UIImage*) createImageWithColor: (UIColor*) color imageSize:(CGSize)size
{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma mark - 清理缓存
-(long long)getTmpDirectorySize:(NSString*)tmpDir{
    long long dirSize=0;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:tmpDir error:&error];
    for (NSString *file in fileList ) {
        //        NSLog(@"file name is:%@",file);
        
        BOOL isDir;
        //判断是否是为目录
        NSString *selectedPath=[tmpDir stringByAppendingPathComponent:file];
        if ([fileManager fileExistsAtPath:selectedPath isDirectory:&isDir] && isDir)
        {//目录
            
            dirSize += [self getTmpDirectorySize:selectedPath];
            NSLog(@"path name is:%@ size:%f",selectedPath,dirSize/(1024.0*1024.0));
        }
        else
        {//文件
            
            dirSize+=[self getFileSizeAtPath:selectedPath];
            NSLog(@"file name is:%@ size:%f",selectedPath,dirSize/(1024.0*1024.0));
        }
    }
    return dirSize;
    
}
-(long long)getFileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
#pragma mark - 图片缓存
- (BOOL)saveImage:(UIImage *)image withScale:(CGFloat)scale savePath:(NSString**)path;
{
    NSData *imageData = UIImageJPEGRepresentation(image, scale);
    NSString * filesPath = [self getDocumentDirectory];
    filesPath = [filesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[self getUniqueStrByUUID]]];
    *path = [filesPath copy];
    return [imageData writeToFile:filesPath atomically:YES];
}

- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString ;
}
-(NSString *)getDocumentDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    return [paths firstObject];
}
#pragma mark - 待办缓存数据
-(NSMutableDictionary*)getWaitHandledData:(NSDictionary*)sender{
    NSString *taskId = [[sender objectForKey:@"task"] objectForKey:@"c_task_id"];
    NSMutableDictionary *storeDict = [self getWaitHandledData];
    NSMutableDictionary *dict = [storeDict objectForKey:taskId];
    if(!dict){
        dict = [[NSMutableDictionary alloc] initWithDictionary:sender copyItems:YES];
        NSMutableDictionary *taskDict = [[NSMutableDictionary alloc] initWithDictionary:[sender objectForKey:@"task"] copyItems:YES];
        //下午任务中，这些数组可能有空对象，造成不能写文件，需要删除 c_actnode_media c_scan_code c_templet_media
        
        NSMutableArray *scanCodeArray = [[NSMutableArray alloc] initWithArray:[taskDict objectForKey:@"c_scan_code"] copyItems:YES];
        for (NSObject *obj in scanCodeArray) {
            if(!obj || (NSNull*)obj == [NSNull null]){
                [scanCodeArray removeObject:obj];
            }
        }
        [taskDict setValue:scanCodeArray forKey:@"c_scan_code"];
        
        NSMutableArray *actionMediaArray = [[NSMutableArray alloc] initWithArray:[taskDict objectForKey:@"c_actnode_media"] copyItems:YES];
        for (NSObject *obj in actionMediaArray) {
            if(!obj || (NSNull*)obj == [NSNull null]){
                [actionMediaArray removeObject:obj];
            }
        }
        [taskDict setValue:actionMediaArray forKey:@"c_scan_code"];
        
        NSMutableArray *templetMediaArray = [[NSMutableArray alloc] initWithArray:[taskDict objectForKey:@"c_templet_media"] copyItems:YES];
        for (NSObject *obj in templetMediaArray) {
            if(!obj || (NSNull*)obj == [NSNull null]){
                [templetMediaArray removeObject:obj];
            }
        }
        [taskDict setValue:templetMediaArray forKey:@"c_scan_code"];
        
        [dict setValue:taskDict forKey:@"task"];
        
        NSMutableArray *stepArray = [[NSMutableArray alloc] initWithArray:[sender objectForKey:@"step"] copyItems:YES];
        
        for(int i = 0; i < [stepArray count]; i ++ ){
            NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithDictionary:[stepArray objectAtIndex:i] copyItems:YES];
            [stepArray replaceObjectAtIndex:i withObject:d];
        }
        [dict setValue:stepArray forKey:@"step"];
        
        //保存
        [storeDict setValue:dict forKey:taskId];
        [self setWaitHandledData:storeDict];
    }
    return dict;
}
-(BOOL)setWaitHandledWithSourceData:(NSMutableDictionary*)dict withHandledStatus:(BOOL)statues{
    //保存数据，即状态变为进行中
    if(statues)
        [dict setValue:[NSNumber numberWithBool:YES] forKey:@"status"];
    NSString *taskId = [[dict objectForKey:@"task"] objectForKey:@"c_task_id"];
    NSMutableDictionary *storeDict = [self getWaitHandledData];
    //保存
    [storeDict setValue:dict forKey:taskId];
    return [self setWaitHandledData:storeDict];
}

-(BOOL)setWaitHandledData:(NSMutableDictionary*)dict{
    NSString *path = [self getDocumentDirectory];
    path = [path stringByAppendingPathComponent:@"WaitHandled.plist"];
    BOOL b = [dict writeToFile:path atomically:YES];
    return b;
}
-(NSMutableDictionary*)getWaitHandledData{
    NSString *path = [self getDocumentDirectory];
    path = [path stringByAppendingPathComponent:@"WaitHandled.plist"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL ff= [fileManager fileExistsAtPath:path];
    if(!ff)
        return [NSMutableDictionary new];
    return [NSMutableDictionary dictionaryWithContentsOfFile:path];
}
-(BOOL)deleteWaitHandledData{
    NSString *path = [self getDocumentDirectory];
    path = [path stringByAppendingPathComponent:@"WaitHandled.plist"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path])
        return [fileManager removeItemAtPath:path error:nil];
    return YES;
}

#pragma mark - 媒体播放

-(void)playMedia:(NSURL*)url{
    playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:[playerViewController moviePlayer]];
    //-- add to view---
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:playerViewController.view];
    
    //---play movie---
    MPMoviePlayerController *player = [playerViewController moviePlayer];
    [player play];
    
}

- (void) movieFinishedCallback:(NSNotification*) aNotification {
    MPMoviePlayerController *player = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [player stop];
    [playerViewController.view removeFromSuperview];
    playerViewController = nil;
}

#pragma mark - 显示大图

-(void)showImageView:(UIImageView*)imageview fromUrl:(NSURL*)url{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    oldframe=[imageview convertRect:imageview.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed: @"no_img"] options:SDWebImageProgressiveDownload];
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    [UIView
     animateWithDuration:0.3
     animations:^{
         imageView.frame=CGRectMake(0,([UIScreen
                                        mainScreen].bounds.size.height-imageView.image.size.height*[UIScreen mainScreen].bounds.size.width/imageView.image.size.width)/2,
                                    [UIScreen mainScreen].bounds.size.width, imageView.image.size.height*[UIScreen mainScreen].bounds.size.width/imageView.image.size.width);
         
         backgroundView.alpha=1;
     }
     completion:^(BOOL finished) {
     }];
}
static CGRect oldframe;

-(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView
     animateWithDuration:0.3
     animations:^{
         imageView.frame=oldframe;
         backgroundView.alpha=0;
     }
     completion:^(BOOL finished) {
         [backgroundView removeFromSuperview];
     }];
    backgroundView = nil;
}

+(NSString*)getFormaterDateString:(NSString*)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateString];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"MM月dd日 HH:mm"];
    return [formatter1 stringFromDate:date];
}
//阿拉伯数字转化为汉语数字
//**阿拉伯数字转化为汉语数字**
+(NSString *)translation:(NSString *)arebic

{   NSString *str = arebic;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]])
        {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
            {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            }else
            {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum])
            {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    
    NSString *sumStr = [sums  componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    NSLog(@"%@",str);
    NSLog(@"%@",chinese);
    return chinese;
}
@end
