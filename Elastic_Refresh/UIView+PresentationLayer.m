//
//  UIView+PresentationLayer.m
//  Elastic_Refresh
//
//  Created by jiaxiang on 16/9/29.
//  Copyright © 2016年 jiaxiang. All rights reserved.
//

#import "UIView+PresentationLayer.h"

@implementation UIView (PresentationLayer)

-(CGPoint) PresentationLayerCenter:(BOOL) shouldUsePresentationLayer {
    if (shouldUsePresentationLayer) {
        CALayer *presentationLayer = [self.layer presentationLayer];
        return presentationLayer.position;
    }
    
    return self.center;
}

@end
