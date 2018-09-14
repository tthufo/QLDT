//
//  Media.m
//  AFNetworking
//
//  Created by Mac on 9/14/18.
//

#import "Media.h"

#import "NSObject+Category.h"

static Media * __shareInstance = nil;

@interface Media()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIPopoverController * popover;
}
@end

@implementation Media

@synthesize completionBlock;

+ (Media*)shareInstance
{
    if(!__shareInstance)
    {
        __shareInstance = [Media new];
    }
    
    return __shareInstance;
}

- (void)startPickImageWithOption:(BOOL)isCamera andBase:(UIView*)baseView andRoot:(UIViewController*)base andCompletion:(MediaCompletion)completion
{
    completionBlock = completion;
    
    UIImagePickerController * ipc = [[UIImagePickerController alloc] init];
    
    ipc.delegate = self;
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && isCamera)
    {
        [self alert:@"Error" message:@"Camera not present"];
        
        return;
    }
    
    ipc.sourceType = !isCamera ? UIImagePickerControllerSourceTypeSavedPhotosAlbum : UIImagePickerControllerSourceTypeCamera;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [base presentViewController:ipc animated:YES completion:nil];
    }
    else
    {
        CGRect rect ;
        
        if(!baseView)
        {
            rect = CGRectMake(base.view.frame.size.width/2, base.view.frame.size.height/2, 0, 0);
        }
        else
        {
            rect = baseView.frame;
        }
        
        if(!popover)
            popover = [[UIPopoverController alloc] initWithContentViewController:ipc];
        
        [popover presentPopoverFromRect:rect inView:base.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [popover dismissPopoverAnimated:YES];
    }
    
    completionBlock([info objectForKey:UIImagePickerControllerOriginalImage]);
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    completionBlock(nil);
}

@end
