//
//  SocketLibDelegate.h
//  SocketLib
//
//  Created by Kirk Chu on 2014/6/15.
//  Copyright (c) 2014年 Kirk Chu. All rights reserved.
//

@class ServerSocket;
@class OneClient;
@class Socket;

//////////////////////////////////////////////////////////////////
//
// 给client 端使用
//
@protocol SocketDelegate <NSObject>

@required
-(void) dataReadyForRead: (NSData *) data;

@end

//////////////////////////////////////////////////////////////////
//
// 给 server 端使用
//
@protocol ServerSocketDelegate <NSObject>

@required
-(void) oneClientDidConnect: (OneClient *) client;
-(void) dataReadyForRead: (NSData *) data;

@end

//////////////////////////////////////////////////////////////////
//
// 给 SocketLib 中的 OneClient 与 Socket 使用
//
@protocol SocketState <NSObject>

@required
-(void) dataReadyForRead:(NSData *)data;
-(void) streamDidClosed;

@end
