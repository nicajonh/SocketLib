//
//  ServerSocket.m
//  SocketLib
//
//  Created by Nicajonh 2014/6/7.
//  Copyright (c) 2014年 Nica. All rights reserved.
//

#import "ServerSocket.h"

@implementation ServerSocket


- (instancetype) init
{
    // 用途：初始化 ServerSocket
    self = [super init];
    if (self) {
        thisClass = self;
        clientList = [NSMutableArray new];
    }
    
    return self;
}


- (instancetype) initWithListeningPort: (int) port delegate: (id) delegate
{
    // 用途：传进port number，并且让server开始listen网络
    self = [self init];
    if (self) {
        self.delegate = delegate;
        
        // 参数 handleConnect 将会调用 3号 method
        CFSocketRef myipv4cfsock = CFSocketCreate(
                                        kCFAllocatorDefault,
                                        PF_INET,
                                        SOCK_STREAM,
                                        IPPROTO_TCP,
                                        kCFSocketAcceptCallBack, handleConnect, NULL);

        struct sockaddr_in sin;
        
        memset(&sin, 0, sizeof(sin));
        sin.sin_len = sizeof(sin);
        sin.sin_family = AF_INET;
        sin.sin_port = htons(port);
        sin.sin_addr.s_addr= INADDR_ANY;
        
        CFDataRef sincfd = CFDataCreate(
                                        kCFAllocatorDefault,
                                        (UInt8 *)&sin,
                                        sizeof(sin));

        CFSocketSetAddress(myipv4cfsock, sincfd);
        CFRelease(sincfd);
        
        CFRunLoopSourceRef socketsource = CFSocketCreateRunLoopSource(
                                        kCFAllocatorDefault,
                                        myipv4cfsock,
                                        0);

        // server 开始 listen
        CFRunLoopAddSource(
                           CFRunLoopGetCurrent(),
                           socketsource,
                           kCFRunLoopDefaultMode);
        
        NSLog(@"开始监听 port: %d", port);
    }
    
    return self;
}

// 3号
static void handleConnect(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    // 用途：只要有client端连上此函数便会触发，并且传进socket连接的相关数据
    // 此函数中需要调用OneClient对象的初始化函数
    if ( type != kCFSocketAcceptCallBack ) {
        return;
    }
    
    CFSocketNativeHandle nativeSocketHandle = *(CFSocketNativeHandle *)data;
    [thisClass initOneClient:nativeSocketHandle];
}

// 4号
- (void) initOneClient: (CFSocketNativeHandle) nativeSocketHandle
{
    // 用途：产生OneClient实体，并且将这个实体加入到clientList中
    // 然后将连接转给OneClient去处理
    OneClient *client = [[OneClient alloc] initWithServerSocket:self];
    [clientList addObject:client];
    
    [client handleNewNativeSocket:nativeSocketHandle];
    [self.delegate oneClientDidConnect:client];
}

// 5号
- (void) removeOneClient: (OneClient *) client
{
    // 用途：当网络断线后，调用此方法将OneClient实体从clientList中移除
    [clientList removeObject:client];
}

@end
