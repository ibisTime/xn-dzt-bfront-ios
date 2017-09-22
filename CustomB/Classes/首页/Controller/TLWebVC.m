//
//  TLWebVC.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/1/10.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "TLWebVC.h"
#import <WebKit/WebKit.h>
//#import "TLHeader.h"
#import "TLAlert.h"
#import "TLProgressHUD.h"

@interface TLWebVC ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation TLWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    
    WKWebView *webV = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webConfig];
    [self.view addSubview:webV];
    webV.navigationDelegate = self;
    
    NSURL *url = [[NSURL alloc] initWithString:self.url];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    
    [webV loadRequest:req];
    self.webView = webV;
    
}


- (void)viewDidLayoutSubviews {

    self.webView.frame = self.view.bounds;
    
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [TLProgressHUD dismiss];
    [TLAlert alertWithHUDText:@"加载失败"];
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD showWithStatus:nil];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [TLProgressHUD dismiss];
}

@end
