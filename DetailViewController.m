//
//  DetailViewController.m
//  PeekABoo
//
//  Created by Robert Figueras on 6/5/14.
//
//

#import "DetailViewController.h"
#import "Person.h"

@interface DetailViewController () <UIScrollViewDelegate, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@end

@implementation DetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    CGFloat x = 0.0;

//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
//    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
//
//    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
//    self.fetchedResultsController.delegate = self;
//    [self.fetchedResultsController performFetch:nil];

    for (Person *eachPerson in self.personObjectsArray) {
        UIImageView *eachImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:eachPerson.image]];
        eachImageView.transform = CGAffineTransformMakeRotation(M_PI_2); //rotation in radians
        eachImageView.frame = CGRectMake(x,0,self.view.frame.size.width, self.view.frame.size.height-64);
        eachImageView.contentMode = UIViewContentModeScaleToFill;
        x += eachImageView.frame.size.width;
        [self.myScrollView addSubview:eachImageView];
    }

    NSLog(@"selected index is %i", self.selectedIndex);
    CGFloat contentOffSetAmount = (self.selectedIndex * self.view.frame.size.width);
    NSLog(@"content offset amount is %g", contentOffSetAmount);

    self.myScrollView.contentSize = CGSizeMake(x, self.myScrollView.frame.size.height-64);
    [self.myScrollView setContentOffset:CGPointMake(contentOffSetAmount, 0)  animated:YES];
    self.myScrollView.delegate = self;
}




@end
