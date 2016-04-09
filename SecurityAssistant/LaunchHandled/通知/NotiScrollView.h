//
//  NotiScrollView.h
//  SecurityAssistant
//
//  Created by 周文松 on 16/3/8.
//  Copyright © 2016年 talkweb. All rights reserved.
//

#import "PJScrollView.h"

@interface NotiScrollView : PJScrollView
@property (nonatomic, copy) void (^notiName)(NSString *);
@property (nonatomic, copy) void (^recipient)(NSString *);
@property (nonatomic, copy) void (^endDate)(NSString *);
@property (nonatomic, copy) void (^contents)(NSString *);
@property (nonatomic, copy) void (^pushInContacts)(id);

+ (id)showInView:(UIView *)showInView;

@end
