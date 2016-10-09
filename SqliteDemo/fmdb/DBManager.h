//
//  DBManager.h
//  SqliteDemo
//
//  Created by likangding on 16/5/15.
//  Copyright © 2016年 likangding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"

@interface DBManager : NSObject

+ (instancetype)shareInstance;

//创建表
- (void)createTable;

//保存
- (void)saveMessaeg:(NSArray *)messageList;

//删除
- (void)deleteMessage:(MessageModel *)model;

//更新
- (void)updateMessage:(MessageModel *)model messageID:(NSString *)messageID;

//查询
- (void)queryMessageList:(void(^)(NSMutableArray *messageList))callback;

@end
