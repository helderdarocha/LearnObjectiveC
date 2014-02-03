//
//  MyQuartzView.m
//  MyQuartzView
//
//  Created by Helder da Rocha on 9/22/08.
//  Copyright 2008 Argo Navis. All rights reserved.
//

#import "MyQuartzView.h"

#import "CounterView.h" // test view

#define RGB() (random() % 256 / 256.0)


@implementation MyQuartzView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		/*
		CounterView *counterView = [[CounterView alloc] initWithFrame:[self frame]];
		[counterView setCount:123];
		[counterView setHidden:NO];
		[self addSubview:counterView];
		*/
    }
    return self;
}

- (void)drawRect:(NSRect)rect {

	// Window context
	CGRect windowBox = CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height);
	CGContextRef myWindowContext   = [self windowContext];
	CGContextRetain(myWindowContext);
	[self drawRectangles: myWindowContext];
	
	// PDF context
	CGRect mediaBox = CGRectMake(0, 0, 400, 300);
	CGContextRef myDocumentContext = [self createPDFContextWithPath: CFSTR("/Users/helder/Desktop/myPdf.pdf") andBounds: &mediaBox];
	// page 1
	CGContextBeginPage(myDocumentContext, &mediaBox);
	[self drawRectangles: myDocumentContext];
	CGContextEndPage(myDocumentContext);
	// page 2
	CGContextBeginPage(myDocumentContext, &mediaBox);
	[self drawOvals: myDocumentContext];
	CGContextEndPage(myDocumentContext);
	// page 3
	CGContextBeginPage(myDocumentContext, &mediaBox);
	[self drawLines:myDocumentContext];
	CGContextEndPage(myDocumentContext);
	// page 4
	CGContextBeginPage(myDocumentContext, &mediaBox);
	[self drawArcs:myDocumentContext];
	CGContextEndPage(myDocumentContext);
	// page 5
	CGContextBeginPage(myDocumentContext, &mediaBox);
	[self drawCurves:myDocumentContext];
	CGContextEndPage(myDocumentContext);
	// page 6
	CGContextBeginPage(myDocumentContext, &mediaBox);
	[self drawEllipseWithTransformation: myDocumentContext];
	CGContextEndPage(myDocumentContext);
	// page 7
	CGContextBeginPage(myDocumentContext, &mediaBox);
	[self drawPath: myDocumentContext];
	CGContextEndPage(myDocumentContext);
	// page 8
	CGContextBeginPage(myDocumentContext, &mediaBox);
	[self drawStrokedThings: myDocumentContext];
	CGContextEndPage(myDocumentContext);
	// page 9
	CGContextBeginPage(myDocumentContext, &mediaBox);
	[self drawFilledThings: myDocumentContext];
	CGContextEndPage(myDocumentContext);
	
	CGContextRelease(myDocumentContext);
	
	// Bitmap context
	CGContextRef myBitmapContext = [self createBitmapContextWithPixelWidth:400 andPixelHeight:300];
	
	CGContextClearRect(myBitmapContext, windowBox);
	CGContextSetAlpha(myBitmapContext, 0.2);
	
	// CGContextSetShouldAntialias(myBitmapContext, NO); // default is antialiased
	//[self drawOvals:myBitmapContext];
	//[self drawLines:myBitmapContext];
	//[self drawArcs:myBitmapContext];
	//[self drawCurves:myBitmapContext];
	//[self drawEllipseWithTransformation: myBitmapContext];
	//[self drawPath: myBitmapContext];
	//[self drawStrokedThings: myBitmapContext];
	//[self drawFilledThings: myBitmapContext];
	[self drawMoreFilledThings: myBitmapContext];
	//[self drawCustomView:myBitmapContext];
	
	// Create the image in the context
	CGImageRef myImage = CGBitmapContextCreateImage (myBitmapContext); 
	
	// draw the image in the window context
	CGContextDrawImage(myWindowContext, windowBox, myImage); 

	CGContextRelease (myBitmapContext); 

	CGImageRelease(myImage);
	
	// window context release
	CGContextRelease(myWindowContext);
}

- (void) drawOvals: (CGContextRef) context {
	CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
	CGContextFillEllipseInRect(context, CGRectMake(0.0, 0.0, 200.0, 100.0));
	CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 0.5);
	CGContextFillEllipseInRect(context, CGRectMake(0.0, 0.0, 100.0, 200.0));
    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 1.0, 1.0);
	CGContextSetLineWidth(context, 3.0);
	CGContextStrokeEllipseInRect(context, CGRectMake(100.0, 100.0, 200.0, 100.0));
}

