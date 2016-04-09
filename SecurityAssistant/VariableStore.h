//
//  VariableStore.h
//  SecurityAssistant
//
//  Created by talkweb on 16/3/3.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VariableStore : NSObject

+ (VariableStore *)sharedInstance;
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;
+(NSString *) getServerUrl;
/*
 * 系统背景色－ 兰色
 */
+(UIColor*)getSystemBackgroundColor;
/*
 * 系统文本颜色 绿色
 */
+(UIColor*)getSystemTureTextColor;
/*
 * 系统文本颜色 红色
 */
+(UIColor*)getSystemWarnTextColor;
+ (UIImage*) createImageWithColor: (UIColor*) color imageSize:(CGSize)size;

/** 保存图片到本地缓存
 * scale 缩放比例
 * path 返回存放的路径
 **/
- (BOOL)saveImage:(UIImage *)image withScale:(CGFloat)scale savePath:(NSString**)path;
/** 返回执行任务数据字典，key=taskid
 * sender 下载过来的执行任务
 * return 返回 － 如果有缓冲即取出本地缓存里的，如果没有重新构建可伸缩的数据集合并保存到缓存
 **/
-(NSMutableDictionary*)getWaitHandledData:(NSDictionary*)sender;
/** 在执行任务的时候，保存当前执行任务的数据集合
 * dict 需要保存的数据集合
 * statues 是否状态为进行中
 **/
-(BOOL)setWaitHandledWithSourceData:(NSMutableDictionary*)dict withHandledStatus:(BOOL)statues;
//-(BOOL)setWaitHandledWithSourceData:(NSMutableDictionary*)dict;
/** 播放音视频多媒体
 *  url 媒体文件路径
 **/
-(void)playMedia:(NSURL*)url;
/** 显示放大图片
 * imageview 小图加载的图片容器
 * url 图片路径
 **/
-(void)showImageView:(UIImageView*)imageview fromUrl:(NSURL*)url;
/**
 * 获取格式化时间
 * input yyyy-MM-dd HH:mm:ss
 * return MM月dd日 HH:mm
 **/
+(NSString*)getFormaterDateString:(NSString*)dateString;
/**
 阿拉伯数字转化为汉语数字
 */

+(NSString *)translation:(NSString *)arebic;


@end
