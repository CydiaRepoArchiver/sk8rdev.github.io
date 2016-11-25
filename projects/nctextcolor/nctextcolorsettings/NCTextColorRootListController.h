//#import <Preferences/PSListController.h>
#import "../headers.h"


@interface NCTextColorRootListController : PSListController
{
    NSMutableDictionary* _settings;
}
- (void)setCellForRowAtIndexPath:(NSIndexPath *)indexPath enabled:(BOOL)enabled;
-(void)respring;
@end
