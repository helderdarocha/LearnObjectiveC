//
//  MyQuartzView.m
//  QuartzBlendModes
//
//  Created by Helder da Rocha on 9/23/08.
//  Copyright 2008 Argo Navis. All rights reserved.
//

#import "MyQuartzView.h"
#define RGB() (random() % 256 / 256.0)

static CGBlendMode modes[] = {
			kCGBlendModeNormal,
			kCGBlendModeMultiply,
			kCGBlendModeScreen,
			kCGBlendModeOverlay,
			kCGBlendModeDarken,
			kCGBlendModeLighten,
			kCGBlendModeColorDodge,
			kCGBlendModeColorBurn,
			kCGBlendModeSoftLight,
			kCGBlendModeHardLight,
			kCGBlendModeDifference,
			kCGBlendModeExclusion,
			kCGBlendModeHue,
			kCGBlendModeSaturation,
			kCGBlendModeColor,
			kCGBlendModeLuminosity,
			kCGBlendModeClear,
			kCGBlendModeCopy,
			kCGBlendModeSourceIn,
			kCGBlendModeSourceOut,
			kCGBlendModeSourceAtop,
			kCGBlendModeDestinationOver,
			kCGBlendModeDestinationIn,
			kCGBlendModeDestinationOut,
			kCGBlendModeDestinationAtop,
			kCGBlendModeXOR,
			kCGBlendModePlusDarker,
			kCGBlendModePlusLighter
};

static CGColorRef colors[8];

@implementation MyQuartzView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        mode = kCGBlendModeNormal;
		NSMutableArray *theBlendModes = [NSMutableArray arrayWithObjects:
									 @"Normal",
									 @"Multiply",
								     @"Screen",
									 @"Overlay",
									 @"Darken",
									 @"Lighten",
									 @"ColorDodge",
									 @"ColorBurn",
									 @"SoftLight",
									 @"HardLight",
									 @"Difference",
									 @"Exclusion",
									 @"Hue",
									 @"Saturation",
									 @"Color",
									 @"Luminosity",
									 @"Clear",
									 @"Copy",
									 @"SourceIn",
									 @"SourceOut",
									 @"SourceAtop",
									 @"DestinationOver",
									 @"DestinationIn",
									 @"DestinationOut",
									 @"DestinationAtop",
									 @"XOR",
									 @"PlusDarker",
									 @"PlusLighter", 
									 nil];
		[theBlendModes retain];
		blendModes = [theBlendModes copy];
		[theBlendModes release];
		opacity = 1.0;
		clipImage = NO;
		buttonTitle = @"Clip Image With Circle";
		
		CGColorSpaceRef space = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
		int i;
		for (i = 0; i < 8; i++) {
			CGFloat colorComponents[3];
			for (int j = 0; j < 3; j++) {
				colorComponents[j] = (i >> j) & 1;
			}
			colorComponents[3] = 1.0;
			colors[i] = CGColorCreate(space, colorComponents);
		}
		int k;
		for (k = 0; k < 8; k++) {
			CGFloat colorComponents[3];
			for (int j = 0; j < 3; j++) {
				CGFloat result = (k >> j) & 1;
				if (result == 0)
					result = 0.5;
				colorComponents[j] = result;
			}
			colorComponents[3] = 1.0;
			colors[i + k - 1] = CGColorCreate(space, colorComponents);
		}
		colorsLength = i + k;
		CGColorSpaceRelease(space);
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
	
	float w = [self bounds].size.width;
	float h = [self bounds].size.height;
	
	CGContextRef myWindowContext   = [self windowContext];
	CGContextRetain(myWindowContext);
	
	CGContextSetRGBFillColor(myWindowContext, 0.0, 0.0, 0.0, 0.0);
	CGContextStrokeRect(myWindowContext, CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height));
	
	CGContextSetBlendMode(myWindowContext, mode);
	
	if (clipImage) {
		CGContextBeginPath (myWindowContext); 
		CGContextAddArc (myWindowContext, w/2, h/2, ((w>h) ? h : w)/2, 0, 2*M_PI, 1); 
		CGContextClosePath (myWindowContext); 
		CGContextEOClip (myWindowContext);	
	}
	float op = opacity;
	opacity = 1.0;
	[self drawHorizontalRectangles: myWindowContext];
	opacity = op;
	[self drawVerticalRectangles: myWindowContext];
	

	
	CGContextRelease(myWindowContext);
}

- (IBAction) setBlendMode: (id) sender {
	NSInteger index = [popUp indexOfSelectedItem];
	mode = modes[index];
	[self setNeedsDisplay:YES];
}

- (IBAction) changeOpacity: (id) sender {
	opacity = [slider floatValue];
	[self setNeedsDisplay:YES];
}

- (IBAction) clip: (id) sender {
	if (clipImage) {
		clipImage = NO;
		buttonTitle = @"Clip Image";
		[clipButton setTitle:buttonTitle];
	} else {
		clipImage = YES;
		buttonTitle = @"Unclip Image";
		[clipButton setTitle:buttonTitle];
	}
	[self setNeedsDisplay:YES];
}

- (void) drawHorizontalRectangles: (CGContextRef) context {
	for (int i = 0; i < colorsLength - 1; i++) { // remove last black
		CGColorRef color = CGColorCreateCopyWithAlpha(colors[i], opacity);
		CGContextSetFillColorWithColor(context, color);
		CGColorRelease(color);
		CGContextFillRect(context, CGRectMake(0, 100 + 20*i, 500, 20));
	}
}

- (void) drawVerticalRectangles: (CGContextRef) context {
	// flip context sideways
	CGAffineTransform at = CGAffineTransformMake(0,1,-1,0,500,0);
	CGContextConcatCTM(context, at);
	
	[self drawHorizontalRectangles: context];
}

- (CGContextRef) windowContext {
	return [[NSGraphicsContext currentContext] graphicsPort];
}

- (void) dealloc {
	[blendModes release];
	[slider release];
	[clipButton release];
	[popUp release];
	
	for (int i = 0; i < colorsLength; i++) {
		free(colors[i]);
	}	
	
	[super dealloc];
}

@end
