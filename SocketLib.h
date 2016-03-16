//
//  SocketLib.h
//  SocketLib
//
//  Created by Kirk Chu on 2014/6/7.
//  Copyright (c) 2014年 Kirk Chu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import "SocketLibDelegate.h"

// 用來設定 socket I/O 時的資料流緩衝區大小
#define BUFFER_SIZE      1024

@interface SocketLib : NSObject <NSStreamDelegate>
{
    NSInputStream *m_inputStream;
    NSOutputStream *m_outputStream;
    NSMutableData *inputData;
}

// child 是用來呼叫繼承者中的一些method
@property (nonatomic, assign) id child;

-(void)openReadStream:(CFReadStreamRef)readStream writeStream:(CFWriteStreamRef)writeStream child:(id)aChild;
-(NSData *)readData;
-(NSUInteger)writeData:(NSData *)data;
-(void) disconnect;

@end

