
#import "LKUserCenterView.h"

@implementation LKUserCenterView


+ (instancetype)instanceUserCenterView{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKUserCenterView *view = [[bundle loadNibNamed:@"LKUserCenterView" owner:nil options:nil] firstObject];
    return view;
}

@end
