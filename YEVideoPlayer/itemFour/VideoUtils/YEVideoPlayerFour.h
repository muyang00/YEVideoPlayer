//
//  YEVideoPlayerFour.h
//  YEVideoPlayer
//
//  Created by yongen on 2017/5/20.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YEVideoPlayerFour;
typedef void (^VideoCompletedPlayingBlock) (YEVideoPlayerFour *videoPlayer);

@interface YEVideoPlayerFour : UIView

@property (nonatomic, copy) VideoCompletedPlayingBlock completedPlayingBlock;

//视频路径
@property (nonatomic, strong) NSString *videoUrl;

- (void)playPause;

- (void)destroyPlayer;

//在cell 上播放必须绑定TableView， 当前播放cell的IndexPath
- (void)playerBindTableView:(UITableView *)bindTableView currentIndexPath:(NSIndexPath *)currentIndexPath;

//是否支持小窗口播放
- (void)playerScrollIsSupportSmallWindowPlay:(BOOL)support;

@end