- (void) drawRectangles: (CGContextRef) context {
	CGContextSetRGBFillColor(context, 1.0, 0.5, 0.0, 1.0);
	CGContextFillRect(context, CGRectMake(0.0, 0.0, 200.0, 100.0));
	CGContextSetRGBFillColor(context, 0.0, 0.4, 0.8, 0.5);
	CGContextFillRect(context, CGRectMake(0.0, 0.0, 100.0, 200.0));
}

- (void) drawEllipseWithTransformation: (CGContextRef) context {
	CGContextScaleCTM(context, 1,2); 
	CGContextBeginPath(context); 
	CGContextAddArc(context, 100, 100, 25, 0, 2*M_PI, false); 
	CGContextStrokePath(context); 
}

- (void) drawLines: (CGContextRef) context {
	int h = 300;//[self bounds].size.height;
	int w = 400;//[self bounds].size.width;

	CGContextSetLineWidth(context, 3.0);
	CGContextSetRGBStrokeColor(context, 1.0, 0.2, 0.2, 1.0);
	
	CGContextBeginPath(context);
	  CGContextMoveToPoint(context, w/2, h/2);
	  CGContextAddLineToPoint(context, 10, h - 10);
	  CGContextAddLineToPoint(context, w - 10, h - 10);
	  CGContextAddLineToPoint(context, w - 10, 10);
	  CGContextAddLineToPoint(context, 10, 10);
	  CGContextClosePath(context);
	CGContextStrokePath(context);

	int countPoints = 3;
	CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.7, 1.0);
	CGPoint points[] = {CGPointMake(50,h/2-25), CGPointMake(100,h/2), CGPointMake(50,h/2+25)};
	CGContextAddLines(context, points, countPoints);
	CGContextStrokePath(context);
}

- (void) drawArcs: (CGContextRef) context {
	int h = [self bounds].size.height;
	int w = [self bounds].size.width;
	
	CGContextSetLineWidth(context, 3.0);
	CGContextSetRGBStrokeColor(context, 1.0, 0.2, 1.0, 1.0);
	CGContextSetRGBFillColor(context, 0.6, 0.6, 1.0, 0.5);
	
	CGContextBeginPath(context); 
	  CGContextAddArc(context, w/2, h/2, 80, 45, 180, -1);
	  CGContextAddArcToPoint(context, 100, 100, 150, 150, 50);
	  CGContextClosePath(context);
	CGContextStrokePath(context);
}

- (void) drawCurves: (CGContextRef) context {
	int h = [self bounds].size.height;
	int w = [self bounds].size.width;
	 
	CGContextSetLineWidth(context, 3.0);
	CGContextSetRGBStrokeColor(context, 0.4, 1.0, 0.2, 1.0);
	CGContextSetRGBFillColor(context, 0.3, 0.0, 0.5, 0.5);
	
	CGContextBeginPath(context);
	  CGContextMoveToPoint(context, w/2, h/2);
	  CGContextAddCurveToPoint(context, w/2 + 33, h/2 + 20, w/2 + 66, h/2 - 20, w/2 + 100, h/2);
	  CGContextAddQuadCurveToPoint(context, w/2 + 150, h/2 + 50, w/2 + 100, h/2 + 100);
	CGContextStrokePath(context);
}	

- (void) drawPath: (CGContextRef) context {
	int h = [self bounds].size.height;
	int w = [self bounds].size.width;
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, w/2, h/2);
	CGPathAddLineToPoint(path, NULL, 300, 200);
	CGPathAddCurveToPoint(path, NULL, 300, 400, 100, 0, 100, 100);
	CGPathAddArc(path, NULL, 100, 150, 150, 90, 225, YES);
	CGPathCloseSubpath(path);
	
	CGContextAddPath(context, path);
	CGContextSetRGBStrokeColor(context, 1.0, 0.3, 0.6, 1.0);
	CGContextStrokePath(context);
	
	CGPathRelease(path);
}

