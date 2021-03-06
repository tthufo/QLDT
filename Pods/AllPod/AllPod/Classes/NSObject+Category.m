//
//  NSObject+Category.m
//  Pods
//
//  Created by thanhhaitran on 12/21/15.
//
//

#import "NSObject+Category.h"

#import "AVHexColor.h"

#import "SVProgressHUD.h"

#import "UIView+Toast.h"

#import "Reachability.h"

#import <AVFoundation/AVFoundation.h>

#import <Accelerate/Accelerate.h>

#import "objc/runtime.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define iOS7_0 @"7.0"

@implementation NSObject (Extension_Category)

- (float)screenWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}

- (float)screenHeight
{
    return [[UIScreen mainScreen] bounds].size.height;
}

- (BOOL)isSimulator
{
    #if TARGET_IPHONE_SIMULATOR
        
        return YES;
        
    #else
        
        return NO;
        
    #endif
}

- (BOOL)checkForNotification
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        UIUserNotificationType type = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
        if (type == UIUserNotificationTypeNone)
        {
            return NO;
        }
    }
    else
    {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (types == UIRemoteNotificationTypeNone)
        {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isConnectionAvailable
{
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef add;
    add = SCNetworkReachabilityCreateWithName(NULL, "www.apple.com" );
    Boolean success = SCNetworkReachabilityGetFlags(add, &flags);
    CFRelease(add);
    
    bool canReach = success
    && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)
    && (flags & kSCNetworkReachabilityFlagsReachable);
    
    return canReach;
}

- (NSString *)uuidString
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    return uuidString;
}

- (NSDictionary *)infoPlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    return dictionary;
}

- (NSString *)deviceUUID
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString *)uniqueDeviceId
{
    return [[self deviceUUID] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

- (NSDictionary *)appInfor
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    return @{@"majorVersion":majorVersion,@"minorVersion":minorVersion};
}

- (NSInteger)currentDateInt
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"ddMMyyyy"];
    NSDate *date = [NSDate date];
    CFAbsoluteTime at = [date timeIntervalSinceReferenceDate];
    CFTimeZoneRef tz = CFTimeZoneCopySystem();
    SInt32 WeekdayNumber = CFAbsoluteTimeGetDayOfWeek(at, tz);
    return WeekdayNumber;
}

- (NSString*)currentDate:(NSString*)format
{
    return  [[NSDate date] stringWithFormat:format];
}

- (NSString*)yesterdayDate:(NSString*)format
{
    NSDate *today = [NSDate date];
    
    NSDateComponents *components = [NSDateComponents new];
    
    [components setDay:-1];
    
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components
                                                                      toDate:today
                                                                     options:kNilOptions];
    
    return [yesterday stringWithFormat:format];
}

- (NSString*)specificDate:(NSString*)format withDays:(int)days
{
    NSDate *today = [NSDate date];
    
    NSDateComponents *components = [NSDateComponents new];
    
    [components setDay:days];
    
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components
                                                                      toDate:today
                                                                     options:kNilOptions];
    
    return [yesterday stringWithFormat:format];
}

- (BOOL)isPassTime:(NSString*)time
{
    NSDate * limitDate = [[NSString stringWithFormat:@"%@ %@", [[NSDate date] stringWithFormat:@"dd/MM/yyyy"], time] dateWithFormat:@"dd/MM/yyyy HH:mm"];
        
    return ([[NSDate date] timeIntervalSince1970] >= [limitDate timeIntervalSince1970]) ? YES : NO;
}

