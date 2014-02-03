//
//  MyQuartzView.h
//  Gradients
//
//  Created by Helder da Rocha on 9/28/08.
//  Copyright 2008 Argo Navis. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MyQuartzView : NSView {

}

- (void) drawGradients: (CGContextRef) context;
- (void) drawMoreGradients: (CGContextRef) context;
- (void) axialShading: (CGContextRef) context;
- (void) radialShading: (CGContextRef) context;

// exercise - do these two shadings with gradients!!!

@end
