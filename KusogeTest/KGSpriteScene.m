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

static const float speed = 1.5f;
static const float groundToBottomSpeed = 0.3f;
static const float playerSpeed = 2.0f;

static const float wallCreateInterval = 0.6f;
static const int holyPieceNum = 8;

CGPoint startPt;
float startPlayerPosX;

float SCREEN_RIGHT;
float SCREEN_LEFT;
int GROUND_Y;

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
    
    self.backgroundColor = [SKColor colorWithRed:0 green:0.3 blue:0 alpha:1.0];
    
    //BGMを設定
    
    NSError *error;
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"bgm"
                                         ofType:@"mp3"]];
    self.bgm = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    self.bgm.numberOfLoops = -1;
    [self.bgm play];
    
    [self addScoreDisplay];
//    [self addGround];
    [self addPlayer];
    
    //繰り返し壁を生成
    _timer = [NSTimer scheduledTimerWithTimeInterval:wallCreateInterval target:self selector:@selector(addWall) userInfo:nil repeats:YES];
}

//スコアを表示
- (void)addScoreDisplay{
    self.scoreDisplay = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    self.scoreDisplay.text = @"😎";
    self.scoreDisplay.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 100);
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

//プレイヤーを追加
- (void)addPlayer{
    SKLabelNode *player = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    player.text = @"💩";
    //ウンチのサイズ
    player.fontSize = self.frame.size.width / 5;
    
    player.position = CGPointMake(CGRectGetMidX(self.frame), GROUND_Y);
    player.name = @"player";
    
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(10, 10)];
    player.physicsBody.affectedByGravity = NO;
    player.physicsBody.contactTestBitMask = 1;
    [self addChild:player];
    //画面端を定義
    SCREEN_RIGHT = self.view.bounds.size.width - player.frame.size.width / 2;
    SCREEN_LEFT = player.frame.size.width / 2;
}

//壁を追加
- (void)addWall{
    //左の⛪️の数をランダムに決める
    int leftHolyPieceNum = arc4random() % holyPieceNum;
    SKLabelNode *leftHoly = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    leftHoly.text = @"";
    for (int i = 0; i < leftHolyPieceNum; i++) {
        //絵文字を結合
        leftHoly.text = [leftHoly.text stringByAppendingString:@"⛪️"];
    }
    leftHoly.fontSize = self.frame.size.width / (holyPieceNum + 1);
    leftHoly.position = CGPointMake(leftHoly.frame.size.width / 2, self.view.bounds.size.height + leftHoly.frame.size.height / 2);
    leftHoly.name = @"leftHoly";
    leftHoly.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:leftHoly.frame.size];
    leftHoly.physicsBody.dynamic = NO;
    leftHoly.physicsBody.contactTestBitMask = 1;
    [self addChild:leftHoly];
    
    //右の教会を作成
    SKLabelNode *rightHoly = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    rightHoly.text = @"️️️️️️️";
    int spaceSize = 2;
    for (int i = 0; i < holyPieceNum - (leftHolyPieceNum + spaceSize - 1); i++) {
        rightHoly.text = [rightHoly.text stringByAppendingString:@"⛪️"];
    }
    rightHoly.fontSize = leftHoly.fontSize;
    //左の⛪️　+ スペース　+ 右の⛪️
    rightHoly.position = CGPointMake(self.frame.size.width - rightHoly.frame.size.width / 2, self.view.bounds.size.height + rightHoly.frame.size.height / 2);
    rightHoly.name = @"rightHoly";
    rightHoly.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rightHoly.frame.size];
    rightHoly.physicsBody.dynamic = NO;
    rightHoly.physicsBody.contactTestBitMask = 1;
    [self addChild:rightHoly];
    
    
    CGPoint leftHolyScreenTop = CGPointMake(leftHoly.frame.size.width / 2, self.view.bounds.size.height + leftHoly.frame.size.height / 2);
    CGPoint leftHolyScreenBottom = CGPointMake(leftHoly.frame.size.width / 2, - leftHoly.frame.size.height / 2);
    //地面下
    CGPoint leftHolyGroundBottom = CGPointMake(leftHoly.frame.size.width / 2, GROUND_Y - leftHoly.frame.size.height / 2);
    
    //アニメーションを定義
    SKAction *leftHolyMoveGround = [SKAction moveTo:leftHolyGroundBottom duration:speed];
    SKAction *leftHolyMoveDown = [SKAction moveTo:leftHolyScreenBottom duration:groundToBottomSpeed];
    SKAction *leftHolyMoveTop = [SKAction moveTo:leftHolyScreenTop duration:0.0f];
    //スコアを計算
    SKAction *updateScore = [SKAction runBlock:^{
        [self calcScore];
    }];
    SKAction *remove = [SKAction removeFromParent];
    
    SKAction *leftHolySequence = [SKAction sequence:@[leftHolyMoveGround,updateScore,leftHolyMoveDown,leftHolyMoveTop,remove]];
    [leftHoly runAction:leftHolySequence];
    
    
    float rightHolyPosX = self.frame.size.width - rightHoly.frame.size.width / 2;
    CGPoint rightHolyScreenTop = CGPointMake(rightHolyPosX, self.view.bounds.size.height + rightHoly.frame.size.height / 2);
    CGPoint rightHolyScreenBottom = CGPointMake(rightHolyPosX, - rightHoly.frame.size.height / 2);
    //地面下
    CGPoint rightHolyGroundBottom = CGPointMake(rightHolyPosX, GROUND_Y - rightHoly.frame.size.height / 2);
    
    //アニメーションを定義
    SKAction *rightHolyMoveGround = [SKAction moveTo:rightHolyGroundBottom duration:speed];
    SKAction *rightHolyMoveDown = [SKAction moveTo:rightHolyScreenBottom duration:groundToBottomSpeed];
    SKAction *rightHolyMoveTop = [SKAction moveTo:rightHolyScreenTop duration:0.0f];
    
    SKAction *rightHolySequence = [SKAction sequence:@[rightHolyMoveGround,rightHolyMoveDown,rightHolyMoveTop,remove]];
    [rightHoly runAction:rightHolySequence];
}

//スコアを計算
- (void)calcScore{
    [KGSingletonSample sharedManager].score++;
    NSString *str1 = @"😎";
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
    if([contact.bodyA.node.name isEqualToString:@"player"] && ([contact.bodyB.node.name isEqualToString:@"leftHoly"] || [contact.bodyB.node.name isEqualToString:@"rightHoly"])){
        NSLog(@"hit");                                                                                                  
        
        //タイマー停止
        [_timer invalidate];
        _timer = nil;
        
        //sound stop
        [self.bgm stop];
        
        KGSecondScene *resultScene = [KGSecondScene sceneWithSize:self.size];
        resultScene.prevScene = self;
        [self.view presentScene:resultScene];
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact{
    
}
@end
