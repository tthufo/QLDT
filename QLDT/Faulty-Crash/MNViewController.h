//
//  MNViewController.h
//  MNCalendarViewExample
//
//  Created by Min Kim on 7/26/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNViewController;

@protocol CalendarDelegate <NSObject>
    
@optional
    
- (void)didChooseCalendar:(NSDate*)date;
    
@end

@interface MNViewController : UIViewController

- (instancetype)initWithCalendar:(NSCalendar *)calendar title:(NSString *)title;

@property (nonatomic, weak) id <CalendarDelegate> delegate;

@end
