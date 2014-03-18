//
//  BRSettings.h
//  BooklEpicReader
//
//  Created by CAwesome on 2014-03-18.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BRSettings : NSObject

@property (nonatomic, retain) NSDictionary *bookmarks;
@property (nonatomic, assign) CGFloat columnGap;
@property (nonatomic, assign) CGFloat fontScale;
@property (nonatomic, assign) BOOL isSyntheticSpread;

+ (BRSettings *)shared;

@end
