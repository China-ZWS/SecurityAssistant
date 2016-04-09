//
//  UIImagePickerController+photo.h
//  GrowingSupermarket
//
//  Created by 周文松 on 15-7-8.
//  Copyright (c) 2015年 com.talkweb.Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface UIImagePickerController (photo)
#pragma mark - 摄像头和相册相关的公共类
/**
 *  @brief  判断设备是否有摄像头
 *
 *  @return 返回判断结果
 */
+ (BOOL) isCameraAvailable;

/**
 *  @brief  前面的摄像头是否可用
 *
 *  @return 返回判断结果
 */
+ (BOOL) isFrontCameraAvailable;

/**
 *  @brief  后面的摄像头是否可用
 *
 *  @return 返回判断结果
 */
+ (BOOL) isRearCameraAvailable;

/**
 *  @brief  判断是否支持某种多媒体类型：拍照，视频
 *
 *  @param paramMediaType  <#paramMediaType description#>
 *  @param paramSourceType <#paramSourceType description#>
 *
 *  @return 返回判断结果
 */
+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType;

/**
 *  @brief  检查摄像头是否支持录像
 *
 *  @return 返回判断结果
 */
+ (BOOL) doesCameraSupportShootingVideos;

/**
 *  @brief  检查摄像头是否支持拍照
 *
 *  @return 返回判断结果
 */
+ (BOOL) doesCameraSupportTakingPhotos;


#pragma mark - 相册文件选取相关
/**
 *  @brief  相册是否可用
 *
 *  @return 返回判断结果
 */
+ (BOOL) isPhotoLibraryAvailable;

/**
 *  @brief  是否可以在相册中选择视频
 *
 *  @return 返回判断结果
 */
+ (BOOL) canUserPickVideosFromPhotoLibrary;

/**
 *  @brief  是否可以在相册中选择视频
 *
 *  @return 返回判断结果
 */
+ (BOOL) canUserPickPhotosFromPhotoLibrary;

@end
