//
//  UserData.h
//  SecondWind
//
//  Created by Momotov Vladimir on 29.04.14.
//  Copyright (c) 2014 Artem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserData : NSManagedObject

@property (nonatomic, retain) NSDate * lastMediaModifiedDate;

@end
