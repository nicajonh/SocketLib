//
//  OneClient.m
//  SocketClient
//
//  Created by Nicajonh  on 2014/5/11.
//  Copyright (c) 2014年 Nica Chu. All rights reserved.
//

#import "OneClient.h"

@implementation OneClient

// 1号
- (instancetype) init
{
    // OneClient 初始化
    self = [super init];
    if (self) {
        
    }
    return self;
}

// 2号
- (instancetype) initWithServerSocket: (ServerSocket *) server
{
    // 将 ServerSocket 实体传进 OneClient
    self = [self init];
    if (self) {
        self.delegate = server.delegate;
        serverSocket = server;
    }
    return self;
}

// 3号
- (void) handleNewNativeSocket:(CFSocketNativeHandle)nativeSocketHandle
{
    // 设置并打开 socket 连接上的 I/O stream
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocket(
                                 kCFAllocatorDefault,
                                 nativeSocketHandle,
                                 &readStream,
                                 &writeStream
                                 );
    [super openReadStream:readStream writeStream:writeStream child:self];
}

// 4号
-(void)dataReadyForRead:(NSData *)data
{
    // 读取到一条数据
    [self.delegate dataReadyForRead:data];
}

// 5号
-(void)streamDidClosed
{
    // 数据流关闭或是网络断线
    [serverSocket removeOneClient:self];
}

@end
