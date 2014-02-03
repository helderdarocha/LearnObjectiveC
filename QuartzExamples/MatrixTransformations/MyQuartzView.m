//
//  MyQuartzView.m
//  MatrixTransformations
//
//  Created by Helder da Rocha on 9/23/08.
//  Copyright 2008 Argo Navis. All rights reserved.
//

#import "MyQuartzView.h"


@implementation MyQuartzView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        w = [self bounds].size.width;
		h = [self bounds].size.height;
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    CGContextRef winCtx = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextRetain(winCtx);
	
	[self rotate: winCtx];
	//[self scale: winCtx];
	//[self translate: winCtx];
	
	//[self affineRotate: winCtx];
	//[self affineScale: winCtx];
	//[self affineTranslate: winCtx];
	//[self affineSkew: winCtx];
	//[self affineTranslateAndScale: winCtx];
	//[self affineConcatenatingTranslateAndScale: winCtx];
	//[self affineTranslateAndScaleAndRotate: winCtx];

	[self drawImageInContext: winCtx];
	
	CGContextRelease(winCtx);
}

- (void) drawImageInContext: (CGContextRef) context {
	NSURL *url = [NSURL fileURLWithPath: @"/Users/helder/Desktop/image.jpg"];
	CGImageSourceRef source = CGImageSourceCreateWithURL( (CFURLRef)url, NULL);
	CGImageRef image = CGImageSourceCreateImageAtIndex(source, 0, NULL);
	CGContextDrawImage(context, CGRectMake(0,0,w,h), image);
}

- (void) rotate: (CGContextRef) context {
	CGContextRotateCTM(context, 45 * M_PI / 180);
}

- (void) scale: (CGContextRef) context {
	CGContextScaleCTM(context, .5, .5);
}

- (void) translate: (CGContextRef) context {
	CGContextTranslateCTM (context, 200, 0);
}

- (void) affineRotate: (CGContextRef) context {
	float angle = -45*M_PI/180;
	CGAffineTransform at = CGAffineTransformMake(cos(angle), sin(angle), -sin(angle), cos(angle), 0, 0);
	CGContextConcatCTM(context, at);
}

- (void) affineScale: (CGContextRef) context {
	CGAffineTransform at = CGAffineTransformMake(.5, 0, 0, .5, 0, 0);
	CGContextConcatCTM(context, at);
}

- (void) affineSkew: (CGContextRef) context {
	CGAffineTransform at = CGAffineTransformMake(.5, 0, -0.5, .5, 0, 0);
	CGContextConcatCTM(context, at);
}

- (void) affineTranslate: (CGContextRef) context {
	CGAffineTransform at = CGAffineTransformMake(1, 0, 0, 1, 200, 100);
	CGContextConcatCTM(context, at);
}

- (void) affineTranslateAndScale: (CGContextRef) context {
	CGAffineTransform at = CGAffineTransformMake(.3, 0, 0, .6, 200, 100);
	CGContextConcatCTM(context, at);
}

- (void) affineConcatenatingTranslateAndScale: (CGContextRef) context {
	CGAffineTransform at = CGAffineTransformMake(1, 0, 0, 1, 200, 100);
	CGContextConcatCTM(context, at);
	at = CGAffineTransformMake(.5, 0, 0, .5, 0, 0);
	CGContextConcatCTM(context, at);
}

- (void) affineTranslateAndScaleAndRotate: (CGContextRef) context {
	CGAffineTransform at = CGAffineTransformMake(.3, -.5, .5, .3, 200, 100);
	CGContextConcatCTM(context, at);
}


@end
