//
//  MessageModel.h
//  SqliteDemo
//
//  Created by likangding on 16/5/15.
//  Copyright © 2016年 likangding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (copy, nonatomic) NSString *messageID;
@property (copy, nonatomic) NSString *messageTime;
@property (copy, nonatomic) NSString *messageContent;
@property (copy, nonatomic) NSString *senderName;
@property (copy, nonatomic) NSString *headerURL;

@end
