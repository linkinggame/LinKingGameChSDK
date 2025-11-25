
#import "LKFloatView.h"
#import <objc/runtime.h>
#import "LKGlobalConf.h"
#import "NSObject+LKUserDefined.h"
#import "UIImage+LKAdditions.h"
#import "NSBundle+LKResources.h"

#define NavBarBottom 64
#define TabBarHeight 49
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
static char kActionHandlerTapBlockKey;
static char kActionHandlerTapGestureKey;

@interface LKFloatView (){
      BOOL mIsHalfInScreen;
      dispatch_source_t _dispatchTimer;
}
@end
@implementation LKFloatView

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super initWithImage:image]) {
        self.userInteractionEnabled = YES;
        self.stayEdgeDistance = 5;
        self.stayAnimateTime = 0.3;
        [self initStayLocation];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[LKFloatView alloc] initWithImage:[UIImage lk_ImageNamed:@"float"]];
        self.userInteractionEnabled = YES;
        self.stayEdgeDistance = 5;
        self.stayAnimateTime = 0.3;
        [self initStayLocation];
    }
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 先让悬浮图片的alpha为1
    self.alpha = 1;
    // 获取手指当前的点
    UITouch * touch = [touches anyObject];
    CGPoint  curPoint = [touch locationInView:self];
    
    CGPoint prePoint = [touch previousLocationInView:self];
    
    // x方向移动的距离
    CGFloat deltaX = curPoint.x - prePoint.x;
    CGFloat deltaY = curPoint.y - prePoint.y;
    CGRect frame = self.frame;
    frame.origin.x += deltaX;
    frame.origin.y += deltaY;
    self.frame = frame;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self moveStay];
}


- (void)initStayLocation
{
    CGRect frame = self.frame;
    CGFloat stayWidth = self.image.size.width;
    CGFloat initX;

    if ([self lk_isLandscape]) {
        // 横屏：按刘海方向，放到安全那一侧
        BOOL safeLeft = [self lk_safeSideIsLeftInLandscape];
        if (safeLeft) {
            initX = self.stayEdgeDistance;
        } else {
            initX = kScreenWidth - self.stayEdgeDistance - stayWidth;
        }
    } else {
        // 竖屏：保持你原来的逻辑，吸在右边
        initX = kScreenWidth - self.stayEdgeDistance - stayWidth;
    }

    CGFloat initY = (kScreenHeight - NavBarBottom - TabBarHeight) * (2.0 / 3.0) + NavBarBottom;
    frame.origin.x = initX;
    frame.origin.y = initY;
    frame.size.width = stayWidth;
    frame.size.height = self.image.size.height;
    self.frame = frame;
    mIsHalfInScreen = YES;
}



- (void)moveStay
{
    bool isLeft = [self judgeLocationIsLeft];

    if ([self lk_isLandscape]) {
        // 横屏：无视当前位置，强制使用“安全侧”（与刘海相反的那边）
        isLeft = [self lk_safeSideIsLeftInLandscape];
    }

    switch (_stayMode) {
        case STAYMODE_LEFTANDRIGHT:
        {
            [self moveStayToMiddleInScreenBorder:isLeft];
        }
            break;
        case STAYMODE_LEFT:
        {
            if ([self lk_isLandscape]) {
                // 如果业务硬指定 LEFT，横屏时还是要保护一下：用安全侧
                BOOL safeLeft = [self lk_safeSideIsLeftInLandscape];
                [self moveToBorder:safeLeft];
            } else {
                [self moveToBorder:YES];
            }
        }
            break;
        case STAYMODE_RIGHT:
        {
            if ([self lk_isLandscape]) {
                BOOL safeLeft = [self lk_safeSideIsLeftInLandscape];
                [self moveToBorder:safeLeft];
            } else {
                [self moveToBorder:NO];
            }
        }
            break;
        default:
            break;
    }
}



- (void)moveToBorder:(BOOL)isLeft
{
    if ([self lk_isLandscape]) {
        // 横屏下始终覆盖成安全侧
        isLeft = [self lk_safeSideIsLeftInLandscape];
    }

    CGRect frame = self.frame;
    CGFloat destinationX;
    if (isLeft) {
        destinationX = self.stayEdgeDistance;
    }
    else {
        CGFloat stayWidth = frame.size.width;
        destinationX = kScreenWidth - self.stayEdgeDistance - stayWidth;
    }
    frame.origin.x = destinationX;
    frame.origin.y = [self moveSafeLocationY];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:_stayAnimateTime animations:^{
        __strong typeof(self) pThis = weakSelf;
        pThis.frame = frame;
    }];
    mIsHalfInScreen = NO;
}



- (CGFloat)moveSafeLocationY
{
    CGRect frame = self.frame;
    CGFloat stayHeight = frame.size.height;

    CGFloat curY = self.frame.origin.y;
    CGFloat destinationY = frame.origin.y;

    CGFloat stayMostTopY = NavBarBottom + _stayEdgeDistance;
    if (curY <= stayMostTopY) {
        destinationY = stayMostTopY;
    }
    CGFloat stayMostBottomY = kScreenHeight - TabBarHeight - _stayEdgeDistance - stayHeight;
    if (curY >= stayMostBottomY) {
        destinationY = stayMostBottomY;
    }
    return destinationY;
}

- (bool)judgeLocationIsLeft
{
    // 手机屏幕中间位置x值
    CGFloat middleX = [UIScreen mainScreen].bounds.size.width / 2.0;
    // 当前view的x值
    CGFloat curX = self.frame.origin.x + self.bounds.size.width/2;
    if (curX <= middleX) {
        return YES;
    } else {
        return NO;
    }
}


