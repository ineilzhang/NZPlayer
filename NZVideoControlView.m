//
//  NZVideoControlView.m
//  NZPlayer
//
//  Created by Neil Zhang on 2017/5/31.
//  Copyright © 2017年 Neil Zhang. All rights reserved.
//

#import "NZVideoControlView.h"
#import <AVFoundation/AVFoundation.h>
#import "System.h"

@interface NZVideoControlView ()

@property (nonatomic,strong) UIPanGestureRecognizer *pan;

@end

@implementation NZVideoControlView



#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.topBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetWidth(self.bounds), kVideoControlBarHeight);
    self.close.frame = CGRectMake(CGRectGetWidth(self.topBar.bounds) - CGRectGetWidth(self.close.bounds), CGRectGetMinX(self.topBar.bounds), CGRectGetWidth(self.close.bounds), CGRectGetHeight(self.close.bounds));
    self.bottomBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetHeight(self.bounds) - kVideoControlBarHeight, CGRectGetWidth(self.bounds), kVideoControlBarHeight);
    self.progressSlider.frame     = CGRectMake(0, -0, CGRectGetWidth(self.bounds), 10);
    self.play.frame = CGRectMake(CGRectGetMinX(self.bottomBar.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.play.bounds)/2 + CGRectGetHeight(self.progressSlider.frame) * 0.6, CGRectGetWidth(self.play.bounds), CGRectGetHeight(self.play.bounds));
    self.pause.frame = self.play.frame;
    self.fullScreen.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - CGRectGetWidth(self.fullScreen.bounds) - 5, self.play.frame.origin.y, CGRectGetWidth(self.fullScreen.bounds), CGRectGetHeight(self.fullScreen.bounds));
//    self.backScreen.frame =
    self.indicatorView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
    self.time.frame          = CGRectMake(CGRectGetMaxX(self.play.frame), self.play.frame.origin.y, CGRectGetWidth(self.bottomBar.bounds), CGRectGetHeight(self.time.bounds));
    self.alertLabel.center        = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);

}

#pragma mark - public method
#pragma mark ???: need to test
#pragma mark TODO: test
#pragma mark FIXME: test
#pragma mark !!!: test
- (void)animateHide{
    [UIView animateWithDuration:kVideoControlAnimationInterval animations:^{
        self.topBar.alpha = 0.0f;
        self.bottomBar.alpha = 0.0f;
    } completion:^(BOOL finished) {
        NSLog(@"animateHide has finished? %d",finished);
    }];
}

- (void)animateShow{
    [UIView animateWithDuration:kVideoControlAnimationInterval animations:^{
        self.topBar.alpha = 1.0f;
        self.bottomBar.alpha = 1.0f;
    } completion:^(BOOL finished) {
        NSLog(@"animateShow has finished? %d",finished);
        [self autoFadeControlBar];
    }];
}

- (void)autoFadeControlBar{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:kVideoControlBarAutoFadeOutInterval];
}

#pragma mark - private method

- (void)setupView{
    self.backgroundColor = [UIColor clearColor];
    [self.layer addSublayer:self.backgroundLayer];
    [self addSubview:self.bottomBar];
    [self addSubview:self.topBar];
    [self addSubview:self.indicatorView];
    [self addSubview:self.alertLabel];
    
    [self.topBar addSubview:self.close];
    [self.topBar addSubview:self.backScreen];
    [self.bottomBar addSubview:self.play];
    [self.bottomBar addSubview:self.pause];
    [self.bottomBar addSubview:self.progressSlider];
    [self.bottomBar addSubview:self.fullScreen];
    [self.bottomBar addSubview:self.time];
    
    self.pause.hidden = YES;
    self.backScreen.hidden = YES;
    
    [self addGestureRecognizer:self.pan];
}

- (void)respondsToTap{
    self.bottomBar.alpha == 0 ? [self animateShow] : [self animateHide];
}

#pragma mark - touch event

- (void)panAction:(UIPanGestureRecognizer *)tap{
    CGPoint localPosition = [tap locationInView:self];
    CGPoint speedDir = [tap velocityInView:self];
    switch (tap.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.alertLabel.alpha = kVideoControlAlertLabelAlpha;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            //判断滑动的方向为想左右方向
            if (ABS(speedDir.x) > ABS(speedDir.y)) {
                if ([tap translationInView:self].x > 0) {
                    //滑动的方向是向右
                    if ([_delegate respondsToSelector:@selector(controlFingerMoveRight)]) {
                        [self.delegate controlFingerMoveRight];
                        [self.alertLabel configureWithTime:[self.time.text substringToIndex:5] forward:YES];
                    }
                }
                else{
                    //滑动的方向是向左
                    if ([_delegate respondsToSelector:@selector(controlFingerMoveLeft)]) {
                        [self.delegate controlFingerMoveLeft];
                        [self.alertLabel configureWithTime:[self.time.text substringToIndex:5] forward:NO];
                    }
                }
            }
            //滑动的方向是上下
            else{
                //在右边上下滑动，改变音量
                if(localPosition.x > (self.bounds.size.width / 2)){
                    //增加音量
                    if([tap translationInView:self].y > 0){
                        self.volumeSlider.value -= 0.01;
                    }
                    //降低音量
                    else{
                        self.volumeSlider.value += 0.01;
                    }
                    [self.alertLabel configureWithVolume:self.volumeSlider.value];
                }
                //在左边上下滑动，改变亮度
                else{
                    //增加亮度
                    if([tap translationInView:self].y > 0){
                        [UIScreen mainScreen].brightness -= 0.1;
                    }
                    //降低亮度
                    else{
                        [UIScreen mainScreen].brightness += 0.01;
                    }
                    [self.alertLabel configureWithLight:[UIScreen mainScreen].brightness];
                }
            }
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0f animations:^{
                    self.alertLabel.alpha = 0.0f;
                }];
            });
        }
            break;
        default:
            break;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.tapCount > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self respondsToTap];
        });
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self respondsToTap];
}


