//
//  ViewController.m
//  Deprocrastinator
//
//  Created by ETC ComputerLand on 7/28/14.
//  Copyright (c) 2014 cmeats. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property NSMutableArray * todoItems;
@property NSMutableArray * todoItemTextColors;
@property NSMutableArray * todoItemBackground;
@property (strong, nonatomic) IBOutlet UITextField *customTextLabel;
@property (strong, nonatomic) IBOutlet UITableView *todoItemsTable;
@property BOOL editMode;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.todoItems = [NSMutableArray arrayWithObjects:
                      @"Add project to GitHub",
                      @"Complete Challenge MVP",
                      @"Complete Challenge Stretches",
                      @"Complete Mobile Makers Course",
                      nil];
    self.todoItemTextColors = [NSMutableArray arrayWithObjects:
                               [UIColor blackColor],
                               [UIColor blackColor],
                               [UIColor blackColor],
                               [UIColor blackColor],
                               nil];
    self.todoItemBackground = [NSMutableArray arrayWithObjects:
                               [UIColor whiteColor],
                               [UIColor whiteColor],
                               [UIColor whiteColor],
                               [UIColor whiteColor],
                               nil];
    self.editMode = NO;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.todoItems.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.textLabel.text = [self.todoItems objectAtIndex:indexPath.row];

    cell.backgroundColor = [self.todoItemBackground objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [self.todoItemTextColors objectAtIndex:indexPath.row];
    return cell;
}
- (IBAction)onAddButtonPressed:(id)sender
{
    [self.todoItems addObject:self.customTextLabel.text];
    [self.todoItemsTable reloadData];
    self.customTextLabel.text = @"";
    [self.customTextLabel resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editMode) {
        [self removeTodoItem:indexPath.row];
    } else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor greenColor];
        self.todoItemTextColors[indexPath.row] = [UIColor greenColor];
    }
}
- (IBAction)onEditButtonPressed:(UIButton *)sender
{
    if (self.editMode) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        self.editMode = NO;
        [self.todoItemsTable setEditing:NO animated:YES];
    } else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        self.editMode = YES;
        self.todoItemsTable.allowsSelectionDuringEditing = YES;
        [self.todoItemsTable setEditing:YES animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeTodoItem:indexPath.row];
}
-(IBAction)onSwipeRight:(UISwipeGestureRecognizer *) swipeGesture
{
    CGPoint point = [swipeGesture locationInView:self.todoItemsTable];
    NSIndexPath *indexPath = [self.todoItemsTable indexPathForRowAtPoint:point];
    UITableViewCell *cell = [self.todoItemsTable cellForRowAtIndexPath:indexPath];

    NSArray *priorityColors = [NSArray arrayWithObjects:
                               [UIColor whiteColor],
                               [UIColor greenColor],
                               [UIColor yellowColor],
                               [UIColor redColor]
                               , nil];
    for (UIColor *color in priorityColors) {
        if ([cell.backgroundColor isEqual:color]) {
            NSInteger index = [priorityColors indexOfObject:color];
            if(index+1 == priorityColors.count) {
                index = -1;
            }
            cell.backgroundColor = [priorityColors objectAtIndex:index+1];
            self.todoItemBackground[indexPath.row] = [priorityColors objectAtIndex:index+1];
            break;
        }
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *stringToMove = self.todoItems[sourceIndexPath.row];
    [self.todoItems removeObjectAtIndex:sourceIndexPath.row];
    [self.todoItems insertObject:stringToMove atIndex:destinationIndexPath.row];
}

-(void)removeTodoItem:(NSInteger)row
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.title = @"Confirmation";
    alert.message = @"Are you sure you want to delete this item";
    alert.tag = row;
    [alert addButtonWithTitle:@"Delete"];
    [alert addButtonWithTitle:@"Cancel"];
    alert.delegate = self;
    [alert show];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.todoItems removeObjectAtIndex:alertView.tag];
        [self.todoItemsTable reloadData];

        [self.todoItemBackground removeObjectAtIndex:alertView.tag];
        [self.todoItemTextColors removeObjectAtIndex:alertView.tag];
    }
}

@end
