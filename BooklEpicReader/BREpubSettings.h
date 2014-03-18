//
//  BREpubSettings.h
//  BooklEpicReader
//
//  Created by CAwesome on 2014-03-18.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kBREpubSettingsDidChange;

@interface BREpubSettings : NSObject

@property (nonatomic, assign) CGFloat columnGap;
@property (nonatomic, strong, readonly) NSDictionary *dictionary;
@property (nonatomic, assign) CGFloat fontScale;
@property (nonatomic, assign) BOOL isSyntheticSpread;

+ (BREpubSettings *)shared;


@end
