//
//  MyQuartzView.h
//  QuartzBlendModes
//
//  Created by Helder da Rocha on 9/23/08.
//  Copyright 2008 Argo Navis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyQuartzView : NSView {
	CGBlendMode mode;
	NSArray *blendModes;
	float opacity;
	BOOL clipImage;
	NSString *buttonTitle;
	int colorsLength;
	
	IBOutlet NSSlider *slider;
	IBOutlet NSPopUpButton *popUp;
	IBOutlet NSButton *clipButton;
}

- (IBAction) setBlendMode: (id) sender;
- (IBAction) changeOpacity: (id) sender;
- (IBAction) clip: (id) sender;

- (CGContextRef) windowContext;

- (void) drawHorizontalRectangles: (CGContextRef) context;
- (void) drawVerticalRectangles: (CGContextRef) context;

@end
