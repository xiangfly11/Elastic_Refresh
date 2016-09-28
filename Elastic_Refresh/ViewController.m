//
//  ViewController.m
//  Elastic_Refresh
//
//  Created by jiaxiang on 16/9/28.
//  Copyright © 2016年 jiaxiang. All rights reserved.
//


#import "ViewController.h"

static const CGFloat minimalHeight = 50.0;

@interface ViewController ()

@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createView];
    
}


-(void) createView {
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, minimalHeight);
    _shapeLayer.backgroundColor = [UIColor colorWithRed:57/255.0 green:67/255.0 blue:89/255.0 alpha:1.0].CGColor;
//    _shapeLayer.actions = [NSDictionary dictionaryWithObjectsAndKeys:NULL,@"position",NULL,@"bounds",NULL,@"path",nil];
    [self.view.layer addSublayer:_shapeLayer];
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc]  initWithTarget:self action:@selector(handlePanGesture:)]];
    

}

-(void) handlePanGesture:(UIPanGestureRecognizer *) recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateFailed || recognizer.state == UIGestureRecognizerStateCancelled) {
        
    }else {
        CGRect frame = _shapeLayer.frame;
        frame.size.height = minimalHeight + MAX([recognizer translationInView:self.view].y, 0);
        _shapeLayer.frame = frame;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(UIStatusBarStyle) preferredStatusBarStyle {
    return  UIStatusBarStyleLightContent;
}
@end
