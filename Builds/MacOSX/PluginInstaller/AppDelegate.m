//
//  AppDelegate.m
//  PluginInstaller
//
//  Created by Daniel Szabo on 28/09/14.
//
//

#import "AppDelegate.h"
#import "ImagingAppDetails.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (id)init
{
    self = [super init];
    if (self) {
        // init here
        mdQuery = [[NSMetadataQuery alloc] init];
        imagingApps = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    if (nil != mdQuery)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queryDidUpdate:)
                                                     name:NSMetadataQueryDidUpdateNotification
                                                   object:mdQuery];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(initalGatherComplete:)
                                                     name:NSMetadataQueryDidFinishGatheringNotification
                                                   object:mdQuery];
        
        NSPredicate *searchPredicate = [NSPredicate
                           predicateWithFormat:@"(kMDItemCFBundleIdentifier contains[cd] %@) AND (kMDItemKind == 'Application') AND (kMDItemExecutableArchitectures == 'x86_64')",
                           @"photoshop"];
        
        [mdQuery setPredicate:searchPredicate];
        //[metadataSearch setSearchScopes: @[@"/Applications"]];  // if you want to isolate to Applications
        NSSortDescriptor *sortKeys=[[NSSortDescriptor alloc] initWithKey:(id)kMDItemDisplayName
                                                               ascending:YES];
        [mdQuery setSortDescriptors:[NSArray arrayWithObject:sortKeys]];
        // Begin the asynchronous query
        [mdQuery startQuery];

    }
    
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

// Method invoked when notifications of content batches have been received
- (void)queryDidUpdate:sender;
{
    NSLog(@"A data batch has been received");
}

// Method invoked when the initial query gathering is completed
- (void)initalGatherComplete:sender;
{
    // Stop the query, the single pass is completed.
    [mdQuery stopQuery];
    
    // Process the content. In this case the application simply
    // iterates over the content, printing the display name key for
    // each image
    NSUInteger i=0;
    for (i=0; i < [mdQuery resultCount]; i++) {
        NSMetadataItem *theResult = [mdQuery resultAtIndex:i];
        NSString *bundleId = [theResult valueForAttribute:(NSString *)kMDItemCFBundleIdentifier];
        NSString *bundlePath = [theResult valueForAttribute:(NSString *)kMDItemPath];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        
        ImagingAppDetails *d = [[ImagingAppDetails alloc] initWithBundlePath:bundlePath bundleIdentifier:bundleId];
        [d setAppBundleInfoDictionary:[bundle infoDictionary]];
        
        [imagingApps addObject:d];
         NSLog(@"Bundle Id: %@; Bundle Path: %@", [d appBundleIdentifier], [d appBundlePath]);
    }
    
    // Remove the notifications to clean up after ourselves.
    // Also release the metadataQuery.
    // When the Query is removed the query results are also lost.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMetadataQueryDidUpdateNotification
                                                  object:mdQuery];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMetadataQueryDidFinishGatheringNotification
                                                  object:mdQuery];
    
    [labelFindApps setStringValue: [NSString stringWithFormat:@"Looking for Image manipulation applications: Found %ld Apps", [mdQuery resultCount]]];
    
    //ImagingAppDetails *d = [[ImagingAppDetails alloc] initWithBundlePath:@"" bundleIdentifier:@""];
    [tableView reloadData];
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [imagingApps count];
}

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    ImagingAppDetails *item = [imagingApps objectAtIndex:row];
    if ([[tableColumn identifier] isEqualToString:@"Id"]) {
        return [item appBundleIdentifier];
    }
    
    if ([[tableColumn identifier] isEqualToString:@"Path"]) {
        return [item appBundlePath];
    }

    return nil;
}


@end
