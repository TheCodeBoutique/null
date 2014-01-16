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
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation TRMDashboardTableViewCell
@synthesize bottomBorder;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    [bottomBorder removeFromSuperlayer];
}

-(void)layoutSubviews {
    [[self cellTitle] sizeToFit];
    CGRect cellFrame = [_cellTitle frame];
    [self drawBorderForCell];
    
    if (self.isDisabled) {
        [self addSubview:[self spinnerView]];
        CGRect spinnerFrame = [_spinner frame];
        CGRect cellTitleFrame = [_cellTitle frame];
        cellTitleFrame.origin.x = CGRectGetMaxX(spinnerFrame) + 7.0f;
        [_cellTitle setFrame:cellTitleFrame];
        [[self rightArrow] setHidden:YES];
    } else {
        cellFrame.origin.x = 20.0f;
        [_cellTitle setFrame:cellFrame];
        [_rightArrow setHidden:NO];
    }
}

-(UIActivityIndicatorView *)spinnerView {
    if (!_spinner) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_spinner startAnimating];
        [_spinner setFrame:CGRectMake(10, 18, 40.0f, 40.0f)];
        return _spinner;
    }
    return _spinner;
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
}
@end