- (void) drawStrokedThings: (CGContextRef) context {
	int h = [self bounds].size.height;
	//int w = [self bounds].size.width;
	
	int baseX1 = 50;
	int baseX2 = baseX1 * 2;
	int baseY  = h / 2;
	int loBaseY = baseY - 50;
	int hiBaseY = baseY + 50;
	
	int countPoints = 3;
	
	CGContextSetLineWidth(context, 12.0);
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextSetLineCap(context, kCGLineCapRound);
	
	CGContextSetRGBStrokeColor(context, RGB(), RGB(), RGB(), 1.0);
	CGPoint points[] = {CGPointMake(baseX1,loBaseY), CGPointMake(baseX2,baseY), CGPointMake(baseX1,hiBaseY)};
	CGContextAddLines(context, points, countPoints);
	CGContextStrokePath(context);
	
	CGContextSetLineWidth(context, 8.0);
	CGContextSetRGBStrokeColor(context, RGB(), RGB(), RGB(), 1.0);
	points[0] = CGPointMake(baseX1 + 50,loBaseY);
	points[1] = CGPointMake(baseX2 + 50,baseY);
	points[2] = CGPointMake(baseX1 + 50,hiBaseY);
	CGContextAddLines(context, points, countPoints);
	CGContextStrokePath(context);
	
	CGContextSetLineWidth(context, 4.0);
	CGContextSetLineCap(context, kCGLineCapButt);
	float dashPattern[] = {4,4};
	CGContextSetLineDash(context, 0, dashPattern, 2);
	CGContextSetRGBStrokeColor(context, RGB(), RGB(), RGB(), 1.0);
	points[0] = CGPointMake(baseX1 + 100,loBaseY);
	points[1] = CGPointMake(baseX2 + 100,baseY);
	points[2] = CGPointMake(baseX1 + 100,hiBaseY);
	CGContextAddLines(context, points, countPoints);
	CGContextStrokePath(context);
	
	CGContextSetLineWidth(context, 2.0);
	float dashPattern2[] = {4,6,2};
	CGContextSetLineDash(context, 0, dashPattern2, 3);
	CGContextSetRGBStrokeColor(context, RGB(), RGB(), RGB(), 1.0);
	points[0] = CGPointMake(baseX1 + 150,loBaseY);
	points[1] = CGPointMake(baseX2 + 150,baseY);
	points[2] = CGPointMake(baseX1 + 150,hiBaseY);
	CGContextAddLines(context, points, countPoints);
	CGContextStrokePath(context);
	
	float dashPattern3[] = {6};
	CGContextSetLineDash(context, 0, dashPattern3, 1);
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0);
	points[0] = CGPointMake(baseX1 + 200,loBaseY);
	points[1] = CGPointMake(baseX2 + 200,baseY);
	points[2] = CGPointMake(baseX1 + 200,hiBaseY);
	CGContextAddLines(context, points, countPoints);
	CGContextStrokePath(context);
	
	float dashPattern4[] = {20, 8, 2, 8};
	CGContextSetLineDash(context, 0, dashPattern4, 4);
	CGContextSetRGBStrokeColor(context, 1, 0, 1, 1.0);
	points[0] = CGPointMake(baseX1 + 250,loBaseY);
	points[1] = CGPointMake(baseX2 + 250,baseY);
	points[2] = CGPointMake(baseX1 + 250,hiBaseY);
	CGContextAddLines(context, points, countPoints);
	CGContextStrokePath(context);
	
	CGContextSetLineDash(context, 0, dashPattern3, 1);
	CGContextStrokeRectWithWidth(context, CGRectMake(100, 25, 100, 50), 3);

}

- (void) drawFilledThings: (CGContextRef) context {
	int h = [self bounds].size.height;
	int w = [self bounds].size.width;
	
	CGContextSetLineWidth(context, 1.0);
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
	
	CGContextSetRGBFillColor(context, RGB(), RGB(), RGB(), 0.5);
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGContextBeginPath(context); 
	  CGPathAddArc(path, NULL, w/4, h/2, 90, 0, 2 * M_PI, YES);
	  CGPathAddArc(path, NULL, w/4, h/2, 60, 0, 2 * M_PI, YES);
	CGContextAddPath(context, path);
	CGContextFillPath(context);
	// CGContextEOFillPath(context);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	CGPathRelease(path);
	
	CGContextSetRGBFillColor(context, RGB(), RGB(), RGB(), 0.5);
	path = CGPathCreateMutable();
	CGContextBeginPath(context); 
	  CGPathAddArc(path, NULL, w/2, h/2, 90, 0, 2 * M_PI, YES);
	  CGPathAddArc(path, NULL, w/2, h/2, 60, 0, 2 * M_PI, NO); // counterclockwise
	CGContextAddPath(context, path);
	CGContextFillPath(context);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	CGPathRelease(path);
}

