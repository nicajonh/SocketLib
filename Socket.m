//
//  Socket.m
//  SocketLib
//
//  Created by Nicajonh on 2014/6/7.
//  Copyright (c) 2014年 Nica. All rights reserved.
//

#import "Socket.h"

@implementation Socket

// 1号
- (instancetype) init
{
    // Socket 初始化
    self = [super init];
    if (self) {

    }
    return self;
}

// 2号
- (instancetype) initWithIP: (NSString *) ip port: (int) port delegate: (id) delegate
{
    // 跟 server 连接，并且开启 I/O stream
    self = [self init];
    if (self) {
        self.delegate = delegate;

        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;

        CFStreamCreatePairWithSocketToHost(
                                           NULL,
                                           (__bridge CFStringRef)ip,
                                           port,
                                           &readStream,
                                           &writeStream);
        
        [super openReadStream:readStream writeStream:writeStream child:self];
    }
    return self;
}

// 3号
-(void)dataReadyForRead:(NSData *)data
{
    // 读取到一条数据
    [self.delegate dataReadyForRead:data];
}

//4号
-(void)streamDidClosed
{
    // 数据流关闭或是网络连接
}


@end
