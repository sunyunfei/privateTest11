//
//  YFFPS.m
//  FPSDemo
//
//  Created by 孙云飞 on 2016/12/18.
//  Copyright © 2016年 孙云飞. All rights reserved.
//

#import "YFFPS.h"
#import <UIKit/UIKit.h>
#define Height [UIScreen mainScreen].bounds.size.height
#define Width [UIScreen mainScreen].bounds.size.width
@interface YFFPS()
@property(nonatomic,assign)NSTimeInterval oldTime;//时间
@property(nonatomic,assign)int count;//次数
@property(nonatomic,strong)UILabel *showLabel;//显示
@end
@implementation YFFPS
+ (instancetype)shareYFFPS{

    static YFFPS *yffps = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        yffps = [[self alloc]init];
    });
    return yffps;
}

- (instancetype)init{

    self = [super init];
    if (self) {
        
        [self p_initDisplayLabel];
    }
    return self;
}

- (void)p_initDisplayLabel{


    self.showLabel = [[UILabel alloc]initWithFrame:CGRectMake(Width / 2 - 30, Height - 20, 60, 20)];
    self.showLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    self.showLabel.textAlignment = NSTextAlignmentCenter;
    self.showLabel.font = [UIFont systemFontOfSize:13];
    self.showLabel.textColor = [UIColor whiteColor];
    self.showLabel.userInteractionEnabled = NO;
    self.showLabel.layer.cornerRadius = 2;
    //加载数据
    [self p_initDisplayLink];
    [[UIApplication sharedApplication].keyWindow addSubview:self.showLabel ];
}

- (void)p_initDisplayLink{

    CADisplayLink *fpsLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(dealLink:)];
    [fpsLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)dealLink:(CADisplayLink *)link{

    //首先初始化
    if (self.oldTime == 0) {
        self.oldTime = link.timestamp;
        return;
    }
    self.count += 1;//记录一秒中执行的次数
    NSTimeInterval nowTime = link.timestamp - self.oldTime;//计算间隔
    if (nowTime >= 1) {//如果间隔大于等于1s了
        self.oldTime = link.timestamp;//重新赋值
        float fps = self.count / nowTime;//计算fps
        self.count = 0;//次数归0
        //显示
        [self p_showFPS:fps];
    }
}
//显示
- (void)p_showFPS:(float)fps{

    self.showLabel.text = [NSString stringWithFormat:@"fps %d",(int)fps];
    
}
@end
