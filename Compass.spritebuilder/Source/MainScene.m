#import "MainScene.h"

@implementation MainScene

- (void) startGame
{
    CCScene *gamePlay = [CCBReader loadAsScene:@"GamePlay"];
    [[CCDirector sharedDirector] replaceScene: (CCScene *)gamePlay];
}

- (void) startTutorial
{
    CCScene *tutorial = [CCBReader loadAsScene:@"TutorialMode"];
    [[CCDirector sharedDirector] replaceScene: (CCScene *)tutorial];

}

@end
