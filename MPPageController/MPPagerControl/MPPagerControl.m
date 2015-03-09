//
// Created by Michal Piwowarczyk on 07.03.15.
// Copyright (c) 2015 Allianz. All rights reserved.
//

#import "MPPagerControl.h"
#import "MPTitleCollectionView.h"


#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

@interface MPPagerControl () <UIScrollViewDelegate, MPTitleCollectionViewDelegate>

@property (nonatomic, strong) NSArray  * viewControllers;
@property (nonatomic, strong) UIScrollView    * scrollView;
@property (nonatomic, strong) MPTitleCollectionView *titleCollectionView;
@property (nonatomic, assign) BOOL isScrolling;

@property (nonatomic, assign) CGFloat scaleTransform;
@property (nonatomic, assign) BOOL scaleTransformEnabled;

@end


@implementation MPPagerControl

- (instancetype)initWithNavBarBackground:(UIColor*)navBarBackground
                               textColor:(UIColor*)textColor
                         viewControllers:(NSArray*)viewControllers
                          scaleTransform:(CGFloat)scaleTransform {
    self = [self initWithNavBarBackground:navBarBackground textColor:textColor viewControllers:viewControllers];
    if(self){
        if(scaleTransform>0.0f && scaleTransform<1.0f){
            self.scaleTransformEnabled = YES;
            self.scaleTransform = scaleTransform;
        }
    }
    return self;
}

- (instancetype)initWithNavBarBackground:(UIColor*)navBarBackground
                               textColor:(UIColor*)textColor
                         viewControllers:(NSArray*)viewControllers {
    if([super init]){
        self.viewControllers = viewControllers;
        self.titleCollectionView.backgroundColor = navBarBackground;
        self.titleCollectionView.textColor = textColor;
        self.scaleTransformEnabled = NO;
    }
    return self;
}

#pragma mark - life cycle

- (void)loadView {
    [super loadView];
    [self.navigationController.navigationBar setHidden:NO];
    [self.view addSubview:self.scrollView];
    [self loadViews];

    [self.navigationController.navigationBar addSubview:self.titleCollectionView];
}

- (void)dealloc {
    [self unloadViews];
    self.scrollView.delegate =  nil;
}

#pragma mark - custom getters

- (MPTitleCollectionView*)titleCollectionView {
    if(!_titleCollectionView){
        NSMutableArray *titlesArray = [[NSMutableArray alloc] init];
        for(UIViewController * controller in self.viewControllers){
            [titlesArray addObject:controller.title];
        }
        _titleCollectionView = [[MPTitleCollectionView alloc] initWithFrame:(CGRect){0, 0, SCREEN_SIZE.width, 44} titlesArray:titlesArray];
        _titleCollectionView.titleViewDelegate = self;

    }
    return _titleCollectionView;
}

- (UIScrollView*)scrollView {
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame]; 
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
       // _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return _scrollView;
}

#pragma mark MPTitleCollectionViewDelegate

- (void)titleView:(MPTitleCollectionView*)titleView didMoveToIndexPatch:(NSIndexPath*)indexPath {
    [self scrollToPageAtIndex:indexPath];
}

#pragma mark Private methods

- (void)unloadViews {
    if(self.viewControllers) {
        for (UIViewController *viewController in self.viewControllers) {
            [viewController removeFromParentViewController];
            [viewController.view removeFromSuperview];
        }
    }
}

- (void)loadViews {
    for(NSInteger i = 0; i<[self.viewControllers count]; i++){
        UIViewController * viewController = [self.viewControllers objectAtIndex:i];
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = i * CGRectGetWidth(self.scrollView.bounds);
        viewController.view.frame = frame;
        [self addChildViewController:viewController];
        [self.scrollView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
    }

    CGFloat width = CGRectGetWidth(self.scrollView.bounds) * [self.viewControllers count];
    CGFloat height = CGRectGetHeight(self.scrollView.bounds);
    self.scrollView.contentSize = CGSizeMake(width, height);
}

#pragma mark ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self applyScaleTransfromWithOffset:scrollView.contentOffset.x];
    if([scrollView isEqual:self.scrollView] && !self.isScrolling){
        [self.titleCollectionView pageViewDidScroll:scrollView];
    }
}

- (void)scrollToPageAtIndex:(NSIndexPath*)indexPath{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if(page!=indexPath.row){
        [UIView animateWithDuration:0.35
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.isScrolling = YES;
                             [self.scrollView scrollRectToVisible:CGRectMake(indexPath.row*self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height) animated:NO];
                         }
                         completion:^(BOOL finished) {
                             self.isScrolling = NO;
                         }];
    }
}

- (void)applyScaleTransfromWithOffset:(CGFloat)offset {
    if (self.scaleTransformEnabled)  {
        for (UIViewController *viewController in self.viewControllers) {
            NSInteger index = [self.viewControllers indexOfObject:viewController];
            CGFloat width = self.scrollView.bounds.size.width;
            CGFloat y = index * width;
            CGFloat value = (offset-y)/width;
            CGFloat scale = 1.f-fabs(value);
            if (scale > 1.f) scale = 1.f;
            if (scale < self.scaleTransform) scale = self.scaleTransform;
            
            viewController.view.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
}

@end