//
//  MyQuartzView.m
//  Patterns
//
//  Created by Helder da Rocha on 9/27/08.
//  Copyright 2008 Argo Navis. All rights reserved.
//

#import "MyQuartzView.h"

#define PSIZE 16
#define H_PATTERN_SIZE 16
#define V_PATTERN_SIZE 16

//C callbacks (to draw the patterns)
void drawColoredPattern(void *info, CGContextRef context)  { 
	
	CGContextSetRGBFillColor(context, 1, 0, 0, 0.5); // red
	CGContextFillRect(context, CGRectMake(0, 0, 4, 4));
	CGContextFillRect(context, CGRectMake(12, 12, 4, 4));
	CGContextFillRect(context, CGRectMake(0, 12, 4, 4));
	CGContextFillRect(context, CGRectMake(12, 0, 4, 4));
	
	CGContextSetRGBFillColor(context, 0, 0.8, 0, 1.0); // solid green
	CGContextBeginPath(context);
	CGContextAddArc(context, 8, 8, 2, 0, 2 * M_PI, -1);
	CGContextFillPath(context);
	
	float startAngle = 0.5 * M_PI;
	float endAngle   = 0.0;
	CGContextSetRGBStrokeColor(context, 0, 0, 1, 1.0); // solid blue
	CGContextBeginPath(context);
	CGContextAddArc(context, 0, 0, 8, startAngle, endAngle, -1);
	CGContextStrokePath(context);
	
	startAngle = 1.5 * M_PI;
	endAngle   = M_PI;
	CGContextSetRGBStrokeColor(context, 0, 0, 1, 1.0); // solid blue
	CGContextBeginPath(context);
	CGContextAddArc(context, 16, 16, 8, startAngle, endAngle, -1);
	CGContextStrokePath(context);
}

static void drawStencilStar (void *info, CGContextRef myContext) { 
	int k; 
	double r, theta; 
	r = 0.8 * PSIZE / 2; 
	theta = 2 * M_PI * (2.0 / 5.0); // 144 degrees 
	CGContextTranslateCTM (myContext, PSIZE/2, PSIZE/2); 
	CGContextMoveToPoint(myContext, 0, r); 
	for (k = 1; k < 5; k++) { 
		CGContextAddLineToPoint (myContext, 
								 r * sin(k * theta), 
								 r * cos(k * theta)); 
	} 
	CGContextClosePath(myContext); 
	CGContextFillPath(myContext); 
}

static const CGPatternCallbacks colorCallbacks = {0, &drawColoredPattern, NULL};
static const CGPatternCallbacks stencilCallbacks = {0, &drawStencilStar, NULL};

// Objective C
@implementation MyQuartzView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void) coloredPattern: (CGContextRef) context {
	
	CGContextSaveGState(context);

	CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
	CGContextSetFillColorSpace(context, patternSpace);
	CGColorSpaceRelease(patternSpace);
	
	CGPatternRef pattern = CGPatternCreate(nil, 
										   CGRectMake(0, 0, 16, 16), 
										   CGAffineTransformIdentity, 16, 16, 
										   kCGPatternTilingNoDistortion, 
										   TRUE, 
										   &colorCallbacks);
	float alpha[1] = {1.0};
	CGContextSetFillPattern (context, pattern, alpha);
	CGPatternRelease(pattern);
	
	CGContextFillRect(context, CGRectMake(10,10,150,150));
	
	CGContextRestoreGState(context);
}

- (void) stencilPattern: (CGContextRef) context {
	
	CGContextSaveGState(context);
	CGSize offset = CGSizeMake(5.0, 5.0);
	CGFloat blur = 0.5;
	
	CGContextSetShadow(context, offset, blur);
	
	CGColorSpaceRef baseSpace = CGColorSpaceCreateWithName (kCGColorSpaceGenericRGB);
	CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(baseSpace);
	CGContextSetFillColorSpace(context, patternSpace);
	CGColorSpaceRelease(patternSpace);
	CGColorSpaceRelease(baseSpace);
	
	CGPatternRef pattern = CGPatternCreate(nil, 
										   CGRectMake(0, 0, 16, 16), 
										   CGAffineTransformIdentity, 16, 16, 
										   kCGPatternTilingNoDistortion, 
										   FALSE, 
										   &stencilCallbacks);
	
	float color[4] = {1.0, 0.0, 0.0, 0.5};
	CGContextSetFillPattern (context, pattern, color);
	CGContextFillRect(context, CGRectMake(160,160,150,150));
	
	float color2[4] = {0.0, 0.0, 1.0, 0.8};
	CGContextSetFillPattern (context, pattern, color2);
	CGContextFillRect(context, CGRectMake(310,160,150,150));
	
	CGPatternRelease(pattern);
	
	CGContextRestoreGState(context);
}

- (void)drawRect:(NSRect)rect {
	// Window context
	CGContextRef myWindowContext   = [self windowContext];
	CGContextRetain(myWindowContext);
	//drawColoredPattern(nil, myWindowContext);
	[self coloredPattern: myWindowContext];
	[self stencilPattern: myWindowContext];
	
	// window context release
	CGContextRelease(myWindowContext);
}

- (CGContextRef) windowContext {
	return [[NSGraphicsContext currentContext] graphicsPort];
}

@end
