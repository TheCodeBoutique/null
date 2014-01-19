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
        photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth([self frame]), CGRectGetHeight([self frame]) - 25.0f)];
        [photoImage setContentMode:UIViewContentModeScaleToFill];
        [[photoImage layer] setBorderWidth:[TRMUtils halfPixel]];
        [[photoImage layer] setBorderColor:[[TRMUtils colorWithHexString:@"959fa5"] CGColor]];
        [[photoImage layer] setCornerRadius:5.0f];
        [photoImage setClipsToBounds:YES];
        [self addSubview:photoImage];
        return photoImage;
    }
    return photoImage;
}

-(UILabel *)photoType {
    if (!photoType) {
        photoType = [[UILabel alloc] initWithFrame:CGRectMake(13.0f, 10.0f, CGRectGetWidth([self frame]) - 10.0f, 23.0f)];
        [self addSubview:photoType];
        [self bringSubviewToFront:photoType];
        return photoType;
    }
    return photoType;
}
@end
