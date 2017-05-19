//
//  ViewController.m
//  YEVideoPlayer
//
//  Created by yongen on 2017/5/17.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic, strong) NSString *videoPath1;
@property (nonatomic, strong) NSString *videoPath2;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //http://120.25.226.186:32812/resources/videos/minion_01.mp4
    
     self.navigationItem.title = @"MPMoviePlayerController";
   
    
    self.playBtn.layer.cornerRadius = 15;
    self.playBtn.layer.masksToBounds = YES;
    
    
    
    _videoPath1 = @"http://120.25.226.186:32812/resources/videos/minion_01.mp4";
    //_videoPath1 = @"http://vod.m.snrtv.com/data/2017/05/16/1107e599ac100ece0050f7dca2d3cd92.mp4";
    _videoPath2 = @"http://vod.m.snrtv.com/data/2017/05/16/110a7e2bac100ece01c61075b76be869.mp4";
    
     [self.view addSubview:self.player.view];

    
}

- (IBAction)playerAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if(sender.isSelected){
        
        [self.player prepareToPlay];  //这句代码很重要
        if([self.player isPreparedToPlay])
            [self.player play];
    }else {
        
        [self.player stop];
    }
}

- (void)handleLoadState:(NSNotification *)sender{
    switch (self.player.loadState) {
        case MPMovieLoadStatePlayable:{
               NSLog(@"缓冲完成，可以播放");
            break;
        }
        case MPMovieLoadStatePlaythroughOK:{
               NSLog(@"缓冲完成，可以连续播放");
            break;
        }
        case MPMovieLoadStateStalled:{
            NSLog(@"缓冲中。。。");
            break;
        }
        case MPMovieLoadStateUnknown:{
            NSLog(@"未知。。。");
            break;
        }
        default:
            break;
    }
}

- (MPMoviePlayerController *)player{
    if (!_player) {
        
        NSURL *url = [NSURL URLWithString:_videoPath1];
        self.player = [[MPMoviePlayerController alloc]initWithContentURL:url];
        self.player.view.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 240);
        [self.view addSubview:self.player.view];
        self.player.controlStyle = MPMovieControlStyleFullscreen;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoadState:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
        
    }
    return _player;
}


@end
