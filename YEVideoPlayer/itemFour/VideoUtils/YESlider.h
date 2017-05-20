//
//  YESlider.h
//  YEVideoPlayer
//
//  Created by yongen on 2017/5/20.
//  Copyright © 2017年 yongen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YESlider;

typedef void (^SliderValueChangeBlock)(YESlider *slider);
typedef void (^SliderFinishChangeBlock)(YESlider *slider);
typedef void (^DraggingSliderBlock)(YESlider *slider);


@interface YESlider : UIView

@property (nonatomic, assign) CGFloat value;//from 0 to 1

@property (nonatomic, assign) CGFloat middleValue;//from 0 to 1

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat sliderDiameter;

@property (nonatomic, strong) UIColor *sliderColor;
@property (nonatomic, strong) UIColor *maxColor;
@property (nonatomic, strong) UIColor *middleColor;
@property (nonatomic, strong) UIColor *minColor;

@property (nonatomic, strong) SliderValueChangeBlock valueChangeBlock;
@property (nonatomic, strong) SliderFinishChangeBlock finishChangeBlock;
@property (nonatomic, strong) DraggingSliderBlock draggingSliderBlock;


@end
