//
//  StyleFourViewController.m
//  YEVideoPlayer
//
//  Created by yongen on 2017/5/18.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "StyleFourViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "YEVideoItem.h"
#import "YEVideoCell.h"

@interface StyleFourViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIWindow *keyWindow;

@end

@implementation StyleFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"视频列表";
    
    [self setupUI];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YEVideoCell *cell = [YEVideoCell videoCellWithTableView:tableView];
    

    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath --- %@", indexPath);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformMakeRotation( -M_PI / 2);
    
    }];
}

- (void)setupUI {
    
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = [UIColor orangeColor];
    [self.view addSubview:self.tableView];
    
}

@end
