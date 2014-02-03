//
//  MyQuartzView.h
//  MyQuartzView
//
//  Created by Helder da Rocha on 9/22/08.
//  Copyright 2008 Argo Navis. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MyQuartzView : NSView {

}
- (CGContextRef) windowContext;
- (CGContextRef) createPDFContextWithPath: (CFStringRef) path andBounds: (CGRect *) bounds;
- (CGContextRef) createBitmapContextWithPixelWidth: (int) pixelWidth andPixelHeight: (int) pixelHeight;
- (void) drawOvals: (CGContextRef) context;
- (void) drawRectangles: (CGContextRef) context;
- (void) drawLines: (CGContextRef) context;
- (void) drawArcs: (CGContextRef) context;
- (void) drawCurves: (CGContextRef) context;
- (void) drawEllipseWithTransformation: (CGContextRef) context;
- (void) drawPath: (CGContextRef) context;
- (void) drawStrokedThings: (CGContextRef) context;
- (void) drawFilledThings: (CGContextRef) context;
- (void) drawMoreFilledThings: (CGContextRef) context;

- (void) drawCustomView;

@end
