//
//  UserInfoViewController.h
//  PeekABoo
//
//  Created by Robert Figueras on 6/5/14.
//
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController 
@property NSManagedObjectContext *managedObjectContext;
@property NSFetchedResultsController *fetchedResultsController;
@end
