#define _plistfile @"/var/mobile/Library/Preferences/com.sk8r.nctextcolorsettings.plist"

@interface PSTableCell : UITableViewCell
{
    UIImage *_imageView;
}
@end

@interface PSControlTableCell : PSTableCell
- (UIControl *)control;
@end

@interface PSSwitchTableCell : PSControlTableCell
@end



@interface PSSpecifier : NSObject
- (id)propertyForKey:(id)arg1;
@end

@interface PSViewController : UIViewController
- (void)setPreferenceValue:(id)arg1 specifier:(id)arg2;
- (id)readPreferenceValue:(id)arg1;
@end

@interface PSListController : PSViewController {
	UITableView *_table;
	NSArray *_specifiers;
}
- (id)loadSpecifiersFromPlistName:(id)arg1 target:(id)arg2;
- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2;
- (UITableView *)table;
-(UINavigationController*)navigationController;

@end
