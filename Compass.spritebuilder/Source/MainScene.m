#import "MainScene.h"
#import "WhiteCompass.h"
#import "Arrow.h"

@implementation MainScene{
    WhiteCompass *_whiteCompass;
    Arrow * _arrow;
    CCButton * _retryButton;
    int _arrowType;
    int _arrowRotation;
    int _whiteCompassRotation;
    int _score;
    CCLabelTTF * _scoreLabel;
}

- (void) didLoadFromCCB
{
    _retryButton.visible = false;
    [_retryButton setTarget:self selector: @selector(retry)];
    
    [self randomSet];
    
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
    
    _score = 0;
}

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
    _arrow.position = ccp(_whiteCompass.contentSize.width/2, _whiteCompass.contentSize.height/2);
    _arrowRotation = [self randomRotation];
    _arrow.rotation = _arrowRotation;
    [_whiteCompass addChild:_arrow];
}

- (void) randomSet
{
    [self randomArrow];
    _whiteCompassRotation = [self randomRotation];
    [_whiteCompass setRotation: _whiteCompassRotation];
    
    NSLog(@"arrow rotation: %f", _arrow.rotation);
    NSLog(@"white compass rotation: %f", _whiteCompass.rotation);
    
}



- (void) checkSwipe : (UISwipeGestureRecognizer*) recognizer
{
    
    UISwipeGestureRecognizerDirection correctDirection = [self getCorretDirection];
    if(recognizer.direction == correctDirection)
    {
        _score ++;
        _scoreLabel.string = [NSString stringWithFormat:@"%d", _score];
        NSLog(@"correct! ");
        NSLog(@"Your swipe is : %d", (int) recognizer.direction);
        NSLog(@"Correct direction is: %d", (int)correctDirection);
    }
    else
    {
        NSLog(@"wrong! ");
        NSLog(@"Your swipe is : %d", (int) recognizer.direction);
        NSLog(@"Correct direction is: %d", (int)correctDirection);
        _retryButton.visible = true;
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

- (void)retry
{
    NSLog(@"Retry");
    [self randomSet];
    _retryButton.visible = false;
}

@end
