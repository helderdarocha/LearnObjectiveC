//
//  MyQuartzView.m
//  Gradients
//
//  Created by Helder da Rocha on 9/28/08.
//  Copyright 2008 Argo Navis. All rights reserved.
//

#import "MyQuartzView.h"

// CGFunctionEvaluateCallback
// need to study C to understand these arrays
static void calculateShadingValues (void *info, const float *in, float *out) {
	size_t k;
	static const float c[] = {1.0, 0.0, 0.5, 1.0}; // range is from 0 to this
	
	size_t numberOfComponents = (size_t) info; // number of components passed here

	float input = *in; // level 0.0 to 1.0
	for (k = 0; k < numberOfComponents - 1; k++) { // ignore alpha
		*out++ = c[k] * input; // multiply each component by level
	}
	*out++ = 1; // why out++? and not out? incrementing the array index?
	// study more C to understand this!!!
}

// book examples copied to demonstrate radial shading
static void myCalculateShadingValues (void *info, 
									  const float *in, 
									  float *out) { 
	size_t k, components; 
	double frequency[4] = { 110, 220, 55, 0 }; // what is this???
	components = (size_t)info; 
	for (k = 0; k < components - 1; k++) 
		*out++ = (1 + sin(*in * frequency[k]))/2; 
	*out++ = 1; // alpha 
} 

@implementation MyQuartzView

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
	
	//[self drawGradients: windowContext];
	//[self drawMoreGradients: windowContext];
	[self axialShading: windowContext]; // prefer gradients - simpler!!!
	//[self radialShading: windowContext]; // prefer gradients - simpler!!
	
	CGContextRelease(windowContext);
}

// private function to create a shading function and return
- (CGFunctionRef) shadingFunctionCreateWithColorspace: (CGColorSpaceRef) colorspace
									 andCallbackArray: (CGFunctionCallbacks) callbacks {
	float input_value_range[2] = { 0, 1 }; // domain
	float output_value_ranges [8] = { 0, 1, 0, 1, 0, 1, 0, 1 }; 
	
	size_t components = 1 + CGColorSpaceGetNumberOfComponents (colorspace); // so colorspace comes w/o alpha?
	size_t domainDimension = 1; // what is this?
	
	return CGFunctionCreate( (void *) components, // why the pointer?
							domainDimension, 
							input_value_range, 
							components,  // range dimension
							output_value_ranges, 
							&callbacks);
}

- (void) axialShading: (CGContextRef) context {
	int w = [self bounds].size.width;
	int h = [self bounds].size.height;

	// shading setup
	CGPoint startPoint = CGPointMake(1.0, 1.0);
	CGPoint endPoint   = CGPointMake(2.0, 2.0);
	CGColorSpaceRef colorspace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	
	CGFunctionCallbacks callbacks = { 
		0, 
		&myCalculateShadingValues, 
		NULL 
	};
	
	CGFunctionRef shadingFunction = [self shadingFunctionCreateWithColorspace: colorspace
															 andCallbackArray: callbacks];
	
	CGShadingRef shading = CGShadingCreateAxial(colorspace, 
												startPoint, 
												endPoint, 
												shadingFunction, 
												false, 
												false);
	
	CGContextSaveGState(context);
	
	// clipping (before scaling)
	CGContextBeginPath(context);
	CGContextAddArc(context, w/2, h/2, h/2, 0.0, 2*M_PI, -1);
	CGContextClosePath(context);
	CGContextClip(context);
	
	// scaling
	CGAffineTransform transform = CGAffineTransformMakeScale(140.0, 140.0);
	CGContextConcatCTM(context, transform);
	
	// draw shading in clip
	CGContextDrawShading(context, shading);
	
	CGShadingRelease(shading);
	CGColorSpaceRelease(colorspace);
	CGFunctionRelease(shadingFunction);
	
	CGContextRestoreGState(context);
}

