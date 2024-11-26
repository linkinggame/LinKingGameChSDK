

#import "LKSubmitIssueView.h"
#import "LKGlobalConf.h"
#import "LKPictureCollectionView.h"
#import "LKTextView.h"
#import "NSObject+LKUserDefined.h"
#import "UIImage+LKAdditions.h"
#import "NSBundle+LKResources.h"
#import "LKSDKConfig.h"
#import "LKUser.h"
#import "LKNetWork.h"
#import <Toast/Toast.h>
#import <SDWebImage/SDWebImage.h>
#import <TZImagePickerController/TZImagePickerController.h>
@interface LKSubmitIssueView ()<UITextViewDelegate>
@property (nonatomic,weak) UIView *contentView;
@property (nonatomic,assign) BOOL isShowTipMessage;
@end
@implementation LKSubmitIssueView

+ (instancetype)instanceSubmitIssueView{
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LinKingGameChSDKBundle" withExtension:@"bundle"]];
    LKSubmitIssueView *view = [[bundle loadNibNamed:@"LKSubmitIssueView" owner:nil options:nil] firstObject];
    view.layer.cornerRadius = 15;
    view.clipsToBounds = YES;
    
    view.button_commit.layer.cornerRadius = 8;
    view.button_commit.clipsToBounds = YES;

    view.textView.placeholder = @"请填写10字以上的问题描述以使我们提供更好的帮助";

    view.button_commit.layer.cornerRadius = 8;
    view.button_commit.clipsToBounds = YES;
    view.textView.delegate = view;
    view.isShowTipMessage = YES;
    return view;
}

- (void)setLKSuperView:(UIView *)superView{
    self.contentView = superView;
}

- (IBAction)closeViewAction:(id)sender {
    if (self.closeAlterViewCallBack) {
        self.closeAlterViewCallBack();
    }
}
- (IBAction)checkboxAction:(UIButton *)sender {
    
    
    if (self.button_checkbox.isSelected) {
        [self.button_checkbox setBackgroundImage:[UIImage lk_ImageNamed:@"frame"] forState:UIControlStateNormal];
        
    }else{
        [self.button_checkbox setBackgroundImage:[UIImage lk_ImageNamed:@"checkmark"] forState:UIControlStateNormal];
    }

    self.button_checkbox.selected = !sender.selected;
    
    if (self.checkBoxCallBack) {
        self.checkBoxCallBack(sender);
    }
}
- (IBAction)commitAction:(UIButton *)sender {
    
    if (self.textView.text.exceptNull == nil) {
        [self endEditing:YES];
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
        [self.contentView makeToast:@"意见不能为空" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    
    if (self.textView.text.length > 200) {
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
        [self.contentView makeToast:@"反馈意见不能超过200字符" duration:2 position:CSToastPositionCenter style:style];
        return;
    }
    
    
    if (self.commitCallBack) {
        self.commitCallBack();
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
   
    NSString *lenthStr = [NSString stringWithFormat:@"%ld",(long)textView.text.length];
    
    if ([lenthStr intValue] > 200) {
        if (self.isShowTipMessage == YES) {
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
            [self.contentView makeToast:@"反馈意见不能超过200字符" duration:2 position:CSToastPositionCenter style:style];
            self.isShowTipMessage = NO;
        }
        self.label_count.text = [NSString stringWithFormat:@"%@/200",lenthStr];
        return;
    }else{
        self.isShowTipMessage = YES;
    }
    self.label_count.text = [NSString stringWithFormat:@"%@/200",lenthStr];
    
}
@end
