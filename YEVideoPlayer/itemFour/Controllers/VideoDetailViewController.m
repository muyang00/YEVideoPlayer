//
//  VideoDetailViewController.m
//  YEVideoPlayer
//
//  Created by yongen on 2017/5/19.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "YEVideoPlayerFour.h"

@interface VideoDetailViewController ()
@property (nonatomic, strong) YEVideoPlayerFour *player;
@end

@implementation VideoDetailViewController

- (YEVideoPlayerFour *)player {
    if (!_player) {
        _player = [[YEVideoPlayerFour alloc] init];
        _player.frame = CGRectMake(0, 64, self.view.frame.size.width, 250);
    }
    return _player;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.videoTitle;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.player.videoUrl = self.mp4_url;
    [self.view addSubview:self.player];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.player destroyPlayer];
    self.player = nil;
}



@end