- (void)moveTohalfInScreenWhenScrolling
{
    bool isLeft = [self judgeLocationIsLeft];
    [self moveStayToMiddleInScreenBorder:isLeft];
    mIsHalfInScreen = YES;
}

- (void)moveStayToMiddleInScreenBorder:(BOOL)isLeft
{
    if ([self lk_isLandscape]) {
        // 横屏：半隐藏也只能在安全侧那边
        isLeft = [self lk_safeSideIsLeftInLandscape];
    }

    CGRect frame = self.frame;
    CGFloat stayWidth = frame.size.width;
    CGFloat destinationX;
    if (isLeft == YES) {
        destinationX = - stayWidth/2;
    }
    else {
        destinationX = kScreenWidth - stayWidth + stayWidth/2;
    }
    frame.origin.x = destinationX;
    frame.origin.y = [self moveSafeLocationY];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        __strong typeof(self) pThis = weakSelf;
        pThis.frame = frame;
    }];
    mIsHalfInScreen = YES;
}


- (void)setCurrentAlpha:(CGFloat)stayAlpha
{
    if (stayAlpha <= 0) {
        stayAlpha = 1;
    }
    self.alpha = stayAlpha;
}


- (void)setTapActionWithBlock:(void (^)(void))block
{
    // 为gesture添加关联是为了gesture只创建一次，objc_getAssociatedObject如果返回nil就创建一次
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerTapGestureKey);
    
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        void(^action)(void) = objc_getAssociatedObject(self, &kActionHandlerTapBlockKey);
        if (action)
        {
            self.alpha = 1;
            if (mIsHalfInScreen == NO) {
                 bool isLeft = [self judgeLocationIsLeft];
                action();
                [self moveToBorder:isLeft];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self moveStay];
//                });

            }
            else {
                 bool isLeft = [self judgeLocationIsLeft];
                [self moveToBorder:isLeft];
                //[self moveStay];
            }
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self moveStay];
//            });
            [self delayTime];
        }
    }
}
- (void)delayTime{
  
    if (_dispatchTimer) {
        dispatch_source_cancel(_dispatchTimer);
        _dispatchTimer = nil;
    }

    // 队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 创建 dispatch_source
    _dispatchTimer  = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 设置触发时间
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC);
    // 设置下次触发事件为 DISPATCH_TIME_FOREVER
    dispatch_time_t nextTime = DISPATCH_TIME_FOREVER;
    // 设置精确度
    dispatch_time_t leeway = 0.1 * NSEC_PER_SEC;
    // 配置时间
    dispatch_source_set_timer(_dispatchTimer, startTime, nextTime, leeway);
    // 回调
     __weak typeof(self)weakSelf = self;
    dispatch_source_set_event_handler(_dispatchTimer, ^{
        __strong typeof(self)strongSelf = weakSelf;
        [strongSelf moveStay];
        dispatch_source_cancel(strongSelf->_dispatchTimer);
        strongSelf->_dispatchTimer = nil;
    });
    // 激活
    dispatch_resume(_dispatchTimer);
}

- (void)setImageWithName:(NSString *)imageName
{
    self.image = [UIImage lk_ImageNamed:imageName];
}

#pragma mark - Orientation / Notch Helpers

- (UIWindow *)lk_mainWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows.firstObject;
    }
    return window;
}

// 取当前界面的 UIInterfaceOrientation（注意不是 UIDeviceOrientation）
- (UIInterfaceOrientation)lk_interfaceOrientation {
    UIInterfaceOrientation orientation = UIInterfaceOrientationUnknown;
    if (@available(iOS 13.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window) {
            window = [UIApplication sharedApplication].windows.firstObject;
        }
        if ([window.windowScene isKindOfClass:[UIWindowScene class]]) {
            orientation = window.windowScene.interfaceOrientation;
        }
    } else {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        orientation = [UIApplication sharedApplication].statusBarOrientation;
    #pragma clang diagnostic pop
    }
    return orientation;
}


- (BOOL)lk_isLandscape {
    UIInterfaceOrientation o = [self lk_interfaceOrientation];
    return UIInterfaceOrientationIsLandscape(o);
}

// 是否是带刘海的机型（简单用 safeArea 顶部大于 20 来判断）
- (BOOL)lk_hasNotch {
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [self lk_mainWindow];
        UIEdgeInsets insets = window.safeAreaInsets;
        return insets.top > 20.0;
    }
    return NO;
}

/**
 * 在横屏时，返回“安全侧”是不是左边：
 * YES  = 左边安全
 * NO   = 右边安全
 *
 * 这里直接用你实测的规律：
 *  - 刘海在左：UIInterfaceOrientationLandscapeRight
 *  - 刘海在右：UIInterfaceOrientationLandscapeLeft
 */
- (BOOL)lk_safeSideIsLeftInLandscape {
    UIInterfaceOrientation o = [self lk_interfaceOrientation];

    if (!UIInterfaceOrientationIsLandscape(o)) {
        // 竖屏：走原来的逻辑，按当前位置判断左右
        return [self judgeLocationIsLeft];
    }

    if (o == UIInterfaceOrientationLandscapeRight) {
        // 刘海在左 -> 右侧安全
        return NO;
    } else if (o == UIInterfaceOrientationLandscapeLeft) {
        // 刘海在右 -> 左侧安全
        return YES;
    }

    // 理论上不会到这，兜底用当前位置
    return [self judgeLocationIsLeft];
}



@end
