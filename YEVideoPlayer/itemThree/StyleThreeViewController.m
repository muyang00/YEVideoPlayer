//
//  StyleThreeViewController.m
//  YEVideoPlayer
//
//  Created by yongen on 2017/5/17.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "StyleThreeViewController.h"
#import "YEVideoPlayer.h"

#define closeButton_leftDefaultMargin 20
#define closeButton_topDefaultMargin 100
#define closeButton_WidthHeight  35
#define timeLabel_topMargin 100
#define timeLabel_rightMargin 30
#define timeLabel_WidthHeight 35

@interface StyleThreeViewController ()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation StyleThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupPlayer];
    [self setupUI];
    
}

- (void)setupPlayer {
    
    //播放单个视频
    __weak __typeof(self)weakSelf = self;
    NSString *videoPath = @"http://vod.m.snrtv.com/data/2017/05/16/110a7e2bac100ece01c61075b76be869.mp4";
    [[YEVideoPlayer sharedInstance] playVideoUrl:[NSURL URLWithString:videoPath] coverImageurl:@"背景图片路径" showInSuperView:self.view];
    [YEVideoPlayer sharedInstance].openSoundWhenPlaying = YES;
    [[YEVideoPlayer sharedInstance] setPlayTimeProgressBlock:^(long residueTime){
        [weakSelf reloadTimeProgress: residueTime];
    }];
}

- (void)setupUI {
    [self.view insertSubview:self.closeButton atIndex:0];
    self.closeButton.frame = CGRectMake(closeButton_leftDefaultMargin, closeButton_topDefaultMargin, closeButton_WidthHeight, closeButton_WidthHeight);
    [self.view insertSubview:self.timeLabel atIndex:0];
    self.timeLabel.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - 50, timeLabel_topMargin, timeLabel_WidthHeight, timeLabel_WidthHeight);
}

- (void)stopPlayer {
    
    [[YEVideoPlayer sharedInstance] stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)closeButtonClick {
    [self stopPlayer];
}

- (void)reloadTimeProgress:(NSInteger)time {
    self.timeLabel.text = [NSString stringWithFormat:@"%ld", time];
    if (time == 0) {
        [self stopPlayer];
    }
}


#pragma mark - lazy
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"shortvideo_button_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.backgroundColor = [UIColor orangeColor];
    }
    return _closeButton;
}

-  (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:16.0];
        _timeLabel.textColor = [UIColor redColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = [UIColor orangeColor];
    }
    return _timeLabel;
}


@end
