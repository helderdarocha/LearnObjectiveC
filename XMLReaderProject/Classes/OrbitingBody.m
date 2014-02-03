//
//  OrbitingBody.m
//  XMLReader1
//
//  Created by Helder da Rocha on 17/02/2011.
//  Copyright 2011 Argo Navis. All rights reserved.
//

#import "OrbitingBody.h"


@implementation OrbitingBody

@synthesize name;
@synthesize satelites;
@synthesize aphelion;
@synthesize perihelion;

-(id) initWithName:(NSString *)name {
	if (self = [super init]) {
		self.name = name;
	}
	return self;
}


-(void) dealloc {
	[name release];
	[satelites release];
	[super dealloc];
}

@end
