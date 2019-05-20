//
//  TYPercentView.m
//  AnimationTest
//
//  Created by stone on 2019/5/20.
//  Copyright © 2019 stone. All rights reserved.
//

#import "TYPercentView.h"
#import <Masonry.h>

@interface TYPercentView()

@property(nonatomic, strong)CAShapeLayer *shaperLayer;
@property(nonatomic, strong)UILabel *labTip;

@end

@implementation TYPercentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.pathWidth = 10;
        [self addSubview:self.labTip];
        [self.labTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - public methods
- (void)setPercent:(CGFloat)percent
{
    if (!self.bgLayer.superlayer) {
        [self.layer addSublayer:self.bgLayer];
        [self.bgLayer setMask:self.shaperLayer];
    }
    [_shaperLayer setStrokeEnd:percent];
    [_labTip setText:[NSString stringWithFormat:@"%.1f%@",percent,@"%"]];
}

#pragma mark - lazy methods
- (CAShapeLayer *)shaperLayer
{
    if (!_shaperLayer) {
        if (!self.path) {
            self.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.pathWidth/2.f,
                                                                                   self.pathWidth/2.f,
                                                                                   self.frame.size.width-self.pathWidth,
                                                                                   self.frame.size.height-self.pathWidth)];
            self.path.lineWidth = self.pathWidth;
        }
       
        _shaperLayer = [CAShapeLayer layer];
        _shaperLayer.path = self.path.CGPath;
        _shaperLayer.fillColor = [UIColor clearColor].CGColor;
        _shaperLayer.strokeColor = [UIColor blackColor].CGColor;
        _shaperLayer.lineWidth = self.pathWidth;
        _shaperLayer.strokeStart = 0;
        _shaperLayer.strokeEnd = 0;
    }
    return _shaperLayer;
}

- (CALayer *)bgLayer
{
    if(!_bgLayer){
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        gradientLayer.colors = @[(__bridge id)[UIColor whiteColor].CGColor,
                                  (__bridge id)[UIColor blackColor].CGColor];
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
        _bgLayer = gradientLayer;
    }
    return _bgLayer;
}

- (UILabel *)labTip
{
    if(!_labTip){
        _labTip = [[UILabel alloc] init];
        [_labTip setTextColor:[UIColor blackColor]];
        _labTip.text = @"0.0%";
    }
    return _labTip;
}

@end
