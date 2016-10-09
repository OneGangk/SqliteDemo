//
//  ViewController.m
//  SqliteDemo
//
//  Created by likangding on 16/5/15.
//  Copyright © 2016年 likangding. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"

@interface ViewController ()

@end

@implementation ViewController{
    NSMutableArray  *_modelList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _modelList = [NSMutableArray new];
    for (int i = 0; i < 5; i++) {
        MessageModel *model = [[MessageModel alloc] init];
        model.messageID = [NSString stringWithFormat:@"%i", i];
        model.messageTime = [NSString stringWithFormat:@"2016-1-%i", (i + 1)];
        model.messageContent = [NSString stringWithFormat:@"消息内容...%i", i];
        model.senderName = [NSString stringWithFormat:@"'name + %i '", i];
        model.headerURL = @"http://www.baidu.com";
        
        [_modelList addObject:model];
    }
    
    UIButton *saveBtn = [self buttonWithTitle:@"保存" y:40 action:@selector(save)];
    [self.view addSubview:saveBtn];
    
    UIButton *delBtn = [self buttonWithTitle:@"删除" y:100 action:@selector(delete)];
    [self.view addSubview:delBtn];
    
    UIButton *queryBtn = [self buttonWithTitle:@"查询" y:160 action:@selector(query)];
    [self.view addSubview:queryBtn];
    
    UIButton *updateBtn = [self buttonWithTitle:@"更新" y:220 action:@selector(update)];
    [self.view addSubview:updateBtn];
}

- (UIButton *)buttonWithTitle:(NSString *)title y:(CGFloat)y action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(100, y, 120, 50);
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//保存
- (void)save{
    [[DBManager shareInstance] saveMessaeg:_modelList];
}

//删除
- (void)delete{
    [[DBManager shareInstance] deleteMessage:nil];
}

//查询
- (void)query{
    [[DBManager shareInstance] queryMessageList:^(NSMutableArray *messageList) {
        NSLog(@"%zi", messageList.count);
    }];
}

//更新
- (void)update{
    [[DBManager shareInstance] updateMessage:nil messageID:nil];
}

@end
