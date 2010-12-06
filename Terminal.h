//
//  Terminal.h
//  piupiu
//
//  Created by Danilo Altheman on 03/12/10.
//  Copyright 2010 Quaddro. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Terminal : NSObject {
	NSString *terminalName;
	NSFileHandle *master;
	NSFileHandle *slave;
}

@property (nonatomic, retain) NSString *terminalName;
@property (nonatomic, retain) NSFileHandle *master, *slave;

-(void)setTermType:(const char *)type;

@end
