//
//  GamePlay.m
//  Compass
//
//  Created by fairydream on 15-5-1.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//
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
#import "GamePlay.h"
#import "TutorialText.h"

@implementation GamePlay
{
    CCNode * _pivot;
    BlackCompass * _blackCompass;
    WhiteCompassSmall * _whiteCompass;
    OutsideCompass * _outsideCompass;
    InsideCompass * _insideCompass;
    Arrow * _arrow;
    CorrectDirection * _correctDirection;
    TimeCircle *_timecircle;
    TutorialText *_tutorialText;
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
    int gameLevel;
    NSTimer *timer1;
    NSTimer *timer2;
    NSTimer *timer3;
    NSTimer *timer4;
    NSTimer *timer5;
    NSTimer *timer6;
    NSTimer *timer7;
    NSTimer *timer8;
    NSTimer *timer9;
}

- (void) setHighScore:(int)highScore{
    _highScore = highScore;
    _highScoreLabel.string = [NSString stringWithFormat:@"%d", _highScore];
}

- (void) didLoadFromCCB
{
    
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
   // if(_highScore <0 ) _highScore= 0;
    _highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"];
    
    _time_limit = 2.0f;
    animationManager = self.animationManager;
    _time = 0;
    isLoose = false;
    isTimeOutOrWrongSwipe = false;
    isGameOver = false;
    audio = [OALSimpleAudio sharedInstance];
    gameLevel = 0;
    
    [_tutorialText setTextContent:@""];
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
    if (_score < 5)
    {
        [self showTutorial];
    }
    
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
    [_tutorialText setTextContent:@""];
    if(_correctDirection!=nil)
    {
        [_correctDirection removeFromParent];
    }
    if([timer1 isValid])
    {
        [timer1 invalidate];
        timer1 = nil;
    }
    if([timer2 isValid])
    {
        [timer2 invalidate];
        timer2 = nil;
    }
    if([timer3 isValid])
    {
        [timer3 invalidate];
        timer3 = nil;
    }
    if([timer3 isValid])
    {
        [timer3 invalidate];
        timer3 = nil;
    }
    if([timer4 isValid])
    {
        [timer4 invalidate];
        timer4 = nil;
    }
    if([timer5 isValid])
    {
        [timer5 invalidate];
        timer5 = nil;
    }
    if([timer6 isValid])
    {
        [timer6 invalidate];
        timer6 = nil;
    }
    if([timer7 isValid])
    {
        [timer7 invalidate];
        timer7 = nil;
    }
    if([timer8 isValid])
    {
        [timer8 invalidate];
        timer8 = nil;
    }
    if([timer9 isValid])
    {
        [timer9 invalidate];
        timer9 = nil;
    }

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
            _highScoreLabel.string = [NSString stringWithFormat:@"%d", _score];
        }
        NSLog(@"correct! ");
        NSLog(@"Your swipe is : %d", (int) recognizer.direction);
        NSLog(@"Correct direction is: %d", (int)correctDirection);
        [self randomSet];
        if (_score <= 5)
        {
            [animationManager runAnimationsForSequenceNamed:@"LongTimeline"];
        }
        else if(_score <= 10)
        {
            [animationManager runAnimationsForSequenceNamed:@"TimeCircleTimeline"];
        }
        else if(_score <= 15)
        {
            [animationManager runAnimationsForSequenceNamed:@"L2_Timeline"];
        }
        else if(_score <= 20)
        {
            [animationManager runAnimationsForSequenceNamed:@"L3_Timeline"];
        }
        else
        {
            [animationManager runAnimationsForSequenceNamed:@"L4_Timeline"];
        }
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
    int timeLimit = 5;
    if (_score <= 5)
    {
        timeLimit = 10;
    }
    else if (_score <= 10)
    {
        timeLimit = 5;
    }
    else if (_score <= 15)
    {
        timeLimit = 4;
    }
    else if (_score <= 20)
    {
        timeLimit = 3;
    }
    else
    {
        timeLimit = 2;
    }
    if (_time > timeLimit && !isGameOver)
    {
        _time = 0;
        [self timeOut];
    }
    
}

- (void) gameOver
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:_highScore
                      forKey:@"HighScore"];
    [userDefaults synchronize];
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