- (BOOL)isLiveRange:(NSString*)region
{
    NSDictionary * dict = [[NSDictionary new] dictionaryWithPlist:@"LiveRange"];
    
    NSDictionary * ranges = dict[region];
    
    NSDate * start = [[NSString stringWithFormat:@"%@ %@",[[[NSDate date] stringWithFormat:@"dd/MM/yyyy HH:mm:ss"] componentsSeparatedByString:@" "][0], ranges[@"end"]] dateWithFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    NSDate * end = [[NSString stringWithFormat:@"%@ %@",[[[NSDate date] stringWithFormat:@"dd/MM/yyyy HH:mm:ss"] componentsSeparatedByString:@" "][0], ranges[@"live"]] dateWithFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    if([[NSDate date] timeIntervalSince1970] > [start timeIntervalSince1970] && [[NSDate date] timeIntervalSince1970] < [end timeIntervalSince1970])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)isLiveScore:(NSString*)region
{
    NSDictionary * dict = [[NSDictionary new] dictionaryWithPlist:@"LiveRange"];
    
    NSDictionary * ranges = dict[region];
    
    NSDate * start = [[NSString stringWithFormat:@"%@ %@",[[[NSDate date] stringWithFormat:@"dd/MM/yyyy HH:mm:ss"] componentsSeparatedByString:@" "][0], ranges[@"start"]] dateWithFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    NSDate * end = [[NSString stringWithFormat:@"%@ %@",[[[NSDate date] stringWithFormat:@"dd/MM/yyyy HH:mm:ss"] componentsSeparatedByString:@" "][0], ranges[@"end"]] dateWithFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    if([[NSDate date] timeIntervalSince1970] > [start timeIntervalSince1970] && [[NSDate date] timeIntervalSince1970] < [end timeIntervalSince1970])
    {
        return YES;
    }
    
    return NO;
}

- (void)addValue:(NSString*)value andKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

- (NSString*)getValue:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)removeValue:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

- (void)modifyObject:(NSDictionary*)value andKey:(NSString*)key
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
    for(NSString * key in value.allKeys)
    {
        BOOL isFound = NO;
        for(NSString * k in dic.allKeys)
        {
            if([k isEqualToString:key])
            {
                dic[k] = value[key];
                isFound = YES;
                break;
            }
        }
        if(!isFound)
        {
            dic[key] = value[key];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:key];
}

- (void)addObject:(NSDictionary*)value andKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

- (NSDictionary*)getObject:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)removeObject:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

- (void)clearAllValue
{
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
}

- (void)alert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

- (void)showToast:(NSString*)toast andPos:(int)pos
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    [window hideAllToasts];
    
    [window makeToast:toast duration:2 position:pos == 0 ? CSToastPositionBottom : pos == 1 ? CSToastPositionCenter : CSToastPositionTop];
}

- (void)showSVHUD:(NSString *)string andProgress:(float)progress
{
    [SVProgressHUD showProgress:progress status:string];
}

- (void)showSVHUD:(NSString*)string andOption:(int)index
{
    switch (index)
    {
        case 0:
        {
            [SVProgressHUD showWithStatus:string];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
            [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
            [SVProgressHUD setForegroundColor:[UIColor systemBlueColor]];
        }
            break;
        case 1:
            [SVProgressHUD showSuccessWithStatus:string];
            break;
        case 2:
            [SVProgressHUD showErrorWithStatus:string];
            break;
        default:
            break;
    }
}

- (void)hideSVHUD
{
    [SVProgressHUD dismiss];
}

- (id)withView:(id)superView tag:(int)tag
{
    return [superView viewWithTag:tag];
}

- (NSDictionary*)inForOf:(UIView*)view andTable:(UITableView*)tableView
{
    CGPoint center = view.center;
    CGPoint rootViewPoint = [view.superview convertPoint:center toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:rootViewPoint];
    return @{@"index":@(indexPath.row),@"section":@(indexPath.section)};
}

- (NSDictionary*)inForOf:(UIView*)view andCollection:(UICollectionView*)collectionView
{
    CGPoint center = view.center;
    CGPoint rootViewPoint = [view.superview convertPoint:center toView:collectionView];
    NSIndexPath *indexPath = [collectionView indexPathForItemAtPoint:rootViewPoint];
    return @{@"index":@(indexPath.item),@"section":@(indexPath.section)};
}

- (int)inDexOf:(UIView*)view andTable:(UITableView*)tableView
{
    CGPoint center = view.center;
    CGPoint rootViewPoint = [view.superview convertPoint:center toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:rootViewPoint];
    return (int)indexPath.row;
}

- (int)inDexOf:(UIView*)view andCollection:(UICollectionView*)collectionView
{
    CGPoint center = view.center;
    CGPoint rootViewPoint = [view.superview convertPoint:center toView:collectionView];
    NSIndexPath *indexPath = [collectionView indexPathForItemAtPoint:rootViewPoint];
    return (int)indexPath.item;
}

- (void)registerForKeyboardNotifications:(BOOL)isRegister andSelector:(NSArray*)selectors
{
    if(isRegister)
    {
        [[NSNotificationCenter defaultCenter] addUniqueObserver:self selector:NSSelectorFromString(selectors[0]) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addUniqueObserver:self selector:NSSelectorFromString(selectors[1]) name:UIKeyboardWillHideNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (NSDictionary*)dictWithPlist:(NSString*)pList
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:pList ofType:@"plist"];
    return [[NSDictionary alloc] initWithContentsOfFile:plistPath];
}

- (NSArray*)arrayWithPlist:(NSString*)pList
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:pList ofType:@"plist"];
    return [[NSArray alloc] initWithContentsOfFile:plistPath];
}

- (NSMutableDictionary*)dictWithFile:(NSString*)path
{
    return [[NSMutableDictionary alloc] initWithContentsOfFile:path];
}

- (NSArray*)arryWithFile:(NSString*)path
{
    return [[NSArray alloc] initWithContentsOfFile:path];
}

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

- (NSString*)nonce
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity:10];
    
    for (int i=0; i<10; i++)
    {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

- (UIImage*)animate:(NSArray*)names andDuration:(float)duration_
{
    NSMutableArray * arr = [NSMutableArray new];
    
    for(NSString * name in names)
    {
        [arr addObject:[UIImage imageNamed:name]];
    }
    
    return [UIImage animatedImageWithImages:arr duration:duration_];
}

- (NSString *)duration:(int)seconds_
{
    int seconds = seconds_ % 60;
    int minutes = (seconds_ / 60) % 60;
    int hours = seconds_ / 3600;
    
    return hours == 0 ? [NSString stringWithFormat:@"%02d:%02d", minutes, seconds] : [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

- (CGAffineTransform)translatedAndScaledTransformUsingViewRect:(CGRect)viewRect fromRect:(CGRect)fromRect
{
    CGSize scales = CGSizeMake(viewRect.size.width/fromRect.size.width, viewRect.size.height/fromRect.size.height);
    CGPoint offset = CGPointMake(CGRectGetMidX(viewRect) - CGRectGetMidX(fromRect), CGRectGetMidY(viewRect) - CGRectGetMidY(fromRect));
    return CGAffineTransformMake(scales.width, 0, 0, scales.height, offset.x, offset.y);
}

- (NSString*)autoIncrement:(NSString*)uniqueName
{
    if(![self getValue:uniqueName])
    {
        [self addValue:@"1" andKey:uniqueName];
    }
    else
    {
        [self addValue:[NSString stringWithFormat:@"%i",[[self getValue:uniqueName] intValue] + 1] andKey:uniqueName];
    }
    
    return [self getValue:uniqueName];
}

@end

@implementation NSDictionary (name)

- (NSMutableDictionary*)reFormat
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:self];
    for(NSString * key in dict.allKeys)
    {
        if([dict[key] isKindOfClass:[NSDictionary class]])
        {
            dict[key] = [((NSDictionary*)dict[key]) reFormat];
        }
        else if([dict[key] isKindOfClass:[NSArray class]])
        {
            dict[key] = [((NSArray*)dict[key]) arrayWithMutable];
        }
        else
        {
            if(dict[key] == [NSNull null])
            {
                dict[key] = @"";
            }
        }
    }
    return dict;
}

-(NSDictionary*)dictionaryWithPlist:(NSString*)pList
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:pList ofType:@"plist"];
    return [self initWithContentsOfFile:plistPath];
}

