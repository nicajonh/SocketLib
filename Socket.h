//
//  Socket.h
//  SocketLib
//
//  Created by Nicajonh on 2014/6/7.
//  Copyright (c) 2014年 Nica. All rights reserved.
//

#import "SocketLib.h"

@interface Socket : SocketLib <SocketState>

@property (nonatomic, assign) id<SocketDelegate> delegate;

- (instancetype) initWithIP: (NSString *) ip port: (int) port delegate: (id) delegate;

@end