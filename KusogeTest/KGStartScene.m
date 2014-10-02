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
    holyShit.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 100);
    [self addChild:holyShit];
    
    SKLabelNode *emoji = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    
    emoji.text = @"⛪️💩";
    emoji.fontSize = 100;
    emoji.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 50);
    [self addChild:emoji];
    
    SKLabelNode *startBtn = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    
    startBtn.text = @"🍺";
    startBtn.fontSize = 100;
    startBtn.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 100);
    startBtn.name = @"startBtn";
    [self addChild:startBtn];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if (node != nil && [node.name isEqualToString:@"startBtn"]) {
//        NSLog(@"button click");
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