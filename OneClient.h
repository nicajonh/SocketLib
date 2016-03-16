//
//  OneClient.h
//  SocketClient
//
//  Created by NicaJonh on 2014/5/11.
//  Copyright (c) 2014年 Nica. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketLib.h"
#import "ServerSocket.h"

@interface OneClient : SocketLib <SocketState>
{
    ServerSocket *serverSocket;
}

@property (nonatomic, assign) id<ServerSocketDelegate> delegate;

- (instancetype) initWithServerSocket: (ServerSocket *) server;
- (void) handleNewNativeSocket:(CFSocketNativeHandle)nativeSocketHandle;

@end
