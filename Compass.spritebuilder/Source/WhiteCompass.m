//
//  WhiteCompass.m
//  Compass
//
//  Created by fairydream on 15-3-1.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "WhiteCompass.h"
#import "Arrow.h"

@implementation WhiteCompass {
    Arrow * _arrow;
    int _arrowType;
    int _arrowRotation;
    int _whiteCompassRotation;
}

- (void) didLoadFromCCB
{
    UISwipeGestureRecognizer *swipeGestureRecognizerRight;
    swipeGestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget: self action : @selector(checkSwipe :)];
    swipeGestureRecognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *swipeGestureRecognizerLeft;
    swipeGestureRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget: self action : @selector(checkSwipe :)];
    swipeGestureRecognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeGestureRecognizerUp;
    swipeGestureRecognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget: self action : @selector(checkSwipe :)];
    swipeGestureRecognizerUp.direction = UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer *swipeGestureRecognizerDown;
    swipeGestureRecognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget: self action : @selector(checkSwipe :)];
    swipeGestureRecognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    [[[CCDirector sharedDirector] view] addGestureRecognizer: swipeGestureRecognizerRight];
    [[[CCDirector sharedDirector] view] addGestureRecognizer: swipeGestureRecognizerLeft];
    [[[CCDirector sharedDirector] view] addGestureRecognizer: swipeGestureRecognizerUp];
    [[[CCDirector sharedDirector] view] addGestureRecognizer: swipeGestureRecognizerDown];
}

- (void)onEnter
{
    [super onEnter];
    
    [self randomArrow];
    
    self.userInteractionEnabled = YES;

}

/*- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    NSLog(@"touch began");
    [self randomSet];
    
    NSLog(@"arrow rotation: %f", _arrow.rotation);
    NSLog(@"white compass rotation: %f", self.rotation);

}*/


- (int) randomRotation
{
    int r = arc4random() % 4;
    switch (r)
    {
        case 0: return 0;
        case 1: return 90;
        case 2: return 180;
        case 3: return 270;
        default: return 0;
    }
}

- (void) randomArrow
{
    [_arrow removeFromParentAndCleanup:true];
    _arrowType = arc4random() % 2 + 1;
    _arrow = [[Arrow alloc] initArrow : _arrowType];
    _arrow.anchorPoint = ccp(0.5, 0.5);
    _arrow.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    _arrowRotation = [self randomRotation];
    _arrow.rotation = _arrowRotation;
    [self addChild:_arrow];
}

- (void) randomSet
{
    [self randomArrow];
    _whiteCompassRotation = [self randomRotation];
    [self setRotation: _whiteCompassRotation];
    
    NSLog(@"arrow rotation: %f", _arrow.rotation);
    NSLog(@"white compass rotation: %f", self.rotation);

}



- (void) checkSwipe : (UISwipeGestureRecognizer*) recognizer
{
    
    UISwipeGestureRecognizerDirection correctDirection = [self getCorretDirection];
    if(recognizer.direction == correctDirection)
    {
        NSLog(@"correct! ");
        NSLog(@"Your swipe is : %d", (int) recognizer.direction);
        NSLog(@"Correct direction is: %d", (int)correctDirection);
    }
    else
    {
        NSLog(@"wrong! ");
        NSLog(@"Your swipe is : %d", (int) recognizer.direction);
        NSLog(@"Correct direction is: %d", (int)correctDirection);
    }
    [self randomSet];
}


- (UISwipeGestureRecognizerDirection) getCorretDirection
{
    int realRotation;
    if (_arrowType == 1)
    {
        // white arrow
        realRotation = _arrowRotation + _whiteCompassRotation;
    }
    else
    {
        // black arrow
        realRotation = _arrowRotation;
    }
    switch (realRotation)
    {
        case 0:
            return UISwipeGestureRecognizerDirectionRight;
        case 90:
            return UISwipeGestureRecognizerDirectionDown;
        case 180:
            return UISwipeGestureRecognizerDirectionLeft;
        case 270:
            return UISwipeGestureRecognizerDirectionUp;
        default:
            return UISwipeGestureRecognizerDirectionRight;
    }
}


@end
