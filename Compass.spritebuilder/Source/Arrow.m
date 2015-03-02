//
//  Arrow.m
//  Compass
//
//  Created by fairydream on 15-3-1.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "Arrow.h"

@implementation Arrow

- (instancetype)initArrow : (int) arrowType{
    NSString *dir = @"resource/";
    dir = [dir stringByAppendingString:[self type2dir: arrowType]];
    self = [super initWithImageNamed: dir];
    return self;
}

- (NSString *) type2dir : (int) arrowType {
    switch (arrowType) {
        case 1:
            return @"white_arrow.png";
        case 2:
            return @"black_arrow.png";
        default:
            return @"";
    }
}

@end
