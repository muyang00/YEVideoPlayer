//
//  YEVideoPlayer.m
//  YEVideoPlayer
//
//  Created by yongen on 2017/5/17.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "YEVideoPlayer.h"

#define YEVideoPlayerStatus @"status"
#define YEVideoPlayerPlaybackBufferEmpty @"playbackBufferEmpty"
#define YEVideoPlayerStatusplaybackLikeToKeepUp @"playbackLikelyToKeepUp"
#define kPlayBackgroundColor [UIColor blackColor].CGColor

@interface YEVideoPlayer ()

@property (nonatomic, strong) AVPlayerItem *currentPlayerItem;//当前正在播放视频的item
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *currentPlayerLayer;//当前图像层
@property (nonatomic, strong) NSURL *playPathURL;

#pragma mark - parm参数
//是否添加了监听
@property (nonatomic, assign) BOOL isAddObserver;
@property (nonatomic, weak) UIView *showSuperView;
//是否正在缓冲
@property (nonatomic, assign) BOOL isBuffering;

@property (nonatomic, strong) NSTimer *timer;

//定时器监听播放的时间进度
@property (nonatomic, strong) CADisplayLink *playerTimerProgress;

@property (nonatomic, strong) UIImageView *coverImageView;

@end

const CGFloat checkSuperViewRate = 0.01;//second

@implementation YEVideoPlayer

+ (instancetype)sharedInstance {
    return [[self alloc]init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static id _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.stopWhenAppDidEnterBackground = YES;
        self.showActivityWhenLoading = YES;
        [self addObserverOnce];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopTimer];
}

#pragma mark - API

- (void)playVideoUrl:(NSURL *)url showInSuperView:(UIView *)superview {
    [self playVideoUrl:url coverImageurl:nil showInSuperView:superview];
}

- (void)playVideoUrl:(NSURL *)url coverImageurl:(NSString *)coverUrl showInSuperView:(UIView *)superview {
    //检测URL
    if (![self checkAvailableWithURL:url]) return;
    if (!superview) return;
    self.playPathURL = url;
    self.showSuperView = superview;
    
    [self stopTimer];
    [self stopPlayerTimeProgress];
    [self startTimer];
    [self stop];
    
    [self startLoadingViewInSuperView:superview];
    
    //加载视频的方式
    if ([url.absoluteString hasPrefix:@"http"]) {
        //网络加载数据
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[url.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        self.currentPlayerItem = playerItem;
    }else {
        //本地视频
        self.currentPlayerItem = [AVPlayerItem playerItemWithURL:url];
    }
    self.player = [AVPlayer playerWithPlayerItem:self.currentPlayerItem];
    self.currentPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.currentPlayerLayer.frame = CGRectMake(0, 0, superview.bounds.size.width, superview.bounds.size.height);
    
    //背景coverImageView
    if (coverUrl.length > 0) {
        [self.showSuperView insertSubview:self.coverImageView atIndex:0];
        self.coverImageView.frame = self.showSuperView.bounds;
        self.coverImageView.hidden = NO;
        //加载图片
        self.coverImageView.image = [UIImage imageNamed:@"default_photo"];
    }
    
    
}

- (void)playWithResume {
    if (!self.currentPlayerItem) return;
    [self.player play];
}

- (void)pause {
    if (!self.currentPlayerItem) return;
    [self.player pause];
}

- (void)stop {
    if (self.player == nil) return;
    [self.player pause];
    [self.player cancelPendingPrerolls];
    //移除视频层
    if (self.currentPlayerLayer) {
        [self.currentPlayerLayer removeFromSuperlayer];
        self.currentPlayerLayer = nil;
    }
    self.currentPlayerItem = nil;
    self.player = nil;
    self.playPathURL = nil;
    if (self.showActivityWhenLoading && self.loadingView) {
        [self.loadingView removeFromSuperview];
    }
}


//检测URL是否正确
- (BOOL)checkAvailableWithURL:(NSURL *)url {
    BOOL isCorrentURL = YES;
    if ([url isKindOfClass:[NSURL class]]) {
        if (url.absoluteString.length == 0) {
            return NO;
        }
    }
    return isCorrentURL;
}

#pragma mark - 定时器监听superView是否释放
- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:checkSuperViewRate target:self selector:@selector(timeChanged) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}


- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)timeChanged {
    if (!self.showSuperView) {
        self.showSuperView = nil;
        [self stop];
        [self stopTimer];
        [self stopPlayerTimeProgress];
    }
}

#pragma mark  - 定时器更新播放时间

- (void)stopPlayerTimeProgress {
    
    if (self.playerTimerProgress) {
        [self.playerTimerProgress invalidate];
        self.playerTimerProgress = nil;
    }
}

