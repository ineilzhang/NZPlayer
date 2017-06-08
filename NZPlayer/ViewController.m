//
//  ViewController.m
//  NZPlayer
//
//  Created by Neil Zhang on 2017/5/27.
//  Copyright © 2017年 Neil Zhang. All rights reserved.
//

#import "ViewController.h"
#import "System.h"
#import "NZVLCPlayer.h"

@interface ViewController ()

- (IBAction)playLocalVideo:(id)sender;

- (IBAction)playRemoteVideo:(id)sender;


@end

@implementation ViewController

#pragma mark - view controller lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserver];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - override method

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - private method

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeInterfaceOrientationToLandscapeLeft:)
                                                 name:kLandscapeLeftNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeInterfaceOrientationToProtrait:)
                                                 name:kPortraitNotification
                                               object:nil];
}

#pragma mark - notification handler

- (void)changeInterfaceOrientationToLandscapeLeft:(NSNotification *)aNotification{
    [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeLeft;
}

- (void)changeInterfaceOrientationToProtrait:(NSNotification *)aNotification{
    [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
}

#pragma mark - target action

- (IBAction)playLocalVideo:(id)sender {
    NZVLCPlayer *localPlayer = [[NZVLCPlayer alloc]init];
    localPlayer.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
    localPlayer.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width * 9 / 16);
    localPlayer.mediaURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"mp4"];
    [localPlayer showInView:self.view];
}

- (IBAction)playRemoteVideo:(id)sender {
    NZVLCPlayer *remotePlayer = [[NZVLCPlayer alloc]init];
    remotePlayer.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
    remotePlayer.frame = CGRectMake(0, self.view.frame.size.width * 9 / 16 + 160, self.view.frame.size.width,self.view.frame.size.width * 9 / 16);
    remotePlayer.mediaURL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"mp4"];
    [remotePlayer showInView:self.view];
}
@end
