//
//  AutoPicScrollView.h
//  AlipayDemo
//
//  Created by 段贤才 on 15/12/22.
//  Copyright © 2015年 段贤才. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AutoPicDelegate<NSObject>
- (void)imageViewTouchDown:(NSInteger)index;
@end
@interface AutoPicScrollView : UIView
@property (strong , nonatomic)UIScrollView *scrollView;
@property (strong , nonatomic)UIPageControl *pageControl;

@property (assign,nonatomic)id<AutoPicDelegate>delegate;
- (instancetype)initWithFrame:(CGRect)frame andModels:(NSArray*) models defaultImage:(UIImage *)defaultImage;
@end
