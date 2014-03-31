//
//  TestViewController.m
//  TestScrollLazy
//
//  Created by xiejc on 14-3-25.
//  Copyright (c) 2014年 xiejc. All rights reserved.
//

# define CACHE_COUNT 2

#import "TestViewController.h"

@interface TestViewController ()

@property (nonatomic, strong) NSArray *imageList;
@property (nonatomic, strong) NSMutableArray *imageViewList;

@end

@implementation TestViewController
@synthesize imageScrollView;
@synthesize imageList;
@synthesize imageViewList;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageList = [NSArray arrayWithObjects:@"test1", @"test2", @"test3", @"test4", @"test5", @"test6", nil];
    imageScrollView.delegate = self;
    imageScrollView.pagingEnabled= YES;
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.showsVerticalScrollIndicator = NO;
    imageScrollView.contentSize = CGSizeMake(imageScrollView.frame.size.width * imageList.count, 0);
    self.imageViewList = [NSMutableArray array];
    for (int i=0; i<imageList.count; i++) {
        [imageViewList addObject:[NSNull null]];
    }
    [self loadPageView:0];
    [self loadPageView:1];
}

- (void)loadPageView:(int)page {
    if (page <0 || page >= imageList.count) {
        return;
    }
    if ([imageViewList objectAtIndex:page] != [NSNull null]) {
        return;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageScrollView.frame.size.width * page, 0,
                                                                           imageScrollView.frame.size.width, imageScrollView.frame.size.height)];
    imageView.image = [UIImage imageNamed:[imageList objectAtIndex:page]];
    [imageViewList replaceObjectAtIndex:page withObject:imageView];
    [imageScrollView addSubview:imageView];
}

- (void)removePageView:(int)page {
    if (page <0 || page >= imageViewList.count) {
        return;
    }
    if ([imageViewList objectAtIndex:page] == [NSNull null]) {
        return;
    }
    UIImageView *imageView = [imageViewList objectAtIndex:page];
    imageView.image = nil;
    [imageViewList replaceObjectAtIndex:page withObject:[NSNull null]];
    [imageView removeFromSuperview];
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    scrollView.scrollEnabled = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self loadPageView:page];
    [self loadPageView:page + 1];
    [self loadPageView:page - 1];
    [self removePageView:page - 2];
    [self removePageView:page + 2];

    scrollView.scrollEnabled = YES;
}

@end
