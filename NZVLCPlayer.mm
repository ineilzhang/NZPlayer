//
//  NZVLCPlayer.m
//  NZPlayer
//
//  Created by Neil Zhang on 2017/5/31.
//  Copyright © 2017年 Neil Zhang. All rights reserved.
//

#import "NZVLCPlayer.h"
#import "System.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface NZVLCPlayer ()

{
    CGRect _originFrame;
}

@property (nonatomic,strong) VLCMediaPlayer *player;

@property (nonatomic,strong,nonnull) NZVideoControlView *controlView;

@end

@implementation NZVLCPlayer

#pragma mark - life cycle

- (instancetype)init{
    if (self = [super init]) {
        [self addObserver];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self setupView];
    [self setupControlView];
}

#pragma mark - public method

- (void)showInView:(UIView *)view{
    NSAssert(self.mediaURL != nil, @"NZVLCPlayer Exception: mediaURL can not be nil!");
    [view addSubview:self];
    [self.player setDrawable:self];
    self.player.media = [[VLCMedia alloc]initWithURL:self.mediaURL];
    [self play];
}

#pragma mark - player logic

- (void)play{
    [self.player play];
    self.controlView.pause.hidden = NO;
    self.controlView.play.hidden = YES;
    [self.controlView autoFadeControlBar];
}

- (void)pause{
    [self.player pause];
    self.controlView.play.hidden = NO;
    self.controlView.pause.hidden = YES;
    [self.controlView autoFadeControlBar];
}

- (void)stop{
    [self.player stop];
    self.controlView.play.hidden = NO;
    self.controlView.pause.hidden = YES;
    self.controlView.progressSlider.value = 1.0f;
}

#pragma mark - vlc delegate

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification{
    [self bringSubviewToFront:self.controlView];
    if (self.player.media.state == VLCMediaStateBuffering) {
        self.controlView.indicatorView.hidden = NO;
        self.controlView.backgroundLayer.hidden = NO;
    }else if(self.player.media.state == VLCMediaStatePlaying){
        self.controlView.indicatorView.hidden = YES;
        self.controlView.backgroundLayer.hidden = YES;
    }else if(self.player.state == VLCMediaPlayerStateStopped){
        [self stop];
    }else{
        self.controlView.indicatorView.hidden = NO;
        self.controlView.backgroundLayer.hidden = NO;
    }
}

- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification{
    [self bringSubviewToFront:self.controlView];
    if (self.controlView.progressSlider.state != UIControlStateNormal) {
        return;
    }
    float percentValue = ([self.player.time.numberValue floatValue]) / ([kMediaLength.numberValue floatValue]);
    [self.controlView.progressSlider setValue:percentValue animated:YES];
    [self.controlView.time setText:[NSString stringWithFormat:@"%@/%@",self.player.time.stringValue,kMediaLength.stringValue]];
}

#pragma mark - video controlview delegate

- (void)controlFingerMoveLeft{
    [self.player shortJumpBackward];
}

- (void)controlFingerMoveRight{
    [self.player shortJumpForward];
}

- (void)controlFingerMoveUp{
    self.controlView.volumeSlider.value += 0.01;
}

- (void)controlFingerMoveDown{
    self.controlView.volumeSlider.value -= 0.01;
}

#pragma mark - private method

- (void)addObserver{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationHandler)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}
//强制转屏
- (void)forceChangeOrientation:(UIInterfaceOrientation)orientation{
    int val = orientation;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]){
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)setupView{
    [self setBackgroundColor:[UIColor redColor]];
}

- (void)setupControlView{
    [self addSubview:self.controlView];
    [self.controlView.play addTarget:self
                              action:@selector(playButtonClick)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.pause addTarget:self
                               action:@selector(pauseButtonClick)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.fullScreen addTarget:self
                                    action:@selector(fullScreenButtonClick)
                          forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.backScreen addTarget:self
                                    action:@selector(backScreenButtonClick)
                          forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.close addTarget:self
                               action:@selector(closeButtonClick)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.controlView.progressSlider addTarget:self
                                        action:@selector(progressSliderClick)
                              forControlEvents:UIControlEventTouchUpInside];
}
- (void)dismiss{
    [self.player stop];
    self.player.drawable = nil;
    self.player.delegate = nil;
    self.player = nil;
    
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeFromSuperview];
}

#pragma mark - notification handler

- (void)orientationHandler{
    if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)){
        self.isFullScreen = YES;
    }else{
        self.isFullScreen = NO;
    }
    [self.controlView autoFadeControlBar];
}

- (void)applicationDidEnterBackground{
    [self pause];
}

- (void)applicationWillResignActive{
    [self pause];
}

- (void)applicationDidBecomeActive{
    [self play];
}

- (void)applicationWillEnterForeground{
    [self play];
}

#pragma mark - button event

- (void)playButtonClick{
    [self play];
}

- (void)pauseButtonClick{
    [self pause];
}

- (void)closeButtonClick{
    [self dismiss];
    [kNoficationCenter postNotificationName:kInterfaceOrientationPortrait object:nil];

}

- (void)fullScreenButtonClick{
    [self forceChangeOrientation:UIInterfaceOrientationLandscapeLeft];
    [kNoficationCenter postNotificationName:kInterfaceLandscapeLeftOrientation object:nil];

}

- (void)backScreenButtonClick{
    [self forceChangeOrientation:UIInterfaceOrientationPortrait];
    [kNoficationCenter postNotificationName:kInterfaceOrientationPortrait object:nil];

}

- (void)progressSliderClick{
    int targetInt = (int)(self.controlView.progressSlider.value * (float)(kMediaLength.intValue));
    VLCTime *targetTime = [[VLCTime alloc]initWithInt:targetInt];
    [self.player setTime:targetTime];
    [self.controlView autoFadeControlBar];
}
#pragma mark - property

- (VLCMediaPlayer *)player{
    if (!_player) {
        _player = [[VLCMediaPlayer alloc] init];
        _player.delegate = self;
    }
    return _player;
}

- (NZVideoControlView *)controlView{
    if (!_controlView) {
        _controlView = [[NZVideoControlView alloc]init];
        _controlView.frame = self.bounds;
        _controlView.delegate = self;
    }
    return _controlView;
}

- (void)setIsFullScreen:(BOOL)isFullScreen{
    if (_isFullScreen == isFullScreen) {
        return;
    }
    _isFullScreen = isFullScreen;
    if (isFullScreen) {
        _originFrame = self.frame;
        CGFloat width = kScreenHeight;
        CGFloat height = kScreenWidth;
        CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);
        [UIView animateWithDuration:kVideoControlAnimationInterval animations:^{
            if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
                self.frame = frame;
                self.transform = CGAffineTransformMakeRotation(M_PI_2);
            }
            else{
                self.frame = [UIScreen mainScreen].bounds;
            }
            self.controlView.frame = self.bounds;
            [self.controlView layoutIfNeeded];
            self.controlView.fullScreen.hidden = YES;
            self.controlView.backScreen.hidden = NO;
        }];
    }
    else{
        [UIView animateWithDuration:kVideoControlAnimationInterval animations:^{
            self.transform = CGAffineTransformIdentity;
            self.frame = _originFrame;
            self.controlView.frame = self.bounds;
            [self.controlView layoutIfNeeded];
            self.controlView.fullScreen.hidden = NO;
            self.controlView.backScreen.hidden = YES;
        }];
    }
}

@end
