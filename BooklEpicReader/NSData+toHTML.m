//
//  NSData+toHTML.m
//  BooklEpicReader
//
//  Created by CAwesome on 2014-03-18.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import "NSData+toHTML.h"

@implementation NSData (toHTML)


//
// Converts the given HTML data to a string.  The character set and encoding are assumed to be
// UTF-8, UTF-16BE, or UTF-16LE.
//
- (NSString *)toHTML {
	if (self == nil || self.length == 0) {
		return nil;
	}
    
	NSString *html = nil;
	UInt8 *bytes = (UInt8 *)self.bytes;
    
	if (self.length >= 3) {
		if (bytes[0] == 0xFE && bytes[1] == 0xFF) {
			html = [[NSString alloc] initWithData:self
                                         encoding:NSUTF16BigEndianStringEncoding];
		}
		else if (bytes[0] == 0xFF && bytes[1] == 0xFE) {
			html = [[NSString alloc] initWithData:self
                                         encoding:NSUTF16LittleEndianStringEncoding];
		}
		else if (bytes[0] == 0xEF && bytes[1] == 0xBB && bytes[2] == 0xBF) {
			html = [[NSString alloc] initWithData:self
                                         encoding:NSUTF8StringEncoding];
		}
		else if (bytes[0] == 0x00) {
			// There's a very high liklihood of this being UTF-16BE, just without the BOM.
			html = [[NSString alloc] initWithData:self
                                         encoding:NSUTF16BigEndianStringEncoding];
		}
		else if (bytes[1] == 0x00) {
			// There's a very high liklihood of this being UTF-16LE, just without the BOM.
			html = [[NSString alloc] initWithData:self
                                         encoding:NSUTF16LittleEndianStringEncoding];
		}
		else {
			html = [[NSString alloc] initWithData:self
                                         encoding:NSUTF8StringEncoding];
            
			if (html == nil) {
				html = [[NSString alloc] initWithData:self
                                             encoding:NSUTF16BigEndianStringEncoding];
                
				if (html == nil) {
					html = [[NSString alloc] initWithData:self
                                                 encoding:NSUTF16LittleEndianStringEncoding];
				}
			}
		}
	}
    
	return html;
}


@end
