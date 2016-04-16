//
//  ImageBrowserViewController.m
//  WebViewImageBrower
//
//  Created by tunsuy on 6/4/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "ImageBrowserViewController.h"

#define kSeperateWidth 15

@interface ImageBrowserViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic) NSInteger index;

@property (nonatomic) CGFloat startOffsetX;
@property (nonatomic) CGFloat endOffsetX;
@property (nonatomic) CGPoint point;

@end

@implementation ImageBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _scrollView.backgroundColor = [UIColor grayColor];
    _scrollView.contentSize = CGSizeMake((_scrollView.frame.size.width+kSeperateWidth)*_images.count, self.scrollView.frame.size.height);
    
    [self.view addSubview:_scrollView];
    
    _scrollView.delegate = self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initData];
    [self generateContent];
    
}

- (void)initData{
    //    self.callback = ^(NSArray *images, NSInteger index){
    //        _images = images;
    //        _index = index;
    //    };
    
}

- (void)curImage:(NSArray *)images withIndex:(NSInteger)index{
    _images = images;
    _index = index;
}

- (void)generateContent{
    for (int i=0; i<_images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_scrollView.frame.size.width+kSeperateWidth)*i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        imageView.image = _images[i];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor grayColor];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeOrigPic:)];
        [imageView addGestureRecognizer:tapGest];
        imageView.tag = i;
        [self.scrollView addSubview:imageView];
    }
}

- (void)seeOrigPic:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    [UIApplication sharedApplication].statusBarHidden = YES;
    _scrollView.contentOffset = CGPointMake((_scrollView.frame.size.width+kSeperateWidth)*_index, 0);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    _endOffsetX = scrollView.contentOffset.x;
    if (_endOffsetX > _startOffsetX) {
        _point  = scrollView.contentOffset;
        NSLog(@"_endOffsetX %f (kSeperateWidth+kImageViewWidth) %d is : %d", _endOffsetX, (int)(kSeperateWidth+_scrollView.frame.size.width), (int)_endOffsetX/(int)(kSeperateWidth+_scrollView.frame.size.width));
        _point.x = (CGFloat)((((int)_endOffsetX/(int)(kSeperateWidth+_scrollView.frame.size.width))+1)*(kSeperateWidth+_scrollView.frame.size.width));
        NSLog(@"pointX is : %f", _point.x);
        
        //        if (_point.x+(_scrollView.frame.size.width+kSeperateWidth)*2 <= kImageCount*kImageViewWidth+(kImageCount+1)*kSeperateWidth) {
        scrollView.contentOffset = _point;
        //        }
        
    }
    else{
        _point  = scrollView.contentOffset;
        NSLog(@"_endOffsetX %f (kSeperateWidth+kImageViewWidth) %d is : %d", _endOffsetX, (int)(kSeperateWidth+_scrollView.frame.size.width), (int)_endOffsetX/(int)(kSeperateWidth+_scrollView.frame.size.width));
        _point.x = (CGFloat)(((int)_endOffsetX/(int)(kSeperateWidth+_scrollView.frame.size.width))*(kSeperateWidth+_scrollView.frame.size.width));
        NSLog(@"pointX is : %f", _point.x);
        
        //        if (_point.x-(kImageViewWidth+kSeperateWidth)*2 >= kImageCount*kImageViewWidth+(kImageCount+1)*kSeperateWidth) {
        scrollView.contentOffset = _point;
        //        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
