//
//  StyleTwoViewController.m
//  YEVideoPlayer
//
//  Created by yongen on 2017/5/17.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "StyleTwoViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface StyleTwoViewController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerViewController *playerView;

@end

@implementation StyleTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"AVPlayerViewController";
    
    NSString *playString = @"http://vod.m.snrtv.com/data/2017/05/16/110a7e2bac100ece01c61075b76be869.mp4";
    
    //视频播放的url
    NSURL *playerURL = [NSURL URLWithString:playString];
    
    //初始化
    self.playerView = [[AVPlayerViewController alloc]init];
    
    //AVPlayerItem 视频的一些信息  创建AVPlayer使用的
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:playerURL];
    
    //通过AVPlayerItem创建AVPlayer
    self.player = [[AVPlayer alloc]initWithPlayerItem:item];
    
    //给AVPlayer一个播放的layer层
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    layer.frame = CGRectMake(0, 100, self.view.frame.size.width, 200);
    
    layer.backgroundColor = [UIColor purpleColor].CGColor;
    
    //设置AVPlayer的填充模式
    layer.videoGravity = AVLayerVideoGravityResize;
    
    [self.view.layer addSublayer:layer];
    
    //设置AVPlayerViewController内部的AVPlayer为刚创建的AVPlayer
    self.playerView.player = self.player;
    
    //关闭AVPlayerViewController内部的约束
    self.playerView.view.translatesAutoresizingMaskIntoConstraints = YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showViewController:self.playerView sender:nil];
}

@end
