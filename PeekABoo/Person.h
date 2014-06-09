//
//  Person.h
//  PeekABoo
//
//  Created by Robert Figueras on 6/6/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * adress;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * isDefaultImage;

@end
