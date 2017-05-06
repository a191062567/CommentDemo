//
//  FJBulletView.h
//  CommentDemo
//
//  Created by 范人杰 on 2017/5/6.
//  Copyright © 2017年 byfan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FJBulletMoveStatus) {
    FJBulletMoveStatusStart,
    FJBulletMoveStatusEnter,
    FJBulletMoveStatusEnd
};

@interface FJBulletView : UIView

/** 弹道 */
@property (nonatomic, assign) int trajectory;
/** 弹道状态回调 */
@property (nonatomic, copy) void(^moveStatusBlock)(FJBulletMoveStatus status);

/** 初始化弹幕 */
- (instancetype)initWithBulletString:(NSString *)string;
/** 开始动画 */
- (void)startAnimation;
/** 结束动画 */
- (void)stopAnimation;

@end
