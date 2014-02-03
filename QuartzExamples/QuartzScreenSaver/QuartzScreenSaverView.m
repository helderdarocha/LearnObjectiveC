//
//  QuartzScreenSaverView.m
//  QuartzScreenSaver
//
//  Created by Helder da Rocha on 9/24/08.
//  Copyright (c) 2008, Argo Navis. All rights reserved.
//

#import "QuartzScreenSaverView.h"

#define RECT 0
#define OVAL 1
#define	ARC  2


@implementation QuartzScreenSaverView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
	NSBezierPath *path;
	NSRect shape; // shape bounding rectangle
	NSColor *color;
	float red, green, blue, alpha;
	int shapeType;
	
	// Calculate random width and height for shape
	float w = SSRandomFloatBetween([self bounds].size.width  / 100.0, [self bounds].size.width  / 10.0);
	float h = SSRandomFloatBetween([self bounds].size.height / 100.0, [self bounds].size.height / 10.0);
	shape.size = NSMakeSize(w, h);
	
	// Calculate random origin point
	shape.origin = SSRandomPointForSizeWithinRect(shape.size, [self bounds]);
	
	shapeType = SSRandomIntBetween(0, 2);

	switch (shapeType) {
		case RECT:
			path = [NSBezierPath bezierPathWithRect:shape];
			break;
		case OVAL:
			path = [NSBezierPath bezierPathWithOvalInRect:shape];
			break;
		case ARC:
		default:
			; // without this it does not compile. Why?
			float startAngle = SSRandomFloatBetween(0.0, 360.0);
			float endAngle   = SSRandomFloatBetween(startAngle, 360.0 + startAngle);
			float radius = (w <= h) ? w/2 : h/2;
			NSPoint origin = NSMakePoint(shape.origin.x, shape.origin.y);
			
			path = [NSBezierPath bezierPath];
			[path appendBezierPathWithArcWithCenter:origin 
											 radius:radius 
										 startAngle:startAngle 
										   endAngle:endAngle
										  clockwise: SSRandomIntBetween(0, 1)];
			break;
	}
	
	red = SSRandomFloatBetween(0.0, 255.0) / 255.0;
	blue = SSRandomFloatBetween(0.0, 255.0) / 255.0;
	green = SSRandomFloatBetween(0.0, 255.0) / 255.0;
	alpha = SSRandomFloatBetween(0.0, 255.0) / 255.0;
	
	color = [NSColor colorWithCalibratedRed:red 
									  green:green 
									   blue:blue 
									  alpha:alpha];
	[color set];
	
	// draw the image
	if (SSRandomIntBetween(0, 1) == 0) {
		[path fill];
	} else {
		[path stroke];
	}

}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
