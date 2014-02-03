//
//  RootViewController.h
//  XMLReader1
//
//  Created by Helder da Rocha on 15/02/2011.
//  Copyright 2011 Argo Navis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController <NSXMLParserDelegate> {
	
	NSXMLParser *parser;
	NSDictionary *planetaryData;
	NSDictionary *entitiesMap;
	NSMutableDictionary *planetaryDataDict;
}

@property (nonatomic, retain) NSXMLParser  *parser;
@property (nonatomic, copy)   NSDictionary *planetaryData;
@property (nonatomic, copy)   NSDictionary *entitiesMap;

@end
