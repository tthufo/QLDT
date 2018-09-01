//
//  UIViewController+ViewCat.m
//  LuckPhone
//
//  Created by Thanh Hai Tran on 11/1/17.
//  Copyright © 2017 com. All rights reserved.
//

#import "UIViewController+ViewCat.h"

#import "AVHexColor.h"

@implementation UIViewController (ViewCat)

- (void)viewDidLoad
{
    self.navigationController.navigationBar.barTintColor = [AVHexColor colorWithHexString:@"#2C4760"];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
    
//    if (@available(iOS 11, *)) {
//        
//        NSLayoutConstraint *bottomConstraint   = [NSLayoutConstraint constraintWithItem:self.childView
//                                                                              attribute:NSLayoutAttributeBottom
//                                                                              relatedBy:NSLayoutRelationEqual
//                                                                                 toItem:self.parentView.safeAreaLayoutGuide
//                                                                              attribute:NSLayoutAttributeBottom
//                                                                             multiplier:1.0
//                                                                               constant:0];
//        
//        
//        NSLayoutConstraint *topConstraint   = [NSLayoutConstraint constraintWithItem:self.childView
//                                                                           attribute:NSLayoutAttributeTop
//                                                                           relatedBy:NSLayoutRelationEqual
//                                                                              toItem:self.parentView.safeAreaLayoutGuide
//                                                                           attribute:NSLayoutAttributeTop
//                                                                          multiplier:1.0
//                                                                            constant:0];
//        
//        
//    } else {
//        
//        NSLayoutConstraint *bottomConstraint   = [NSLayoutConstraint constraintWithItem:self.childView
//                                                                              attribute:NSLayoutAttributeBottom
//                                                                              relatedBy:NSLayoutRelationEqual
//                                                                                 toItem:self.parentView
//                                                                              attribute:NSLayoutAttributeBottom
//                                                                             multiplier:1.0
//                                                                               constant:0];
//        
//        
//        NSLayoutConstraint *topConstraint   = [NSLayoutConstraint constraintWithItem:self.childView
//                                                                           attribute:NSLayoutAttributeTop
//                                                                           relatedBy:NSLayoutRelationEqual
//                                                                              toItem:self.parentView
//                                                                           attribute:NSLayoutAttributeTop
//                                                                          multiplier:1.0
//                                                                            constant:0];
//        
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (BOOL)hasDup:(NSArray*)array
{
    NSCountedSet *set = [[NSCountedSet alloc] initWithArray:array];
    
    int duplicates = 0;
    for (id object in set) {
        if ([set countForObject:object] > 1) {
            duplicates++;
            
            NSLog(@"%@", object);
        }
    }
    
    return duplicates == 0;
}

- (void)getAddressFromLocation:(CLLocation *)location complationBlock:(addressCompletion)completionBlock
{
    __block CLPlacemark* placemark;
    __block NSString *address = nil;
    
    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil && [placemarks count] > 0)
         {
             placemark = [placemarks lastObject];
             
             //placemark.locality
             
             address = [NSString stringWithFormat:@"%@, %@, %@, %@", placemark.name, placemark.subLocality, placemark.subAdministrativeArea, placemark.administrativeArea];
             completionBlock(@{@"address":address, @"city":placemark.locality, @"province":placemark.subAdministrativeArea});
         }
     }];
}

@end

@implementation UIView (extend)

- (void)pulseViewSize:(float)oSize andSize:(float)size andDuration:(float)duration;
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    [animation setFromValue:[NSNumber numberWithFloat:oSize]];
    [animation setToValue:[NSNumber numberWithFloat: size]];
    
    [animation setDuration:duration];
    
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    
    [[self layer] addAnimation:animation forKey:@"scale"];
}

@end

@implementation UIButton (badge)

- (void)setBadgeBGColor:(UIColor *)badgeBGColor
{
    self.badgeBGColor = [UIColor blueColor];
}

- (UIColor*)badgeBGColor
{
    return self.badgeBGColor;
}

@end

@implementation NSString (strip)

- (NSString*)stripVNI
{
    NSString *standard = [self stringByReplacingOccurrencesOfString:@"đ" withString:@"d"];
    standard = [standard stringByReplacingOccurrencesOfString:@"Đ" withString:@"D"];
    NSData *decode = [standard dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *ansi = [[NSString alloc] initWithData:decode encoding:NSASCIIStringEncoding];
    return ansi;
}

@end
