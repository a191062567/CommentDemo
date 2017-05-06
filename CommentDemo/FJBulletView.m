//
//  FJBulletView.m
//  CommentDemo
//
//  Created by 范人杰 on 2017/5/6.
//  Copyright © 2017年 byfan. All rights reserved.
//

#import "FJBulletView.h"

#define Padding 10
#define ViewHeight 30
#define PhotoHeiWid 30
#define FontSize 14

@interface FJBulletView ()

@property (nonatomic, strong)UILabel *lbComment;
@property (nonatomic, strong)UIImageView *photoImageView;

@end

@implementation FJBulletView

/** 初始化弹幕 */
- (instancetype)initWithBulletString:(NSString *)string {
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = ViewHeight / 2;
        
        //计算弹幕的实际宽度
        NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:FontSize]};
        CGFloat width = [string sizeWithAttributes:attr].width;
        
        self.bounds = CGRectMake(0, 0, width + 2 * Padding + PhotoHeiWid, ViewHeight);
        
        self.lbComment.text = string;
        self.lbComment.frame = CGRectMake(Padding + PhotoHeiWid, 0, width, ViewHeight);
        
        self.photoImageView.frame = CGRectMake(-Padding, -Padding, PhotoHeiWid + Padding, PhotoHeiWid + Padding);
    }
    return self;
}

/** 开始动画 */
- (void)startAnimation {
    
    // 弹幕越长 动画时间越长, 速度越慢
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 4.0f;
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);
    
    //弹幕开始
    if (self.moveStatusBlock) {
        self.moveStatusBlock(FJBulletMoveStatusStart);
    }
    
    // t = s/v
    CGFloat speed = wholeWidth/duration;
    CGFloat enterDuration = CGRectGetWidth(self.bounds) / speed;
    
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if (self.moveStatusBlock) {
            self.moveStatusBlock(FJBulletMoveStatusEnd);
        }
    }];
}

/** 结束动画 */
- (void)stopAnimation {
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(enterScreen) object:nil];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

-(void)enterScreen
{
    if (self.moveStatusBlock) {
        self.moveStatusBlock(FJBulletMoveStatusEnter);
    }
}

- (UILabel *)lbComment {
    if (!_lbComment) {
        _lbComment = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbComment.font = [UIFont systemFontOfSize:FontSize];
        _lbComment.textColor = [UIColor whiteColor];
        _lbComment.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbComment];
    }
    return _lbComment;
}

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _photoImageView.clipsToBounds = YES;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.backgroundColor = [UIColor yellowColor];
        _photoImageView.layer.cornerRadius = (PhotoHeiWid + Padding) / 2;
        _photoImageView.layer.borderColor = [UIColor orangeColor].CGColor;
        _photoImageView.layer.borderWidth = 1;
        [self addSubview:_photoImageView];
    }
    return _photoImageView;
}

@end
