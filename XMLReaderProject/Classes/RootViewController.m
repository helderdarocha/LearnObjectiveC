//
//  RootViewController.m
//  XMLReader1
//
//  Created by Helder da Rocha on 15/02/2011.
//  Copyright 2011 Argo Navis. All rights reserved.
//

#import "RootViewController.h"
#import "OrbitingBody.h"
#import "WebViewController.h"


@implementation RootViewController

@synthesize parser;
@synthesize planetaryData;
@synthesize entitiesMap;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSDictionary *entMap = [[NSDictionary alloc] initWithObjectsAndKeys:@"jupiter.xml",@"jupiter",nil];
	self.entitiesMap = [entMap copy];
	[entMap release];
	
	NSLog(@"Entities Map: %@", self.entitiesMap);
	
	// Loading XML file from website (did not check if available!)
	NSLog(@"Getting website...");
	//NSURL  *xmlUrl  = [NSURL URLWithString:@"http://www.argonavis.com.br/astronomia/data/sol_2010.2.2.xml"];
	NSURL  *xmlUrl  = [NSURL URLWithString:@"http://www.argonavis.com.br/astronomia/data/centauros.xml"];
	NSData *xmlData = [NSData dataWithContentsOfURL:xmlUrl];

	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
	[xmlParser setShouldResolveExternalEntities:YES];
	self.parser = xmlParser;
	[xmlParser release];
	
	// Use this file as delegate (change this later)
	[self.parser setDelegate:self];
	
	if([self.parser parse] == YES) {
		
	} else {
		NSError *parsingError = [self.parser parserError];
		NSLog(@"%@", parsingError);
	}
	
	[self setTitle:@"XML to TableView"];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/


 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return YES;
}
 


#pragma mark -
#pragma mark XML Parser delegate

// parser:didStartDocument
- (void)parserDidEndDocument:(NSXMLParser *)parser {
	self.planetaryData = [planetaryDataDict copy];
	[planetaryDataDict release];
}
// parser:didEndDocument
- (void)parserDidStartDocument:(NSXMLParser *)parser {
	planetaryDataDict = [[NSMutableDictionary alloc] init];
}


// parser:didStartElement
- (void)		parser:(NSXMLParser *) parser
	   didStartElement:(NSString *) elementName
		  namespaceURI:(NSString *) namespaceURI
		 qualifiedName:(NSString *) qName
	        attributes:(NSDictionary *) attributeDict {
	
	if ([elementName isEqual:@"planeta"] || [elementName isEqual:@"cometa"] || [elementName isEqual:@"planeta-anao"] || [elementName isEqual:@"asteroide"] || [elementName isEqual:@"objeto"]) {
		
		/*
		NSLog(@"Element Name = %@", elementName); 
		NSLog(@"Number of attributes = %lu", (unsigned long)[attributeDict count]); 
		if ([attributeDict count] > 0) {
			NSLog(@"Attributes dictionary = %@", attributeDict); 
		}
		NSLog(@"========================");
		 */
		
		NSString *bodyName = [attributeDict objectForKey:@"nome"];
		
		OrbitingBody *body = [[OrbitingBody alloc] initWithName:bodyName];
		body.name = bodyName;
		body.aphelion = [[attributeDict objectForKey:@"afelioUA"] doubleValue];
		body.perihelion = [[attributeDict objectForKey:@"perielioUA"] doubleValue];
		
		[planetaryDataDict setValue:body forKey:bodyName];
		
		//NSLog(@"Object dict: %@", planetaryDataDict);
		
		[body release];
	}
}

- (void)parser:(NSXMLParser *)parser foundExternalEntityDeclarationWithName:(NSString *)entityName publicID:(NSString *)publicID systemID:(NSString *)systemID {
	NSLog(@"Entity: %@, %@", entityName, systemID);
}

- (NSData *)parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)entityName systemID:(NSString *)systemID {
	NSLog(@"Entity name: %@", entityName);
	NSLog(@"System ID: %@", systemID); // WHY IS THIS NULL - DO I HAVE TO MAKE A MAP USING THE found method?
	
	NSString *string = [[NSString alloc] initWithFormat:@"http://www.argonavis.com.br/astronomia/data/%@", [self.entitiesMap objectForKey:entityName]];
    
	NSLog(@"URL string: %@", string);
	
	NSURL  *xmlUrl  = [NSURL URLWithString:string];
	[string release];
	
	NSData  *data = [NSData dataWithContentsOfURL:xmlUrl];
	NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSLog(@"Result %@", str);
	
	//NSString *str = @" ";
	//NSData *data = [NSData dataWithBytes:[str UTF8String] length:1];
    return data;
}

// parser:didEndElement


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.planetaryData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell...
	NSUInteger row = [indexPath row];		
	NSArray *keys = [self.planetaryData allKeys];
	OrbitingBody *body = (OrbitingBody *)[self.planetaryData objectForKey:[keys objectAtIndex:row]];
	cell.textLabel.text = body.name;	
	
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}




// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}




// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}




// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
	 WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:webViewController animated:YES];
	 [webViewController release];
	 
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.parser = nil;
	self.planetaryData = nil;
}


- (void)dealloc {
	[parser release];
	[planetaryData release];
    [super dealloc];
}


@end

