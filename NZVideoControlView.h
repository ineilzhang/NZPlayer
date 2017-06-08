//
//  NZVideoControlView.h
//  NZPlayer
//
//  Created by Neil Zhang on 2017/5/31.
//  Copyright © 2017年 Neil Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NZVideoHUDView.h"

@class NZProgressSlider;

@protocol NZVideoControlViewDelegate <NSObject>

@optional

- (void)controlFingerMoveUp;

- (void)controlFingerMoveDown;

- (void)controlFingerMoveLeft;

- (void)controlFingerMoveRight;

@end

@interface NZVideoControlView : UIView

@property (nonatomic,weak) id<NZVideoControlViewDelegate> delegate;

@property (nonatomic,strong) UIView *topBar;

@property (nonatomic,strong) UIButton *close;

@property (nonatomic,strong) UIView *bottomBar;

@property (nonatomic,strong) UIButton *play;

@property (nonatomic,strong) UIButton *pause;

@property (nonatomic,strong) UIButton *fullScreen;

@property (nonatomic,strong) UIButton *backScreen;

@property (nonatomic,strong) NZProgressSlider *progressSlider;

@property (nonatomic,strong) UILabel *time;

@property (nonatomic,strong) CALayer *backgroundLayer;

@property (nonatomic,strong) MPVolumeView *volumeView;

@property (nonatomic,strong) UISlider *volumeSlider;

@property (nonatomic,strong) NZVideoHUDView *indicatorView;

@property (nonatomic,strong) UILabel *alertLabel;


- (void)animateHide;

- (void)animateShow;

- (void)autoFadeControlBar;

- (void)cancelAutoFadeControlBar;

@end

@interface NZProgressSlider : UISlider

@end

@interface UILabel (configureable)

- (void)configureWithTime:(NSString *)time forward:(BOOL)forward;

- (void)configureWithLight:(float)light;

- (void)configureWithVolume:(float)volume;

@end
