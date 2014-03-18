//
//  BRLocStr.m
//  BooklEpicReader
//
//  Created by CAwesome on 2014-03-18.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import "BRLocStr.h"

NSString *BRLocStr(NSString *key, ...) {
	if (key == nil) {
		NSLog(@"Got a nil key!");
	}
	else {
		NSString *s = [[NSBundle mainBundle] localizedStringForKey:key
                                                             value:nil table:nil];
        
		if (s == nil) {
			NSLog(@"Key '%@' has a nil value!", key);
		}
		else if ([s isEqualToString:key]) {
			NSLog(@"Key '%@' not found!", key);
		}
		else {
			// We found the string.  Apply the formatting arguments.
            
			va_list list;
			va_start(list, key);
			s = [[NSString alloc] initWithFormat:s arguments:list];
			va_end(list);
            
			return s;
		}
	}
    
	return @"NOT FOUND";
}
