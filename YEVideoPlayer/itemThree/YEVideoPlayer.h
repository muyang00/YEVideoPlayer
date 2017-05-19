//
//  YEVideoPlayer.h
//  YEVideoPlayer
//
//  Created by yongen on 2017/5/17.
//  Copyright © 2017年 yongen. All rights reserved.
//
//视频工具类，可以播放本地视频也可以播放网络视频

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol YEVideoPlayerLoadingDelegate <NSObject>

@required
- (void)startAnimating;
- (void)stopAnimating;

@end

@interface YEVideoPlayer : NSObject

+ (instancetype)sharedInstance;

//传入URL, superView表示在哪里播放， 传入的视频播放层的父控件
- (void)playVideoUrl:(NSURL *)url showInSuperView:(UIView *)superview;

//传入的url自动播放，coverurl默认的加载背景图， superView是表示在哪里播放， 传入的视频播放层的父控件

- (void)playVideoUrl:(NSURL *)url coverImageurl:(NSString *)coverUrl showInSuperView:(UIView *)superview;


//返回剩余的时间
@property (nonatomic, copy) void(^playTimeProgressBlock)(long residueTime);
- (void)setPlayerTimeProgressBlock:(void (^)(long residueTime))playerTimeProgressBlock;

//播放与重播
- (void)playWithResume;

//暂停
- (void)pause;

- (void)stop;


#pragma mark - config 

//视频加载视图,默认为系统的UIActivityIndicatorView
@property (nonatomic, strong) UIView <YEVideoPlayerLoadingDelegate> *loadingView;

//默认为YES， 当APP加载视频是否显示加载动画
@property (nonatomic, assign) BOOL showActivityWhenLoading;
//默认YES， 当APP进入后台是否停止播放
@property (nonatomic, assign) BOOL stopWhenAppDidEnterBackground;

//默认NO， 当播放的时候的是否打开声音
@property (nonatomic, assign) BOOL openSoundWhenPlaying;





@end
