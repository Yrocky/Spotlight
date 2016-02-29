//
//  PLPSpotlight.h
//  PLPSpotlight
//
//  Created by 王鹏 on 13-12-12.
//  Copyright (c) 2013年 王鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLPSpotlight : UIView

@property (assign) NSTimeInterval animationDuration;
@property (assign) CGPoint spotlightCenter;
@property (nonatomic) CGGradientRef spotlightGradientRef;
@property (assign) float spotlightStartRadius;
@property (assign) float spotlightEndRadius;
@property (nonatomic,retain)UILabel * infoLabel;

+ (instancetype)addSpotlightInView:(UIView *)view atPoint:(CGPoint)centerPoint startRadius:(float)startRadius EndRadius:(float)endRaduis withLabel:(BOOL)withLabel labelFrame:(CGPoint)labelCenterPoint InfoText:(NSString *)text withImage:(BOOL)withImage imageWithName:(NSString *)image imageRotate:(int)rotate imageCenterPoint:(CGPoint)imageCenterPoint;

+ (instancetype)addSpotlightInView:(UIView *)view atPoint:(CGPoint)centerPoint withDuration:(NSTimeInterval)duration startRadius:(float)startRadius EndRadius:(float)endRaduis withLabel:(BOOL)withLabel labelFrame:(CGPoint)labelCenterPoint InfoText:(NSString *)text withImage:(BOOL)withImage imageWithName:(NSString *)image imageRotate:(int)rotate imageCenterPoint:(CGPoint)imageCenterPoint;

+ (NSArray *)spotlightsInView:(UIView *)view;


+ (instancetype)spotlightWithFrame:(CGRect)frame withSpotlightAtPoint:(CGPoint)centerPoint startRadius:(float)startRadius EndRadius:(float)endRaduis withLabel:(BOOL)withLabel labelFrame:(CGPoint)labelCenterPoint InfoText:(NSString *)text withImage:(BOOL)withImage imageWithName:(NSString *)image imageRotate:(int)rotate imageCenterPoint:(CGPoint)imageCenterPoint;

- (id)initWithFrame:(CGRect)frame withSpotlightAtPoint:(CGPoint)centerPoint startRadius:(float)startRadius EndRadius:(float)endRaduis withLabel:(BOOL)withLabel labelFrame:(CGPoint)labelCenterPoint InfoText:(NSString *)text withImage:(BOOL)withImage imageWithName:(NSString *)image imageRotate:(int)rotate imageCenterPoint:(CGPoint)imageCenterPoint;

+ (void)removeSpotlightsInView:(UIView *)view;

@end
