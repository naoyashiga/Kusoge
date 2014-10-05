//
//  KGStartScene.m
//  KusogeTest
//
//  Created by naoyashiga on 2014/10/02.
//  Copyright (c) 2014年 naoyashiga. All rights reserved.
//

#import "KGStartScene.h"
#import "KGSpriteScene.h"
@implementation KGStartScene{
    BOOL _contentCreated;
}

- (void)didMoveToView:(SKView *)view{
    if (!_contentCreated) {
        [self createSceneContents];
        _contentCreated = YES;
    }
}
- (void)createSceneContents{
    self.backgroundColor = [SKColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    [self addStartScene];
}

- (void)addStartScene{
    SKLabelNode *holyShit = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    
    holyShit.text = @"HOLY SHIT";
    holyShit.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) * (5.0f / 3.0f));
    [self addChild:holyShit];
    
    SKLabelNode *emoji = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    
    emoji.text = @"⛪️💩";
    emoji.fontSize = 80;
    emoji.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 50);
    [self addChild:emoji];
    
    SKLabelNode *startBtn = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    
    startBtn.text = @"😎";
    startBtn.fontSize = 100;
    startBtn.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 100);
    startBtn.name = @"startBtn";
    [self addChild:startBtn];
    
    //アニメーションを定義
//    float startBtnSpeed = 2.0f;
    float startBtnScaleSpeed = 2.0f;
    float startBtnScale = 1.1f;
//    float startBtnMove = 20;
    
//    CGPoint startBtnTop = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 100);
//    CGPoint startBtnBottom = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 100 - startBtnMove);
    
//    SKAction *down = [SKAction moveTo:startBtnBottom duration:startBtnSpeed];
//    SKAction *up = [SKAction moveTo:startBtnTop duration:startBtnSpeed];
    SKAction *bigger = [SKAction scaleTo:startBtnScale duration:startBtnScaleSpeed];
    SKAction *smaller = [SKAction scaleTo:1.0/startBtnScale duration:startBtnScaleSpeed];
    
//    SKAction *startBtnSequence = [SKAction sequence:@[down,up]];
    SKAction *scaleSequence = [SKAction sequence:@[bigger,smaller]];
//    SKAction *group = [SKAction group:@[startBtnSequence,scaleSequence]];
    SKAction *repeat = [SKAction repeatActionForever:scaleSequence];
    repeat.timingMode = SKActionTimingEaseInEaseOut;
    [startBtn runAction:repeat];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if (node != nil && [node.name isEqualToString:@"startBtn"]) {
//        NSLog(@"button click");
        //sound
        SKAction *startSound = [SKAction playSoundFileNamed:@"start.mp3" waitForCompletion:NO];
        [node runAction:startSound];
        SKScene *test = [KGSpriteScene sceneWithSize:self.size];
        SKTransition *push = [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.5f];
//
//        //スコアを初期化
//        [KGSingletonSample sharedManager].score = 0;
        [self.view presentScene:test transition:push];
//        [self.view presentScene:_prevScene transition:push];
    }
}
@end