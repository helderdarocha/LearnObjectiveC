//
//  MyQuartzView.h
//  MatrixTransformations
//
//  Created by Helder da Rocha on 9/23/08.
//  Copyright 2008 Argo Navis. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MyQuartzView : NSView {
	int h;
	int w;
}

- (void) drawImageInContext: (CGContextRef) context;

- (void) translate: (CGContextRef) context;
- (void) rotate: (CGContextRef) context;
- (void) scale: (CGContextRef) context;

- (void) affineRotate: (CGContextRef) context;
- (void) affineScale: (CGContextRef) context;
- (void) affineSkew: (CGContextRef) context;
- (void) affineTranslate: (CGContextRef) context;

- (void) affineTranslateAndScale: (CGContextRef) context;
- (void) affineConcatenatingTranslateAndScale: (CGContextRef) context;
- (void) affineTranslateAndScaleAndRotate: (CGContextRef) context;

@end
