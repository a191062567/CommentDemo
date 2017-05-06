//
//  ViewController.m
//  CommentDemo
//
//  Created by 范人杰 on 2017/5/6.
//  Copyright © 2017年 byfan. All rights reserved.
//

#import "ViewController.h"
#import "FJBulletView.h"
#import "FJBulletManage.h"

@interface ViewController ()

@property (nonatomic, strong)FJBulletManage *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.manager = [[FJBulletManage alloc] init];
    __weak typeof(self)weakSelf = self;
    self.manager.generateViewBlock = ^(FJBulletView *view) {
        [weakSelf addBulletView:view];
    };
    
    UIButton *startButton = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
        [btn setTitle:@"Start" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didClickStart) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:startButton];
    
    UIButton *stopButton = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(200, 100, 50, 50)];
        [btn setTitle:@"Stop" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didClickStop) forControlEvents:UIControlEventTouchUpInside];
        btn;
    });
    [self.view addSubview:stopButton];
    
}

- (void)didClickStart
{
    [self.manager start];
}

-(void)didClickStop
{
    [self.manager stop];
}

- (void)addBulletView:(FJBulletView *)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(width, 300 + view.trajectory * 40, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    [view startAnimation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
