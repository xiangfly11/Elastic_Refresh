//
//  ViewController.m
//  Elastic_Refresh
//
//  Created by jiaxiang on 16/9/28.
//  Copyright © 2016年 jiaxiang. All rights reserved.
//


#import "ViewController.h"
#import "UIView+PresentationLayer.h"


static const CGFloat minimalHeight = 50.0;
static const CGFloat maxWaveHeight = 100.0;


@interface ViewController () {
    BOOL animating;
}

@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@property (nonatomic,strong) UIView *cControlPointView;
@property (nonatomic,strong) UIView *l1ControlPointView;
@property (nonatomic,strong) UIView *l2ControlPointView;
@property (nonatomic,strong) UIView *l3ControlPointView;
@property (nonatomic,strong) UIView *r1ControlPointView;
@property (nonatomic,strong) UIView *r2ControlPointView;
@property (nonatomic,strong) UIView *r3ControlPointView;

@property (nonatomic,strong) CADisplayLink * displayLink;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createView];
    
    [self layouControlPointsWithBaseHeight:minimalHeight waveHeight:0.0f locationX:self.view.bounds.size.width / 2.0];
    [self updateShapeLayer];
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateShapeLayer)];
    [_displayLink  addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    animating = NO;
    _displayLink.paused = !animating;
    self.view.userInteractionEnabled = !animating;
}


-(void) createView {
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, minimalHeight);
//  _shapeLayer.backgroundColor = [UIColor colorWithRed:57/255.0 green:67/255.0 blue:89/255.0 alpha:1.0].CGColor;
//    _shapeLayer.actions = [NSDictionary dictionaryWithObjectsAndKeys:NULL,@"position",NULL,@"bounds",NULL,@"path",nil];
    _shapeLayer.fillColor = [UIColor colorWithRed:57/255.0 green:67/255.0 blue:89/255.0 alpha:1.0].CGColor;
    [self.view.layer addSublayer:_shapeLayer];
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc]  initWithTarget:self action:@selector(panGestureDidMove:)]];
    
    _cControlPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
    _l1ControlPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
    _l2ControlPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
    _l3ControlPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
    _r1ControlPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
    _r2ControlPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
    _r3ControlPointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 3)];
    
//    _cControlPointView.backgroundColor = [UIColor redColor];
//    _l1ControlPointView.backgroundColor = [UIColor redColor];
//     _l2ControlPointView.backgroundColor = [UIColor redColor];
//     _l3ControlPointView.backgroundColor = [UIColor redColor];
//    _r1ControlPointView.backgroundColor = [UIColor redColor];
//    _r2ControlPointView.backgroundColor = [UIColor redColor];
//    _r3ControlPointView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:_cControlPointView];
    [self.view addSubview:_l1ControlPointView];
    [self.view addSubview:_l2ControlPointView];
    [self.view addSubview:_l3ControlPointView];
    [self.view addSubview:_r1ControlPointView];
    [self.view addSubview:_r2ControlPointView];
    [self.view addSubview:_r3ControlPointView];
    
}

-(void) panGestureDidMove:(UIPanGestureRecognizer *) recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateFailed || recognizer.state == UIGestureRecognizerStateCancelled) {
        CGFloat centerY = minimalHeight;
        animating = YES;
        [UIView animateWithDuration:0.9 delay:0.0 usingSpringWithDamping:0.57 initialSpringVelocity:0.0 options:nil animations:^{
         [self layouControlPointsWithBaseHeight:minimalHeight waveHeight:0.0f locationX:self.view.bounds.size.width / 2.0];
        [self updateShapeLayer];
        } completion:^(BOOL finished) {
            if (finished) {
                animating = NO;
                _displayLink.paused = NO;
            }
            
        }];
        
    }else {
        CGFloat additionalHeight = fmax([recognizer translationInView:self.view].y, 0);
        CGFloat waveHeight = fmin(additionalHeight * 0.6,maxWaveHeight);
        CGFloat baseHeight = minimalHeight + additionalHeight - waveHeight;
        CGFloat locationX = [recognizer  locationInView:self.view].x;
        [self layouControlPointsWithBaseHeight:baseHeight waveHeight:waveHeight locationX:locationX];
        [self updateShapeLayer];
        
    }
}

-(CGPathRef) currentPath {
    CGFloat width = self.view.bounds.size.width;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint:CGPointMake(0.0f, 0.0f)];
    [bezierPath addLineToPoint:CGPointMake(0.0f, [_l3ControlPointView PresentationLayerCenter:animating].y)];
    [bezierPath addCurveToPoint:[_l1ControlPointView PresentationLayerCenter:animating] controlPoint1:[_l3ControlPointView PresentationLayerCenter:animating] controlPoint2:[_l2ControlPointView PresentationLayerCenter:animating]];
    [bezierPath addCurveToPoint:[_r1ControlPointView PresentationLayerCenter:animating] controlPoint1:[_cControlPointView PresentationLayerCenter:animating] controlPoint2:[_r1ControlPointView PresentationLayerCenter:animating]];
    [bezierPath addCurveToPoint:[_r3ControlPointView PresentationLayerCenter:animating] controlPoint1:[_r1ControlPointView PresentationLayerCenter:animating] controlPoint2:[_r2ControlPointView PresentationLayerCenter:animating]];
    [bezierPath addLineToPoint:CGPointMake(width, 0.0f)];
    [bezierPath closePath];
    
    return bezierPath.CGPath;
}


-(void) updateShapeLayer {
    _shapeLayer.path = [self currentPath];
}

-(void) layouControlPointsWithBaseHeight:(CGFloat) baseHeight waveHeight:(CGFloat) waveHeight  locationX:(CGFloat) locationX {
    CGFloat width = self.view.bounds.size.width;
    
    CGFloat minLeftX = fmin((locationX - width / 2.0) * 0.28 , 0.0);
    CGFloat maxRightX = fmax((width + (locationX - width / 2.0) * 0.28), width);
    
    CGFloat leftPartWidth = locationX - minLeftX;
    CGFloat rightPartWidth = maxRightX - locationX;
    
    _l3ControlPointView.center = CGPointMake(minLeftX, baseHeight);
    _l2ControlPointView.center = CGPointMake(minLeftX + leftPartWidth * 0.44, baseHeight);
    _l1ControlPointView.center = CGPointMake(minLeftX + leftPartWidth * 0.71, baseHeight + waveHeight * 0.64);
    _cControlPointView.center = CGPointMake(locationX, baseHeight + waveHeight * 1.36);
    _r1ControlPointView.center = CGPointMake(maxRightX - rightPartWidth * 0.71, baseHeight + waveHeight * 0.64);
    _r2ControlPointView.center = CGPointMake(maxRightX - (rightPartWidth * 0.44), baseHeight);
    _r3ControlPointView.center = CGPointMake(maxRightX, baseHeight);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(UIStatusBarStyle) preferredStatusBarStyle {
    return  UIStatusBarStyleLightContent;
}
@end
