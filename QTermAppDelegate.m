//
//  QTermAppDelegate.m
//  QTerm
//
//  Created by Danilo Altheman on 04/12/10.
//  Copyright 2010 Quaddro. All rights reserved.
//

#import "QTermAppDelegate.h"

@implementation QTermAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	[window setOpaque:NO];
	[window setBackgroundColor:[NSColor clearColor]];
}

@end
