//
//  ImagingAppDetails.h
//  JuceAppWithPluginInstaller
//
//  Created by Daniel Szabo on 28/09/14.
//
//

#import <Foundation/Foundation.h>

@interface ImagingAppDetails : NSObject
{
    NSString *appBundlePath;
    NSString *appBundleIdentifier;
    NSDictionary *appBundleInfoDictionary;
}

- (id)initWithBundlePath:(NSString *)aPath bundleIdentifier:(NSString *)identifer;

@property (readwrite, copy) NSString *appBundlePath;
@property (readwrite, copy) NSString *appBundleIdentifier;
@property (readwrite) NSDictionary *appBundleInfoDictionary;

@end
