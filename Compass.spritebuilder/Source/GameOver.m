//
//  GameOver.m
//  Compass
//
//  Created by fairydream on 15-4-14.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "GameOver.h"
#import "MainScene.h"

@implementation GameOver
{
    CCLabelTTF * _scoreLabel;
    CCLabelTTF * _highScoreLabel;
    int _highScore;
}

- (void) setScore:(int)score
{
    _scoreLabel.string = [NSString stringWithFormat:@"%d", score];
}

- (void) setHighScore:(int) highScore
{
    _highScore = highScore;
    _highScoreLabel.string = [NSString stringWithFormat:@"%d", highScore];
}

- (void)retry
{
    MainScene *gamePlay = (MainScene *)[CCBReader load:@"MainScene"];
    [gamePlay setHighScore:_highScore];
    CCScene *scene = [CCScene node];
    [scene addChild: gamePlay];
    [[CCDirector sharedDirector] replaceScene: scene withTransition: [CCTransition transitionCrossFadeWithDuration: 0.5]];
  //  CCScene *gamePlay = [CCBReader loadAsScene:@"MainScene"];
  //  [[CCDirector sharedDirector] replaceScene: (CCScene *)gamePlay];
}

@end
