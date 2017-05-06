//
//  FJBulletManage.h
//  CommentDemo
//
//  Created by 范人杰 on 2017/5/6.
//  Copyright © 2017年 byfan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FJBulletView;
@interface FJBulletManage : NSObject

@property (nonatomic, copy) void(^generateViewBlock)(FJBulletView *view);

/** 弹幕开始执行*/
- (void)start;

/** 弹幕结束执行*/
- (void)stop;

@end
