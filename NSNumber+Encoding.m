//
//  NSNumber+Encoding.m
//  Category for encoding CGPoint, CGSize and CGRect into unsigned long long values
//
//  Created by Richard Stelling on 18/07/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import "NSNumber+Encoding.h"

typedef unsigned long long ULongLong;

const int SHIFT = 16;
const int SHIFT_DOUBLE = 32;

@implementation NSNumber (Encoding)

#pragma mark - Private

+ (ULongLong)encodeInteger:(ULongLong)high andInterger:(ULongLong)low withShift:(int)shiftValue
{
    ULongLong encoded = (high << shiftValue) + low;
    
    return encoded;
}

- (ULongLong *)splitEncodedInteger:(ULongLong)encocedInteger withShift:(int)shiftValue
{
    ULongLong *splitFloats = malloc(sizeof(ULongLong) * 2);
    
    splitFloats[0] = (encocedInteger >> shiftValue);
    splitFloats[1] = encocedInteger - ((encocedInteger >> shiftValue) << shiftValue);
    
    return splitFloats;
}

#pragma mark - Public

+ (NSNumber *)numberWithPoint:(CGPoint)aPoint
{
    NSInteger X = lroundf(aPoint.x);
    NSInteger Y = lroundf(aPoint.y);
    
    return [NSNumber numberWithUnsignedLongLong:[self encodeInteger:X andInterger:Y withShift:SHIFT]];
}

- (CGPoint)pointValue
{
    ULongLong encodedPoint = [self unsignedLongLongValue];
    ULongLong *values = [self splitEncodedInteger:encodedPoint withShift:SHIFT];
    
    /*volatile*/ CGPoint point = CGPointMake(values[0], values[1]);
    
    free(values); //clean up
    
    return point;
}

+ (NSNumber *)numberWithSize:(CGSize)aSize
{
    NSInteger width = lroundf(aSize.width);
    NSInteger height = lroundf(aSize.height);
    
    return [NSNumber numberWithUnsignedLongLong:[self encodeInteger:width andInterger:height withShift:SHIFT]];
}

- (CGSize)sizeValue
{
    ULongLong encodedPoint = [self unsignedLongLongValue];
    ULongLong *values = [self splitEncodedInteger:encodedPoint withShift:SHIFT];
    
    /*volatile*/ CGSize size = CGSizeMake((CGFloat)values[0], (CGFloat)values[1]);
    
    free(values); //clean up
    
    return size;
}

+ (NSNumber *)numberWithRect:(CGRect)aRect
{
    NSNumber *origin = [NSNumber numberWithPoint:aRect.origin];
    NSNumber *size = [NSNumber numberWithSize:aRect.size];
    
    ULongLong encodedRect = [self encodeInteger:[origin unsignedLongLongValue] andInterger:[size unsignedLongLongValue]  withShift:SHIFT_DOUBLE];
    
    return [NSNumber numberWithLongLong:encodedRect];
}

- (CGRect)rectValue
{
    ULongLong encodedRect = [self unsignedLongLongValue];
    
    ULongLong *values = [self splitEncodedInteger:encodedRect withShift:SHIFT_DOUBLE];
    ULongLong *originVlaues = [self splitEncodedInteger:(ULongLong)values[0] withShift:SHIFT];
    ULongLong *sizeValues = [self splitEncodedInteger:(ULongLong)values[1] withShift:SHIFT];
    
    /*volatile*/ CGRect rect = CGRectMake((CGFloat)originVlaues[0], (CGFloat)originVlaues[1], (CGFloat)sizeValues[0], (CGFloat)sizeValues[1]);
    
    free(values);
    free(originVlaues);
    free(sizeValues);
    
    return rect;
}

@end
