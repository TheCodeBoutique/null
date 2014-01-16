//
//  TRMTaskListCell.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/11/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMTaskListCell.h"

@implementation TRMTaskListCell
@synthesize title;
@synthesize taskImage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)prepareForReuse {
    [super prepareForReuse];
}

-(void)layoutSubviews {
    if (_isDisabled) {
        [[self layer] setOpacity:0.30];
    }
    
    if (_isLastCell) {
        [[self bridgeImage] setHidden:YES];
    }
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//}
@end
