//
//  LoginViewController.m
//  FollowPlaces
//
//  Created by Luchian Chivoiu on 23/11/2012.
//  Copyright (c) 2012 Luchian Chivoiu. All rights reserved.
//

#import "LoginViewController.h"
#import "AuditionsViewController.h"
#import "API.h"



@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize userId;
@synthesize EmailTextfield;
@synthesize PasswordTextfield;
@synthesize KeyboardToolbar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    EmailTextfield.inputAccessoryView=KeyboardToolbar;
    PasswordTextfield.inputAccessoryView=KeyboardToolbar;
    self.userId = [[NSString alloc] init];
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     [detailViewController release];
//     */
//}
//

 
- (IBAction)LoginClick:(UIBarButtonItem *)sender {
    
    
    NSMutableDictionary* params =[NSMutableDictionary dictionaryWithObjectsAndKeys:[self.EmailTextfield text], @"Email",[self.PasswordTextfield text], @"Password", nil];
    /*
     UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(100, 100, 80, 80)];
    [activity setBackgroundColor:[UIColor clearColor]];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activity];
    [activity release];
    [activity startAnimating];
    */
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    sender.enabled = false;
   
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [[API sharedInstance] getCommand:params  APIPath:@"/Api/Login"  onCompletion:^(NSDictionary *json)  {
            if ([json valueForKey:@"error" ]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[json valueForKey:@"error" ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            } else {
            if ([[[json valueForKey:@"Logged" ] stringValue] isEqualToString:@"1"]) {
                self.userId = [json valueForKey:@"UserId"];
				[self performSegueWithIdentifier: @"LoginSegue" sender: self];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect" message:@"Username and password are incorrect" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            }
            //[activity stopAnimating];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                sender.enabled = true;
            });
        }];
       
    });
    

    
}

- (IBAction)DoneToolbar:(UIBarButtonItem *)sender {
    if ([self.EmailTextfield isFirstResponder]) {
        
        [self.EmailTextfield resignFirstResponder];
    }
    else
        if ([self.PasswordTextfield isFirstResponder]) {
            
            [self.PasswordTextfield resignFirstResponder];
            
        }
           
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textfield{
    // [textfield resignFirstResponder];
    if(textfield==self.EmailTextfield)
    {
        [self.PasswordTextfield becomeFirstResponder];
    }
    else
            {
                
                
            }
    return YES;
}

- (void)dealloc {

    [EmailTextfield release];
    [PasswordTextfield release];
    [KeyboardToolbar release];
    [userId release];
    
    //[_LogInButton release];
    [super dealloc];
}
- (void)viewDidUnload {

    [self setEmailTextfield:nil];
    [self setPasswordTextfield:nil];
    [self setKeyboardToolbar:nil];
   // [self setLogInButton:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"LoginSegue"]) {
        UINavigationController *myNC = (UINavigationController *) [segue destinationViewController];
        AuditionsViewController *myVC = (AuditionsViewController*)myNC.viewControllers[0];

        //  [segue destinationViewController];
      // myVC.userId = [[NSString alloc]init];
        [LoginInfo sharedInstance].userId = self.userId;
       //myVC.userId = self.userId;// set your properties here
       // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Got Server Response" message:myVC.userId delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alert show];
        //[alert release];
        // [userId release];
    }
}

@end
