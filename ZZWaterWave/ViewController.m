//
//  ViewController.m
//  ZZWaterWave
//
//  Created by 周晓瑞 on 2017/11/8.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"
#import "ZZWaterWave.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet ZZWaterWave *waveView;

@end

@implementation ViewController
- (IBAction)wave:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"停止"]) {
        [self.waveView stopAnimation];
        sender.title = @"运动";
    }else{
        [self.waveView startAnimation];
        sender.title = @"停止";
    }
}
@end
