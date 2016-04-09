//
//  AssignmentScrollView.h
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/1.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PJScrollView.h"
@interface AssignmentScrollView : PJScrollView

@property (nonatomic, copy) void (^assignmentName)(NSString *);
@property (nonatomic, copy) void (^recipient)(NSString *);
@property (nonatomic, copy) void (^cc)(NSString *);
@property (nonatomic, copy) void (^startDate)(NSString *);
@property (nonatomic, copy) void (^endDate)(NSString *);
@property (nonatomic, copy) void (^contents)(NSString *);
@property (nonatomic, copy) void (^files)(id);
@property (nonatomic, copy) void (^pushInRecipient)(id);
@property (nonatomic, copy) void (^pushInCC)(id);

/**
 *  @brief - AssignmentScrollView add to showInView
 *
 *  @param showInView - need to be loaded
 *
 *  @return - AssignmentScrollView objects
 */
+ (id)showInView:(UIView *)showInView;


@end
