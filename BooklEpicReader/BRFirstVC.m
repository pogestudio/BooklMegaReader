//
//  BRFirstVC.m
//  BooklEpicReader
//
//  Created by CAwesome on 2014-03-17.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import "BRFirstVC.h"
#import "RDNavigationElement.h"
#import "RDPackage.h"
#import "RDContainer.h"

#import "BREpubViewController.h"

@interface BRFirstVC ()

@end

@implementation BRFirstVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *newB = [UIButton buttonWithType:UIButtonTypeCustom];
    [newB setTitle:@"PRESS" forState:UIControlStateNormal];
    [newB setBackgroundColor:[UIColor redColor]];
        
    [newB addTarget:self action:@selector(startReading) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newB];
    [newB setFrame:CGRectMake(100, 100, 100, 100)];
    [self.view setBackgroundColor:[UIColor yellowColor]];
}

-(void)startReading
{
    //create container
    RDContainer *container = [self createContainer];
    //create package
    RDPackage *package = [self createPackageWithContainer:container];
    //start reading with elem and package
    
    [self startReadingWithContainer:container package:package];
}

-(RDContainer*)createContainer{

//    
//    NSMutableArray *paths = [NSMutableArray arrayWithCapacity:16];
//    
//	NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                              NSUserDomainMask, YES) objectAtIndex:0];
//	NSFileManager *fm = [NSFileManager defaultManager];
//    
//	for (NSString *fileName in [fm contentsOfDirectoryAtPath:docsPath error:nil]) {
//		if ([fileName.lowercaseString hasSuffix:@".epub"]) {
//			[paths addObject:[docsPath stringByAppendingPathComponent:fileName]];
//		}
//	}
//    
//	[paths sortUsingComparator:^NSComparisonResult(NSString *path0, NSString *path1) {
//		return [path0 compare:path1];
//	}];
//    
//	NSString *onePath = [paths firstObject];
//    
    
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"titan"
                                                         ofType:@"epub"];
    
    
    RDContainer *container = [[RDContainer alloc] initWithPath:filePath];
    if (container == nil || container.packages.count == 0) {
        return nil;
    }
    
    
    return container;
}


-(RDPackage*)createPackageWithContainer:(RDContainer*)container{
    
    RDPackage *package = [container.packages objectAtIndex:0];
    return package;
}

-(void)startReadingWithContainer:(RDContainer*)container package:(RDPackage*)package
{

    
	BREpubViewController *c = [[BREpubViewController alloc]
                              initWithContainer:container
                               package:package];
    
	if (c != nil) {
		[self.navigationController pushViewController:c animated:YES];
	}
}


@end
