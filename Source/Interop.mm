//
//  Interop.mm
//  MainJuceApp
//
//  Created by Daniel Szabo on 27/09/14.
//
//

#include "Interop.h"
#import <Cocoa/Cocoa.h>

class NSInterop::Private {
    
};

NSInterop::NSInterop()
{
    pimpl = new Private();
}

NSInterop::~NSInterop()
{
    delete pimpl;
}

void NSInterop::launchHelper()
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [[mainBundle bundleURL] URLByAppendingPathComponent:@"Contents/Resources/PluginInstaller.app"];
    
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    
    NSArray *arguments = [NSArray arrayWithObjects:@"Argument1", @"Argument2", nil];
    [workspace launchApplicationAtURL:url options:0 configuration:[NSDictionary dictionaryWithObject:arguments forKey:NSWorkspaceLaunchConfigurationArguments] error:nil];
    
    NSArray* apps = [NSRunningApplication
                     runningApplicationsWithBundleIdentifier:@"com.xycod.PluginInstaller"];
    [(NSRunningApplication*)[apps objectAtIndex:0]
     activateWithOptions: NSApplicationActivateAllWindows];}

void NSInterop::quitHelper()
{
    NSArray *runninHelperApps = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.xycod.PluginInstaller"];
    if ([runninHelperApps count] > 0)
    {
        for (int i = 0; i < [runninHelperApps count]; i++)
        {
            [[runninHelperApps objectAtIndex:i] forceTerminate];
        }
    }
}



