//
//  YE_AVPLayerNextViewController.m
//  YEVideoPlayer
//
//  Created by yongen on 2017/5/18.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "YE_AVPLayerNextViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface YE_AVPLayerNextViewController ()

@property (nonatomic, strong) AVPlayerItem *currentPlayerItem;//当前正在播放视频的item
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *currentPlayerLayer;//当前图像层
@property (nonatomic, strong) NSURL *playPathURL;

@end

@implementation YE_AVPLayerNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *videopath = @"http://vod.m.snrtv.com/data/2017/05/16/110a7e2bac100ece01c61075b76be869.mp4";
    
    //网络加载数据
    NSURL *url = [NSURL URLWithString:videopath];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[url.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    self.currentPlayerItem = playerItem;
    
    self.player = [AVPlayer playerWithPlayerItem:self.currentPlayerItem];
    self.currentPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.currentPlayerLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.player play];
    [self.view.layer addSublayer: self.currentPlayerLayer];
    
    
    
}


- (IBAction)back:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"-----------  YE_AVPLayerNextViewController.h  ---------");
}

@end
