//
//  MasterViewController.h
//  PeekABoo
//
//  Created by Robert Figueras on 6/5/14.
//
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
