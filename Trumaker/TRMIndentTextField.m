//
//  TRMIndentTextField.m
//  Trumaker
//
//  Created on 8/28/13.
//  Copyright (c) 2013 The Code Boutique. All rights reserved.
//

#define kTRMIndentSpacing   10
#import "TRMIndentTextField.h"


@implementation TRMIndentTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.edgeInsets = UIEdgeInsetsMake(0, kTRMIndentSpacing, 0, 0);
    }
    return self;
}

//for IBOutlets
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.edgeInsets = UIEdgeInsetsMake(0, kTRMIndentSpacing, 0, 0);
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
