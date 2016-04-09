//
//  MeHandleScrollview.h
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/13.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "PJScrollView.h"

@interface MeHandleScrollView : PJScrollView

@property (nonatomic, copy) void (^contents)(NSString *);
@property (nonatomic, copy) void (^files)(id);
@property (nonatomic, copy) void (^certifier)(NSString *);
@property (nonatomic, copy) void (^appraiser)(NSString *);
@property (nonatomic, copy) void (^pushInCertifier)(id);
@property (nonatomic, copy) void (^pushInAppraiser)(id);

/**
 *  @brief - AssignmentScrollView add to showInView
 *
 *  @param showInView - need to be loaded
 *
 *  @return - AssignmentScrollView objects
 */
+ (id)showInView:(UIView *)showInView;

@end
