//
// Created by Michal Piwowarczyk on 07.03.15.
// Copyright (c) 2015 Allianz. All rights reserved.
//

#import "MPTitleCollectionView.h"
#import "MPTitleViewFlowLayout.h"
#import "MPTitleCollectionViewCell.h"

static float itemSpacing      = 15.0f;
static float minimumTitleSize = 80.0f;
static

@interface MPTitleCollectionView ()
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) MPTitleViewFlowLayout *titleFlowLayout;
@property (nonatomic) CGFloat lastContentOffset;
@property (nonatomic) NSInteger currentTitleIndex;
@property (nonatomic, getter = isScrolling) BOOL scrolling;
@property (nonatomic, assign)  CGFloat frameWidth;

@end

@implementation MPTitleCollectionView

- (CGFloat)frameWidth {
   return CGRectGetWidth(self.bounds);
}

- (id)initWithFrame:(CGRect)frame titlesArray:(NSArray*)titlesArray
{
    self = [super initWithFrame:frame collectionViewLayout:self.titleFlowLayout];
    if (self) {
        
        { //setup layout
            NSString *firstTitle = [self.titlesArray firstObject];
            NSString *lastTitle = [self.titlesArray lastObject];
            
            CGSize firstTitleSize = [self sizeForIndexPath:[NSIndexPath indexPathForItem:[self.titlesArray indexOfObject:firstTitle] inSection:0]];
            CGSize lastTitleSize = [self sizeForIndexPath:[NSIndexPath indexPathForItem:[self.titlesArray indexOfObject:lastTitle] inSection:0]];
            
            if(firstTitleSize.width < minimumTitleSize) firstTitleSize.width = minimumTitleSize;
            if(lastTitleSize.width < minimumTitleSize) lastTitleSize.width = minimumTitleSize;
            
            self.titleFlowLayout.sectionInset = UIEdgeInsetsMake(0, (self.frameWidth-firstTitleSize.width)/2, 0, (self.frameWidth-lastTitleSize.width)/2);
        }
       
        self.titlesArray                    = titlesArray;
        self.clipsToBounds                  = YES;
        self.backgroundColor                = [UIColor clearColor];
        self.dataSource                     = self;
        self.delegate                       = self;
        self.decelerationRate               = UIScrollViewDecelerationRateFast;
        self.showsVerticalScrollIndicator   = NO;
        self.showsHorizontalScrollIndicator = NO;
    
        [self registerClass:[MPTitleCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    }
    return self;
}

- (void)applicationWillResignActive
{
    [self setCurrentPageIndex:self.currentTitleIndex];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.delegate = nil;
    self.dataSource = nil;
    self.titleViewDelegate = nil;
}

-(MPTitleViewFlowLayout *)titleFlowLayout{
    if (!_titleFlowLayout) {
        _titleFlowLayout                         = [[MPTitleViewFlowLayout alloc] init];
        _titleFlowLayout.minimumInteritemSpacing = itemSpacing;
        [_titleFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    }
    return _titleFlowLayout;
}

#pragma mark - Public methods

- (void)setCurrentPageIndex:(NSInteger)pageIndex {
    self.currentTitleIndex = pageIndex;
    [self  scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:pageIndex inSection:0]
                  atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)reloadTitlesWithArray:(NSArray*)titlesArray{
    if(titlesArray){
        self.titlesArray = titlesArray;
        [self reloadData];
    }
}

#pragma mark - CollectionView data source & delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.titlesArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MPTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.titleLabel.text = self.titlesArray[indexPath.row];
    cell.titleLabel.textColor = self.textColor;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self sizeForIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self  scrollToItemAtIndexPath:indexPath
                  atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([scrollView isEqual:self] && !self.isScrolling){
        [self titleViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if([scrollView isEqual:self] && !self.isScrolling){
        [self titleViewDidScroll:scrollView];
    }
}

#pragma mark - calculation methods

- (CGSize)sizeForIndexPath:(NSIndexPath*)indexPath{
    NSString *text = self.titlesArray[indexPath.row];
    
    CGSize maxSize          = self.frame.size;
    CGSize expectedLabelSize = [text boundingRectWithSize:maxSize
                                                  options:NSStringDrawingUsesFontLeading
                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    expectedLabelSize.width += 3;
    expectedLabelSize.height = 44;
    if(expectedLabelSize.width < minimumTitleSize) expectedLabelSize.width = minimumTitleSize;
    return expectedLabelSize;
}


- (void)pageViewDidScroll:(id)sender{
    if([sender  isKindOfClass:[UIScrollView class]]){
        UIScrollView *scrollView = (UIScrollView*)sender;
        
        if (self.lastContentOffset == scrollView.contentOffset.x) {
            return;
        }
        
        self.lastContentOffset  = scrollView.contentOffset.x;
        CGFloat pageWidth       = CGRectGetWidth(scrollView.frame);
        CGFloat percentage      = ((int)scrollView.contentOffset.x % (int)pageWidth)/pageWidth;
        
        [self scrollWithPercentage:percentage currentPage:[self getCurrentPageFromScrollView:scrollView]];
    }
}

-(NSUInteger)getCurrentPageFromScrollView:(UIScrollView*)scrollView{
    CGFloat     pageWidth = CGRectGetWidth(scrollView.frame);
    NSUInteger  currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.currentTitleIndex = currentPage;
    return currentPage;
}

- (void)scrollWithPercentage:(CGFloat)percentage currentPage:(NSInteger)current{
    
    if(percentage == 0.0 || percentage == 0.5) {
        return;
    }
    
    UICollectionViewLayoutAttributes *actualItem;
    UICollectionViewLayoutAttributes *nextItem;
    
    if(percentage<=0.5){
        if(self.currentTitleIndex < [self.titlesArray count] - 1)
        {
            actualItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentTitleIndex inSection:0]];
            nextItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentTitleIndex+1 inSection:0]];
            
        }
    } else if (percentage>0.5){
        if(self.currentTitleIndex > 0)
        {
            actualItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentTitleIndex-1 inSection:0]];
            nextItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentTitleIndex inSection:0]];
            
        }
    }
    
    CGFloat distanceBetweenCenterPoints = actualItem.frame.size.width/2 + nextItem.frame.size.width/2+itemSpacing;
    CGFloat deltaOffset = distanceBetweenCenterPoints*percentage;
    CGFloat startingConentOffsetX = actualItem.frame.origin.x - (self.frame.size.width - actualItem.frame.size.width)/2;
    
    [UIView animateWithDuration:0.05f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                            self.scrolling = YES;
                            [self setContentOffset:CGPointMake(startingConentOffsetX+deltaOffset, 0)];
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             self.scrolling = NO;
                         }
                     }];

}

#pragma mark - scroll to page calculation method

- (void)titleViewDidScroll:(UIScrollView*)scrollView{
    if([scrollView isEqual:self]){
        for (UICollectionViewCell *cell in [self visibleCells]) {
            CGPoint point = cell.center;
            if(ABS(floorf(self.contentOffset.x + self.frame.size.width/2) - floorf(point.x))<=2){
                NSIndexPath *indexPath = [self indexPathForCell:cell];
                self.currentTitleIndex = indexPath.row;
                [self.titleViewDelegate titleView:self didMoveToIndexPatch:indexPath];
            }
        }
    }
}

@end
