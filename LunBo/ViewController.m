//
//  ViewController.m
//  LunBo
//
//  Created by Aron on 2017/5/3.
//  Copyright © 2017年 XSService. All rights reserved.
//

#import "ViewController.h"
#import "AutoPicScrollView.h"
#import "GoodsModel.h"
#import "DetailViewController.h"
//屏幕的宽高
#define SCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
@interface ViewController ()<AutoPicDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *pics = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1493807582998&di=c835bfd5e48480aa24817846ca00d74b&imgtype=0&src=http%3A%2F%2Fp5.zbjimg.com%2Ftask%2F2011-06%2F18%2F830578%2Flarge4dfc39051bb08.png", @"http://d.lanrentuku.com/down/png/1308/maximal_icons_png/chrome.png", @"http://attach.bbs.miui.com/forum/201704/15/065614ynk3in9yqtik8qss.jpg", @"http://pic1.win4000.com/wallpaper/0/58fda86844cec.jpg"];
    NSArray *times = @[@"15616516", @"165164", @"84169814651", @"8498941651561"];
    NSMutableArray *models = [NSMutableArray new];
    for (int i = 0; i<4; i++) {
        GoodsModel *model = [[GoodsModel alloc]init];
        model.title = @"限时特价";
        model.time = times[i];
        model.picUrl = pics[i];
        model.name = @"南瓜";
        model.money = @"¥58";
        model.weight = @"9两";
        model.number = @"已售1561件";
        [models addObject:model];
    }
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    AutoPicScrollView *autoSV = [[AutoPicScrollView alloc]initWithFrame:CGRectMake(50, 100, SCREEN_WIDTH/2, 221) andModels:models defaultImage:nil];
    autoSV.delegate = self;
    [self.view addSubview:autoSV];
}
- (void)imageViewTouchDown:(NSInteger)index {
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    detailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:detailVC animated:YES];
//    [self presentViewController:detailVC animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