- (void)startPlayerTimeProgress {
    self.playerTimerProgress = [CADisplayLink displayLinkWithTarget:self selector:@selector(playerTimerProgressChanged)];
    [self.playerTimerProgress addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}


- (void)playerTimerProgressChanged {
    if (self.currentPlayerItem) {
        float totalDuration = CMTimeGetSeconds(self.currentPlayerItem.duration);
        float currentTime = CMTimeGetSeconds(self.currentPlayerItem.currentTime);
        NSInteger residueTime = (NSInteger)(totalDuration - currentTime);
        if (residueTime == 0) {
            [self stopPlayerTimeProgress];
        }
        if (self.playTimeProgressBlock) {
            self.playTimeProgressBlock(residueTime);
        }
    }
}

#pragma mark -- 加载动画

- (void)startLoadingViewInSuperView:(UIView *)superView {
    if (!self.showActivityWhenLoading) return;
    
    if (self.loadingView == nil) {
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
#pragma clang diagnostic push
#pragma clang disagnostic ignored "Wincompatible-pointer-types"
        self.loadingView = loading;
#pragma clang diagnostic pop
        
    }
    
    //判断是否增加到父控件
    if (!self.loadingView.superview) {
        [superView addSubview:self.loadingView];
        self.loadingView.center = CGPointMake(superView.bounds.size.width *0.5, superView.bounds.size.height * 0.5);
        self.loadingView.bounds = self.loadingView.bounds;
    }
    
    if ([self.loadingView respondsToSelector:@selector(startAnimating)]) {
        [self.loadingView performSelector:@selector(startAnimating)];
    }
    
}

- (void)stopLoading {
    if (!self.showActivityWhenLoading) return;
    
    if ([self.loadingView respondsToSelector:@selector(stopAnimating)]) {
        [self.loadingView performSelector:@selector(stopAnimating)];
    }
}


#pragma mark - KVO - 播放器状态

- (void)addPlayerObserver {
    //播放状态监听
    [_currentPlayerItem addObserver:self forKeyPath:YEVideoPlayerStatus options:NSKeyValueObservingOptionNew context:nil];
    [_currentPlayerItem addObserver:self forKeyPath:YEVideoPlayerPlaybackBufferEmpty options:NSKeyValueObservingOptionNew context:nil];
    [_currentPlayerItem addObserver:self forKeyPath:YEVideoPlayerStatusplaybackLikeToKeepUp options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removePlayerObserver {
    [_currentPlayerItem removeObserver:self forKeyPath:YEVideoPlayerStatus];
    [_currentPlayerItem removeObserver:self forKeyPath:YEVideoPlayerPlaybackBufferEmpty];
    [_currentPlayerItem removeObserver:self forKeyPath:YEVideoPlayerStatusplaybackLikeToKeepUp];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:YEVideoPlayerStatus]) {
        [self processObserverValueStatusWithItem:(AVPlayerItem *)object];
    }else if ([keyPath isEqualToString:YEVideoPlayerPlaybackBufferEmpty]){
        [self processObserverBuffering];
    }else if ([keyPath isEqualToString:YEVideoPlayerStatusplaybackLikeToKeepUp]){
        [self processObserverBuffered];
    }
}

- (void)processObserverValueStatusWithItem:(AVPlayerItem *)playerItem {
    AVPlayerItemStatus status  = playerItem.status;
    switch (status) {
        case AVPlayerItemStatusUnknown:{
            
            break;
        }
        case AVPlayerItemStatusFailed:{
            
            break;
        }
        case AVPlayerItemStatusReadyToPlay:{
            [self.player play];
            [self.showSuperView.layer insertSublayer:self.currentPlayerLayer atIndex:0];
            break;
        }
        default:
            break;
    }
}

//缓冲进度
- (void)processObserverBuffering {
    if (self.currentPlayerItem.playbackBufferEmpty) {
        [self startLoadingViewInSuperView:self.showSuperView];
        self.isBuffering = YES;
        [self bufferingForSeconds];
    }
}

//缓冲完成
- (void)processObserverBuffered {
    if (self.currentPlayerItem.playbackLikelyToKeepUp) {
        [self stopLoading];
        [self startPlayerTimeProgress];
        self.coverImageView.hidden = YES;
        self.isBuffering = NO;
    }
}

- (void)bufferingForSeconds{
    if (self.isBuffering == NO) return;
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.player play];
        if (!self.currentPlayerItem.isPlaybackLikelyToKeepUp) {
            [self bufferingForSeconds];
        }
    });
}

#pragma mark - KVO - app状态


- (void)addObserverOnce {
  
    if (!self.isAddObserver) {
        //添加监听，只能增加一次
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMemoryWaring) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
    }
    self.isAddObserver = YES;
}

- (void)appDidEnterBackground {
    if (self.stopWhenAppDidEnterBackground) {
        [self stop];
    }
}

- (void)appDidEnterPlayGround {
    [self playWithResume];
}

- (void)playerItemDidPlayToEnd: (NSNotification *)sender {
    
}

- (void)receiveMemoryWaring {
    [self stop];
}

#pragma mark -- set

- (void)setCurrentPlayerItem:(AVPlayerItem *)currentPlayerItem {
    if (_currentPlayerItem) {
        [self removePlayerObserver];
    }
    _currentPlayerItem = currentPlayerItem;
    [self addPlayerObserver];
}

- (void)setCurrentPlayerLayer:(AVPlayerLayer *)currentPlayerLayer {
    if (_currentPlayerLayer) {
        [_currentPlayerLayer removeFromSuperlayer];
    }
    _currentPlayerLayer = currentPlayerLayer;
    _currentPlayerLayer.backgroundColor = kPlayBackgroundColor;
    _currentPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}

- (void)setOpenSoundWhenPlaying:(BOOL)openSoundWhenPlaying {
    _openSoundWhenPlaying = openSoundWhenPlaying;
    self.player.muted = !openSoundWhenPlaying;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}

@end
