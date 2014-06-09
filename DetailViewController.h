//
//  DetailViewController.h
//  PeekABoo
//
//  Created by Robert Figueras on 6/5/14.
//
//

#import <UIKit/UIKit.h>
#import "Person.h"
@interface DetailViewController : UIViewController

@property NSManagedObjectContext *managedObjectContext;
@property NSFetchedResultsController *fetchedResultsController;

@property NSMutableArray *personObjectsArray;
@property int selectedIndex;
@end