- (BOOL)responseForKey:(NSString *)name
{
    return ([self objectForKey:name] && [self objectForKey:name] != [NSNull null]);
}

- (NSString*)responseForKind:(NSString*)name
{
    return [self responseForKey:name] ? [self[name] isKindOfClass:[NSString class]] ? self[name] : [self[name] stringValue] : @"Wrong key";
}

- (NSString*)responseForKind:(NSString*)name andOption:(NSString*)placeHolder
{
    return [self responseForKey:name] ? [self[name] isKindOfClass:[NSString class]] ? self[name] : [self[name] stringValue] : placeHolder ? placeHolder : name;
}

- (NSString*)getValueFromKey:(NSString *)name
{
    if(!self[name])
    {
        return @"";
    }
    if(self[name] == [NSNull null])
    {
        return @"";
    }
    if([self[name] isKindOfClass:[NSString class]])
    {
        return self[name];
    }
    else
    {
        return [self[name] stringValue];
    }
    return nil;
}

- (BOOL)responseForKindOfClass:(NSString *)name andTarget:(NSString*)target
{
    if([self[name] isKindOfClass:[NSString class]])
    {
        if([self[name] isEqualToString:target])
            return YES;
        else
            return NO;
    }
    else
    {
        if([self[name] isEqualToNumber:@([target intValue])])
            return YES;
        else
            return NO;
    }
    return NO;
}

- (NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    if (! jsonData)
    {
        return @"{}";
    }
    else
    {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end


@implementation NSNotificationCenter (UniqueNotif)

- (void)addUniqueObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:object];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:object];
}
@end



@implementation UILabel (UILabelDynamicHeight)

- (CGSize)sizeOfLabel
{
    return  [self.text sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:self.font.fontName size:self.font.pointSize]}];
}

- (CGSize)sizeOfMultiLineLabel
{
    NSAssert(self, @"UILabel was nil");
    NSString *aLabelTextString = [self text];
    UIFont *aLabelFont = [self font];
    CGFloat aLabelSizeWidth = self.frame.size.width;
    if (SYSTEM_VERSION_LESS_THAN(iOS7_0))
    {
        return [aLabelTextString sizeWithFont:aLabelFont
                            constrainedToSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                lineBreakMode:NSLineBreakByWordWrapping];
    }
    else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(iOS7_0))
    {
        return [aLabelTextString boundingRectWithSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{
                                                        NSFontAttributeName : aLabelFont
                                                        }
                                              context:nil].size;
    }
    return [self bounds].size;
}

