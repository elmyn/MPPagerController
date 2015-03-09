//
// Created by Michal Piwowarczyk on 07.03.15.
// Copyright (c) 2015 Allianz. All rights reserved.
//

#import "MPTitleCollectionViewCell.h"

@implementation MPTitleCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        frame.origin = CGPointZero;
        self.titleLabel = [[UILabel alloc] initWithFrame:frame];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.backgroundColor   = [UIColor clearColor];
        self.titleLabel.textColor         = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
    }
    return self;
}



@end
