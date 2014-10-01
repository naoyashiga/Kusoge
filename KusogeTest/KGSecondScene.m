//
//  KGSecondScene.m
//  KusogeTest
//
//  Created by naoyashiga on 2014/09/20.
//  Copyright (c) 2014年 naoyashiga. All rights reserved.
//

#import "KGSecondScene.h"
#import "KGSpriteScene.h"
#import "KGSingletonSample.h"

@implementation KGSecondScene{
    BOOL _contentCreated;
}

- (void)didMoveToView:(SKView *)view{
    if (!_contentCreated) {
        [self createSceneContents];
        _contentCreated = YES;
    }
}
- (void)createSceneContents{
    self.backgroundColor = [SKColor colorWithRed:0.6 green:0 blue:0 alpha:0.9];
    [self addResult];
}

- (void)addResult{
    SKLabelNode *holyShit = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    
    holyShit.text = @"HOLY SHIT";
    holyShit.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 100);
    [self addChild:holyShit];
    
    SKLabelNode *emoji = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    
    emoji.text = @"⛪️💩";
    emoji.fontSize = 50;
    emoji.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 50);
    [self addChild:emoji];
    
    SKLabelNode *resultDisplay = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    
    NSString *str1 = @"SCORE:";
    NSString *str2 = [NSString stringWithFormat:@"%d",[KGSingletonSample sharedManager].score];
    resultDisplay.text = [str1 stringByAppendingString:str2];
    resultDisplay.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    resultDisplay.name = @"SCORE";
    [self addChild:resultDisplay];
    
    //button
    SKLabelNode *retryBtn = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    retryBtn.text = @"Retry";
    retryBtn.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 100);
    retryBtn.name = @"retryBtn";
    [self addChild:retryBtn];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if (node != nil && [node.name isEqualToString:@"retryBtn"]) {
        NSLog(@"button click");
        SKScene *test = [KGSpriteScene sceneWithSize:self.size];
        SKTransition *push = [SKTransition pushWithDirection:SKTransitionDirectionLeft duration:0.5f];
        
        //スコアを初期化
        [KGSingletonSample sharedManager].score = 0;
        [self.view presentScene:test transition:push];
//        [self.view presentScene:_prevScene transition:push];
    }
}
@end