@end

@implementation NSMutableArray (utility)

- (void)selfDeleteObject
{
    NSMutableArray * arr = [NSMutableArray new];
    
    for(id  dict in self)
    {
        if(![dict isKindOfClass:[NSDictionary class]])
        {
            [arr addObject:dict];
            continue;
        }
        BOOL isEmpty = YES;
        
        for(NSString * value in ((NSDictionary*)dict).allValues)
        {
            if(value && value.length != 0)
            {
                isEmpty = NO;
                break;
            }
        }
        if(isEmpty)
        {
            [arr addObject:dict];
        }
    }
    [self removeObjectsInArray:arr];
}

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex < toIndex) {
        toIndex--;
    }
    
    id object = [self objectAtIndex:fromIndex];
    [self removeObjectAtIndex:fromIndex];
    [self insertObject:object atIndex:toIndex];
}

@end


@implementation NSArray (OrderedDuplicateElimination)

- (NSArray *)arrayByEliminatingDuplicatesMaintainingOrder
{
    NSMutableSet *addedObjects = [NSMutableSet set];
    NSMutableArray *result = [NSMutableArray array];
    for (id obj in self) {
        if (![addedObjects containsObject:obj]) {
            [result addObject:obj];
            [addedObjects addObject:obj];
        }
    }
    return result;
}

- (NSMutableArray*)arrayByMergeAndDeduplication:(NSArray*)total
{
    [total[0] addObjectsFromArray:total[1]];
    
    NSMutableArray * ar3 = [total[1] arrayByEliminatingDuplicatesMaintainingOrder];
    
    NSMutableArray * deleteElement = [@[] mutableCopy];
    
    for(NSDictionary * string3 in ar3)
    {
        BOOL found = NO;
        for(NSDictionary * string2 in total[1])
        {
            if([string3[@"id"] isEqualToString:string2[@"id"]])
            {
                found = YES;
                break;
            }
        }
        if(!found)
        {
            [deleteElement addObject:string3];
        }
    }
    
    [ar3 removeObjectsInArray:deleteElement];
    
    return ar3;
}

-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions) (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        //        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"[]";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

-(NSArray*)arrayWithPlist:(NSString*)name
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    return [self initWithContentsOfFile:plistPath];
}

-(NSArray*)arrayWithMutable
{
    NSMutableArray * arr = [NSMutableArray new];
    for(id objc in self)
    {
        if([objc isKindOfClass:[NSDictionary class]])
        {
            [arr addObject:[objc reFormat]];
        }
        else if([objc isKindOfClass:[NSArray class]])
        {
            [arr addObject:[objc arrayWithMutable]];
        }
        else if (objc == [NSNull null])
        {
            [arr addObject:@""];
        }
        else
        {
            [arr addObject:objc];
        }
    }
    return arr;
}

- (NSArray*)order
{
    return [self sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
}

@end


@implementation UIView (Border)

- (UIImage *)pb_takeSnapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    if([self.subviews containsObject:(UIView*)[self withView:self tag:1]])
    {
        [(UIView*)[self withView:self tag:1] removeFromSuperview];
    }
    UIView *border = [UIView new];
    border.tag = 1;
    border.backgroundColor = color;
    [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
    [self addSubview:border];
}

- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    if([self.subviews containsObject:(UIView*)[self withView:self tag:2]])
    {
        [(UIView*)[self withView:self tag:2] removeFromSuperview];
    }
    UIView *border = [UIView new];
    border.tag = 2;
    border.backgroundColor = color;
    [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
    [self addSubview:border];
}

- (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    if([self.subviews containsObject:(UIView*)[self withView:self tag:3]])
    {
        [(UIView*)[self withView:self tag:3] removeFromSuperview];
    }
    UIView *border = [UIView new];
    border.tag = 3;
    border.backgroundColor = color;
    border.frame = CGRectMake(0, 1, borderWidth, self.frame.size.height);
    [border setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin];
    [self addSubview:border];
}

- (void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    if([self.subviews containsObject:(UIView*)[self withView:self tag:4]])
    {
        [(UIView*)[self withView:self tag:4] removeFromSuperview];
    }
    UIView *border = [UIView new];
    border.tag = 4;
    border.backgroundColor = color;
    [border setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin];
    border.frame = CGRectMake(self.frame.size.width - borderWidth, 1, borderWidth, self.frame.size.height);
    [self addSubview:border];
}

- (CALayer *)prefix_addUpperBorder:(UIRectEdge)edge color:(UIColor *)color thickness:(CGFloat)thickness
{
    CALayer *border = [CALayer layer];
    
    switch (edge) {
        case UIRectEdgeTop:
            border.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), thickness);
            break;
        case UIRectEdgeBottom:
            border.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame), thickness);
            break;
        case UIRectEdgeLeft:
            border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(self.frame));
            break;
        case UIRectEdgeRight:
            border.frame = CGRectMake(CGRectGetWidth(self.frame) - thickness, 0, thickness, CGRectGetHeight(self.frame));
            break;
        default:
            break;
    }
    
    border.backgroundColor = color.CGColor;
    
    [self.layer addSublayer:border];
    
    return border;
}

