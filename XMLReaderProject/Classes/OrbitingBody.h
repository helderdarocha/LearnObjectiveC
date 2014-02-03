//
//  OrbitingBody.h
//  XMLReader1
//
//  Created by Helder da Rocha on 17/02/2011.
//  Copyright 2011 Argo Navis. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OrbitingBody : NSObject {
	double aphelion;
	double perihelion;
	NSString *name;
	NSArray *satelites;
}

@property (nonatomic, assign, readwrite) double aphelion;
@property (nonatomic, assign, readwrite) double perihelion;
@property (nonatomic, retain, readwrite) NSString *name;
@property (nonatomic, copy, readwrite)   NSArray *satelites;

@end
