//
//  YEVideoCell.h
//  YEVideoPlayer
//
//  Created by yongen on 2017/5/19.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YEVideoItem;
@interface YEVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
@property (nonatomic, strong) YEVideoItem *videoItem;

+ (instancetype)videoCellWithTableView:(UITableView *)tableView;


@end
