//
//  YE_MPViewController.m
//  YEVideoPlayer
//
//  Created by yongen on 2017/5/17.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "YE_MPViewController.h"

@interface YE_MPViewController ()

@property (nonatomic, strong) MPMoviePlayerViewController *MPVC;

@end

@implementation YE_MPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"MPMoviePlayerViewController播放器";
}



- (IBAction)playerClick:(UIButton *)sender {
    
    [self presentMoviePlayerViewControllerAnimated:self.MPVC];
}

- (MPMoviePlayerViewController *)MPVC {
    if (!_MPVC) {
        _MPVC = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:@"http://vod.m.snrtv.com/data/2017/05/16/110a7e2bac100ece01c61075b76be869.mp4"]];
        
    }
    return _MPVC;
}


@end
