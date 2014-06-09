//
//  MasterViewController.m
//  PeekABoo
//
//  Created by Robert Figueras on 6/5/14.
//
//

#import "MasterViewController.h"
#import "CustomUICollectionViewCell.h"
#import "Person.h"
#import "DetailViewController.h"
#import "UserInfoViewController.h"

@interface MasterViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>
@property NSMutableArray *personObjectsArray;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fetchedResultsController.delegate = self;
    self.collectionView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultsController performFetch:nil];

//    if (![self.fetchedResultsController fetchedObjects].count)
//    {
//        [self loadSeedData];
//    }

    self.personObjectsArray = (NSMutableArray *)[self.fetchedResultsController fetchedObjects];

    for (Person *eachPerson in self.personObjectsArray) {
        
//        NSLog(@",eachPerson.name);
    }

    [self.collectionView reloadData];
}


#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.personObjectsArray.count;
}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    CustomUICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    Person *currentPerson = [self.personObjectsArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageWithData:currentPerson.image];

    //rotate rect
//    cell.imageView.transform = CGAffineTransformMakeRotation(M_PI_2); //rotation in radians

    return cell;
}


#pragma mark - UICollectionViewDelegate

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval = CGSizeMake(120,120);
    return retval;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20,25,20,25);
}

- (void) loadSeedData
{
    self.personObjectsArray = [[NSMutableArray alloc] init];

    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    person.name = @"Sally Johnson";
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation([UIImage imageNamed:@"aaronGrowl.jpg"])];
    person.image = imageData;
    [self.personObjectsArray addObject:person];

    Person *person2 = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    person2.name = @"John Bradly";
    NSData *imageData2 = [NSData dataWithData:UIImagePNGRepresentation([UIImage imageNamed:@"person1.jpeg"])];
    person2.image = imageData2;
    [self.personObjectsArray addObject:person2];

    Person *person3 = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    person3.name = @"Tom Johnson";
    NSData *imageData3 = [NSData dataWithData:UIImagePNGRepresentation([UIImage imageNamed:@"person1.jpeg"])];
    person3.image = imageData3;
    [self.personObjectsArray addObject:person3];

    [self.managedObjectContext save:nil];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqual: @"userInfoSegue"])
        {
            UserInfoViewController *userInfoVC = segue.destinationViewController;
            userInfoVC.managedObjectContext = self.managedObjectContext;
        }
    else
        {
            DetailViewController *detailVC = segue.destinationViewController;
            detailVC.managedObjectContext = self.managedObjectContext;
            [detailVC setPersonObjectsArray:self.personObjectsArray];
            NSIndexPath *selectedIndexPath = self.collectionView.indexPathsForSelectedItems[0];
            detailVC.selectedIndex = (int)selectedIndexPath.row;
        }
}

-(void)didReceiveMemoryWarning
{
    
}


@end
