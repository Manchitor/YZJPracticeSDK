//
//  ERViewDefine.h
//  ElectricRoom
//
//  Created by 刘永吉 on 2022/5/25.
//

#ifndef ERViewDefine_h
#define ERViewDefine_h

#import <WebKit/WebKit.h>

static inline  UITableView * _Nonnull TABLEVIEW_INIT(UITableViewStyle style, id _Nullable classView) {\
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];\
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;\
    tableView.delegate = classView;\
    tableView.dataSource = classView;\
    tableView.backgroundColor = [UIColor clearColor];\
    tableView.estimatedRowHeight = 44.f;\
    tableView.estimatedSectionHeaderHeight = 0;\
    tableView.estimatedSectionFooterHeight = 0;\
    tableView.rowHeight = UITableViewAutomaticDimension;\
    if (@available(iOS 11.0, *)) {\
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;\
    } else {\
        // Fallback on earlier versions
    }\
    return tableView;\
}

static inline UICollectionView * _Nonnull COLLECTIONVIEW_INIT(UICollectionViewLayout * _Nullable flowlLayout, id _Nullable classView) {\
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlLayout];\
    collectionView.delegate = classView;\
    collectionView.dataSource = classView;\
    collectionView.backgroundColor = [UIColor clearColor];\
    return collectionView;\
}

static inline WKWebView * _Nonnull WEBVIEW_INIT(id _Nullable classView) {
    WKWebViewConfiguration *wbConfig = [[WKWebViewConfiguration alloc] init];
    //允许视频播放
    if (@available(iOS 9.0, *)) {
        wbConfig.allowsAirPlayForMediaPlayback = YES;
    } else {
        // Fallback on earlier versions
    }
    // 允许在线播放
    wbConfig.allowsInlineMediaPlayback = YES;
    // 允许可以与网页交互，选择视图
    wbConfig.selectionGranularity = WKSelectionGranularityDynamic;
    // web内容处理池
    wbConfig.processPool = [[WKProcessPool alloc] init];
    //自定义配置,一般用于 js调用oc方法(OC拦截URL中的数据做自定义操作)
    WKUserContentController * wkUserContentC = [[WKUserContentController alloc]init];
    // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
    //        [wkUserContentC addScriptMessageHandler:self name:@"share"];
    wbConfig.userContentController = wkUserContentC;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wbConfig];
    //代理
    webView.UIDelegate = classView;
    webView.navigationDelegate = classView;
    //开启手势触摸
    webView.allowsBackForwardNavigationGestures = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return webView;
}


#endif /* ERViewDefine_h */
