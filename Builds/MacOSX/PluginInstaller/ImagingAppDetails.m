//
//  ImagingAppDetails.m
//  JuceAppWithPluginInstaller
//
//  Created by Daniel Szabo on 28/09/14.
//
//

#import "ImagingAppDetails.h"

@implementation ImagingAppDetails

@synthesize appBundlePath;
@synthesize appBundleIdentifier;
@synthesize appBundleInfoDictionary;



- (id)initWithBundlePath:(NSString *)aPath bundleIdentifier:(NSString *)identifer
{
    self = [super init];
    if (self) {
        self.appBundleIdentifier = identifer;
        self.appBundlePath = aPath;
        self.appBundleInfoDictionary = [[NSDictionary alloc] init];
    }
    
    return self;
}

@end