- (UIView *)withBorder:(NSDictionary *)dict
{
    self.layer.borderColor =  ![dict responseForKey:@"Bcolor"] ? [dict responseForKey:@"Bhex"] ? [AVHexColor colorWithHexString:dict[@"Bhex"]].CGColor : [UIColor clearColor].CGColor : ((UIColor*)dict[@"Bcolor"]).CGColor;
    self.layer.cornerRadius = [dict responseForKey:@"Bcorner"] ? [dict[@"Bcorner"] floatValue] : 0;
    self.layer.borderWidth =  [dict responseForKey:@"Bwidth"] ? [dict[@"Bwidth"] floatValue] : 0;
    self.clipsToBounds = YES;
    if([dict responseForKey:@"Bground"])
        self.backgroundColor = ([dict responseForKey:@"Bground"] && [dict[@"Bground"] isKindOfClass:[NSString class]]) ? [AVHexColor colorWithHexString:dict[@"Bground"]] : ((UIColor*)dict[@"Bground"]);
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.userInteractionEnabled = YES;
    
    return self;
}

-(UIView*)withShadow
{
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(01.0f,3.0f);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = .8f;
    self.layer.shadowColor = [AVHexColor colorWithHexString:@"#2B292A"].CGColor;
    return self;
}

-(UIView*)withShadow:(UIColor*)hext
{
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(1.0f,3.0f);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = .8f;
    self.layer.shadowColor = hext.CGColor;
    return self;
}

- (void)setHeight:(CGFloat)height animated:(BOOL)animated
{
    if (animated)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    CGRect f = self.frame;
    f.size.height = height;
    self.frame = f;
    if (animated)
    {
        [UIView commitAnimations];
    }
}

- (void)setWidth:(CGFloat)width animated:(BOOL)animated
{
    if (animated)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    CGRect f = self.frame;
    f.size.width = width;
    self.frame = f;
    if (animated)
    {
        [UIView commitAnimations];
    }
}

+ (CAKeyframeAnimation*)dockBounceAnimationWithViewHeight:(CGFloat)viewHeight
{
    NSUInteger const kNumFactors    = 22;
    CGFloat const kFactorsPerSec    = 30.0f;
    CGFloat const kFactorsMaxValue  = 128.0f;
    CGFloat factors[kNumFactors]    = {0,  60, 83, 100, 114, 124, 128, 128, 124, 114, 100, 83, 60, 32, 0, 0, 18, 28, 32, 28, 18, 0};
    
    NSMutableArray* transforms = [NSMutableArray array];
    
    for(NSUInteger i = 0; i < kNumFactors; i++)
    {
        CGFloat positionOffset  = factors[i] / kFactorsMaxValue * viewHeight;
        CATransform3D transform = CATransform3DMakeTranslation(0.0f, -positionOffset, 0.0f);
        
        [transforms addObject:[NSValue valueWithCATransform3D:transform]];
    }
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.repeatCount           = 1;
    animation.duration              = kNumFactors * 1.0f/kFactorsPerSec;
    animation.fillMode              = kCAFillModeForwards;
    animation.values                = transforms;
    animation.removedOnCompletion   = YES;
    animation.autoreverses          = NO;
    
    return animation;
}

- (void)bounce:(float)bounceFactor
{
    CGFloat midHeight = self.frame.size.height * bounceFactor;
    CAKeyframeAnimation* animation = [[self class] dockBounceAnimationWithViewHeight:midHeight];
    [self.layer addAnimation:animation forKey:@"bouncing"];
}

- (UIViewController *)parentViewController
{
    id responder = self;
    while ([responder isKindOfClass:[UIView class]])
        responder = [responder nextResponder];
    return responder;
}

- (void)removeAllGestures
{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers)
    {
        [self removeGestureRecognizer:gesture];
    }
}

- (void)removeAllSubviews
{
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
}

