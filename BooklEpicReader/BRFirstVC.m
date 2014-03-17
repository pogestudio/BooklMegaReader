//
//  BRFirstVC.m
//  BooklEpicReader
//
//  Created by CAwesome on 2014-03-17.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import "BRFirstVC.h"
#import "RDNavigationElement.h"

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
    //create element
    //create package
    //start reading with elem and package
}

-(void)createElement{
    
}

-(void)createPackage{
    
}

-(void)startReadingWithElement:(NSInteger)element andPackage:(NSInteger)package
{
    RDNavigationElement *element = [m_element.children objectAtIndex:indexPath.row];
    
	EPubViewController *c = [[[EPubViewController alloc]
                              initWithContainer:m_container
                              package:m_package
                              navElement:element] autorelease];
    
	if (c != nil) {
		[self.navigationController pushViewController:c animated:YES];
	}
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
