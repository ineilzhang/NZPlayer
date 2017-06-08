//
//  NZVLCPlayer.h
//  NZPlayer
//
//  Created by Neil Zhang on 2017/5/31.
//  Copyright © 2017年 Neil Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileVLCKit/MobileVLCKit.h>
#import "NZVideoControlView.h"


@interface NZVLCPlayer : UIView <VLCMediaPlayerDelegate,NZVideoControlViewDelegate>

@property (nonatomic,strong,nonnull) NSURL *mediaURL;

@property (nonatomic,assign) BOOL isFullScreen;

- (void)showInView:(UIView * _Nonnull)view;

@end