- (void)addTapTarget:(id)target action:(SEL)selector
{
    if ([self respondsToSelector:@selector(addTarget:action:forControlEvents:)])
    {
        [(UIButton *)self removeTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        [(UIButton *)self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        BOOL found = NO;
        for (UIGestureRecognizer *gesture in self.gestureRecognizers)
        {
            if ([gesture isKindOfClass:[UITapGestureRecognizer class]])
            {
                found = YES;
                break;
            }
        }
        if (!found)
        {
            self.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
            [self addGestureRecognizer:tap];
        }
    }
}

- (void)animation:(CGFloat)duration
{
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:duration
                     animations:^{
                         [self layoutIfNeeded];
                     }];
}

- (void)rotate360WithDuration:(NSArray*)config repeatCount:(float)repeatCount
{
    CABasicAnimation *fullRotation;
    fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:(2*M_PI) * [config[0] floatValue]];
    fullRotation.duration = [config[1] floatValue];
    fullRotation.speed = [config[2] floatValue];
    if (repeatCount == 0)
        fullRotation.repeatCount = MAXFLOAT;
    else
        fullRotation.repeatCount = repeatCount;
    
    [self.layer addAnimation:fullRotation forKey:@"360"];
}

- (void)stopAllAnimations
{
    [self.layer removeAllAnimations];
}

- (void)pauseAnimations
{
    [self pauseLayer:self.layer];
}

- (void)resumeAnimations
{
    [self resumeLayer:self.layer];
}

- (void)pauseLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer *)layer
{
    if(layer.speed == 0)
    {
        CFTimeInterval pausedTime = [layer timeOffset];
        layer.speed = 1.0;
        layer.timeOffset = 0.0;
        layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        layer.beginTime = timeSincePause;
    }
}

- (void)setFlex:(NSString *)flex
{
    if([flex isEqualToString:@""])
    {
        for (NSLayoutConstraint * constraint in self.constraints) {
            if(constraint.firstAttribute == NSLayoutAttributeHeight){
                constraint.constant = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11") ? 44 : 64 ;
            }
        }
    }
}

- (NSString*)getFlex
{
    return self.flex;
}

- (void)setShadowColor:(NSString *)shadowColor
{
    if([shadowColor isEqualToString:@""])
    {
        self.layer.shadowColor = UIColor.blackColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowRadius = 2.0;
    }
    else
    {
        [self withShadow:[AVHexColor colorWithHexString:shadowColor]];
    }
}

- (NSString*)getShadowColor
{
    return self.shadowColor;
}

@end

@implementation UIImage (Scale)

- (NSString *)encodeToBase64String
{
    return [UIImagePNGRepresentation(self) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)boxblurImageWithBlur:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 50);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"JFDepthView: error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}


- (UIImage *)tintedImage:(NSString*)color
{
    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, self.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [[AVHexColor colorWithHexString:color] setFill];
    CGContextFillRect(context, rect);
    
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:coloredImage.CGImage
                               scale:coloredImage.scale
                         orientation:UIImageOrientationDownMirrored];
}

- (UIImage *)imageScaledToQuarter
{
    return [self imageScaledToScale:0.25f withInterpolationQuality:kCGInterpolationHigh];
}

- (UIImage *)imageScaledToHalf
{
    return [self imageScaledToScale:0.5f withInterpolationQuality:kCGInterpolationHigh];
}

- (UIImage *)imageScaledToScale:(CGFloat)scale
{
    return [self imageScaledToScale:scale withInterpolationQuality:kCGInterpolationHigh];
}

- (UIImage *)imageScaledToScale:(CGFloat)scale withInterpolationQuality:(CGInterpolationQuality)quality
{
    UIGraphicsBeginImageContextWithOptions(self.size, YES, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)timageWithBrightness:(CGFloat)brightnessFactor {
    
    if ( brightnessFactor == 0 ) {
        return self;
    }
    
    CGImageRef imgRef = [self CGImage];
    
    size_t width = CGImageGetWidth(imgRef);
    size_t height = CGImageGetHeight(imgRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = 4;
    size_t bytesPerRow = bytesPerPixel * width;
    size_t totalBytes = bytesPerRow * height;
    
    //Allocate Image space
    uint8_t* rawData = malloc(totalBytes);
    
    //Create Bitmap of same size
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    //Draw our image to the context
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    
    //Perform Brightness Manipulation
    for ( int i = 0; i < totalBytes; i += 4 ) {
        
        uint8_t* red = rawData + i;
        uint8_t* green = rawData + (i + 1);
        uint8_t* blue = rawData + (i + 2);
        
        *red = MIN(255,MAX(0,roundf(*red + (*red * brightnessFactor))));
        *green = MIN(255,MAX(0,roundf(*green + (*green * brightnessFactor))));
        *blue = MIN(255,MAX(0,roundf(*blue + (*blue * brightnessFactor))));
        
    }
    
    //Create Image
    CGImageRef newImg = CGBitmapContextCreateImage(context);
    
    //Release Created Data Structs
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    free(rawData);
    
    //Create UIImage struct around image
    UIImage* image = [UIImage imageWithCGImage:newImg];
    
    //Release our hold on the image
    CGImageRelease(newImg);
    
    //return new image!
    return image;
}

- (UIImage*)imageWithImage:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

@implementation NSString (Contains)

- (NSString*)trim
{
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (CGFloat)didConfigHeight:(CGFloat)fontSize andDistance:(CGFloat)distance andExtra:(CGFloat)extra
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    CGFloat pointSize = fontSize;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:pointSize],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - distance;
    
    CGRect titleBounds = [@"name" boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
    CGRect bodyBounds = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
    
    if (self.length == 0)
    {
        return 0.0;
    }
    
    CGFloat height = CGRectGetHeight(titleBounds);
    height += CGRectGetHeight(bodyBounds);
    height += extra;
    
    if (height < 50)
    {
        height = 50;
    }
    
    return height;
}

- (BOOL)myContainsString:(NSString*)other
{
    NSRange range = [self rangeOfString:other];
    return range.length != 0;
}

- (BOOL)containsString:(NSString *)str
{
    return [self myContainsString:str];
}

- (NSString*)specialDateFromTimeStamp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:self];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    return [dateFormatter stringFromDate:dateFromString];
}

