//
//  KusogeViewController.m
//  KusogeTest
//
//  Created by naoyashiga on 2014/09/16.
//  Copyright (c) 2014年 naoyashiga. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "KusogeViewController.h"
#import "KGSpriteScene.h"

@interface KusogeViewController ()

@end

@implementation KusogeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    SKView *skView = [[SKView alloc] initWithFrame:applicationFrame];
    //viewにSKViewのインスタンスを設定
    self.view = skView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SKView *skView = (SKView *)self.view;
    skView.showsDrawCount = YES;
    skView.showsNodeCount = YES;
    skView.showsFPS = YES;
    
    //シーンの作成
    SKScene *scene = [KGSpriteScene sceneWithSize:self.view.bounds.size];
    //SKScene *scene = [KGSpriteScene sceneWithSize:skView.bounds.size];
    [skView presentScene:scene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
