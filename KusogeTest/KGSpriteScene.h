//
//  KGSpriteScene.h
//  KusogeTest
//
//  Created by naoyashiga on 2014/09/16.
//  Copyright (c) 2014年 naoyashiga. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface KGSpriteScene : SKScene<SKPhysicsContactDelegate>
@property(nonatomic,strong) SKLabelNode *scoreDisplay;
@property(nonatomic,strong) NSTimer *timer;

@end
