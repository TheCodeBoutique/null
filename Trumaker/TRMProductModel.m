//
//  TRMProductModel.m
//  Trumaker
//
//  Created by Kyle Carriedo on 1/14/14.
//  Copyright (c) 2014 Trumaker. All rights reserved.
//

#import "TRMProductModel.h"

@implementation TRMProductModel
- (id)init
{
    self = [super init];
    if (self) {
        _selectedCount = 0;
        _isSelected = NO;
    }
    return self;
}

-(NSString *)parseTitle {
    NSMutableString *parseString = [[NSMutableString alloc] initWithString:self.name];
    [parseString replaceOccurrencesOfString:@"-" withString:@"\n" options:NSBackwardsSearch range:NSMakeRange(0, parseString.length)];
    return parseString;
}

-(void)incrementSelectedCount {
    int value = [_selectedCount intValue];
    _selectedCount = [NSNumber numberWithInt:value + 1];
}

-(void)decrementSelectedCount {
    int value = [_selectedCount intValue];
    if (value == 0) {
        [self setIsSelected:NO];
        return;
    }
    _selectedCount = [NSNumber numberWithInt:value - 1];
}
@end
