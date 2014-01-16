//
//  TRMBadgeView.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/15/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMBadgeView.h"

@interface TRMBadgeView ()
@property (nonatomic, strong) UIImageView *badgeImageView;
@end

@implementation TRMBadgeView
@synthesize badgeCount;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)layoutSubviews {
    [self addSubview:[self badgeImageView]];
    [self addSubview:[self badgeCount]];
}

-(UIImageView *)badgeImageView {
    if (!_badgeImageView) {
        _badgeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge"]];
        [_badgeImageView setFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
        return _badgeImageView;
    }
    return _badgeImageView;
}

-(UILabel *)badgeCount {
    if (!badgeCount) {
        badgeCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
        [badgeCount setTextAlignment:NSTextAlignmentCenter];
        [badgeCount setFont:[UIFont systemFontOfSize:14.0f]];
        [badgeCount setTextColor:[UIColor whiteColor]];
        return badgeCount;
    }
    return badgeCount;
}
@end
