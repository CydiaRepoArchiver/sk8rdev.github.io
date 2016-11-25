#include "NCTextColorRootListController.h"
#import <UIKit/UIKit.h>
#import <spawn.h>
#import <CoreGraphics/CGGeometry.h>
#import <SpringBoard/SpringBoard.h>

@interface UIImage (NCTextColor)
+ (UIImage *)imageNamed:(NSString *)named inBundle:(NSBundle *)bundle;
@end

@implementation NCTextColorRootListController

NSMutableDictionary *settingsDict;

-(void)loadView {
    [super loadView];
    UIButton *someButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 75, 20)];
    [someButton addTarget:self action:@selector(respring) forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    [someButton setTitle:@"Respring" forState:UIControlStateNormal];
    [someButton setTitleColor:[UIColor colorWithRed:231.0/255.0f green:76/255.0f blue:60.0/255.0f alpha:1] forState:UIControlStateNormal];
    UIBarButtonItem *respringButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    /*UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -16;*/
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: respringButton, nil] animated:YES];
    
}

-(void)viewDidLayoutSubviews {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
    //headerView.backgroundColor = [UIColor colorWithRed:46/255.0f green:204/255.0f blue:113/255.0f alpha:1];
    
    UIImage *headerImage = [UIImage imageNamed:@"nctextcolorheader.png" inBundle:[NSBundle bundleForClass:self.class]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:headerImage];
    imageView.frame = CGRectMake(0, 0, headerView.bounds.size.width, headerView.bounds.size.height);
    
    /*UILabel *tweakName = [[UILabel alloc]initWithFrame:CGRectMake(0,0,headerView.bounds.size.width,150)];
    tweakName.text = @"NCTextColor";
    tweakName.textColor = [UIColor whiteColor];
    [tweakName setFont:[UIFont fontWithName:@"Futura" size:40]];
    tweakName.textAlignment = NSTextAlignmentCenter;
    */
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    UILabel *footerText = [[UILabel alloc]initWithFrame:CGRectMake(0,-20,footerView.bounds.size.width,50)];
    //footerText.translatesAutoresizingMaskIntoConstraints = YES;
    footerText.numberOfLines = 2;
    footerText.text = @"Copyright © 2016 sk8r\nNCTextColor";
    footerText.textColor = [UIColor grayColor];
    [footerText setFont:[UIFont systemFontOfSize:10]];
    footerText.textAlignment = NSTextAlignmentCenter;
    
  
    
    [headerView addSubview:imageView];
    [self.table setTableHeaderView:headerView];
    
    [footerView addSubview:footerText];
    [self.table setTableFooterView:footerView];
    
}

- (id)init
{
    if ((self = [super init]) != nil) {
        _settings = ([NSMutableDictionary dictionaryWithContentsOfFile:_plistfile] ?: [NSMutableDictionary dictionary]);
        settingsDict = [[NSMutableDictionary alloc]initWithDictionary:_settings];
    }
    
    return self;
}


- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)setCellForRowAtIndexPath:(NSIndexPath *)indexPath enabled:(BOOL)enabled
{
    UITableViewCell *cell = [self tableView:self.table cellForRowAtIndexPath:indexPath];
    if (cell) {
        cell.userInteractionEnabled = enabled;
        cell.textLabel.enabled = enabled;
        cell.detailTextLabel.enabled = enabled;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if(cell.imageView.image != NULL){
    CGSize itemSize = CGSizeMake(30, 30);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    }
        //cell.textLabel.textColor = [UIColor colorWithRed:60.0f/255.0f green:100.0f/255.0f blue:120.0f/255.0f alpha:1]; //60, 100, 120
    //cell.detailTextLabel.textColor = [UIColor colorWithRed:60.0f/255.0f green:100.0f/255.0f blue:120.0f/255.0f alpha:1];
    return cell;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier
{
    NSString *key = [specifier propertyForKey:@"key"];
    settingsDict = ([NSMutableDictionary dictionaryWithContentsOfFile:_plistfile] ?: [NSMutableDictionary dictionary]);
    [settingsDict setObject:value forKey:key];
    [settingsDict writeToFile:_plistfile atomically:YES];
    
    
    if ([key isEqualToString:@"enabled"]) {
        BOOL enableCell = [value boolValue];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] enabled:enableCell];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] enabled:enableCell];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] enabled:enableCell];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2] enabled:enableCell];
    }
    
    
}

- (id)readPreferenceValue:(PSSpecifier *)specifier
{
    settingsDict = ([NSMutableDictionary dictionaryWithContentsOfFile:_plistfile] ?: [NSMutableDictionary dictionary]);
    NSString *key = [specifier propertyForKey:@"key"];
    id defaultValue = [specifier propertyForKey:@"default"];
    id plistValue;
    if(![settingsDict objectForKey:key])
    {
        plistValue = defaultValue;
    }else {
        plistValue = [settingsDict objectForKey:key];
    }
    
    if ([key isEqualToString:@"enabled"]) {
        BOOL enableCell = plistValue && [plistValue boolValue];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] enabled:enableCell];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] enabled:enableCell];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] enabled:enableCell];
        [self setCellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2] enabled:enableCell];
    }
    
    return plistValue;
}
-(void)respring {
    pid_t pid;
    int status;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char*
                                                       const*)args, NULL);
    waitpid(pid, &status, WEXITED);
    
}

- (void)link {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/sk8r_99"]];
}

- (void)email {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:sk8r.development@gmail.com?subject=NCTextColor"]];
}


@end

