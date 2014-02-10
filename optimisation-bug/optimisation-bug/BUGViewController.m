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
{
}

- (void)viewDidLoad
{
#ifdef DEBUG
# warning Compiling with no optmisations, the code should work as expected
    NSLog(@"*** Compiling with no optmisations, the code should work as expected ***");
#endif

#ifdef RELEASE
# warning Compiling with -Os optmisations, the code should *NOT* work as expected
    NSLog(@">>> Compiling with -Os optmisations, the code should *NOT* work as expected <<<");
#endif
    
    [super viewDidLoad];
    
    CGRect rect;
    CGSize size;
    CGPoint point;
    
    //Use the category to encode the numbers
    NSNumber *encodedRect = [NSNumber numberWithRect:CGRectMake(0, 0, 768, 1024)];
    NSNumber *encodedSize = [NSNumber numberWithSize:CGSizeMake(688, 944)];
    NSNumber *encodePoint = [NSNumber numberWithPoint:CGPointMake(40, 40)];
    
    NSLog(@"encodedRect: %@", encodedRect);
    NSLog(@"encodedSize: %@", encodedSize);
    NSLog(@"encodePoint: %@", encodePoint);
    
    //Decodeing should fail if optmisation level is set to -Os or -O4
    rect = [encodedRect rectValue];
    size = [encodedSize sizeValue];
    point = [encodePoint pointValue];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, size.width, size.height)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    NSLog(@"rect: %@", NSStringFromCGRect(rect));
    NSLog(@"size: %@", NSStringFromCGSize(size));
    NSLog(@"point: %f, %f", point.x, point.y);
    
    NSLog(@"DONE");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
