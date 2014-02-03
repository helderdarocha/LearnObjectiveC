//
//  CounterView.h
//  LightcommDialer
//
//  Created by Helder da Rocha on 3/15/09.
//  Copyright 2009 Argo Navis. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CounterView : NSView {
	int count;
	NSColor *backgroundColor;
	NSColor *color;
	NSView  *zeroView;
}

-(int )count;
-(NSColor *)backgroundColor;
-(NSColor *)color;
-(NSView *)zeroView;
  
-(void)setCount:(int)newCount;
-(void)setBackgroundColor:(NSColor *)color;
-(void)setColor:(NSColor *)color;
-(void)setZeroView:(NSView *)view;

@end
