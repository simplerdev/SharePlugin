#import "SharePluginViewController.h"
#import <MobileCoreServices/MobileCoreServices.h> // For UTI

@implementation SharePluginViewController

@synthesize documentInteractionController, myViewController;

#pragma mark -
#pragma mark Utility methods

- (NSString *)UTIForURL:(NSURL *)url
{
  CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)url.pathExtension, NULL);
  return (NSString *)CFBridgingRelease(UTI) ;
}

- (BOOL) validateFileUrl: (NSString *)candidate
{
  NSString* lowerCased = [candidate lowercaseString];
  return [lowerCased hasPrefix:@"file://"];
}

#pragma mark -
#pragma mark View / Share methods

- (BOOL)viewFile:(NSString *)filePath usingViewController:(UIViewController *) viewController
{
  self.myViewController = viewController;
  NSURL* URL = [NSURL URLWithString:filePath];
  
  if (![self validateFileUrl:filePath]) {
    URL = [[NSURL alloc] initFileURLWithPath:filePath];
  }

  BOOL filePreviewSuccess = NO; // Success is true if it was possible to open the controller and there are apps available
  
  if (URL) {
    // Initialize Document Interaction Controller
    self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
    self.documentInteractionController.UTI = [self UTIForURL:URL];
    self.documentInteractionController.delegate = self;
    
    UIView *filePreviewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [[self.myViewController view] addSubview:filePreviewView];
    self.view = filePreviewView;
    
    // Configure Document Interaction Controller
    [self.documentInteractionController setDelegate:self];
    
    // Preview
    filePreviewSuccess = [self.documentInteractionController presentPreviewAnimated:YES];
    
    if(!filePreviewSuccess) {
      // Next, try the options menu in openFile below...
      return [self openFile:URL usingViewController:viewController];
    }
  } else {
    return NO;
  }
  
  return YES;
}

- (BOOL) openFile:(NSURL *)URL usingViewController:(UIViewController *) viewController
{
    self.myViewController = viewController;
    
    BOOL fileOpenSuccess = NO; // Success is true if it was possible to open
    
    if (URL) {
      // Initialize Document Interaction Controller
      self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
      self.documentInteractionController.UTI = [self UTIForURL:URL];
      self.documentInteractionController.delegate = self;
      
      // Configure Document Interaction Controller
      [self.documentInteractionController setDelegate:self];
      
      // Open
      CGRect screenRect = [[viewController view] bounds];
      CGFloat screenWidth = screenRect.size.width;
      CGFloat screenHeight = screenRect.size.height;
      fileOpenSuccess = [self.documentInteractionController
                         presentOptionsMenuFromRect:CGRectMake((screenWidth / 2), screenHeight, 1, 1)
                         inView:[self.myViewController view] animated:YES];
      
      if(!fileOpenSuccess) {
        // There is no app to handle this file
        NSString *deviceType = [UIDevice currentDevice].localizedModel;
        NSString *message = [NSString stringWithFormat:NSLocalizedString(
                             @"Your %@ doesn't seem to have any other Apps installed that can open this document.",
                             @"Your %@ doesn't seem to have any other Apps installed that can open this document."),
                             deviceType];
        
        // Display alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(
                               @"No suitable Apps installed", @"No suitable App installed")
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
      }
    } else {
      return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark Document Interaction Controller Delegate Methods
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
  return self.myViewController;
}

@end
