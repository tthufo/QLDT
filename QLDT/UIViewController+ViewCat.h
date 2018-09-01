//
//  UIViewController+ViewCat.h
//  LuckPhone
//
//  Created by Thanh Hai Tran on 11/1/17.
//  Copyright © 2017 com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

@interface UIViewController (ViewCat)

typedef void(^addressCompletion)(NSDictionary *);

- (BOOL)hasDup:(NSArray*)array;

- (void)getAddressFromLocation:(CLLocation *)location complationBlock:(addressCompletion)completionBlock;

@end

@interface UIView (extend)

- (void)pulseViewSize:(float)oSize andSize:(float)size andDuration:(float)duration;

@end

@interface UIButton (badge)

@property (nonatomic) UIColor *badgeBGColor;

@end

@interface NSString (strip)

- (NSString*)stripVNI;

@end
