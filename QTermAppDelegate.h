//
//  QTermAppDelegate.h
//  QTerm
//
//  Created by Danilo Altheman on 04/12/10.
//  Copyright 2010 Quaddro. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface QTermAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
