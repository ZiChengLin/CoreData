//
//  ViewController.m
//  CoreData
//
//  Created by 林梓成 on 15/7/31.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>    // 添加框架
#import "Student.h"

@interface ViewController ()

@property (nonatomic, strong) NSManagedObjectContext *context;    // 上下文（对CodeData进行增删改进行操作的对象＋）

@property (weak, nonatomic) IBOutlet UIImageView *photo;


@end

@implementation ViewController


/**
 *  1、创建模型文件
 *  2、添加实体
 *  3、
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 以下代码固定 需要使用时直接copy过去使用
    
    // 查看应用程序的bundle路径
    NSString *bundle = [[NSBundle mainBundle] bundlePath];
    NSLog(@"bundle = %@", bundle);
    
    // 1、创建一个数据库操作对象
    self.context = [[NSManagedObjectContext alloc] init];
    
    // 2、创建一个模型文件（对应数据库）
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // 3、创建一个数据持久化协调器（数据库管理员）
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // 4、获取document的文件路径并在其路径下创建一个sqlite数据库文件
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *sqlitePath = [doc stringByAppendingPathComponent:@"Student.sqlite"];
    NSLog(@"---%@", sqlitePath);
    
    // 5、管理员要管理的数据库路径
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:nil];
    
    // 6、指定数据库的管理员
    self.context.persistentStoreCoordinator = coordinator;
}

#pragma mark -- 添加学生
- (IBAction)addInfo:(id)sender {
    
    // 1、创建学生对象并插入数据库
    Student *stu = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.context];
    
    // 2、对学生对属性进行赋值
    stu.name = @"Lin Zi";
    stu.num = @004;
    NSString *photoPath = [[NSBundle mainBundle] pathForResource:@"missing_music" ofType:@"png"];
    stu.photo = [NSData dataWithContentsOfFile:photoPath];
    
    // 3、将stu保存到数据库中
    NSError *error = nil;
    [self.context save:&error];
    if (error) {
        
        NSLog(@"error = %@", error);
    }
}

#pragma mark -- 修改学生信息
- (IBAction)updateInfo:(id)sender {
    
    // 创建一个查询的对象（表名）
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    // 创建一个查询条件（修改Lin son这个学生）
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@", @"Lin Zi"];
    request.predicate = pre;
    
    // 执行查询
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    for (Student *stu in array) {
        
        stu.num = @5;     // 修改
    }
    
    // 修改完之后一定要执行保存
    [self.context save:nil];
}

#pragma mark -- 查询学生信息
- (IBAction)selectInfo:(id)sender {
    
    // 创建一个查询的对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    // 2、按条件查询（谓词NSPredicate）
    //NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@", @"Lin"];
    //request.predicate = pre;
    
    // 2.1、以什么开始进行查询（beginswith 大小写都行）
    //NSPredicate *pre = [NSPredicate predicateWithFormat:@"name beginswith %@", @"Lin"];
    //request.predicate = pre;
    
    // 2.2、以什么结尾进行查询
    //NSPredicate *pre = [NSPredicate predicateWithFormat:@"name endswith %@", @"son"];
    //request.predicate = pre;
    
    // 2.3、按照包含某个元素进行查询
    //NSPredicate *pre = [NSPredicate predicateWithFormat:@"name contains %@", @"Zi"];
    //request.predicate = pre;
    
    // 2.4、模糊查询
    //NSPredicate *pre = [NSPredicate predicateWithFormat:@"name like %@", @"*son"];
    //request.predicate = pre;
    
    // 2.5、分页查询 (从0开始 查询两条)
    //request.fetchOffset = 0;
    //request.fetchLimit = 2;
    
    // 3、对查询结果排序（YES表示升序 NO表示降序）
    //NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"num" ascending:NO];
    //request.sortDescriptors = @[sort];
    
    // 执行查询
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    for (Student *stu in array) {
        
        NSLog(@"name = %@, num = %@", stu.name, stu.num);
        UIImage *photo = [UIImage imageWithData:stu.photo];
        self.photo.image = photo;
    }
}

#pragma mark -- 删除学生
- (IBAction)deleteInfo:(id)sender {
    
    // 创建一个查询的对象（表名）
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    // 创建一个查询条件（修改Lin son这个学生）
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@", @"Lin Zi"];
    request.predicate = pre;
    
    // 执行查询
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    for (Student *stu in array) {
    
        [self.context deleteObject:stu];
    }
    
    // 修改完之后一定要执行保存
    [self.context save:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
