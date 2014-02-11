//
//  NSNumber+Encoding.m
//  Category for encoding CGPoint, CGSize and CGRect into unsigned long long values
//
//  Created by Richard Stelling on 18/07/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import "NSNumber+Encoding.h"

typedef unsigned long long ULongLong;

typedef struct _SplitInteger {
    
    ULongLong high;
    ULongLong low;
    
} SplitInteger;

const int SHIFT = 16;
const int SHIFT_DOUBLE = 32;

@implementation NSNumber (Encoding)

#pragma mark - Private

+ (ULongLong)encodeInteger:(ULongLong)high andInterger:(ULongLong)low withShift:(int)shiftValue
{
    ULongLong encoded = (high << shiftValue) + low;
    
    return encoded;
}

- (SplitInteger)splitEncodedInteger:(ULongLong)encocedInteger withShift:(int)shiftValue
{
    SplitInteger split = {0, 0};
    
    split.high = (encocedInteger >> shiftValue);
    split.low = encocedInteger - ((encocedInteger >> shiftValue) << shiftValue);
    
    return split;
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
    SplitInteger values = [self splitEncodedInteger:encodedPoint withShift:SHIFT];
    
    /*volatile*/ CGPoint point = CGPointMake(values.high, values.low);
    
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
    ULongLong encodedSize = [self unsignedLongLongValue];
    SplitInteger values = [self splitEncodedInteger:encodedSize withShift:SHIFT];
    
    /*volatile*/ CGSize size = CGSizeMake((CGFloat)values.high, (CGFloat)values.low);
    
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
    
    SplitInteger values = [self splitEncodedInteger:encodedRect withShift:SHIFT_DOUBLE];
    SplitInteger originValues = [self splitEncodedInteger:values.high withShift:SHIFT];
    SplitInteger sizeValues = [self splitEncodedInteger:values.low withShift:SHIFT];
    
    /*volatile*/ CGRect rect = CGRectMake((CGFloat)originValues.high, (CGFloat)originValues.low, (CGFloat)sizeValues.high, (CGFloat)sizeValues.low);
    
    return rect;
}

@end
