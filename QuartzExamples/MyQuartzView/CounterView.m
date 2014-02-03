//
//  CounterView.m
//  LightcommDialer
//
//  Created by Helder da Rocha on 3/15/09.
//  Copyright 2009 Argo Navis. All rights reserved.
//

#import "CounterView.h"


@implementation CounterView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        backgroundColor = [NSColor grayColor];
		color = [NSColor whiteColor];
		zeroView = [[NSView alloc] initWithFrame:[self frame]];
		[self addSubview:zeroView];
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    CGContextRef context   = [[NSGraphicsContext currentContext] graphicsPort];
	
	int h = [self bounds].size.height;
	int w = [self bounds].size.width;
	backgroundColor = [backgroundColor colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
	
	//CGContextSetRGBFillColor(context, [backgroundColor redComponent] , [backgroundColor greenComponent] , [backgroundColor blueComponent], 1.0);
	
	CGContextSetRGBFillColor(context, 1.0 , 1.0 , 1.0, 1.0);
	NSLog(@"w = %i, h = %i",w,h);
	CGContextFillEllipseInRect(context, CGRectMake(0.0, 0.0, w, h));

}

-(int)count {
	return count;
}
-(NSColor *)backgroundColor {
	return backgroundColor;
}
-(NSColor *)color {
	return color;
}
-(NSView *)zeroView {
	return zeroView;
}

-(void)setCount:(int)newCount {
	count = newCount;
}
-(void)setBackgroundColor:(NSColor *)value {
	[value retain];
	[backgroundColor release];
	backgroundColor = value;
}
-(void)setColor:(NSColor *)value {
	[value retain];
	[color release];
	color = value;
}
-(void)setZeroView:(NSView *)value {
	[value retain];
	[zeroView release];
	zeroView = value;
}
		

-(void)dealloc {
	[backgroundColor release];
	[color release];
	[zeroView release];
	[super dealloc];
}

@end
