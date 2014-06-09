//
//  UserInfoViewController.m
//  PeekABoo
//
//  Created by Robert Figueras on 6/5/14.
//
//

#import "UserInfoViewController.h"
#import "Person.h"
#define kScrollHeight 120
#define kCenterY 284

@interface UserInfoViewController () <UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UITextField *categoryTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property NSDictionary *userInfoDictionary;
@property BOOL didScroll;

@property UIImage *image;
@property UIImagePickerController *imagePicker;
@property (nonatomic, strong) NSString *videoFilePath;
@property (strong, nonatomic) IBOutlet UIImageView *userInfoPhotoThumbImageView;
@end

@implementation UserInfoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.didScroll = NO;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self printOutAllEntities];
}


- (IBAction)saveButtonPressed:(id)sender
{

    Person *newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    newPerson.name = self.nameTextField.text;
    newPerson.adress = self.addressTextField.text;
    newPerson.category = self.categoryTextField.text;
    newPerson.email = self.emailTextField.text;
    newPerson.phone = self.phoneTextField.text;

    if (!newPerson.image)
    {
        UIImage *blankImage = [UIImage imageNamed:@"generic_avatar_rotated.png"];
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(blankImage)];
        newPerson.image = imageData;
        newPerson.isDefaultImage = [NSNumber numberWithBool:YES];
    }
    [self.managedObjectContext save:nil];
    [self printOutAllEntities];

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Helper methods to scroll form up and down

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self animateViewToCenterAndDismissKeyboard];
    return YES;
}


- (IBAction)backgroundTapped:(id)sender
{
    [self animateViewToCenterAndDismissKeyboard];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    int tagValue = textField.tag;
    if (tagValue > 0 && self.didScroll == NO) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 200);
        }];
    }
    self.didScroll = YES;
}


-(void) animateViewToCenterAndDismissKeyboard
{
    [self.nameTextField resignFirstResponder];
    [self.addressTextField resignFirstResponder];
    [self.categoryTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake(self.view.center.x, kCenterY);
    }];
    self.didScroll = NO;
}

- (IBAction)addPhotoButtonPressed:(id)sender {

    if (self.image == nil && self.videoFilePath.length == 0) {

        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.videoMaximumDuration = 10; // *** limit the lenghth of the videos (10 sec)

        // *** check to see if a camera source is available; if not, show the photo library instead ***/

        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        }
        else
        {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        }

        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
}


#pragma mark - ImagePicker methods

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    self.image = [info objectForKey:UIImagePickerControllerOriginalImage]; // *** then get the image

    if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera){ // *** if they used the camera (and not existing)
        UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil); // *** then save to album

        Person *newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
        newPerson.image = [NSData dataWithData:UIImageJPEGRepresentation(self.image, 0.0)];
        self.userInfoPhotoThumbImageView.image = [UIImage imageWithData:newPerson.image];
        self.userInfoPhotoThumbImageView.transform = CGAffineTransformMakeRotation(M_PI_2); //rotation in radians
        newPerson.isDefaultImage = NO;
    }
    [self dismissViewControllerAnimated:YES completion:nil]; // *** since you are overriding the method, need to dismiss modal controller

}


#pragma mark - Print Out Methods for Debugging

- (void) printOutAllEntities
{
    NSArray *allEntitiesArray = [[self.managedObjectContext registeredObjects] allObjects];
    for (Person *eachPerson in allEntitiesArray) {
        NSLog(@"name %@",eachPerson.name);
    }
//    NSLog(@"%@", allEntitiesArray);
}

@end
