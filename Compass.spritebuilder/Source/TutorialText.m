//
//  TutorialText.m
//  Compass
//
//  Created by fairydream on 15-5-2.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "TutorialText.h"

@implementation TutorialText
{
     CCLabelTTF * _textContent;
}

- (void) setTextContent : (NSString*) content
{
    _textContent.string = content;
}

@end
