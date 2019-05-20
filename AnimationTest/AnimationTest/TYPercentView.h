//
//  TYPercentView.h
//  AnimationTest
//
//  Created by stone on 2019/5/20.
//  Copyright © 2019 stone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYPercentView : UIView
//进度条路径
@property(nonatomic,strong)UIBezierPath *path;
//进度条宽度
@property(nonatomic,assign)CGFloat pathWidth;
//进度条背景
@property(nonatomic, strong)CALayer *bgLayer;


- (void)setPercent:(CGFloat)percent;

@end

NS_ASSUME_NONNULL_END
