

#import "LKCrazyTipController.h"
#import "LKCrazyTipView.h"
@interface LKCrazyTipController ()

@end

@implementation LKCrazyTipController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showCrazyTipView];
}
- (void)showCrazyTipView{

    LKCrazyTipView *crazyTipView = [LKCrazyTipView instanceCrazyTipView];
    [self.view insertSubview:crazyTipView atIndex:self.view.subviews.count];
    crazyTipView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setAlterContentView:crazyTipView];
    CGFloat width = 300;
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    if (width > screen_width) {
        width = screen_width - 40;
    }
    [self setAlterWidth:width];
    [self setAlterHeight:190];
    [self layoutConstraint];
    crazyTipView.title.text = self.titleStr;
    crazyTipView.closeAlterViewCallBack = ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    
    
    if (self.isShowClose == YES) {
        crazyTipView.button_close.hidden = NO;
        crazyTipView.imageView_close.hidden = NO;
    }else{
        crazyTipView.button_close.hidden = YES;
        crazyTipView.imageView_close.hidden = YES;
    }
    
    crazyTipView.closeAlterViewCallBack = ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    };
    
    crazyTipView.label_tip.text = self.tip;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
