//
//  NSNumber+Encoding.h
//  Category for encoding CGPoint, CGSize and CGRect into unsigned long long values
//
//  Created by Richard Stelling on 18/07/2013.
//  Copyright (c) 2013 Empirical Magic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Encoding)

+ (NSNumber *)numberWithPoint:(CGPoint)aPoint;
- (CGPoint)pointValue;

+ (NSNumber *)numberWithSize:(CGSize)aSize;
- (CGSize)sizeValue;

+ (NSNumber *)numberWithRect:(CGRect)aRect;
- (CGRect)rectValue;

@end
