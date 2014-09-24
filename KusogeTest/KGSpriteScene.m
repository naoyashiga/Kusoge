//
//  KGSpriteScene.m
//  KusogeTest
//
//  Created by naoyashiga on 2014/09/16.
//  Copyright (c) 2014年 naoyashiga. All rights reserved.
//

#import "KGSpriteScene.h"
#import "KGSecondScene.h"
#import "KGSingletonSample.h"

float speed = 1.5f;
float groundToBottomSpeed = 0.3f;
float wfDuration = 0.1f;
int wallPieceNum = 6;
int wallHeight = 10;
float wallPieceSize;
float playerSpeed = 2.0f;

float wallCreateInterval = 1.0f;
float playerScale = 0.4f;

CGPoint startPt;
float startPlayerPosX;

float SCREEN_RIGHT;
float SCREEN_LEFT;
int GROUND_Y;
//int score = 0;

@implementation KGSpriteScene {
    BOOL _contentCreated;
}


-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

- (void)didMoveToView:(SKView *)view{
    if (!_contentCreated) {
        [self createSceneContents];
        _contentCreated = YES;
    }
}

- (void)createSceneContents{
    GROUND_Y = CGRectGetMidY(self.frame);
    
    [self addScoreDisplay];
    [self addGround];
    [self addPlayer];
    wallPieceSize = self.view.bounds.size.width / wallPieceNum;
    
    //繰り返し壁を生成
    _timer = [NSTimer scheduledTimerWithTimeInterval:wallCreateInterval target:self selector:@selector(addWall) userInfo:nil repeats:YES];
}

//スコアを表示
- (void)addScoreDisplay{
    self.scoreDisplay = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    self.scoreDisplay.text = @"SCORE:0";
    self.scoreDisplay.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.scoreDisplay.name = @"SCORE";
    [self addChild:self.scoreDisplay];
}

//地面を追加
- (void)addGround{
    SKSpriteNode *ground = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(self.view.bounds.size.width,5)];
    ground.position = CGPointMake(CGRectGetMidX(self.frame), GROUND_Y - 10);
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
    ground.physicsBody.dynamic = NO;
    [self addChild:ground];
}

//ネコを追加
- (void)addPlayer{
    //画像を表示
    //SKSpriteNode *player = [SKSpriteNode spriteNodeWithImageNamed:@"cat.jpeg"];
    SKSpriteNode *player = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(50,50)];
    player.position = CGPointMake(CGRectGetMidX(self.frame), GROUND_Y);
    player.xScale = playerScale;
    player.yScale = playerScale;
    player.name = @"player";
    
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
    player.physicsBody.affectedByGravity = NO;
    player.physicsBody.contactTestBitMask = 1;
    [self addChild:player];
    //画面端を定義
    SCREEN_RIGHT = self.view.bounds.size.width - player.size.width / 2;
    SCREEN_LEFT = player.size.width / 2;
}