- (NSString*)specialDateAndTimeFromTimeStamp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:self];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss a"];
    return [dateFormatter stringFromDate:dateFromString];
}

- (NSString*)dateAndTimeFromTimeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    
    return [dateFormatter stringFromDate:date];
}

- (NSString*)dateFromTimeStamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    return [dateFormatter stringFromDate:date];
}

- (NSString*)dateFromTimeStamp:(NSString*)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:date];
}

- (NSString*)normalizeDateTime:(int)position//:(NSString*)dateTime
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZZZ"];
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZZZ"];
    
    //df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    NSString *result = [df stringFromDate:[dateFormatter dateFromString:self]];
    
    NSString * final = [result componentsSeparatedByString:@" "][position];
    
    return final;
}

- (NSDate*)dateWithFormat:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:self];
}

- (NSString*)numbeRize
{
    return [NSNumberFormatter localizedStringFromNumber:@([self intValue]) numberStyle:NSNumberFormatterDecimalStyle];
}

- (NSString *)convertPercentage
{
    NSString *convert = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                              (CFStringRef)self,
                                                                                              NULL,
                                                                                              (CFStringRef)@"!*'();:@&+$,/?%#[]",
                                                                                              kCFStringEncodingUTF8 ));
    return convert;
}

- (BOOL)isEmail
{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc]
                                  initWithPattern:regExPattern
                                  options:NSRegularExpressionCaseInsensitive
                                  error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:self
                                                     options:0
                                                       range:NSMakeRange(0, [self length])];
    return (regExMatches == 0) ? NO : YES ;
}

@end

@implementation NSMutableDictionary (Additions)

- (void)removeObjectForKeyPath: (NSString *)keyPath
{
    NSArray * keyPathElements = [keyPath componentsSeparatedByString:@"."];
    NSUInteger numElements = [keyPathElements count];
    NSString * keyPathHead = [[keyPathElements subarrayWithRange:(NSRange){0, numElements - 1}] componentsJoinedByString:@"."];
    NSMutableDictionary * tailContainer = [self valueForKeyPath:keyPathHead];
    [tailContainer removeObjectForKey:[keyPathElements lastObject]];
}

@end

@implementation UITableView (extras)

@dynamic delegate;

- (void)cellVisible
{
    [self reloadData];

    for(UITableViewCell * cell in self.visibleCells)
    {
        for(UIView * view in cell.contentView.subviews)
        {
            view.hidden = NO;
        }
    }
    
    [self reloadData];
}

- (void)didScrolltoBottom:(BOOL)animate
{
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self numberOfRowsInSection:0] - 1) inSection:0];
    [self scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)didScrolltoTop:(BOOL)animate
{
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)didScrolltoNearTop:(BOOL)animate
{
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)reloadDataWithAnimation:(BOOL)animate
{
    if(animate)
    {
        [UIView transitionWithView: self
                          duration: 0.2f
                           options: UIViewAnimationOptionTransitionCrossDissolve
                        animations: ^(void)
         {
             [self reloadData];
         }
                        completion: ^(BOOL isFinished){}];
    }
    else
    {
        [self reloadData];
    }
}

- (void)withCell:(NSString*)nibAndIdent
{
    [self registerNib:[UINib nibWithNibName:nibAndIdent bundle:nil] forCellReuseIdentifier:nibAndIdent];
}

- (void)withHeaderOrFooter:(NSString*)nibAndIdent
{
    [self registerNib:[UINib nibWithNibName:nibAndIdent bundle:nil] forHeaderFooterViewReuseIdentifier:nibAndIdent];
}

- (void)addLongPressRecognizer {
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.2; //seconds
    lpgr.delegate = self;
    [self addGestureRecognizer:lpgr];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self];
    
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    }
    else {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            [(id<UITableViewDelegateLongPress>)self.delegate tableView:self didRecognizeLongPressOnRowAtIndexPath:indexPath];
        }
    }
}

