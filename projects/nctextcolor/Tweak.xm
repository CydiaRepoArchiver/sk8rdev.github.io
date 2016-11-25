#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "libcolorpicker.h"
#import <QuartzCore/QuartzCore.h>

#define PLIST_PATH @"/var/mobile/Library/Preferences/com.sk8r.nctextcolorsettings.plist"



UIColor *txtColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];

@interface SBNotificationsBulletinCell: UITableViewCell
@property (nonatomic, retain) UILabel *primaryLabel;
@property (nonatomic, retain) UILabel *secondaryLabel;
@property (nonatomic, retain) UILabel *relevanceDateLabel;

-(id)subviews;
@end

@interface SBNotificationCenterHeaderView
@property (nonatomic, retain) UILabel *titleLabel;
@end

@interface SBUISizeObservingView:UIView
@end
@interface _UIContentUnavailableView:UIView
@end

%hook SBNotificationsBulletinCell

-(void)layoutSubviews {
  %orig();
  UILabel *stamp = (UILabel *)[self.contentView viewWithTag:88];
  if(stamp){ [stamp removeFromSuperview];}
  if([[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:@"enabled"]boolValue])
  {
  txtColor = LCPParseColorString([[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:@"textColor"], @"#FFFFFF");
  self.primaryLabel.textColor = txtColor;
  self.secondaryLabel.textColor = txtColor;
  self.relevanceDateLabel.hidden = YES;

  UILabel *label = (UILabel *)[self.contentView viewWithTag:1000];
  if(label){ label.textColor = txtColor;}
  else {
    UILabel *newDateLabel = [[UILabel alloc]initWithFrame:self.relevanceDateLabel.frame];
    newDateLabel.text = self.relevanceDateLabel.text;
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [txtColor getRed:&red green:&green blue:&blue alpha:&alpha];
    newDateLabel.textColor = [txtColor colorWithAlphaComponent:alpha * 0.5];
    newDateLabel.font = self.relevanceDateLabel.font;
    newDateLabel.tag = 88;
    [self.contentView addSubview: newDateLabel];
  }
}
}

%end

%hook SBNotificationCenterHeaderView

-(void)layoutSubviews {
  %orig();
  if([[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:@"enabled"]boolValue]){
  txtColor = LCPParseColorString([[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:@"headerColor"], @"#FFFFFF:0.7");
  self.titleLabel.textColor = txtColor;
}
}
%end
%hook SBTodayTableHeaderView
-(void)layoutSubviews {
  %orig();
  if([[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:@"enabled"]boolValue]){
  txtColor = LCPParseColorString([[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:@"todayHeaderColor"], @"#FFFFFF:0.7");
  MSHookIvar<UILabel *>(self, "_dateLabel").textColor = txtColor;
}
}
%end

%hook SBTodayTableViewCell
-(void)layoutSubviews {
  %orig();
  if([[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:@"enabled"]boolValue]){
  txtColor = LCPParseColorString([[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:@"todayColor"], @"#FFFFFF:0.7");
  UILabel *label = MSHookIvar<UILabel *>(self, "_label");
  label.textColor = txtColor;
}
}
%end

%hook SBUISizeObservingView

-(void)layoutSubviews
{
  %orig();
  if([[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:@"enabled"]boolValue])
  {
  txtColor = LCPParseColorString([[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:@"textColor"], @"#FFFFFF");
  for (UIView *myView in self.subviews) {
    if ([myView isKindOfClass: [_UIContentUnavailableView class]])
    {
      for(UIView *newView in myView.subviews)
      {
        if([newView isKindOfClass:[UIView class]])
        {
          for(UIView *labelView in newView.subviews)
          {
            if([labelView isKindOfClass:[UILabel class]])
            {
              UILabel *myLabel = (UILabel *)labelView;
                myLabel.textColor = txtColor;
            }
          }
        }
      }
    }
  }
 }
}
%end
