//
//  TimeLabel.m
//  LunBo
//
//  Created by Aron on 2017/5/3.
//  Copyright © 2017年 XSService. All rights reserved.
//

#import "TimeLabel.h"
@interface TimeLabel ()
@property (nonatomic, strong)NSTimer *timer;
@end
@implementation TimeLabel

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)timeHeadle{
    
    self.second--;
    if (self.second==-1) {
        self.second=59;
        self.minute--;
        if (self.minute==-1) {
            self.minute=59;
            self.hour--;
        }
    }
    
    self.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)self.hour,(long)self.minute,(long)self.second];
    
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.text];
    NSDictionary *attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],  NSBackgroundColorAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName,nil];
    for (int i = 0; i<3; i++) {
        [attributedString addAttributes:attributeDic range:NSMakeRange(i*3, 2)];
    }
    
        self.attributedText = attributedString;
    
    if (self.second==0 && self.minute==0 && self.hour==0) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
