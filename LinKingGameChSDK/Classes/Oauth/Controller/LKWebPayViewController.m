//
//  LKWebPayViewController.m
//  LinKingSDK
//
//  Created by leon on 2022/4/24.
//  Copyright © 2022 dml1630@163.com. All rights reserved.
//

#import "LKWebPayViewController.h"
#import <WebKit/WebKit.h>
#import "LKSystem.h"
#import "LKUser.h"
#import "MF_Base64Additions.h"
#import "NSObject+LKUserDefined.h"
#import "LKSDKConfig.h"
#import "LKLog.h"
@interface LKWebPayViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, copy  ) NSString *redirectUrl;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation LKWebPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(htmlPayment:) name:@"htmlPaymentNotification" object:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeVC)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor whiteColor];
  
    NSMutableString *stringbuffer = [NSMutableString string];
    
    LKSystem *system = [LKSystem getSystem];
    LKLogInfo(@"---->%@",system.appID);

    [stringbuffer appendString:[NSString stringWithFormat:@"game_id=%@",system.appID]];

    [stringbuffer appendString:[NSString stringWithFormat:@"&cp_order_no=%@",self.parames[@"cp_order_no"]]];
    [stringbuffer appendString:[NSString stringWithFormat:@"&product_id=%@",self.parames[@"product_id"]]];
    [stringbuffer appendString:[NSString stringWithFormat:@"&product_desc=%@",self.parames[@"product_desc"]]];
    //[stringbuffer appendString:[NSString stringWithFormat:@"&amount=%@",@"0.01"]];
    [stringbuffer appendString:[NSString stringWithFormat:@"&amount=%@",self.parames[@"amount"]]];
    [stringbuffer appendString:[NSString stringWithFormat:@"&server_id=%@",self.parames[@"server_id"]]];
    [stringbuffer appendString:[NSString stringWithFormat:@"&role_id=%@",self.parames[@"role_id"]]];
    LKUser *user =[LKUser getUser];
    [stringbuffer appendString:[NSString stringWithFormat:@"&user_id=%@",user.userId]];
    NSString *extra = self.parames[@"extra"];
    if (extra.exceptNull != nil) {
        [stringbuffer appendString:[NSString stringWithFormat:@"&extra=%@",extra]];
    }
    LKSDKConfig *config = [LKSDKConfig getSDKConfig];
    
    if (config.webPayBaseUrl.exceptNull != nil) {

        LKLogInfo(@">>>>> %@", config.webPayBaseUrl);
        [stringbuffer appendString:[NSString stringWithFormat:@"&return_url=https://payh5-app.chiji-h5.com/close"]];
        [stringbuffer appendString:[NSString stringWithFormat:@"&notify_url=%@",self.parames[@"notify_url"]]];
        
        LKLogInfo(@"stringbuffer= %@", stringbuffer);
        NSString * order_id = [stringbuffer base64String];
        
        // https://payh5-app.chiji-h5.com/index.php/index/app/pay2
        // https://payh5-app.chiji-h5.com/index.php/index/app/pay
        NSString *url = [NSString stringWithFormat:@"%@?order=%@",@"https://payh5-app.chiji-h5.com/index.php/index/app/pay2",order_id];
        //NSString *url = [NSString stringWithFormat:@"%@?order=%@",@"https://shop-dev.chiji-h5.com/home/file/test3.html", order_id];
        
        LKLogInfo(@"url= %@", url);
        
        [self loadWebView:url];
    }
    
    [self addProgressView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)htmlPayment:(NSNotification *)notificationt {
    if (self.payHandler) {
        self.payHandler(-1);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@">>>>>>>>>>>viewwillappear==================");
    
}

- (void)addProgressView {
    //进度条初始化
       self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)+44, [[UIScreen mainScreen] bounds].size.width, 2)];
       self.progressView.backgroundColor = [UIColor blueColor];
       //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
       self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
       [self.view addSubview:self.progressView];
}

