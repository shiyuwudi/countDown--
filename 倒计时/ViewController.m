//
//  ViewController.m
//  倒计时
//
//  Created by 郑文明 on 16/1/7.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
     dispatch_source_t _timer;
}
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_timer==nil) {
        __block int timeout = 11120; //倒计时时间 in 毫秒
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),0.01*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.hundredSecondLabel.text = @"00";
                        self.minuteLabel.text = @"00";
                        self.secondLabel.text = @"00";
                    });
                }else{
                    int minute = (int)(timeout/6000);
                    int second = (int)(timeout-minute*6000)/100;
                    int hundred = timeout-minute*6000-second*100;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.minuteLabel.text = [NSString stringWithFormat:@"%0.2d",minute];
                        self.secondLabel.text = [NSString stringWithFormat:@"%0.2d",second];
                        self.hundredSecondLabel.text = [NSString stringWithFormat:@"%0.2d",hundred];
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
