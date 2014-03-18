//
//  BREpubSettings.m
//  BooklEpicReader
//
//  Created by CAwesome on 2014-03-18.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import "BREpubSettings.h"
#import "BRSettings.h"


#define kKeyColumnGap @"columnGap"
#define kKeyFontScale @"fontSize"
#define kKeyIsSyntheticSpread @"isSyntheticSpread"


NSString * const kBREpubSettingsDidChange = @"BREpubSettingsDidChange";


@interface BREpubSettings ()

- (void)postNotification;

@end


@implementation BREpubSettings

- (CGFloat)columnGap {
	return [BRSettings shared].columnGap;
}


- (NSDictionary *)dictionary {
	return @{
             kKeyColumnGap : [NSNumber numberWithInt:round(self.columnGap)],
             kKeyFontScale : [NSNumber numberWithInt:round(100.0 * self.fontScale)],
             kKeyIsSyntheticSpread : [NSNumber numberWithBool:self.isSyntheticSpread],
             };
}


- (CGFloat)fontScale {
	return [BRSettings shared].fontScale;
}


- (BOOL)isSyntheticSpread {
	return [BRSettings shared].isSyntheticSpread;
}


- (void)postNotification {
	[[NSNotificationCenter defaultCenter] postNotificationName:
     kBREpubSettingsDidChange object:self];
}


- (void)setColumnGap:(CGFloat)columnGap {
	if ([BRSettings shared].columnGap != columnGap) {
		[BRSettings shared].columnGap = columnGap;
		[self postNotification];
	}
}


- (void)setFontScale:(CGFloat)fontScale {
	if ([BRSettings shared].fontScale != fontScale) {
		[BRSettings shared].fontScale = fontScale;
		[self postNotification];
	}
}


- (void)setIsSyntheticSpread:(BOOL)isSyntheticSpread {
	if ([BRSettings shared].isSyntheticSpread != isSyntheticSpread) {
		[BRSettings shared].isSyntheticSpread = isSyntheticSpread;
		[self postNotification];
	}
}


+ (BREpubSettings *)shared {
	static BREpubSettings *shared = nil;
    
	if (shared == nil) {
		shared = [[BREpubSettings alloc] init];
	}
    
	return shared;
}


@end


