

#import "UIButton+LKCountDown.h"
#import "LKButtonCountdownManager.h"
#import "LKLog.h"
@implementation UIButton (LKCountDown)

- (void)startWithScheduledCountDownWithKey:(NSString *)keySting WithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color{
    
    [[LKButtonCountdownManager sharedSingletion] scheduledCountDownWithKey:keySting timeInterval:timeLine countingDown:^(NSTimeInterval leftTimeInterval) {
    
        self.backgroundColor = color;
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        [self setTitle:[NSString stringWithFormat:@"(%d)%@",(int)leftTimeInterval,subTitle] forState:UIControlStateNormal];
        self.userInteractionEnabled = NO;
        self.enabled = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        
    } finished:^(NSTimeInterval finalTimeInterval) {
        self.backgroundColor = mColor; // 按钮背景色
        if ( [self firstColor:mColor secondColor:[UIColor whiteColor]]) { // 白底 红字 红边
          [self setTitleColor:color forState:UIControlStateNormal];
        }else{ // 如果不是白色 // 红底 白字
          [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [self setTitle:title forState:UIControlStateNormal];
        
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.userInteractionEnabled = YES;
        self.enabled = YES;
    }];

}

- (void)startWithScheduledCountDownWithKey:(NSString *)keySting WithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color complete:(void (^)(void))complete{
    
    [[LKButtonCountdownManager sharedSingletion] scheduledCountDownWithKey:keySting timeInterval:timeLine countingDown:^(NSTimeInterval leftTimeInterval) {
    
        self.backgroundColor = color;
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        [self setTitle:[NSString stringWithFormat:@"(%d)%@",(int)leftTimeInterval,subTitle] forState:UIControlStateNormal];
        self.userInteractionEnabled = NO;
        self.enabled = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        
    } finished:^(NSTimeInterval finalTimeInterval) {
        self.backgroundColor = mColor; // 按钮背景色
        if ( [self firstColor:mColor secondColor:[UIColor whiteColor]]) { // 白底 红字 红边
          [self setTitleColor:color forState:UIControlStateNormal];
        }else{ // 如果不是白色 // 红底 白字
          [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [self setTitle:title forState:UIControlStateNormal];
        
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.userInteractionEnabled = YES;
        self.enabled = YES;
        
        if (complete) {
            complete();
        }
        
    }];

}
-(BOOL)firstColor:(UIColor*)firstColor secondColor:(UIColor*)secondColor
{
    if (CGColorEqualToColor(firstColor.CGColor, secondColor.CGColor))
    {
        LKLogInfo(@"颜色相同");
        return YES;
    }
    else
    {
        LKLogInfo(@"颜色不同");
        return NO;
    }
}

@end
