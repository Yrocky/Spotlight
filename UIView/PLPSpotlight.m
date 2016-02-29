//
//  PLPSpotlight.m
//  PLPSpotlight
//
//  Created by 王鹏 on 13-12-12.
//  Copyright (c) 2013年 王鹏. All rights reserved.
//

#import "PLPSpotlight.h"

#define kDEFAULT_DURATION 0.3

@implementation PLPSpotlight
@synthesize infoLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Static Methods

+ (instancetype)spotlightWithFrame:(CGRect)frame withSpotlightAtPoint:(CGPoint)centerPoint startRadius:(float)startRadius EndRadius:(float)endRaduis  withLabel:(BOOL)withLabel labelFrame:(CGPoint)labelCenterPoint InfoText:(NSString *)text withImage:(BOOL)withImage imageWithName:(NSString *)image imageRotate:(int)rotate imageCenterPoint:(CGPoint)imageCenterPoint
{
    PLPSpotlight *newSpotlight = [[PLPSpotlight alloc] initWithFrame:frame
                                                withSpotlightAtPoint:centerPoint startRadius:startRadius EndRadius:endRaduis withLabel:withLabel labelFrame:labelCenterPoint InfoText:text withImage:withImage imageWithName:image imageRotate:rotate imageCenterPoint:imageCenterPoint];
    return newSpotlight;
}


+ (instancetype)addSpotlightInView:(UIView *)view atPoint:(CGPoint)centerPoint startRadius:(float)startRadius EndRadius:(float)endRaduis  withLabel:(BOOL)withLabel labelFrame:(CGPoint)labelCenterPoint InfoText:(NSString *)text withImage:(BOOL)withImage imageWithName:(NSString *)image imageRotate:(int)rotate imageCenterPoint:(CGPoint)imageCenterPoint
{
    return [[self class] addSpotlightInView:view atPoint:centerPoint withDuration:kDEFAULT_DURATION startRadius:startRadius EndRadius:endRaduis withLabel:withLabel labelFrame:labelCenterPoint InfoText:text withImage:withImage imageWithName:image imageRotate:rotate imageCenterPoint:imageCenterPoint];
}

+ (instancetype)addSpotlightInView:(UIView *)view atPoint:(CGPoint)centerPoint withDuration:(NSTimeInterval)duration startRadius:(float)startRadius EndRadius:(float)endRaduis  withLabel:(BOOL)withLabel labelFrame:(CGPoint)labelCenterPoint InfoText:(NSString *)text withImage:(BOOL)withImage imageWithName:(NSString *)image imageRotate:(int)rotate imageCenterPoint:(CGPoint)imageCenterPoint
{
    
    PLPSpotlight *newSpotlight = [[self class] spotlightWithFrame:view.bounds
                                             withSpotlightAtPoint:centerPoint startRadius:startRadius EndRadius:endRaduis withLabel:withLabel labelFrame:labelCenterPoint InfoText:text withImage:withImage imageWithName:image imageRotate:rotate imageCenterPoint:imageCenterPoint];
    [newSpotlight setAnimationDuration:duration];
    [view addSubview:newSpotlight];
    [newSpotlight setAlpha:0];
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationCurveEaseOut|
     UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [newSpotlight setAlpha:1];
                     }
                     completion:nil];
    
    return newSpotlight;
}


+ (NSArray *)spotlightsInView:(UIView *)view
{
    NSMutableArray *spotlights = [NSMutableArray array];
    for(UIView *subview in view.subviews){
        if([subview isKindOfClass:[self class]]){
            [spotlights addObject:subview];
        }
    }
    
    return [NSArray arrayWithArray:spotlights];
}

+ (void)removeSpotlightsInView:(UIView *)view
{
    NSArray *spotlightsInView = [[self class] spotlightsInView:view];
    for(PLPSpotlight *spotlight in spotlightsInView){
        if([spotlight isKindOfClass:[self class]]){
            [UIView animateWithDuration:spotlight.animationDuration
                                  delay:0
                                options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 [spotlight setAlpha:0];
                             }
                             completion:^(BOOL finished){
                                 [spotlight removeFromSuperview];
                             }];
        }
    }
}

- (void)setSpotlightGradientRef:(CGGradientRef)newSpotlightGradientRef
{
    CGGradientRelease(_spotlightGradientRef);
    _spotlightGradientRef = nil;
    
    _spotlightGradientRef = newSpotlightGradientRef;
    CGGradientRetain(_spotlightGradientRef);
    
    [self setNeedsDisplay];
}

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame withSpotlightAtPoint:(CGPoint)centerPoint startRadius:(float)startRadius EndRadius:(float)endRaduis  withLabel:(BOOL)withLabel labelFrame:(CGPoint)labelCenterPoint InfoText:(NSString *)text withImage:(BOOL)withImage imageWithName:(NSString *)image imageRotate:(int)rotate imageCenterPoint:(CGPoint)imageCenterPoint
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth |
         UIViewAutoresizingFlexibleHeight];
        
        [self setContentMode:UIViewContentModeRedraw];
        [self setUserInteractionEnabled:NO];
        [self setSpotlightCenter:centerPoint];
        [self setAnimationDuration:kDEFAULT_DURATION];
        [self setBackgroundColor:[UIColor clearColor]];
        
        CGGradientRef defaultGradientRef = [[self class] newSpotlightGradient];
        [self setSpotlightGradientRef:defaultGradientRef];
        CGGradientRelease(defaultGradientRef);
        
//        [self setSpotlightStartRadius:startRadius];
        [self setSpotlightStartRadius:0];
        [self setSpotlightEndRadius:endRaduis];
        if (withLabel) {
            infoLabel = [[UILabel alloc] init];
            [infoLabel setText:text];
            [infoLabel setTextAlignment:NSTextAlignmentCenter];
            [infoLabel setTextColor:[UIColor whiteColor]];
            [infoLabel setFont:[UIFont fontWithName:@"Arial" size:18]];
            [infoLabel setFrame:CGRectMake(0, labelCenterPoint.y, [[UIScreen mainScreen] bounds].size.width, 80)];
            [infoLabel setBackgroundColor:[UIColor clearColor]];
            [infoLabel setNumberOfLines:0];
            [self addSubview:infoLabel];
        }
        if (withImage) {
            UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
            [imageView setCenter:imageCenterPoint];
            // 旋转
            CGAffineTransform transform = CGAffineTransformIdentity;
            imageView.transform = CGAffineTransformRotate(transform,  rotate * M_PI / 180 );
            [self addSubview:imageView];
        }
    }
    return self;
}

#pragma mark - Drawing Override
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGGradientRef gradient = self.spotlightGradientRef;
    
    float radius = self.spotlightEndRadius;
    float startRadius = self.spotlightStartRadius;
    CGContextDrawRadialGradient (context, gradient, self.spotlightCenter, startRadius, self.spotlightCenter, radius, kCGGradientDrawsAfterEndLocation);
}

#pragma mark - Factory Method

+ (CGGradientRef)newSpotlightGradient
{
    size_t locationsCount = 2;
    CGFloat locations[2] = {0.0f, 1.0f,};
    CGFloat colors[12] = {0.0f,0.0f,0.0f,0.0f,
        0.0f,0.0f,0.0f,0.70f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
    CGColorSpaceRelease(colorSpace);
    
    return gradient;
}

#pragma mark - Deallocation

- (void)dealloc
{
    [super dealloc];
    [self setSpotlightGradientRef:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