- (void) showTutorial
{
    if (_arrowType == 1)
    {
        // white arrow
        timer1 = [NSTimer scheduledTimerWithTimeInterval: 1
                                         target:self
                                       selector:@selector(setTutorialText:)
                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Arrow is white,\n white compass shows your\nreal geomagnetic field.", @"text", nil]
                                        repeats: NO];
        timer2 = [NSTimer scheduledTimerWithTimeInterval: 5
                                         target:self
                                       selector:@selector(setTutorialText:)
                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Black compass shows correct direction.", @"text", nil]
                                        repeats: NO];
        timer3 = [NSTimer scheduledTimerWithTimeInterval: 8
                                         target:self
                                       selector:@selector(setTutorialText:)
                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Swipe follow the red arrow.", @"text", nil]
                                        repeats: NO];
        timer4 = [NSTimer scheduledTimerWithTimeInterval: 9
                                         target:self
                                       selector:@selector(setTutorialText:)
                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"", @"text", nil]
                                        repeats: NO];
         timer9 = [NSTimer scheduledTimerWithTimeInterval: 6.5
                                         target:self
                                       selector:@selector(showCorrectDirection)
                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"", @"text", nil]
                                        repeats: NO];
        int _rotationTemp = _arrowRotation + _whiteCompassRotation - _blackCompassRotation;
        _rotationTemp = (_rotationTemp+360)%360;
        switch (_rotationTemp)
        {
            case 0:
                timer5 = [NSTimer scheduledTimerWithTimeInterval: 1.5
                                                 target:self
                                               selector:@selector(loadTutorialEffect:)
                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_blackCompass, @"compassId", @"{0.08, 0.5}", @"position", nil]
                                                repeats: NO];
                timer6 = [NSTimer scheduledTimerWithTimeInterval: 2.5
                                                 target:self
                                               selector:@selector(loadTutorialEffect:)
                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_blackCompass, @"compassId", @"{0.92, 0.5}", @"position", nil]
                                                repeats: NO];
                timer7 = [NSTimer scheduledTimerWithTimeInterval: 5
                                                 target:self
                                               selector:@selector(loadTutorialEffect:)
                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys: _whiteCompass, @"compassId", @"{0.08, 0.5}", @"position", nil]
                                                repeats: NO];
                timer8 = [NSTimer scheduledTimerWithTimeInterval: 6
                                                 target:self
                                               selector:@selector(loadTutorialEffect:)
                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys: _whiteCompass, @"compassId", @"{0.92, 0.5}", @"position", nil]
                                                repeats: NO];
                break;
            case 90:
                timer5 = [NSTimer scheduledTimerWithTimeInterval: 1.5
                                                          target:self
                                                        selector:@selector(loadTutorialEffect:)
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_blackCompass, @"compassId", @"{0.5, 0.92}", @"position", nil]
                                                         repeats: NO];
                timer6 = [NSTimer scheduledTimerWithTimeInterval: 2.5
                                                          target:self
                                                        selector:@selector(loadTutorialEffect:)
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_blackCompass, @"compassId", @"{0.5, 0.08}", @"position", nil]
                                                         repeats: NO];
                timer7 = [NSTimer scheduledTimerWithTimeInterval: 5
                                                          target:self
                                                        selector:@selector(loadTutorialEffect:)
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys: _whiteCompass, @"compassId", @"{0.5, 0.92}", @"position", nil]
                                                         repeats: NO];
                timer8 = [NSTimer scheduledTimerWithTimeInterval: 6
                                                 target:self
                                               selector:@selector(loadTutorialEffect:)
                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys: _whiteCompass, @"compassId", @"{0.5, 0.08}", @"position", nil]
                                                repeats: NO];
                break;
            case 180:
                timer5 = [NSTimer scheduledTimerWithTimeInterval: 1.5
                                                          target:self
                                                        selector:@selector(loadTutorialEffect:)
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_blackCompass, @"compassId", @"{0.92, 0.5}", @"position", nil]
                                                         repeats: NO];
                timer6 = [NSTimer scheduledTimerWithTimeInterval: 2.5
                                                          target:self
                                                        selector:@selector(loadTutorialEffect:)
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_blackCompass, @"compassId", @"{0.08, 0.5}", @"position", nil]
                                                         repeats: NO];
                timer7 = [NSTimer scheduledTimerWithTimeInterval: 5
                                                          target:self
                                                        selector:@selector(loadTutorialEffect:)
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys: _whiteCompass, @"compassId", @"{0.92, 0.5}", @"position", nil]
                                                         repeats: NO];
                timer8 = [NSTimer scheduledTimerWithTimeInterval: 6
                                                 target:self
                                               selector:@selector(loadTutorialEffect:)
                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys: _whiteCompass, @"compassId", @"{0.08, 0.5}", @"position", nil]
                                                repeats: NO];
                break;
            case 270:
                timer5 = [NSTimer scheduledTimerWithTimeInterval: 1.5
                                                          target:self
                                                        selector:@selector(loadTutorialEffect:)
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_blackCompass, @"compassId", @"{0.5, 0.08}", @"position", nil]
                                                         repeats: NO];
                timer6 = [NSTimer scheduledTimerWithTimeInterval: 2.5
                                                          target:self
                                                        selector:@selector(loadTutorialEffect:)
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_blackCompass, @"compassId", @"{0.5, 0.92}", @"position", nil]
                                                         repeats: NO];
                timer7 = [NSTimer scheduledTimerWithTimeInterval: 5
                                                          target:self
                                                        selector:@selector(loadTutorialEffect:)
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys: _whiteCompass, @"compassId", @"{0.5, 0.08}", @"position", nil]
                                                         repeats: NO];
                timer8 = [NSTimer scheduledTimerWithTimeInterval: 6
                                                 target:self
                                               selector:@selector(loadTutorialEffect:)
                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys: _whiteCompass, @"compassId", @"{0.5, 0.92}", @"position", nil]
                                                repeats: NO];
                break;
            default:
                break;
        }
    }
    else
    {
        // black arrow
        timer1 = [NSTimer scheduledTimerWithTimeInterval: 1
                                                target:self
                                              selector:@selector(setTutorialText:)
                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Arrow is black,\nblack compass shows your\nreal geomagnetic field.", @"text", nil]
                                               repeats: NO];
        timer2 = [NSTimer scheduledTimerWithTimeInterval: 5
                                                target:self
                                              selector:@selector(setTutorialText:)
                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"White compass shows correct direction.", @"text", nil]
                                               repeats: NO];
        timer3 = [NSTimer scheduledTimerWithTimeInterval: 8
                                                target:self
                                              selector:@selector(setTutorialText:)
                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Swipe follow the red arrow.", @"text", nil]
                                               repeats: NO];
        timer4 = [NSTimer scheduledTimerWithTimeInterval: 9
                                         target:self
                                       selector:@selector(setTutorialText:)
                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"", @"text", nil]
                                        repeats: NO];
        timer9 = [NSTimer scheduledTimerWithTimeInterval: 6.5
                                         target:self
                                       selector:@selector(showCorrectDirection)
                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"", @"text", nil]
                                        repeats: NO];
        switch (_arrowRotation)
        {
            case 0:
                timer5 =[NSTimer scheduledTimerWithTimeInterval: 1.5
                                                         target:self
                                                       selector:@selector(loadTutorialEffect:)
                                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_whiteCompass, @"compassId", @"{0.08, 0.5}", @"position", nil]
                                                        repeats: NO];
                timer6 =[NSTimer scheduledTimerWithTimeInterval: 2.5
                                                         target:self
                                                       selector:@selector(loadTutorialEffect:)
                                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_whiteCompass, @"compassId", @"{0.92, 0.5}", @"position", nil]
                                                        repeats: NO];
                timer7 =[NSTimer scheduledTimerWithTimeInterval: 5
                                                         target:self
                                                       selector:@selector(loadTutorialEffect:)
                                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys: _blackCompass, @"compassId", @"{0.08, 0.5}", @"position", nil]
                                                        repeats: NO];
                timer8 =[NSTimer scheduledTimerWithTimeInterval: 6
                                                 target:self
                                               selector:@selector(loadTutorialEffect:)
                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys: _blackCompass, @"compassId", @"{0.92, 0.5}", @"position", nil]
                                                repeats: NO];
                break;
            case 90:
                timer5 =[NSTimer scheduledTimerWithTimeInterval: 1.5
                                                         target:self
                                                       selector:@selector(loadTutorialEffect:)
                                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_whiteCompass, @"compassId", @"{0.5, 0.89}", @"position", nil]
                                                        repeats: NO];
                timer6 =[NSTimer scheduledTimerWithTimeInterval: 2.5
                                                         target:self
                                                       selector:@selector(loadTutorialEffect:)
                                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_whiteCompass, @"compassId", @"{0.5, 0.11}", @"position", nil]
                                                        repeats: NO];
                timer7 =[NSTimer scheduledTimerWithTimeInterval: 5
                                                         target:self
                                                       selector:@selector(loadTutorialEffect:)
                                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys: _blackCompass, @"compassId", @"{0.5, 0.92}", @"position", nil]
                                                        repeats: NO];
                timer8 =[NSTimer scheduledTimerWithTimeInterval: 6
                                                 target:self
                                               selector:@selector(loadTutorialEffect:)
                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys: _blackCompass, @"compassId", @"{0.5, 0.08}", @"position", nil]
                                                repeats: NO];
                break;
            case 180:
                timer5 =[NSTimer scheduledTimerWithTimeInterval: 1.5
                                                         target:self
                                                       selector:@selector(loadTutorialEffect:)
                                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_whiteCompass, @"compassId", @"{0.89, 0.5}", @"position", nil]
                                                        repeats: NO];
                timer6 =[NSTimer scheduledTimerWithTimeInterval: 2.5
                                                         target:self
                                                       selector:@selector(loadTutorialEffect:)
                                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_whiteCompass, @"compassId", @"{0.11, 0.5}", @"position", nil]
                                                        repeats: NO];
                timer7 =[NSTimer scheduledTimerWithTimeInterval: 5
                                                         target:self
                                                       selector:@selector(loadTutorialEffect:)
                                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys: _blackCompass, @"compassId", @"{0.92, 0.5}", @"position", nil]
                                                        repeats: NO];
                timer8 =[NSTimer scheduledTimerWithTimeInterval: 6
                                                 target:self
                                               selector:@selector(loadTutorialEffect:)
                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys: _blackCompass, @"compassId", @"{0.08, 0.5}", @"position", nil]
                                                repeats: NO];
                break;
            case 270:
                timer5 =[NSTimer scheduledTimerWithTimeInterval: 1.5
                                                         target:self
                                                       selector:@selector(loadTutorialEffect:)
                                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_whiteCompass, @"compassId", @"{0.5, 0.89}", @"position", nil]
                                                        repeats: NO];
                timer6 =[NSTimer scheduledTimerWithTimeInterval: 2.5
                                                         target:self
                                                       selector:@selector(loadTutorialEffect:)
                                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_whiteCompass, @"compassId", @"{0.5, 0.11}", @"position", nil]
                                                        repeats: NO];
                timer7 =[NSTimer scheduledTimerWithTimeInterval: 5
                                                         target:self
                                                       selector:@selector(loadTutorialEffect:)
                                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys: _blackCompass, @"compassId", @"{0.5, 0.08}", @"position", nil]
                                                        repeats: NO];
                timer8 =[NSTimer scheduledTimerWithTimeInterval: 6
                                                 target:self
                                               selector:@selector(loadTutorialEffect:)
                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys: _blackCompass, @"compassId", @"{0.5, 0.92}", @"position", nil]
                                                repeats: NO];
                break;
            default:
                break;
        }
    }
}

- (void) loadTutorialEffect: (NSTimer *)theTimer
{
    CGPoint position = CGPointFromString([[theTimer userInfo] objectForKey:@"position"]);
    id compass = [[theTimer userInfo] objectForKey:@"compassId"];
    NSLog(@"position  %f, %f", position.x, position.y);
    CCParticleSystem *ring = (CCParticleSystem *)[CCBReader load:@"TutorialEffect"];
    ring.autoRemoveOnFinish = TRUE;
    ring.positionType = CCPositionTypeNormalized;
    ring.position = position;
    ring.scale = 2;
    if (compass == _whiteCompass) ring.scale = 3;
    [compass addChild: ring];
}

- (void) setTutorialText: (NSTimer *)theTimer
{
    NSString* content = [[theTimer userInfo] objectForKey:@"text"];
    [_tutorialText setTextContent:content];
}


@end
