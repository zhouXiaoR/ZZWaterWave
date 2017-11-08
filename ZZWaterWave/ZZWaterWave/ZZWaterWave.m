//
//  ZZWaterWave.m
//  ZZWaterWave
//
//  Created by 周晓瑞 on 2017/11/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#define    VIEW_WIDTH     self.bounds.size.width
#define    VIEW_HEIGHT   self.bounds.size.height

static  const float  kWaveDuration = 1 / 40.0f; // 周期
static  const float  kWaveYMax = 20.0f; // 振幅
static  const float  kWaveYOffset = 100.0f; //竖直方向上的偏移位置
static  const float  kWaveMoveSpeed = 0.05f; // 波浪的速度
static  const float  kWaveMargin = 6.0f; // 波浪的速度

#import "ZZWaterWave.h"

@interface ZZWaterWave()

/**
 波浪层
 */
@property(nonatomic,weak)CAShapeLayer *waveLayer;

/**
 定时器，不断改变路径上的点
 */
@property(nonatomic,weak)CADisplayLink *displayLink;

/**
 波浪在Y轴上的偏移
 */
@property(nonatomic,assign)CGFloat waveOffset;

/**
 背景圈
 */
@property(nonatomic,weak)CAShapeLayer *backShapeLayer;

/**
 波浪的遮罩
 */
@property(nonatomic,weak)CAShapeLayer *circleShapeLayer;
@end

@implementation ZZWaterWave

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self displayLink];
}


- (void)layoutSubviews{
    [super layoutSubviews];
     self.waveLayer.frame = self.bounds;
     self.backShapeLayer.frame = self.bounds;
     self.circleShapeLayer.frame = self.bounds;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawWaterWave];
}

// Asin(x*@ + offset) + C
- (void)drawWaterWave{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, VIEW_HEIGHT/2.0);
    for (int i = 0; i <= VIEW_WIDTH ; i++) {
       CGFloat y = kWaveYMax * sin(kWaveDuration*i+self.waveOffset) + kWaveYOffset;
        CGPathAddLineToPoint(path, NULL, i, y);
    }
    CGPathAddLineToPoint(path, NULL,VIEW_WIDTH, VIEW_HEIGHT);
    CGPathAddLineToPoint(path, NULL, 0, VIEW_HEIGHT);
    CGPathCloseSubpath(path);
    self.waveLayer.path = path;
    CGPathRelease(path);
}

- (CAShapeLayer *)circleShapeLayer{
    if (_circleShapeLayer == nil) {
        CAShapeLayer * cirShapeLayer = [CAShapeLayer layer];
        [self.layer addSublayer:cirShapeLayer];
        UIBezierPath *bPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(VIEW_WIDTH/2.0, VIEW_HEIGHT/2.0) radius:VIEW_WIDTH/2.0 - kWaveMargin startAngle:0 endAngle:2*M_PI clockwise:YES];
        cirShapeLayer.path = bPath.CGPath;
        _circleShapeLayer = cirShapeLayer;
    }
    return _circleShapeLayer;
}

- (CAShapeLayer *)waveLayer{
    if (_waveLayer == nil) {
        CAShapeLayer * shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [UIColor grayColor].CGColor;
        shapeLayer.lineWidth = 2.0f;
         shapeLayer.strokeColor = [UIColor redColor].CGColor;
        [self.layer addSublayer:shapeLayer];
        shapeLayer.mask = self.circleShapeLayer;
        _waveLayer = shapeLayer;
    }
    return _waveLayer;
}
-(CAShapeLayer *)backShapeLayer{
    if (_backShapeLayer == nil) {
        UIBezierPath *bPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(VIEW_WIDTH/2.0, VIEW_HEIGHT/2.0) radius:VIEW_WIDTH/2.0 - kWaveMargin startAngle:0 endAngle:2*M_PI clockwise:YES];
        CAShapeLayer * backShapeLayer = [CAShapeLayer layer];
        backShapeLayer.path = bPath.CGPath;
        backShapeLayer.lineWidth = 3.0f;
        backShapeLayer.fillColor = [UIColor clearColor].CGColor;
        backShapeLayer.strokeColor = [UIColor blueColor].CGColor;
        [self.layer addSublayer:backShapeLayer];
        _backShapeLayer = backShapeLayer;
    }
    return _backShapeLayer;
}

- (void)changeWave{
    self.waveOffset += kWaveMoveSpeed;
    [self setNeedsDisplay];
}

- (CADisplayLink *)displayLink{
    if (_displayLink == nil) {
        CADisplayLink * displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeWave)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        _displayLink = displayLink;
    }
    return _displayLink;
}

- (void)startAnimation{
    self.displayLink.paused = NO;
}
- (void)stopAnimation{
    self.displayLink.paused = YES;
}
-(void)dealloc{
    [self.displayLink invalidate];
}

@end
