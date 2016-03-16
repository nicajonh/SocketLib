//
//  SocketLib.m
//  SocketLib
//
//  Created by Nicajonh on 2014/6/7.
//  Copyright (c) 2014年 Nica All rights reserved.
//

#import "SocketLib.h"

@implementation SocketLib

// 1号
-(instancetype)init
{
    // 初始化
    self = [super init];
    if (self) {
        inputData = [NSMutableData new];
    }
    return self;
}

// 2号
-(void)openReadStream:(CFReadStreamRef)readStream writeStream:(CFWriteStreamRef)writeStream child:(id)aChild
{
    // 设置数据流
    self.child = aChild;
    
    m_inputStream = (__bridge_transfer NSInputStream *)readStream;
    m_outputStream = (__bridge_transfer NSOutputStream *)writeStream;
    
    m_inputStream.delegate = self;
    m_outputStream.delegate = self;
    
    [m_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [m_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [m_inputStream open];
    [m_outputStream open];
}

// 3号
-(NSData *)readData
{
    // 从 socket 读取数据
    uint8_t buff[BUFFER_SIZE];
    long length = [m_inputStream read:buff maxLength:BUFFER_SIZE];
    [inputData appendBytes:buff length:length];
    
    // 判断目前收到的数据是否已经可完整读取“数据大小”部分
    if ([inputData length] >= sizeof(NSUInteger)) {
        // 读取“数据大小”
        NSUInteger dataLength;
        [inputData getBytes:&dataLength length:sizeof(NSUInteger)];
        
        if ([inputData length] - sizeof(NSUInteger) == dataLength) {
            // 根据“数据大小”判断数据已全部读取完毕
            // tmpData 为去除“数据大小”后的原始数据
            NSData *tmpData = [inputData subdataWithRange:NSMakeRange(sizeof(NSUInteger), dataLength)].copy;
            // 将 inputData 的数据清除 => 归零
            [inputData setData:nil];
            
            return tmpData;
        }
    }
    return nil;
}

// 4号
-(NSUInteger)writeData:(NSData *)data
{
    // 将数据写到 socket 上
    uint8_t buff[BUFFER_SIZE];
    NSRange window = NSMakeRange(0, BUFFER_SIZE);
    
    // 在要传送的数据前面先补上这条数据的大小
    NSUInteger dataLength = [data length];
    NSMutableData *tmpData = [NSMutableData dataWithBytes:&dataLength length:sizeof(NSUInteger)];
    // tmpData 格式为 “数据大小 + 数据”
    [tmpData appendData:data];
    
    long length;
    
    //如果数据大于1024,循环再次发送
    do {
        if ([m_outputStream hasSpaceAvailable]) {
            
            //计算数据经添加到头部后，剩余数据字符字符长度数据，超过则长度累加
            if ((window.location + window.length) > [tmpData length]) {
                window.length = [tmpData length] - window.location;
                buff[window.length] = '\0';
            }
            
            //字符数据填充到tmpData
            [tmpData getBytes:buff range:window];
            
            
            if (window.length == 0) {
                buff[0] = '\0';
            }
            
            //flush数据到输出流
            length = [m_outputStream write:buff maxLength:window.length];
            window = NSMakeRange(window.location + BUFFER_SIZE, window.length);
        }
    } while (window.length == BUFFER_SIZE);
    
    return [data length];
}

// 5号
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    // socket 连接的状态会通过此方法传进来
    switch (eventCode) {
        case NSStreamEventNone:
            break;
            
        case NSStreamEventOpenCompleted:
            break;
            
        case NSStreamEventHasBytesAvailable:
            if (aStream == m_inputStream) {
                // 可以从网络上读数据了
                NSData *data = [self readData];
                if (data != nil) {
                    [self.child dataReadyForRead:data];  // <== 调用继承者
                }
            }
            
            break;
            
        case NSStreamEventHasSpaceAvailable:
            if (aStream == m_outputStream) {
                // 可以准备写数据到网络上了
            }
            break;
            
        case NSStreamEventErrorOccurred:
            break;
            
        case NSStreamEventEndEncountered:
            // Socket 断线
            NSLog(@"网络断线");
            [self disconnect];
            [self.child streamDidClosed];  // <== 调用继承者
            break;
            
        default:
            break;
    }
}

// 6号
-(void)disconnect
{
    // 当网络断线时，关闭数据流
    [m_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [m_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [m_inputStream close];
    [m_outputStream close];
}

@end

