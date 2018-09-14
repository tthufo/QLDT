//
//  Media.h
//  AFNetworking
//
//  Created by Mac on 9/14/18.
//

#import <Foundation/Foundation.h>

typedef void (^MediaCompletion)(id object);

@interface Media : NSObject

@property(nonatomic, copy) MediaCompletion completionBlock;

+ (Media*)shareInstance;

- (void)startPickImageWithOption:(BOOL)isCamera andBase:(UIView*)baseView andRoot:(UIViewController*)base andCompletion:(MediaCompletion)completion;

@end
