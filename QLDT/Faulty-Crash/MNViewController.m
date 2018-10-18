//
//  MNViewController.m
//  MNCalendarViewExample
//
//  Created by Min Kim on 7/26/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNViewController.h"

#import "NSObject+Category.h"

#import <MNCalendarView/MNCalendarView.h>

@interface MNViewController () <MNCalendarViewDelegate>
{
    NSString * chosenDate;
}

@property(nonatomic,strong) NSCalendar     *calendar;
@property(nonatomic,strong) IBOutlet MNCalendarView *calendarView;
@property(nonatomic,strong) NSDate         *currentDate ;

@end

@implementation MNViewController

    @synthesize delegate;
    
- (instancetype)initWithCalendar:(NSCalendar *)calendar title:(NSString *)title {
  if (self = [super init]) {
      
    self.calendar = calendar;
      
    [[MNCalendarView appearance] setSeparatorColor:UIColor.blueColor];

    self.title = title;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = UIColor.whiteColor;
  
  self.currentDate = [NSDate date];

  chosenDate = [self.currentDate stringWithFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//  chosenDate = [self.currentDate stringWithFormat:@"yyyy-MM-dd"];

    
  self.calendarView.calendar = self.calendar;
  self.calendarView.selectedDate = [NSDate date];
  self.calendarView.delegate = self;
  self.calendarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  self.calendarView.backgroundColor = UIColor.whiteColor;
  
  [self.view addSubview:self.calendarView];
}

- (IBAction)didPressBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
- (IBAction)didPressChoose:(id)sender
{
    if(delegate && [delegate respondsToSelector:@selector(didChooseCalendar:and:)])
    {
        [delegate didChooseCalendar: chosenDate and:self.title];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [self.calendarView.collectionView.collectionViewLayout invalidateLayout];
  [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  [self.calendarView reloadData];
}

#pragma mark - MNCalendarViewDelegate

- (void)calendarView:(MNCalendarView *)calendarView didSelectDate:(NSDate *)date {
    chosenDate = [date stringWithFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//    chosenDate = [date stringWithFormat:@"yyyy-MM-dd"];
}

- (BOOL)calendarView:(MNCalendarView *)calendarView shouldSelectDate:(NSDate *)date {
  return YES;
}

@end
