//
//  MyQuartzView.h
//  Patterns
//
//  Created by Helder da Rocha on 9/27/08.
//  Copyright 2008 Argo Navis. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MyQuartzView : NSView {

}
- (CGContextRef) windowContext;

- (void) coloredPattern: (CGContextRef) context;
- (void) stencilPattern: (CGContextRef) context;

@end
