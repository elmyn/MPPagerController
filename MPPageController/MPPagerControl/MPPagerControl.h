//
// Created by Michal Piwowarczyk on 07.03.15.
// Copyright (c) 2015 Allianz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface MPPagerControl : UIViewController

- (instancetype)initWithNavBarBackground:(UIColor*)navBarBackground
                               textColor:(UIColor*)textColor
                         viewControllers:(NSArray*)viewControllers;

- (instancetype)initWithNavBarBackground:(UIColor*)navBarBackground
                               textColor:(UIColor*)textColor
                         viewControllers:(NSArray*)viewControllers
                          scaleTransform:(CGFloat)scaleTransform;

@end