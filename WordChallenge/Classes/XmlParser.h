//
//  XmlParser.h
//  WordChallenge
//
//  Created by Nguyen on 10/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XmlParser : NSObject {
	
	NSMutableString		*currentXMLElementValue; // string to store the current xml element value
	NSMutableArray		*arrayXmlObjects;
	NSMutableDictionary *itemDictionary;
}

- (XmlParser *) initXMLParser;
- (NSMutableArray *) getXmlObject;

@end