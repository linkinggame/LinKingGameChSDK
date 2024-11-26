

#import "LKOrderTableViewCell.h"

@interface LKOrderTableViewCell ()
@property (nonatomic,assign) BOOL isAlreadyCopy;
@end

@implementation LKOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    [self addLongPressGesture];
    self.label_orderNumber.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

//- (void)addLongPressGesture{
//    self.label_orderNumber.userInteractionEnabled = YES;
//    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPre:)];
//    longpress.minimumPressDuration = 1;
//    [self.label_orderNumber addGestureRecognizer:longpress];
//}


//- (BOOL)canBecomeFirstResponder{
//    return YES;
//}
//
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    return (action == @selector(copy:));
//}

//- (void)copy:(id)sender{
//    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
//    pasteBoard.string = self.label_orderNumber.text;
//}
//
//- (void)longPre:(UILongPressGestureRecognizer *)recongizer{
//
//    if (self.isAlreadyCopy == YES) {
//        return;
//    }
//    self.isAlreadyCopy = YES;
//
//
//    [self becomeFirstResponder];
//    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copy:)];
//    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
//    [[UIMenuController sharedMenuController] setTargetRect:self.label_orderNumber.frame inView:self.label_orderNumber.superview];
//    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.isAlreadyCopy = NO;
//    });
//}

@end
