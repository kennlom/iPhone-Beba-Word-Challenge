//
//  XmlParser.m
//  WordChallenge
//
//  Created by Nguyen on 10/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "XmlParser.h"


@implementation XmlParser



- (XmlParser *) initXMLParser {
	
	[super init];
	arrayXmlObjects = [NSMutableArray new];
	return self;
}

- (void) dealloc {
	[arrayXmlObjects removeAllObjects];
	[arrayXmlObjects release];
	arrayXmlObjects = nil;
	[currentXMLElementValue release];
	currentXMLElementValue = nil;
	[itemDictionary removeAllObjects];
	[itemDictionary release];
	
	[super dealloc];
}

- (NSMutableArray *) getXmlObject {
	//NSLog([arrayXmlObjects description]);
	return arrayXmlObjects;
}

//XMLParser.m
// start of element
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	// docs is the beginning of our player scores
	if([elementName isEqualToString:@"scores"]) {
		//Initialize the array.
		//NSLog(@"Found scores");
	}
	else if([elementName isEqualToString:@"sys"]) {
		//Initialize the system time.
	}
	else if([elementName isEqualToString:@"score"]) {
		//NSLog(@"Found score");
		//Initialize the item dictionary with what we already have from the xml parser.
		if(itemDictionary) {
			[itemDictionary removeAllObjects];
			[itemDictionary release];
		}
		
		itemDictionary = [[NSMutableDictionary alloc] initWithDictionary:attributeDict];
	//	[arrayXmlObjects addObject: attributeDict];
		
		//Extract the attribute here.
		//Msg.messageId	= [[attributeDict objectForKey:@"id"] integerValue];
		//Msg.date		= [attributeDict objectForKey:@"date"];
		//Msg.author		= [attributeDict objectForKey:@"author"];
		//Msg.location	= [attributeDict objectForKey:@"location"];
		//Msg.ratingBad	= [attributeDict objectForKey:@"badRating"];
		//Msg.ratingGood	= [attributeDict objectForKey:@"goodRating"];
	}
	
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
	if(!currentXMLElementValue){
		currentXMLElementValue = [[NSMutableString alloc] initWithString:string];
		//	NSLog(string);
	}
	else
		[currentXMLElementValue appendString:string];
	
	//	NSLog(@"Processing Value: %@", currentElementValue);
	//	NSLog(string);
}


//XMLParser.m
// end of element
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if([elementName isEqualToString:@"scores"])
		return;
	
	//There is nothing to do if we encounter the Books element here.
	//If we encounter the Book element howevere, we want to add the book object to the array
	// and release the object.
	
	if([elementName isEqualToString:@"score"]) {
		
		//NSLog(currentXMLElementValue);
		NSString *message = [currentXMLElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if(! message) message = @"";
		[itemDictionary setObject:message forKey:@"message"];
		//		[Msg setValue:currentXMLElementValue forKey:@"message"];
		[arrayXmlObjects addObject: itemDictionary];
		
		// Release the temporary item dictionary
		//[itemDictionary removeAllObjects];
		[itemDictionary release];
		itemDictionary = nil;
	}
	/*
	 else
	 // [Msg setValue:currentXMLElementValue forKey:elementName];
	 [Msg setValue:currentXMLElementValue forKey:@"message"];
	 */
	
	[currentXMLElementValue release];
	currentXMLElementValue = nil;
}





@end
