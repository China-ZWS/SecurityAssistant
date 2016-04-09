//
//  BasePhotoPickerManager.m
//  GrowingSupermarket
//
//  Created by 周文松 on 15-7-8.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import "BasePhotoPickerManager.h"
#import "UIImagePickerController+Photo.h"


@interface BasePhotoPickerManager ()
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate>
{
    void (^_eventWithOtherBlock)(NSString *);
}
@property (nonatomic, weak)     UIViewController          *fromController;
@property (nonatomic, copy)     PickerCompelitionBlock completion;
@property (nonatomic, copy)     PickerCancelBlock      cancelBlock;
@property (nonatomic, copy)     PickerOtherBlock otherBlock;


@end
@implementation BasePhotoPickerManager

- (void)dealloc
{
    
}

+ (BasePhotoPickerManager *)shared {
    static BasePhotoPickerManager *sharedObject = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!sharedObject) {
            sharedObject = [[[self class] alloc] init];
        }
    });
    
    return sharedObject;
}


- (void)showActionSheetInView:(UIView *)inView fromController:(UIViewController *)fromController completion:(PickerCompelitionBlock)completion otherBlock:(PickerOtherBlock)otherBlock cancelBlock:(PickerCancelBlock)cancelBlock;
{
    self.completion = completion;
    self.cancelBlock = cancelBlock;
    self.otherBlock = otherBlock;
    self.fromController = fromController;
    
    UIActionSheet *actionSheet = nil;
    if ([UIImagePickerController isCameraAvailable])
    {
        actionSheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:(id<UIActionSheetDelegate>)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"图库", @"拍照", @"语音", @"视频", nil];
    }
    
    [actionSheet showInView:inView];
    
    return;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    { // 从相册选择
        if ([UIImagePickerController isPhotoLibraryAvailable]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.mediaTypes = @[( NSString *)kUTTypeImage];
            [self.fromController presentViewController:picker animated:YES completion:nil];
        }
    }
    else if (buttonIndex == 1)
    { // 拍照
        if ([UIImagePickerController doesCameraSupportTakingPhotos]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = @[( NSString *)kUTTypeImage ];
            [self.fromController presentViewController:picker animated:YES completion:nil];
        }
    }
    else if (buttonIndex == 2)
    {
        __weak BasePhotoPickerManager *safeSelf = self;
        _eventWithOtherBlock = ^(NSString *path)
        {
            if (path && safeSelf.completion) {
                
                NSString *uuid = [safeSelf getUUID];
//                path = [path substringFromIndex:[@"/private" length]];

                dispatch_async(dispatch_get_main_queue(), ^{
                    safeSelf.completion(@{@"type":@"audio",@"file":path,@"path":path,@"uuid":uuid});
                });
            }
            
        };
        _otherBlock(_eventWithOtherBlock);
    }
    else if (buttonIndex == 3)
    {
        if ([UIImagePickerController doesCameraSupportShootingVideos]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = @[( NSString *)kUTTypeMovie];
            [self.fromController presentViewController:picker animated:YES completion:nil];
        }
    }
    return;
}

#pragma mark - UIImagePickerControllerDelegate
// 选择了图片或者拍照了
- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        if (image && self.completion) {
            
            NSString *imagePath = [self saveImage:image];
            NSString *uuid = [self getUUID];
            self.completion(@{@"type":@"image",@"file":image,@"path":imagePath,@"uuid":uuid});
        }
        
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        // 判断获取类型：视频
        //获取视频文件的url
        NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        if (mediaURL && self.completion) {
            NSString *uuid = [self getUUID];
            NSString *path = [[mediaURL absoluteString] substringFromIndex:[@"file://" length]];
            self.completion(@{@"type":@"video",@"file":mediaURL,@"path":path,@"uuid":uuid});
        }
    }
    return;
}

// 取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)aPicker {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.cancelBlock) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.fromController setNeedsStatusBarAppearanceUpdate];
        
        self.cancelBlock();
    }
    return;
}

- (NSString *)saveVideo:(NSURL *)mediaURL
{
    NSData *videoData = [NSData dataWithContentsOfURL:mediaURL];
    NSString * filesPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/files"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY:MM:dd HH:mm:ss:SSS"];
    NSString *dateSting = [formatter stringFromDate:[NSDate date]];
    NSString *imgPath = [filesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",dateSting]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSError *error;
        
        if (![fileManager fileExistsAtPath:filesPath]) {
            [fileManager createDirectoryAtPath:filesPath withIntermediateDirectories:YES attributes:nil error:&error];
        }
        
        
        [videoData writeToFile:imgPath atomically:YES];
    });
    return imgPath;
    
}


- (NSString *)saveImage:(UIImage *)image;
{
    
    NSString * filesPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/files"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY:MM:dd HH:mm:ss:SSS"];
    NSString *dateSting = [formatter stringFromDate:[NSDate date]];
    NSString *imgPath = [filesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",dateSting]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSError *error;
        
        if (![fileManager fileExistsAtPath:filesPath]) {
            [fileManager createDirectoryAtPath:filesPath withIntermediateDirectories:YES attributes:nil error:&error];
        }
        
        
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        [imageData writeToFile:imgPath atomically:YES];
    });
    return imgPath;
}

- (NSString *)getUUID
{
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    return cfuuidString;
}


@end
