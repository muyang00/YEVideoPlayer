//
//  YEVideoCell.m
//  YEVideoPlayer
//
//  Created by yongen on 2017/5/19.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import "YEVideoCell.h"
#import "YEVideoItem.h"
#import "UIImageView+WebCache.h"

@implementation YEVideoCell

+ (instancetype)videoCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"YEVideoCell";
    YEVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YEVideoCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setVideoItem:(YEVideoItem *)videoItem {
    _videoItem = videoItem;
    self.videoTitle.text = videoItem.title;
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:videoItem.cover]];
}

@end
