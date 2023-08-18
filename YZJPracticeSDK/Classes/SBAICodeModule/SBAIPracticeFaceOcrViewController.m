//
//  SBAIPracticeFaceOcrViewController.m
//  SBAIDemo
//
//  Created by 刘永吉 on 2023/5/11.
//

#import "SBAIPracticeFaceOcrViewController.h"

@interface SBAIPracticeFaceOcrViewController ()<WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic,strong) WKWebView *webview;

@end

@implementation SBAIPracticeFaceOcrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webview];
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideTop).offset(0);
        make.left.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom).offset(0);
    }];
    
    [self loaddata];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addScriptMessage];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeScriptMessage];
}

- (void) addScriptMessage{
    [self.webview.configuration.userContentController addScriptMessageHandler:self name:@"isInitEnd"];
}

- (void) removeScriptMessage{
    [self.webview.configuration.userContentController removeScriptMessageHandlerForName:@"isInitEnd"];
}

-(void)loaddata{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://t-power-test.aiyimaiche.com/faceApi/index.html"]];
    [self.webview loadRequest:request];
    
    //imgUrlChange()
}

#pragma mark ================ WKUIDelegate ================
// 获取js 里面的提示
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

// js 信息的交流
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 交互。可输入的文本。
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    //    H5 写法 window.prompt("getUserToken")
    if ([prompt isEqualToString:@"getToken"]) {
        completionHandler(@"");
        return;
    }

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未识别方法" message:@"JS调用输入框回值" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}


#pragma mark ================ WKScriptMessageHandler ================
//拦截执行网页中的JS方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    //服务器固定格式写法 window.webkit.messageHandlers.名字.postMessage(内容);
    //客户端写法 message.name isEqualToString:@"名字"]
    NSLog(@"didReceiveScriptMessage");
    if ([message.name isEqualToString:@"isInitEnd"]) {
        if (!tf_isEmptyObject(message.body)) {
            NSString *params = [NSString stringWithFormat:@"%@",message.body];
        }
    }
}

-(void)faceImage:(UIImage *)faceImg{
    NSData *data = UIImageJPEGRepresentation(faceImg, 0.8);
    NSLog(@"%ld",data.length);
    NSString *jsStr = [NSString stringWithFormat:@"imgUrlChange('%@%@')",@"data:image/png;base64,",[UIImageJPEGRepresentation(faceImg, 0.8) base64EncodedStringWithOptions: 0]];

    [self.webview evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"error:%@  response:%@",error,response);
    }];
}

-(void) getExpressionMap:(DictionaryBlock)block{
    NSString *jsStr = @"getFaceList()";

    [self.webview evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"error:%@  response:%@",error,response);
        if (block){
            block([response mj_JSONObject]);
        }
    }];
}

-(WKWebView *)webview{
    if (!_webview) {
        WKWebViewConfiguration *wbConfig = [[WKWebViewConfiguration alloc] init];
        //允许视频播放
        if (@available(iOS 9.0, *)) {
            wbConfig.allowsAirPlayForMediaPlayback = YES;
        }
        // 允许在线播放
        wbConfig.allowsInlineMediaPlayback = YES;
        // 允许可以与网页交互，选择视图
        wbConfig.selectionGranularity = YES;
        // web内容处理池
        wbConfig.processPool = [[WKProcessPool alloc] init];
        wbConfig.preferences.javaScriptCanOpenWindowsAutomatically = true;
        //是否⽀持JavaScript
        [wbConfig.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
        
        //自定义配置,一般用于 js调用oc方法(OC拦截URL中的数据做自定义操作)
        WKUserContentController * wkUserContentC = [[WKUserContentController alloc]init];
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        //        [wkUserContentC addScriptMessageHandler:self name:@"share"];
        wbConfig.userContentController = wkUserContentC;
        _webview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wbConfig];
        
        // 设置代理
        _webview.navigationDelegate = self;
        _webview.UIDelegate = self;

        //开启手势触摸
        _webview.allowsBackForwardNavigationGestures = NO;
        _webview.scrollView.showsVerticalScrollIndicator = NO;
        _webview.scrollView.showsHorizontalScrollIndicator = NO;
        
        if (@available(iOS 11.0, *)) {
            _webview.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _webview.backgroundColor = UIColor.whiteColor;
    
    }
    return _webview;
}
@end
