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
#import "YEVideoPlayerFour.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "VideoDetailViewController.h"


#define videoListUrl @"http://c.3g.163.com/nc/video/list/VAP4BFR16/y/0-10.html"

@interface StyleFourViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>{
    NSIndexPath *_indexPath;
    YEVideoPlayerFour *_player;
    CGRect _currentPlayCellRect;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIWindow *keyWindow;
@property (nonatomic, strong) NSMutableArray *videoArray;

@end

@implementation StyleFourViewController

- (NSMutableArray *)videoArray {
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_player destroyPlayer];
    _player = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"视频列表";
    
    [self setupUI];
    self.tableView.estimatedRowHeight = 100;
    
    [self fetchVideoListData];
}
#pragma mark - network

- (void)fetchVideoListData {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:videoListUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        //        NSLog(@"%@", responseObject);
        NSArray *dataArray = responseObject[@"VAP4BFR16"];
        for (NSDictionary *dict in dataArray) {
            [self.videoArray addObject:[YEVideoItem mj_objectWithKeyValues:dict]];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)showVideoPlayer:(UITapGestureRecognizer *)tapGesture {
    [_player destroyPlayer];
    _player = nil;
    
    UIView *view = tapGesture.view;
    YEVideoItem *item = self.videoArray[view.tag - 7777];
    
    _indexPath = [NSIndexPath indexPathForRow:view.tag - 7777 inSection:0];
    YEVideoCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    
    _player = [[YEVideoPlayerFour alloc] init];
    _player.videoUrl = item.mp4_url;
    [_player playerBindTableView:self.tableView currentIndexPath:_indexPath];
    _player.frame = view.bounds;
    
    [cell.contentView addSubview:_player];
    
    _player.completedPlayingBlock = ^(YEVideoPlayerFour *player) {
        [player destroyPlayer];
        _player = nil;
    };
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.videoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YEVideoCell *cell = [YEVideoCell videoCellWithTableView:tableView];
    
    YEVideoItem *item = self.videoArray[indexPath.row];
    cell.videoItem = item;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoPlayer:)];
    [cell.videoImageView addGestureRecognizer:tap];
    cell.videoImageView.tag = indexPath.row + 7777;
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath --- %@", indexPath);
    YEVideoItem *item = self.videoArray[indexPath.row];
    VideoDetailViewController *videoDetailViewController = [[VideoDetailViewController alloc] init];
    videoDetailViewController.videoTitle = item.title;
    videoDetailViewController.mp4_url = item.mp4_url;
    [self.navigationController pushViewController:videoDetailViewController animated:YES];
}

- (void)setupUI {
    
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorColor = [UIColor orangeColor];
    [self.view addSubview:self.tableView];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tableView]) {
        
        [_player playerScrollIsSupportSmallWindowPlay:YES];
    }
}

@end
