#import "MainScene.h"
#import "WhiteCompass.h"
#import "Arrow.h"
#import "TimeCircle.h"
#import "GameOver.h"
#import "BlackCompass.h"
#import "WhiteCompassSmall.h"
#import "TimeOut.h"
#import "CorrectDirection.h"
#import "WrongSwipe.h"

@implementation MainScene{
    CCNode * _pivot;
    BlackCompass * _blackCompass;
    WhiteCompassSmall * _whiteCompass;
    Arrow * _arrow;
    CorrectDirection * _correctDirection;
    TimeCircle *_timecircle;
    CCButton * _retryButton;
    int _arrowType;
    int _arrowRotation;
    int _whiteCompassRotation;
    int _blackCompassRotation;
    int _score;
    int _highScore;
    CCLabelTTF * _scoreLabel;
    CCLabelTTF * _highScoreLabel;
    CCAnimationManager* animationManager;
    float _time_limit;
    float _time;
    bool isLoose;
    bool isTimeOutOrWrongSwipe;
    bool isGameOver;
    int realRotation;
    OALSimpleAudio *audio;

}

- (void) setHighScore:(int)highScore{
    _highScore = highScore;
    _highScoreLabel.string = [NSString stringWithFormat:@"%d", _highScore];
}

- (void) didLoadFromCCB
{
    _retryButton.visible = false;
  //  [_retryButton setTarget:self selector: @selector(start)];
    
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
    if(_highScore <0 ) _highScore= 0;
    _time_limit = 2.0f;
    animationManager = self.animationManager;
    _time = 0;
    isLoose = false;
    isTimeOutOrWrongSwipe = false;
    isGameOver = false;
    audio = [OALSimpleAudio sharedInstance];

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
    _blackCompassRotation = [self randomRotation];
    [_whiteCompass setRotation: _whiteCompassRotation];
    [_blackCompass setRotation: _blackCompassRotation];
    
    NSLog(@"arrow rotation: %f", _arrow.rotation);
    NSLog(@"black compass rotation: %f", _blackCompass.rotation);
    NSLog(@"white compass rotation: %f", _whiteCompass.rotation);
    _time = 0;
}

-(void)timeOut
{
    [audio playEffect:@"lose.wav"];
    isTimeOutOrWrongSwipe = true;
    isLoose = true;
    TimeOut *timeout = (TimeOut *)[CCBReader load:@"TimeOut"];
    timeout.positionType = CCPositionTypeNormalized;
    timeout.position = ccp(0.5, 0.7);
    timeout.zOrder = INT_MAX;
    [self addChild:timeout];
}


- (void) checkSwipe : (UISwipeGestureRecognizer*) recognizer
{
    if(isGameOver || isLoose || isTimeOutOrWrongSwipe) return;
    UISwipeGestureRecognizerDirection correctDirection = [self getCorretDirection];
    if(recognizer.direction == correctDirection)
    {
        if (_time <= 1.5)
        {
            _score += 3;
            [audio playEffect:@"3.wav"];
        }
        else if (_time <=3)
        {
            _score +=2;
            [audio playEffect:@"2.wav"];
        }
        else
        {
            _score += 1;
            [audio playEffect:@"1.wav"];
        }
        _scoreLabel.string = [NSString stringWithFormat:@"%d", _score];
        if (_score > _highScore) {
            _highScore = _score;
            _highScoreLabel.string = [NSString stringWithFormat:@"%d", _highScore];
        }
        NSLog(@"correct! ");
        NSLog(@"Your swipe is : %d", (int) recognizer.direction);
        NSLog(@"Correct direction is: %d", (int)correctDirection);
        [animationManager runAnimationsForSequenceNamed:@"TimeCircleTimeline"];
        [self randomSet];
    }
    else
    {
        [audio playEffect:@"lose.wav"];
        NSLog(@"wrong! ");
        NSLog(@"Your swipe is : %d", (int) recognizer.direction);
        NSLog(@"Correct direction is: %d", (int)correctDirection);
        isLoose = true;
        [_timecircle removeFromParentAndCleanup:true];
     //   [self gameOver];
        [self wrongSwipe];
     //   [self showCorrectDirection];
    }
}


- (UISwipeGestureRecognizerDirection) getCorretDirection
{
    if (_arrowType == 1)
    {
        // white arrow
        realRotation = _arrowRotation + 2*_whiteCompassRotation - _blackCompassRotation;
    }
    else
    {
        // black arrow
        realRotation = _arrowRotation + _blackCompassRotation;
    }
    realRotation = (realRotation+360)%360;
    NSLog(@"realRotation= %d", realRotation);
    switch ((realRotation+360)%360)
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

- (void) update:(CCTime)delta
{
    _time += delta;
    if (isGameOver) return;
    if (isTimeOutOrWrongSwipe)
    {
     //   if (_time > 2) [self gameOver];
        if (_time > 1)
        {
            [self showCorrectDirection];
            isLoose = true;
            isTimeOutOrWrongSwipe = false;
            _time = 0;
        }
    }
    if (isLoose)
    {
        if(_time > 2)
        {
            _pivot.position = ccp(0.85, 0.5);
            _pivot.scale = 0.5;
            [self gameOver];
            isGameOver = true;
            isLoose = false;
        }
    }
    if (_time > 5 && !isGameOver)
    {
        _time = 0;
        [self timeOut];
    }
}

- (void) gameOver
{
    GameOver *gameOver = (GameOver *)[CCBReader load:@"GameOver"];
    gameOver.positionType = CCPositionTypeNormalized;
    gameOver.position = ccp(0.5, 0.5);
    gameOver.scale = 0.4;
    gameOver.zOrder = INT_MAX;
    [gameOver setScore: _score];
    [gameOver setHighScore: _highScore];
    [self addChild:gameOver];
}

- (void) wrongSwipe
{
    isTimeOutOrWrongSwipe = true;
    WrongSwipe *wrongSwipe = (WrongSwipe *)[CCBReader load:@"YouLose"];
    wrongSwipe.positionType = CCPositionTypeNormalized;
    wrongSwipe.position = ccp(0.5, 0.7);
    wrongSwipe.zOrder = INT_MAX;
    isTimeOutOrWrongSwipe = true;
    [self addChild:wrongSwipe];
}

- (void) showCorrectDirection
{
    _correctDirection = [[CorrectDirection alloc] init];
    _correctDirection.position = ccp(0.5, 0.2);
    [self getCorretDirection];
    _correctDirection.rotation = realRotation;
    _correctDirection.zOrder = INT_MAX;
    _correctDirection.scale = 0.3;
    if (realRotation == 90 || realRotation == 270)
    {
        _correctDirection.position = ccp(_correctDirection.contentSize.width*0.3, 0);
    }
    else
    {
        _correctDirection.position = ccp(0, -_correctDirection.contentSize.width*0.3);
    }
    [_pivot addChild:_correctDirection];
}


@end
