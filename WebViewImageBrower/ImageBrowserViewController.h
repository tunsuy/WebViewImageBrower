//
//  ImageBrowserViewController.h
//  WebViewImageBrower
//
//  Created by tunsuy on 6/4/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageBrowserViewController : UIViewController

@property (nonatomic, strong) void (^callback)(NSArray *,NSInteger);

- (void)curImage:(NSArray *)images withIndex:(NSInteger)index;

@end
