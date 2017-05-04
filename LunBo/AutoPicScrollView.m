//
//  AutoPicScrollView.m
//  AlipayDemo
//
//  Created by 段贤才 on 15/12/22.
//  Copyright © 2015年 段贤才. All rights reserved.
//

#import "AutoPicScrollView.h"
#import "ContentImageView.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <Masonry/Masonry.h>
#import "GoodsModel.h"

#define WIDTH self.bounds.size.width
#define HIGHT self.bounds.size.height
#define PAGECONTROL_WIDTH 200
#define PAGECONTROL_HIGHT 30
#define IMAGEVIEW_TAG 500
#define SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

@interface AutoPicScrollView()<UIScrollViewDelegate>{
    NSTimer *_timer;
}
@property (assign , nonatomic)NSInteger count;

@property (assign , nonatomic)CGFloat contentWidth;

@property (assign, nonatomic)NSInteger currentPage;

@property (strong, nonatomic)UIImage *defaultImage;

@end
@implementation AutoPicScrollView

- (instancetype)initWithFrame:(CGRect)frame andModels:(NSArray *)models defaultImage:(UIImage *)defaultImage{
    self = [super initWithFrame:frame];
    if (self) {
        self.defaultImage = defaultImage;
        [self prepareScrollView:models];
        [self preparePageControl];
        _pageControl.numberOfPages = models.count;
    }
    
    return self;
}

/**
 *  @author volient丶duan
 *
 *  初始化ScrollView
 */
- (void)prepareScrollView:(NSArray *)models{
    [self removeTimer];
    _count = models.count;
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    //隐藏水平方向滑动条
    _scrollView.showsHorizontalScrollIndicator = FALSE;
    [self addSubview:_scrollView];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake((models.count + 2) * WIDTH, 0);
    _scrollView.contentOffset = CGPointMake(WIDTH, 0);
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self prepareImageViewWithModels:models];
    [self prepareTimer];
    
}

/**
 *  @author volient丶duan
 *
 *  初始化pageControl
 */
- (void)preparePageControl{
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    [self addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 8));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        
    }];
}

- (void)prepareImageViewWithModels:(NSArray *)models{
    for (int i = 0; i < models.count ; i ++) {
        ContentImageView *imageView = [[ContentImageView alloc]initWithFrame:CGRectMake(WIDTH * (i+1), 0, WIDTH, HIGHT)];
        imageView.tag = IMAGEVIEW_TAG + i;
        imageView.userInteractionEnabled = YES;//允许添加用户交互手势
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClick:)];
        [imageView addGestureRecognizer:tap];
        //将数组的最后一张图设置到开头
        if (i == models.count - 1) {
            ContentImageView *firstImageView = [[ContentImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HIGHT)];
            firstImageView.contentMode = UIViewContentModeScaleAspectFill;
            firstImageView.tag = IMAGEVIEW_TAG + i;
            [_scrollView addSubview:firstImageView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClick:)];
            [firstImageView addGestureRecognizer:tap];
        }
        //将数组的第一张图设置到末尾
        else if(i == 0){
            ContentImageView *lastImageView = [[ContentImageView alloc]initWithFrame:CGRectMake(WIDTH * (_count + 1), 0, WIDTH, HIGHT)];
            lastImageView.contentMode = UIViewContentModeScaleAspectFill;
            lastImageView.tag = IMAGEVIEW_TAG + i;
            [_scrollView addSubview:lastImageView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClick:)];
            [lastImageView addGestureRecognizer:tap];
        }
        [imageView viewWithModel:models[i]];

    }

}
 /*  @author volient丶duan
 *
 *  初始化计时器
 */
- (void)prepareTimer{
    _currentPage = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(pageChange) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**
 *  @author volient丶duan
 *
 *  移除计时器
 */
- (void)removeTimer{
    [_timer invalidate];
    _timer = nil;
}

/**
 *  @author volient丶duan
 *
 *  计时器监听向右轮播
 */
- (void)pageChange{
    [_scrollView setContentOffset:CGPointMake((WIDTH * (_currentPage + 1)),0) animated:YES];
    _currentPage ++;
}
#pragma mark - 点击图片
- (void)imageViewClick:(UITapGestureRecognizer *)sender{
    NSInteger index = sender.view.tag - IMAGEVIEW_TAG;
    [self.delegate imageViewTouchDown:index];
    NSLog(@"这是第%ld个imageView",index + 1);
}
#pragma mark - ScrollVIewDelegate

//开始拖动时释放 timer
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

//停止拖动时初始化 timer
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self prepareTimer];
}
//滑动结束计算其在第几页
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = (int)(scrollView.contentOffset.x  / WIDTH);
    if (index == 0) {
        index = _count;
    }
    else if(index == _count + 1){
        index = 1;
    }
    _pageControl.currentPage = index - 1;
    _currentPage = index - 1;
}

//自动滚动到想要的位置(保持循环滚动)
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}
//减速停止时调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = (self.scrollView.contentOffset.x + WIDTH * 0.5) / WIDTH;
    if (index == _count + 1) {
        [self.scrollView setContentOffset:CGPointMake(WIDTH, 0) animated:NO];
        _currentPage = 0;
    } else if (index == 0) {
        [self.scrollView setContentOffset:CGPointMake(_count * WIDTH, 0) animated:NO];
        _currentPage = _count - 1;
    }
}
- (void)dealloc{
   [[SDImageCache sharedImageCache] clearDisk]; 
}
@end
