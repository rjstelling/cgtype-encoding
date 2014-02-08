//
//  BUGViewController.m
//  optimisation-bug
//
//  Created by Richard Stelling on 08/02/2014.
//  Copyright (c) 2014 Richard Stelling. All rights reserved.
//

#import "BUGViewController.h"
#import "NSNumber+Encoding.h"

@interface BUGViewController ()

@end

@implementation BUGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Use the category to encode the numbers
    NSNumber *encodedRect = [NSNumber numberWithRect:CGRectMake(0, 0, 768, 1024)];
    NSNumber *encodedSize = [NSNumber numberWithSize:CGSizeMake(640, 1136)];
    NSNumber *encodePoint = [NSNumber numberWithPoint:CGPointMake(222, 666)];
    
    NSLog(@"encodedRect: %@", encodedRect);
    NSLog(@"encodedSize: %@", encodedSize);
    NSLog(@"encodePoint: %@", encodePoint);
    
    //Decodeing should fail if optmisation level is set to -Os or -O4
    CGRect rect = [encodedRect rectValue];
    CGSize size = [encodedSize sizeValue];
    CGPoint point = [encodePoint pointValue];
    
    NSLog(@"rect: %@", NSStringFromCGRect(rect));
    NSLog(@"size: %@", NSStringFromCGSize(size));
    NSLog(@"point: %@", NSStringFromCGPoint(point));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
