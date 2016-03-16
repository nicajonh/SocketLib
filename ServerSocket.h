//
//  ServerSocket.h
//  SocketLib
//
//  Created by Nicajonh  on 2014/6/7.
//  Copyright (c) 2014年 Nica. All rights reserved.
//

#import "SocketLib.h"
#import "OneClient.h"

@interface ServerSocket : NSObject
{
    // 用來儲存每一個 client 端連線
    NSMutableArray *clientList;
}

@property (nonatomic, assign) id<ServerSocketDelegate> delegate;

- (instancetype) initWithListeningPort: (int) port delegate: (id) delegate;
- (void) removeOneClient: (OneClient *) client;

@end

// 這一行目的是讓 C function 可以呼叫 Objective-C method
// thisClass 的初始化在 .m 檔的 init 方法中
static ServerSocket *thisClass;
