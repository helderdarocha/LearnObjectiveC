//
//  MyQuartzView.m
//  Shadows
//
//  Created by Helder da Rocha on 9/28/08.
//  Copyright 2008 Argo Navis. All rights reserved.
//

#import "MyQuartzView.h"


@implementation MyQuartzView

- (void) drawShadows: (CGContextRef) context {
	CGContextSaveGState(context);
	
	CGSize offset = CGSizeMake(10.0, 10.0);
	CGFloat blur = 5.0;
	
	CGContextSetShadow(context, offset, blur);
	CGContextSetRGBFillColor(context, 1.0, .3, .2, .9);
	CGContextFillEllipseInRect(context, CGRectMake(100, 100, 200, 150));
	
	CGContextRestoreGState(context);
	
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    CGContextRef windowContext = [[NSGraphicsContext currentContext] graphicsPort]; 
	CGContextRetain(windowContext);
	
	[self drawShadows: windowContext];
	
	CGContextRelease(windowContext);
}

@end