- (void)closeVC {
    
    if (self.payHandler) {
        self.payHandler(-1);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)loadWebView:(NSString *)url {
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    self.webView = webView;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURLRequest *request = navigationAction.request;
    NSString *absoluteString = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    NSLog(@">>>>>>>>>>>%@",absoluteString);
    if (!self.redirectUrl) {
       if ([absoluteString hasPrefix:@"https://openapi.alipay.com"]) {
           self.redirectUrl = [self getURLParam:navigationAction.request.URL.absoluteString key:@"return_url"];
       }
       if ([absoluteString hasPrefix:@"https://wx.tenpay.com"]) {
           self.redirectUrl = [self getURLParam:navigationAction.request.URL.absoluteString key:@"redirect_url"];
       }
    }
    if ([navigationAction.request.URL.scheme isEqualToString:@"alipay"]) {
            //  1.以？号来切割字符串
            NSArray *urlBaseArr = [navigationAction.request.URL.absoluteString componentsSeparatedByString:@"?"];
            NSString *urlBaseStr = urlBaseArr.firstObject;
            NSString *urlNeedDecode = urlBaseArr.lastObject;
            //  2.将截取以后的Str，做一下URLDecode，方便我们处理数据
            NSMutableString *afterDecodeStr = [NSMutableString stringWithString:[self urlDecodeString:urlNeedDecode]];
            //  3.替换里面的默认Scheme为自己的Scheme
            NSString *afterHandleStr = [afterDecodeStr stringByReplacingOccurrencesOfString:@"alipays" withString:@"alipayreturn.company.com"];
            //  4.然后把处理后的，和最开始切割的做下拼接，就得到了最终的字符串
            NSString *finalStr = [NSString stringWithFormat:@"%@?%@",urlBaseStr, [self urlEncodeString:afterHandleStr]];

            //  判断一下，是否安装了支付宝APP
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:finalStr]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalStr]];
                
                [NSThread sleepForTimeInterval:1.0];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                NSLog(@"未安装支付宝，请先安装支付宝!");
//                [KKBUtility showHUDError:@"未安装支付宝，请先安装支付宝!"];
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }
        }
        // 拦截WKWebView加载的微信支付统一下单链接, 将redirect_url参数修改为唤起自己App的URLScheme
        NSString *domainUrl = @"payh5-app.chiji-h5.com://wxpaycallback/";
        //NSString *domainUrl = @"https://payh5-app.chiji-h5.com/close";
        //NSString *domainUrl = @"https%3A%2F%2Fpayh5-app.chiji-h5.com%2Fclose";
        
        //NSCharacterSet *encodeSet = [NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"];
        //NSString *domainUrl = [domainUrl2 stringByAddingPercentEncodingWithAllowedCharacters:encodeSet];//编码
        //NSLog([NSString stringWithFormat:@"redirect_url=%@", domainUrl]);
    
        if ([absoluteString hasPrefix:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb"] && ![absoluteString hasSuffix:[NSString stringWithFormat:@"redirect_url=%@",domainUrl]]) {
            NSString *redirectUrl = nil;
            if ([absoluteString containsString:@"redirect_url="]) {
                NSRange redirectRange = [absoluteString rangeOfString:@"redirect_url"];
                redirectUrl = [[absoluteString substringToIndex:redirectRange.location] stringByAppendingString:[NSString stringWithFormat:@"redirect_url=%@",domainUrl]];
            } else {
                redirectUrl = [absoluteString stringByAppendingString:[NSString stringWithFormat:@"redirect_url=%@",domainUrl]];
            }
            NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirectUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
            newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
            newRequest.URL = [NSURL URLWithString:redirectUrl];
            [webView loadRequest:newRequest];
        }

        //拦截重定向的跳转微信的 URL Scheme, 打开微信
        if ([absoluteString hasPrefix:@"weixin://"]) {
            if ([[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL]) {
                [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
                
                [NSThread sleepForTimeInterval:1.0];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                NSLog(@"未安装微信，请先安装微信!");
                decisionHandler(WKNavigationActionPolicyCancel);
                
                //[NSThread sleepForTimeInterval:1.0];
                //[self dismissViewControllerAnimated:YES completion:nil];
                
                return;
            }
        }
        
        /*if ([absoluteString hasPrefix:@"https://payh5-app.chiji-h5.com/close"]) {
            if (self.payHandler) {
                self.payHandler(0);
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }*/
        
        decisionHandler(WKNavigationActionPolicyAllow);
    
}

- (NSString *)getURLParam:(NSString *)url key:(NSString *)key {
    NSMutableDictionary *paramer = [[NSMutableDictionary alloc]init];
    //创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url];
    //遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [paramer setObject:obj.value forKey:obj.name];
    }];
    return [paramer objectForKey:key];
}


- (NSString *)urlEncodeString:(NSString *)urlSting {
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@";
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";

    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];

    static NSUInteger const batchSize = 50;

    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;

    while (index < urlSting.length) {
        NSUInteger length = MIN(urlSting.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);

        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [urlSting rangeOfComposedCharacterSequencesForRange:range];

        NSString *substring = [urlSting substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];

        index += range.length;
    }

    return escaped;
}

- (NSString *)urlDecodeString:(NSString *)urlStr {
    NSMutableString *outputStr = [NSMutableString stringWithString:urlStr];
    [outputStr replaceOccurrencesOfString:@"+" withString:@"" options:NSLiteralSearch range:NSMakeRange(0,[outputStr length])];
    return [outputStr stringByRemovingPercentEncoding];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        LKLogInfo(@">>>>>%lf",self.progressView.progress);
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;

            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
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
