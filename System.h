//
//  Header.h
//  NZPlayer
//
//  Created by Neil Zhang on 2017/5/27.
//  Copyright © 2017年 Neil Zhang. All rights reserved.
//

#ifndef Header_h
#define Header_h


#endif /* Header_h */

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kHUDCenter CGPointMake(CGRectGetWidth(self.bounds) / 2,CGRectGetHeight(self.bounds) / 2)
#define msgLableTextDefault @"msgLabelTextDefault"
#define kMediaLength self.player.media.length
//NSString *msgLableTextDefault = @"msgLabelTextDefault";
//#define kButtonHeight 20
//#define kHUDCycleLineWidth 3.0

#pragma mark - notification 

#define kNoficationCenter [NSNotificationCenter defaultCenter]
#define kInterfaceLandscapeLeftOrientation @"kInterfaceLandscapeLeftOrientation"
#define kInterfaceOrientationPortrait @"kInterfaceOrientationPortrait"

static const NSInteger kButtonHeight = 20;
static const CGFloat kHUDCycleLineWidth = 3.0f;
static const CGFloat kHUDLineWidth = 10.0f;
static const CGFloat leftLayerStokeEnd = 0.25f;
static const CGFloat rightLayerStokeStart = 0.5f;
static const CGFloat rightLayerStokeEnd = 0.75f;
static const NSTimeInterval kHUDCycleTimeInterval = 0.8f;
static const CGFloat kVideoControlBarHeight = 40.0f;
static const CGFloat kVideoControlTimeLabelFontSize = 10.0f;
static const CGFloat kVideoControlAlertLabelAlpha = 0.75f;
static const CGFloat kVideoControlAnimationInterval = 0.3f;
static const CGFloat kVideoControlBarAutoFadeOutInterval = 4.0f;
static const CGFloat kVideoControlProgressSliderHeight = 3.0f;



