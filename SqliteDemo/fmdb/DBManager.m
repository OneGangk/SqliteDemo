//
//  DBManager.m
//  SqliteDemo
//
//  Created by likangding on 16/5/

//  Copyright © 2016年 likangding. All rights reserved.
//

#import "DBManager.h"
#import "FMDB.h"

#define DB_PATH [NSString stringWithFormat:@"%@/Documents/MessageDB.db", NSHomeDirectory()]

@interface DBManager ()

@property (strong, nonatomic) FMDatabaseQueue *dbQueue;

@end

@implementation DBManager

+ (instancetype)shareInstance{
    static DBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBManager alloc] init];
    });
    return manager;
}

- (FMDatabaseQueue *)dbQueue{
    if (!_dbQueue) {
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:DB_PATH];
    }
    return _dbQueue;
}

- (void)createTable{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:DB_PATH]) {
        [fileManager createFileAtPath:DB_PATH contents:nil attributes:nil];
    }

    NSString *sql = @"create table if not exists Message (messageID text, messageTime text, messageContent text, senderName text, headerURL text)";
    __block BOOL success = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:sql];
    }];
    NSLog(@"%@", DB_PATH);
    if (success) {
        NSLog(@"创建表成功");
    }
}

- (void)saveMessaeg:(NSArray *)messageList{
    //如果插入的内容有单引号，会插入不成功，上面的写法不会有这个问题
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        for (MessageModel *mode in messageList) {
            __block BOOL success = NO;
            [self.dbQueue inDatabase:^(FMDatabase *db) {
                [db executeUpdate:@"insert into Message (messageID, messageTime, messageContent, senderName, headerURL) values(?, ?, ?, ?, ?)", mode.messageID, mode.messageTime, mode.messageContent, mode.senderName, mode.headerURL];
            }];
            
            //如果插入的内容有单引号，会插入不成功，上面的写法不会有这个问题
//            NSString *sql = [NSString stringWithFormat:@"insert into Message (messageID, messageTime, messageContent, senderName, headerURL) values('%@', '%@', '%@', '%@', '%@')", mode.messageID, mode.messageTime, mode.messageContent, mode.senderName, mode.headerURL];
//            [self.dbQueue inDatabase:^(FMDatabase *db) {
//                success = [db executeUpdate:sql];
//            }];
            if (success) {
                NSLog(@"插入数据成功");
            }
        }
    });
}

- (void)queryMessageList:(void (^)(NSMutableArray *))callback{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *sql = @"select * from Message";
        
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *result = [db executeQuery:sql];
            
            /*
             //如果确定只有一条数据，直接用if
             if (result.next) { //判断结果集是否有下一条数据
             MessageModel *model = [[MessageModel alloc] init];
             
             //获取字符串
             model.messageContent = [result stringForColumn:@"messageContent"];
             
             //结果同上
             model.messageContent = [result stringForColumnIndex:2];
             
             //获取int/double/NSData....值
             int xx = [result intForColumn:@"字段名"];
             }
             */
            
            NSMutableArray *messageList = [NSMutableArray new];
            while (result.next) {
                MessageModel *model = [[MessageModel alloc] init];
                
                //获取字符串
                model.messageContent = [result stringForColumn:@"messageContent"];
                
                [messageList addObject:model];
            }
            [result close];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (callback) callback(messageList);
            });
        }];
    });
}

- (void)deleteMessage:(MessageModel *)model{
    __block BOOL success = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:@"delete from Message where messageID = ?", model.messageID];
    }];
    if (success) {
        NSLog(@"删除成功");
    }
}

- (void)updateMessage:(MessageModel *)model messageID:(NSString *)messageID{
    __block BOOL success = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:@"update Message set messageID = ?, messageTime = ? where messageID = ?", model.messageID, model.messageTime, messageID];
    }];
    if (success) {
        NSLog(@"更新成功");
    }
}

@end