- (void) radialShading: (CGContextRef) context {
	CGPoint startPoint = CGPointMake(0.25,0.3); 
	float startRadius = .1; 
	CGPoint endPoint = CGPointMake(.7,0.7); 
	float endRadius = .25; 
	CGColorSpaceRef colorspace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	//book example
	CGFunctionCallbacks callbacks = { 
							0, 
							calculateShadingValues,
							//&myCalculateShadingValues, 
							NULL 
	};
	
	CGFunctionRef shadingFunction = [self shadingFunctionCreateWithColorspace:colorspace
															 andCallbackArray:callbacks];
	
	CGShadingRef shading = CGShadingCreateRadial (colorspace, 
						   startPoint, 
						   startRadius, 
						   endPoint, 
						   endRadius, 
						   shadingFunction, 
						   false, 
						   false); 
	
	
	// scaling
	CGAffineTransform transform = CGAffineTransformMakeScale(280.0, 280.0);
	CGContextConcatCTM(context, transform);
	
	CGContextDrawShading (context, shading);
	
	CGShadingRelease(shading);
	CGFunctionRelease(shadingFunction);
	CGColorSpaceRelease(colorspace);
}

- (void) drawMoreGradients: (CGContextRef) context {
	// clipping
	int w = [self bounds].size.width;
	int h = [self bounds].size.height;
	
	CGContextBeginPath(context);
	CGContextAddArc(context, w/2, h/2, h/2, 0.0, 2*M_PI, -1);
	CGContextClosePath(context);
	
	CGContextClip(context);
	
	// gradient drawing
	CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	
	// gray background
	size_t numLocations = 3; 
	CGFloat locationsBack[3] = { 0.0, 0.5, 1.0}; 
	CGFloat componentsBack[12] = { 
		1.0, 1.0, 1.0, 1.0, 
		0.2, 0.1, 0.1, 1.0, 
	    1.0, 1.0, 1.0, 1.0 
	}; 
	
	CGGradientRef grayGradient = CGGradientCreateWithColorComponents(colorSpace, componentsBack, locationsBack, numLocations);
	
	// alpha gradient foreground
	CGFloat locations[] = {.5, 0.0};
	numLocations = 2;
	CGFloat components[] = {
		0.7, 0.1, 0.2, 0.0, 
		1.0, 0.9, 0.9, 1.0 
	}; 
	
	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, numLocations);
	CGColorSpaceRelease(colorSpace);
	
	// paint background
	CGPoint startPoint = CGPointMake(0.0, 0.0);
	CGPoint endPoint   = CGPointMake([self bounds].size.width, [self bounds].size.height);
	
	// linear in context
	CGContextDrawLinearGradient (context, grayGradient, startPoint, endPoint, 0); // options = 0

	// draw foreground
	CGPoint startCenter = CGPointMake(210.0, 210.0);
	CGPoint endCenter   = CGPointMake(200.0, 200.0);
	CGFloat startRadius = 0.0;
	CGFloat endRadius   = 100.0;
	
	CGContextDrawRadialGradient(context, gradient, startCenter, startRadius, endCenter, endRadius, kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(gradient);
	CGGradientRelease(grayGradient);
	

}

- (void) drawGradients: (CGContextRef) context {
	CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	CGFloat locations[] = {1.0, 0.0};
	size_t numLocations = 2;
	CGFloat components[] = {
		1.0, 0.0, 0.2, 0.8,
		0.2, 0.0, 1.0, 1.0
	};
	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, numLocations);
	CGColorSpaceRelease(colorSpace);
	
	CGPoint startPoint = CGPointMake(0.0, 0.0);
	CGPoint endPoint   = CGPointMake(150.0, 150.0);

	// linear in context
	CGContextDrawLinearGradient (context, gradient, startPoint, endPoint, 0); // options = 0
	
	CGPoint startCenter = CGPointMake(200.0, 200.0);
	CGPoint endCenter   = CGPointMake(300.0, 300.0);
	CGFloat startRadius = 25.0;
	CGFloat endRadius   = 75.0;
	
	// radial in context
	CGContextDrawRadialGradient(context, gradient, startCenter, startRadius, endCenter, endRadius, kCGGradientDrawsAfterEndLocation);
	// this options extends the gradient
	
	CGGradientRelease(gradient);
}

@end