#pragma mark - property

- (NZVideoHUDView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[NZVideoHUDView alloc]init];
        _indicatorView.bounds = CGRectMake(0, 0, 100, 100);
    }
    return _indicatorView;
}

-(UIView *)topBar{
    if (!_topBar) {
        _topBar = [UIView new];
        _topBar.backgroundColor = [UIColor redColor];
    }
    return _topBar;
}

- (UIView *)bottomBar{
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        _bottomBar.backgroundColor = [UIColor greenColor];
    }
    return _bottomBar;
}

- (UIButton *)play{
    if (!_play) {
        _play = [UIButton buttonWithType:UIButtonTypeCustom];
        [_play setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        _play.bounds = CGRectMake(0, 0, kVideoControlBarHeight,kVideoControlBarHeight);
    }
    return _play;
}

- (UIButton *)pause{
    if (!_pause) {
        _pause = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pause setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        _pause.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _pause;
}

- (UIButton *)fullScreen{
    if (!_fullScreen) {
        _fullScreen = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreen setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
        _fullScreen.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _fullScreen;
}

- (UIButton *)backScreen{
    if (!_backScreen) {
        _backScreen = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backScreen setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        _backScreen.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _backScreen;
}

- (UIButton *)close{
    if (!_close) {
        _close = [UIButton buttonWithType:UIButtonTypeCustom];
        [_close setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        _close.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _close;
}

- (NZProgressSlider *)progressSlider{
    if (!_progressSlider) {
        _progressSlider = [[NZProgressSlider alloc]init];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackTintColor:[UIColor greenColor]];
        [_progressSlider setMaximumTrackTintColor:[UIColor redColor]];
        _progressSlider.value = 0.f;
        _progressSlider.continuous = YES;
    }
    return _progressSlider;
}

- (UILabel *)time{
    if (!_time) {
        _time = [UILabel new];
        _time.backgroundColor = [UIColor clearColor];
        _time.font = [UIFont systemFontOfSize:kVideoControlTimeLabelFontSize];
        _time.textColor = [UIColor lightGrayColor];
        _time.textAlignment = NSTextAlignmentLeft;
        _time.bounds = CGRectMake(0, 0, kVideoControlTimeLabelFontSize, kVideoControlBarHeight);
    }
    return _time;
}

- (CALayer *)backgroundLayer{
    if (!_backgroundLayer) {
        _backgroundLayer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]].CGColor;
        _backgroundLayer.bounds = self.frame;
        _backgroundLayer.position = CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    }
    return _backgroundLayer;
}

- (UISlider *)volumeSlider{
    if (!_volumeSlider) {
        for (UIView *view in [self.volumeView subviews]) {
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
                _volumeSlider = (UISlider *)view;
                break;
            }
        }
    }
    return _volumeSlider;
}

- (MPVolumeView *)volumeView{
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc]init];
    }
    return _volumeView;
}

- (UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [UILabel new];
        _alertLabel.bounds = CGRectMake(0, 0, 100, 40);
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:kVideoControlAlertLabelAlpha];
        _alertLabel.textColor = [UIColor blueColor];
        _alertLabel.layer.cornerRadius = 10.0;
        _alertLabel.layer.masksToBounds = YES;
        _alertLabel.alpha = 0.0;
    }
    return _alertLabel;
}

- (UIPanGestureRecognizer *)pan{
    if (!_pan){
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    }
    return _pan;
}
@end

@implementation NZProgressSlider

- (CGRect)trackRectForBounds:(CGRect)bounds{
    return CGRectMake(0, self.bounds.size.height * 0.8, self.bounds.size.width, kVideoControlProgressSliderHeight);
}

@end

@implementation UILabel (configureable)

- (void)configureWithTime:(NSString *)time forward:(BOOL)forward{
    forward ? [self setText:[NSString stringWithFormat:@">>%@",time]] : [self setText:[NSString stringWithFormat:@"<<%@",time]];
}

- (void)configureWithLight:(float)light{
    
}

- (void)configureWithVolume:(float)volume{
    
}

@end
