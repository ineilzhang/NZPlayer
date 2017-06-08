//
//  NZVideoHUDView.m
//  NZPlayer
//
//  Created by Neil Zhang on 2017/6/1.
//  Copyright © 2017年 Neil Zhang. All rights reserved.
//

#import "NZVideoHUDView.h"
#import "System.h"

@interface NZVideoHUDView ()
{
    CAShapeLayer *_leftLayer;
    CAShapeLayer *_rightLayer;
}
@end

@implementation NZVideoHUDView : UIView

#pragma mark - super method

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self setupAnimation];
}


#pragma mark - private method

- (void)setupAnimation{
    _leftLayer = [CAShapeLayer layer];
    _leftLayer.bounds = CGRectMake(0, 0, [self getCycleLayerSize].width, [self getCycleLayerSize].height);
    _leftLayer.position = kHUDCenter;
    _leftLayer.fillColor = [UIColor clearColor].CGColor;
    _leftLayer.strokeColor = [UIColor whiteColor].CGColor;
    _leftLayer.lineWidth = kHUDLineWidth;
    _leftLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, [self getCycleLayerSize].width, [self getCycleLayerSize].height)].CGPath;
    _leftLayer.strokeEnd = leftLayerStokeEnd;
    
    _rightLayer = [CAShapeLayer layer];
    _rightLayer.bounds = CGRectMake(0, 0, [self getCycleLayerSize].width, [self getCycleLayerSize].height);
    _rightLayer.position = kHUDCenter;
    _rightLayer.fillColor = [UIColor clearColor].CGColor;
    _rightLayer.strokeColor = [UIColor whiteColor].CGColor;
    _rightLayer.lineWidth = kHUDLineWidth;
    _rightLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, [self getCycleLayerSize].width, [self getCycleLayerSize].height)].CGPath;
    _rightLayer.strokeStart = rightLayerStokeStart;
    _rightLayer.strokeEnd = rightLayerStokeEnd;
    
    CAGradientLayer *gLayerLeft = [CAGradientLayer layer];
    gLayerLeft.backgroundColor = [UIColor redColor].CGColor;
    gLayerLeft.bounds = [self bounds];
    gLayerLeft.position = kHUDCenter;
    gLayerLeft.colors = @[(id)[UIColor yellowColor].CGColor,(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    gLayerLeft.mask = _leftLayer;
    
    CAGradientLayer *gLayerRight = [CAGradientLayer layer];
    gLayerRight.backgroundColor = [UIColor redColor].CGColor;
    gLayerRight.bounds = [self bounds];
    gLayerRight.position = kHUDCenter;
    gLayerRight.colors = @[(id)[UIColor yellowColor].CGColor,(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    gLayerRight.mask = _rightLayer;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = kHUDCycleTimeInterval;
    animation.repeatCount = HUGE_VALF;
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
    
    [_leftLayer addAnimation:animation forKey:nil];
    [_rightLayer addAnimation:animation forKey:nil];
    
    [self.layer addSublayer:gLayerLeft];
    [self.layer addSublayer:gLayerRight];
    
}


- (CGSize)getCycleLayerSize{
    return CGSizeMake(CGRectGetWidth(self.bounds) - kHUDCycleLineWidth, CGRectGetHeight(self.bounds) - kHUDCycleLineWidth);
}

@end

@interface NZAlertView ()

@end

@implementation NZAlertView

+(instancetype)shareInstance{
    static NZAlertView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NZAlertView alloc]init];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        _msgLabel = [UILabel new];
        _msgLabel.frame = self.bounds;
        _msgLabel.backgroundColor = [UIColor greenColor];
        _msgLabel.textColor = [UIColor blueColor];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.text = msgLableTextDefault;
        [self addSubview:_msgLabel];
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.backgroundColor = [UIColor grayColor];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    }];
}

- (void)show{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:2.0];
}

@end


