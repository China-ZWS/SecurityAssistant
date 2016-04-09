//
//  AppDelegate.h
//  SecurityAssistant
//
//  Created by talkweb on 16/2/24.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSArray *basicDatas;
/**
 *  @brief  获取组织架构基础数据
 */
@property (nonatomic, copy) void(^updateBasicData)();

@end

