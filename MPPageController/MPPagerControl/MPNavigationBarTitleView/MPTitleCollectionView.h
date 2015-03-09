//
// Created by Michal Piwowarczyk on 07.03.15.
// Copyright (c) 2015 Allianz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPTitleCollectionView;

@protocol MPTitleCollectionViewDelegate <NSObject>

- (void)titleView:(MPTitleCollectionView*)titleView didMoveToIndexPatch:(NSIndexPath*)indexPath;

@end


@interface MPTitleCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) id<MPTitleCollectionViewDelegate> titleViewDelegate;
@property (nonatomic, strong) UIColor *textColor;

- (id)initWithFrame:(CGRect)frame titlesArray:(NSArray*)titlesArray;

- (void)setCurrentPageIndex:(NSInteger)pageIndex;

- (void)reloadTitlesWithArray:(NSArray*)titlesArray;

- (void)pageViewDidScroll:(id)sender;



@end
