//
//  Student.h
//  CoreData
//
//  Created by 林梓成 on 15/7/31.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Student : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData   * photo;
@property (nonatomic, retain) NSNumber * num;

@end