//壁を追加
- (void)addWall{
    //左の壁
    float leftWallWidth = wallPieceSize * (arc4random() % wallPieceNum);
    SKSpriteNode *leftWall = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(leftWallWidth,wallHeight)];
    
    leftWall.position = CGPointMake(leftWall.size.width / 2, self.view.bounds.size.height + leftWall.size.height / 2);
    leftWall.name = @"leftWall";
    leftWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:leftWall.size];
    leftWall.physicsBody.dynamic = NO;
    leftWall.physicsBody.contactTestBitMask = 1;
    [self addChild:leftWall];
    
    //図形を移動
    CGPoint screenTop = CGPointMake(leftWall.size.width / 2, self.view.bounds.size.height + leftWall.size.height / 2);
    CGPoint screenBottom = CGPointMake(leftWall.size.width / 2, - leftWall.size.height / 2);
    //地面下
    CGPoint groundBottom = CGPointMake(leftWall.size.width / 2, GROUND_Y - leftWall.size.height / 2);
    
    //アニメーションを定義
    SKAction *moveGround = [SKAction moveTo:groundBottom duration:speed];
    SKAction *moveDown = [SKAction moveTo:screenBottom duration:groundToBottomSpeed];
    SKAction *moveTop = [SKAction moveTo:screenTop duration:0.0f];
    //スコアを計算
    SKAction *updateScore = [SKAction runBlock:^{
        [self calcScore];
    }];
    SKAction *remove = [SKAction removeFromParent];
    
    SKAction *sequence = [SKAction sequence:@[moveGround,updateScore,moveDown,moveTop,remove]];
    [leftWall runAction:sequence];
    
    //右の壁
    float rightWallWidth = self.view.bounds.size.width - (leftWallWidth + wallPieceSize);
    SKSpriteNode *rightWall = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(rightWallWidth,wallHeight)];
    float rightWallPosX = leftWall.size.width + wallPieceSize + rightWall.size.width / 2;
    
    rightWall.position = CGPointMake(rightWallPosX, self.view.bounds.size.height + rightWall.size.height / 2);
    rightWall.name = @"rightWall";
    rightWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rightWall.size];
    rightWall.physicsBody.dynamic = NO;
    rightWall.physicsBody.contactTestBitMask = 1;
    [self addChild:rightWall];
    
    //移動位置を定義
    CGPoint rightWallScreenTop = CGPointMake(rightWallPosX, self.view.bounds.size.height + leftWall.size.height / 2);
    CGPoint rightWallScreenBottom = CGPointMake(rightWallPosX, - leftWall.size.height / 2);
    CGPoint rightWallGroundBottom = CGPointMake(rightWallPosX, GROUND_Y - rightWall.size.height / 2);
    
    //アニメーションを定義
    SKAction *rwMoveGround = [SKAction moveTo:rightWallGroundBottom duration:speed];
    SKAction *rightWallMoveDown = [SKAction moveTo:rightWallScreenBottom duration:groundToBottomSpeed];
    SKAction *rightWallMoveTop = [SKAction moveTo:rightWallScreenTop duration:0.0f];
    
    SKAction *rightWallSequence = [SKAction sequence:@[rwMoveGround,rightWallMoveDown,rightWallMoveTop,remove]];
    [rightWall runAction:rightWallSequence];
    
}

//スコアを計算
- (void)calcScore{
    [KGSingletonSample sharedManager].score++;
    NSString *str1 = @"SCORE:";
    NSString *str2 = [NSString stringWithFormat:@"%d",[KGSingletonSample sharedManager].score];
    self.scoreDisplay.text = [str1 stringByAppendingString:str2];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(touches.count == 1){
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInNode:self];
        
        SKNode *player = [self childNodeWithName:@"player"];
        
        //タッチ開始時のネコ画像のX座標 + (タッチ後移動した時の指のX座標　- タッチ開始時の指のX座標) * プレイヤーの移動スピード
        int posX = startPlayerPosX + (location.x - startPt.x) * playerSpeed;
        player.position = CGPointMake(posX, GROUND_Y);
        
        //壁の境界
        if(player.position.x > SCREEN_RIGHT){
            player.position = CGPointMake(SCREEN_RIGHT, GROUND_Y);
        }else if (player.position.x < SCREEN_LEFT){
            player.position = CGPointMake(SCREEN_LEFT, GROUND_Y);
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    startPt = [touch locationInNode:self];
    
    SKNode *player = [self childNodeWithName:@"player"];
    //タッチ開始時点のネコ画像の位置を保持
    startPlayerPosX = player.position.x;
}

- (void)didBeginContact:(SKPhysicsContact *)contact{
    if([contact.bodyA.node.name isEqualToString:@"player"] && ([contact.bodyB.node.name isEqualToString:@"leftWall"] || [contact.bodyB.node.name isEqualToString:@"rightWall"])){
        NSLog(@"hit");                                                                                                  
        
        //タイマー停止
        [_timer invalidate];
        _timer = nil;
        
        //SKTransition *push = [SKTransition pushWithDirection:SKTransitionDirectionUp duration:1.0];
        KGSecondScene *resultScene = [KGSecondScene sceneWithSize:self.size];
        resultScene.prevScene = self;
        [self.view presentScene:resultScene];
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact{
    
}
@end
