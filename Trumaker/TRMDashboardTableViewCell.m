//
//  TRMDashboardTableViewCell.m
//  Trumaker
//
//  Created by Marin Fischer on 1/7/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMDashboardTableViewCell.h"
#import "TRMUtils.h"
@interface TRMDashboardTableViewCell()
@property (nonatomic, strong) CALayer *bottomBorder;
@end

@implementation TRMDashboardTableViewCell
@synthesize bottomBorder;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    [bottomBorder removeFromSuperlayer];
}

-(void)layoutSubviews {
    [[self cellTitle] sizeToFit];
    [self drawBorderForCell];
}


-(void)drawBorderForCell {
    CGRect cellFrame = [self frame];
    bottomBorder = [CALayer layer];
    CGRect borderFrame;
    if (self.isLastCell) {
        borderFrame = CGRectMake(0,CGRectGetHeight(cellFrame) - [TRMUtils halfPixel], CGRectGetWidth(cellFrame), [TRMUtils halfPixel]);
    } else {
        borderFrame = CGRectMake(20.0f,CGRectGetHeight(cellFrame) - [TRMUtils halfPixel], CGRectGetWidth(cellFrame), [TRMUtils halfPixel]);
    }
    [bottomBorder setFrame:borderFrame];
    bottomBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [[self layer] addSublayer: bottomBorder];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
