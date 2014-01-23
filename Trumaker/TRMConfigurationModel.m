//
//  TRMConfiguration.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/15/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMConfigurationModel.h"
#import "UIImageView+WebCache.h"
@implementation TRMConfigurationModel
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(UIImageView *)configurationImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithURL:[NSURL URLWithString:[self image_url]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    return imageView;
}
@end
