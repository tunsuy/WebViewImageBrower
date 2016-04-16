//
//  ViewController.m
//  WebViewImageBrower
//
//  Created by tunsuy on 6/4/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "ViewController.h"
#import "ImageBrowserViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSArray *webViewImages;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height)];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://kd77.cn/help/AddUsers.html"]]];
    _webView.userInteractionEnabled = YES;
    _webView.dataDetectorTypes = UIDataDetectorTypeLink;
    [self.view addSubview:_webView];
    
    _webView.delegate = self;
    
}

- (NSString *)jsCodeFromJsFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"webViewImage" ofType:@"js"];
    NSError *error;
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    return jsCode;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *imagesUrl = [self imagesUrl:webView];
//    NSLog(@"imagesUrl is %@", imagesUrl);
    
//test:
    NSString *test = [webView stringByEvaluatingJavaScriptFromString:@"setImages();"];
    NSLog(@"test is %@", test);
    
//去重：nsset会打乱顺序
//    NSSet *set = [NSSet setWithArray:[imagesUrl componentsSeparatedByString:@","]];
//    _webViewImages = [set allObjects];
    
//去重：NSMutableDictionary不会打乱顺序
    NSArray *arr = [imagesUrl componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSNumber *number in arr) {
        [dic setObject:number forKey:number];
    }
    _webViewImages = [dic allValues];
    
//    第二种：利用jscore框架
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"imageClick"] = ^{
        JSValue *value = [JSContext currentArguments][0];
        
        NSInteger imageIndex = [[value toNumber] integerValue];
        ImageBrowserViewController *imageBrowserVC = [[ImageBrowserViewController alloc] init];
        NSArray *webViewImages = [self webViewImages];
        [imageBrowserVC curImage:webViewImages withIndex:imageIndex];
        [self presentViewController:imageBrowserVC animated:YES completion:nil];
    };
}

- (void)addJsCode {
    NSString *jsCode = [self jsCodeFromJsFile];
    [_webView stringByEvaluatingJavaScriptFromString:jsCode];
}

- (NSString *)imagesUrl:(UIWebView *)webView {
    [self addJsCode];
    return [webView stringByEvaluatingJavaScriptFromString:@"getAllImageUrl();"];
}

- (NSArray *)webViewImages {
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSString *urlStr in _webViewImages) {
        NSURL *imageUrl = [NSURL URLWithString:urlStr];
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        [images addObject:image];
    }
    return images;
}

//js调用oc代码
//第一种：通过在js文件中设置document.location=url，然后再该回调方法中获取
//注：不起作用（还没找到原因）
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSString *requestString = [[request URL] absoluteString];
//    NSArray *urlComponents = [requestString componentsSeparatedByString:@"::"];
//    if ([urlComponents[0] isEqualToString:@"com.sangfor.pocket"]) {
//        NSUInteger imageIndex = [urlComponents[1] integerValue];
//        ImageBrowserViewController *imageBrowserVC = [[ImageBrowserViewController alloc] init];
//        NSArray *webViewImages = [self webViewImages];
//        [imageBrowserVC curImage:webViewImages withIndex:imageIndex];
//        [self presentViewController:imageBrowserVC animated:YES completion:nil];
//    }
//    return YES;
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
