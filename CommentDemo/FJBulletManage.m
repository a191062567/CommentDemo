//
//  FJBulletManage.m
//  CommentDemo
//
//  Created by 范人杰 on 2017/5/6.
//  Copyright © 2017年 byfan. All rights reserved.
//

#import "FJBulletManage.h"
#import "FJBulletView.h"

@interface FJBulletManage ()

//弹幕的数据来源
@property (nonatomic, strong)NSMutableArray *datasource;
//弹幕使用过程中的数组变量
@property (nonatomic, strong)NSMutableArray *bulletComments;
//存储弹幕view的数组变量
@property (nonatomic, strong)NSMutableArray *bulletViews;

@property (nonatomic,assign) BOOL bStopAnimation;

@end

@implementation FJBulletManage

- (instancetype)init {
    if (self = [super init]) {
        self.bStopAnimation = YES;
    }
    return self;
}

/** 弹幕开始执行*/
- (void)start {
    if (!_bStopAnimation) {
        return;
    }
    _bStopAnimation = NO;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.datasource];
    
    [self initBulletComment];
}

//初始化弹幕，随机分配弹幕轨迹
- (void)initBulletComment {
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    for (int i = 0; i < 3; i++) {
        if (self.bulletComments.count > 0) {
            //通过随机数渠道弹幕的轨迹
            NSInteger index = arc4random()%trajectorys.count;
            int trajectory = [[trajectorys objectAtIndex:index] intValue];
            [trajectorys removeObjectAtIndex:index];
            
            //从弹幕数组中逐一取弹幕数据
            NSString *comment = [self.bulletComments firstObject];
            [self.bulletComments removeObjectAtIndex:0];
            
            //创建弹幕view
            [self createBulletView:comment trajectory:trajectory];
        }
    }
}

- (void)createBulletView:(NSString *)comment trajectory:(int)trajecttory {
    if (self.bStopAnimation) {
        return;
    }
    
    FJBulletView *view = [[FJBulletView alloc] initWithBulletString:comment];
    view.trajectory = trajecttory;
    [self.bulletViews addObject:view];
    
    __weak typeof(view) weakView = view;
    __weak typeof(self) myself = self;
    view.moveStatusBlock = ^(FJBulletMoveStatus status) {
        if (self.bStopAnimation) {
            return;
        }
        switch (status) {
            case 0:
                //弹幕开始进入屏幕，将view加入弹幕管理的变量中bulletViews
                [myself.bulletViews addObject:weakView];
                break;
            case 1:
            {
                //弹幕完全进入屏幕，判断是否还有其他内容，如果有则在该弹幕轨迹中创建一个弹幕
                NSString *comment = [myself nextBulletComments];
                if (comment) {
                    [myself createBulletView:comment trajectory:trajecttory];
                }
            }
                break;
            case 2:
                //弹幕飞出屏幕后从bulletViews中删除，释放资源
                if ([myself.bulletViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [myself.bulletViews removeObject:weakView];
                }
                if (myself.bulletViews.count == 0) {
                    //说明屏幕上已经没有弹幕，开始循环滚动
                    self.bStopAnimation = YES;
                    [myself start];
                }
                break;
            default:
                break;
        }
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

/** 弹幕结束执行*/
- (void)stop {
    if (_bStopAnimation) {
        return;
    }
    _bStopAnimation = YES;
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FJBulletView *view = obj;
        [view stopAnimation];
        view = nil;
    }];
    [self.bulletViews removeAllObjects];
}

-(NSString *)nextBulletComments
{
    if (!self.bulletComments.count) {
        return nil;
    }
    NSString *bulletStr = self.bulletComments.firstObject;
    [self.bulletComments removeObjectAtIndex:0];
    return bulletStr;
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray arrayWithArray:@[@"1111111~~~",
                                                       @"@@@@!22222!~~",
                                                       @"@#####333333~~~",
                                                       @"1111111~~~",
                                                       @"@@@@!22222!~~",
                                                       @"@#####333333~~~",
                                                       @"1111111~~~",
                                                       @"@@@@!22222!~~",
                                                       @"@#####333333~~~",
                                                       @"1111111~~~",
                                                       @"@@@@!22222!~~",
                                                       @"@#####333333~~~",
                                                       @"1111111~~~",
                                                       @"@@@@!22222!~~",
                                                       @"@#####333333~~~"]];
    }
    return _datasource;
}

- (NSMutableArray *)bulletComments {
    if (!_bulletComments) {
        _bulletComments = [NSMutableArray array];
    }
    return _bulletComments;
}

- (NSMutableArray *)bulletViews {
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}

@end
