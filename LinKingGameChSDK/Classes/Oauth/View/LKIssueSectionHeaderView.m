

#import "LKIssueSectionHeaderView.h"

@implementation LKIssueSectionHeaderView

+ (instancetype)instancessueSectionHeaderView{
     NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKIssueSectionHeaderView *view = [[bundle loadNibNamed:@"LKIssueSectionHeaderView" owner:nil options:nil] firstObject];
    view.label_issue.adjustsFontSizeToFitWidth = YES;
    view.label_state.adjustsFontSizeToFitWidth = YES;
    return view;
}


@end
