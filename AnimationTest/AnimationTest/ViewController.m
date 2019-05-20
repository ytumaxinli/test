//
//  ViewController.m
//  AnimationTest
//
//  Created by stone on 2019/5/14.
//  Copyright © 2019 stone. All rights reserved.
//

#import "ViewController.h"
#import "TYPercentView.h"
#import <Masonry.h>

@interface ViewController ()
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TYPercentView *persentView = [[TYPercentView alloc] init];
    [self.view addSubview:persentView];
    [persentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(100));
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@(100));
    }];
    
    __block CGFloat percent = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        percent = percent + 0.02;
        [persentView setPercent:percent];
    }];
}


@end