- (void) drawMoreFilledThings: (CGContextRef) context {
	int h = [self bounds].size.height;
	int w = [self bounds].size.width;
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, 0, h);
	CGContextAddLineToPoint(context, w/2, 0);
	CGContextAddLineToPoint(context, w, h);
	CGContextClosePath(context);
	CGContextClosePath(context);
	
	CGContextClip(context);
	
	CGContextSetLineWidth(context, 1.0);
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
	
	CGContextSetRGBFillColor(context, 0, 0, 1, 1);
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGContextBeginPath(context); 
	CGPathAddArc(path, NULL, w/2, 0, 100,  0, 2 * M_PI, YES);
	CGPathAddArc(path, NULL, w/2, 0, 82.5, 0, 2 * M_PI, NO);
	CGPathAddArc(path, NULL, w/2, 0, 72.5, 0, 2 * M_PI, YES);
	CGPathAddArc(path, NULL, w/2, 0, 55.0, 0, 2 * M_PI, NO);
	CGPathAddArc(path, NULL, w/2, 0, 45.0, 0, 2 * M_PI, YES);
	CGPathAddArc(path, NULL, w/2, 0, 27.5, 0, 2 * M_PI, NO);
	CGPathAddArc(path, NULL, w/2, 0, 17.5, 0, 2 * M_PI, YES);
	CGContextAddPath(context, path);
	CGContextFillPath(context);
	CGContextStrokePath(context);
	CGPathRelease(path);

}


- (CGContextRef) createPDFContextWithPath: (CFStringRef) path andBounds: (CGRect *) mediaBox {
	CGContextRef myPdfContext = NULL;
	CFURLRef url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, false);
	if (url != NULL) {
		myPdfContext = CGPDFContextCreateWithURL(url, mediaBox, NULL);
		CFRelease(url);
	}
	return myPdfContext;
}

- (CGContextRef) windowContext {
	return [[NSGraphicsContext currentContext] graphicsPort];
}

- (CGContextRef) createBitmapContextWithPixelWidth: (int) pixelWidth andPixelHeight: (int) pixelHeight {
	
	CGContextRef context = NULL;
	int bitsPerComponent = 8;
	int bytesPerRow = pixelWidth * 4; // 4 bytes (32 bits) per pixel
	int size = pixelHeight * bytesPerRow; // size of data buffer
	
	CGColorSpaceRef   colorSpace = CGColorSpaceCreateWithName(
															  kCGColorSpaceGenericCMYK
															  //kCGColorSpaceGenericRGB
	);
	CGImageAlphaInfo bitmapInfo = //kCGImageAlphaPremultipliedLast; // RGBa - last byte, premultiplies components
								  kCGImageAlphaNone; // CMYK
	
	void * data = malloc(size); 
	if(data == NULL) { 
		fprintf(stderr,"Memory not allocated!"); 
		return NULL; 
	} 
	
	context = CGBitmapContextCreate(data, 
								    pixelWidth, 
									pixelHeight, 
									bitsPerComponent,
									bytesPerRow, 
									colorSpace, 
									bitmapInfo);
	
	if (context == NULL) { 
		free (data); 
		fprintf (stderr, "Context not created!"); 
		return NULL; 
	} 

	CGColorSpaceRelease( colorSpace ); 
	return context; 
	
}

#pragma mark Test Methods
- (void) drawCustomView:(CGContextRef) context {
	
	int h = [self bounds].size.height;
	int w = [self bounds].size.width;
	
	//CGContextRef context   = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextScaleCTM(context, w, h);
	CGContextRetain(context);
	
	NSColor *backgroundColor = [NSColor grayColor];
	NSColor *color = [NSColor whiteColor];
	
	//CGColorRef backColor = (CGColorRef)backgroundColor;
	CGContextSetRGBFillColor(context, 0.0, 0.0, 0.5, 0.6);
	CGContextFillRect(context, CGRectMake(0.0, 0.0, 1.0, 1.0));
	
	NSString *hello   = @"100";
	CGPoint  location = CGPointMake(0, 0);
	NSFont   *font    = [NSFont boldSystemFontOfSize:12];
	
	[color set];
	
	//[hello drawAtPoint:location withAttributes:font];	
	
}

@end
