//
//  GameOver.m
//  Compass
//
//  Created by fairydream on 15-4-14.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "GameOver.h"
#import "GamePlay.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKSharePhoto.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKSharePhotoContent.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>


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
    GamePlay *gamePlay = (GamePlay *)[CCBReader load:@"GamePlay"];
    [gamePlay setHighScore:_highScore];
    CCScene *scene = [CCScene node];
    [scene addChild: gamePlay];
    [[CCDirector sharedDirector] replaceScene: scene withTransition: [CCTransition transitionCrossFadeWithDuration: 0.5]];
  //  CCScene *gamePlay = [CCBReader loadAsScene:@"MainScene"];
  //  [[CCDirector sharedDirector] replaceScene: (CCScene *)gamePlay];
}

- (void) shareToFB
{

  /*  UIImage *image = [self imageFromView];
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = image;
    photo.userGenerated = YES;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:nil];*/
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentDescription = @"HELELELEL";
    content.contentTitle = @"sss";
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:nil];
}

- (UIImage *)imageFromView
{
    id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    UIView *rootView = appDelegate.window.rootViewController.view;
   // AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
   // UIView *topView = appDelegate.viewController.view;
    UIGraphicsBeginImageContext(rootView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [rootView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