@end

@implementation UICollectionView (collect)

- (void)cellVisible
{
    for(UICollectionViewCell * cell in self.visibleCells)
    {
        for(UIView * view in cell.subviews)
        {
            view.hidden = NO;
        }
        
        for(UIView * view in cell.contentView.subviews)
        {
            view.hidden = NO;
        }
    }
    
    [self reloadData];
}

- (void)withCell:(NSString*)nibAndIdent
{
    [self registerNib:[UINib nibWithNibName:nibAndIdent bundle:nil] forCellWithReuseIdentifier:nibAndIdent];
}

- (void)withHeaderOrFooter:(NSString*)nibAndIdent andKind:(NSString*)kind
{
    [self registerNib:[UINib nibWithNibName:nibAndIdent bundle:nil] forSupplementaryViewOfKind:kind withReuseIdentifier:nibAndIdent];
}

@end


@implementation NSDate (extension)

- (NSDate*)nowByTime:(NSInteger)days
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:[NSDate date] options:0];
}

- (NSDate *)addDays:(NSInteger)days toDate:(NSDate *)originalDate
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:originalDate options:0];
}

- (NSString *)stringWithFormat:(NSString *)format
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    return [df stringFromDate:self];
}

- (BOOL)isPastTime:(NSString*)theDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    NSDate *newDate = [df dateFromString:theDate];
    
    NSComparisonResult result;
    
    result = [self compare:newDate];
    
    if(result==NSOrderedAscending)
        return NO;
    else if(result==NSOrderedDescending)
        return YES;
    else
        return NO;
}

@end

@implementation CALayer(XibConfiguration)

-(void)setBorderUIColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

-(UIColor*)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end

static NSCharacterSet* VariationSelectors = nil;

@implementation NSString (RemoveEmoji)

- (NSString*)encodeUrl
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (void)load {
    VariationSelectors = [NSCharacterSet characterSetWithRange:NSMakeRange(0xFE00, 16)];
}

- (BOOL)isEmoji {
    if ([self rangeOfCharacterFromSet: VariationSelectors].location != NSNotFound) {
        return YES;
    }
    
    const unichar high = [self characterAtIndex: 0];
    
    // Surrogate pair (U+1D000-1F9FF)
    if (0xD800 <= high && high <= 0xDBFF) {
        const unichar low = [self characterAtIndex: 1];
        const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
        
        return (0x1D000 <= codepoint && codepoint <= 0x1F9FF);
        
        // Not surrogate pair (U+2100-27BF)
    } else {
        return (0x2100 <= high && high <= 0x27BF);
    }
}

- (BOOL)isIncludingEmoji {
    BOOL __block result = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              if ([substring isEmoji]) {
                                  *stop = YES;
                                  result = YES;
                              }
                          }];
    
    return result;
}

- (instancetype)stringByRemovingEmoji {
    NSMutableString* __block buffer = [NSMutableString stringWithCapacity:[self length]];
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              [buffer appendString:([substring isEmoji])? @"": substring];
                          }];
    
    return buffer;
}

- (instancetype)removedEmojiString {
    return [self stringByRemovingEmoji];
}

@end

@implementation UIViewController (keyboard)

- (void)registerForKeyboardNotifications:(BOOL)isRegister andSelector:(NSArray*)selectors
{
    if(isRegister)
    {
        [[NSNotificationCenter defaultCenter] addUniqueObserver:self selector:NSSelectorFromString(selectors[0]) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addUniqueObserver:self selector:NSSelectorFromString(selectors[1]) name:UIKeyboardWillHideNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (UIViewController*)storyboard:(NSString*)name andId:(NSString*)iD
{
    return [[UIStoryboard storyboardWithName:name bundle:nil] instantiateViewControllerWithIdentifier:iD];

}

@end


@implementation UIView (custom)

@dynamic onTouchEvent, object;

- (void)setObject:(id)object
{
    id obj = object;
    
    objc_setAssociatedObject(self, @selector(object), obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)object
{
    id obj = objc_getAssociatedObject(self, @selector(object));
    
    return obj;
}

- (void)setOnTouchEvent:(TouchAction)onTouchEvent_
{
    TouchAction onTouch = onTouchEvent_;
    
    objc_setAssociatedObject(self, @selector(onTouchEvent), onTouch, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TouchAction)onTouchEvent
{
    TouchAction onTouch = objc_getAssociatedObject(self, @selector(onTouchEvent));
    
    return onTouch;
}

- (void)actionForTouch:(id)object and:(TouchAction)touchEvent
{
    self.onTouchEvent = touchEvent;
    
    self.object = object;
    
    [self addTapTarget:self action:@selector(didPressButton:)];
}

- (void)didPressButton:(UIButton*)sender
{
    self.onTouchEvent(self.object);
}

@end

