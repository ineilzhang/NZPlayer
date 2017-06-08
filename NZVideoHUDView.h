//
//  NZVideoHUDView.h
//  NZPlayer
//
//  Created by Neil Zhang on 2017/6/1.
//  Copyright © 2017年 Neil Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NZVideoHUDView : UIView

@end

@interface NZAlertView : UIView

@property (nonatomic,strong) UILabel *msgLabel;

+ (instancetype)shareInstance;

- (void)show;

@end
