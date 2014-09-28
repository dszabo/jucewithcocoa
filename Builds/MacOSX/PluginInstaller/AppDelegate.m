//
//  AppDelegate.m
//  PluginInstaller
//
//  Created by Daniel Szabo on 28/09/14.
//
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)closeClicked:(id)sender
{
    [[NSApplication sharedApplication] terminate:nil];
    
    /*
     NSArray *arguments = [[NSProcessInfo processInfo] arguments];
     NSMutableString *mutableStr = [NSMutableString stringWithCapacity:0];
     for (int i=0; i< [arguments count]; i++)
     {
     NSString *str = [NSString stringWithFormat:@"%@\n", [arguments objectAtIndex:i]];
     [mutableStr appendString:str];
     }
     [label setStringValue: mutableStr];
     */
}


@end
