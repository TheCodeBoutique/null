//
//  TRMPhotoSelectionView.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/18/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMPhotoSelectionView.h"
#import "TRMUtils.h"

@implementation TRMPhotoSelectionView
@synthesize photoImage;
@synthesize photoType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews
{
    [self photoImage];
    [self photoType];
}

-(UIImageView *)photoImage {
    if(!photoImage) {
        photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100.0f, 70.0f)];
        [photoImage setContentMode:UIViewContentModeScaleAspectFit];
        [photoImage setClipsToBounds:YES];
        [self addSubview:photoImage];
        return photoImage;
    }
    return photoImage;
}

-(UILabel *)photoType {
    if (!photoType) {
        photoType = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 85.0f, 100.0f, 23.0f)];
        [photoType setTextColor:[UIColor blackColor]];
        [photoType setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:photoType];
        [self bringSubviewToFront:photoType];
        return photoType;
    }
    return photoType;
}
@end
