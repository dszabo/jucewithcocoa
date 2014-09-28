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
    
    [installButton setEnabled:NO];
    
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
        
        NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
        pluginFileToCopy = [args stringForKey:@"pluginFileToCopy"];
        
        if (!pluginFileToCopy) {
            // if we started in standalone mode, we set up our own mock file for copying
            NSBundle *mainBundle = [NSBundle mainBundle];
            pluginFileToCopy = [[mainBundle bundlePath] stringByAppendingPathComponent:@"Contents/Resources/pluginMock.txt"];
        }
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)closeClicked:(id)sender
{
    [[NSApplication sharedApplication] terminate:nil];
}

- (IBAction)installClicked:(id)sender
{

    if ([tableView selectedRow] == -1) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Message text."];
        [alert setInformativeText:@"Informative text."];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
    }
    
    ImagingAppDetails *selectedApp = [imagingApps objectAtIndex:[tableView selectedRow]];
    
    // wow, for photoshop the Plug-ins folder is at psd.app/../Plug-ins so...
    NSString *pluginPath = [[[selectedApp appBundlePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Plug-ins"];
    
    // copy pluginFileToCopy to pluginPath
    [self copyFolderAtPath:pluginFileToCopy toDestinationFolderAtPath:pluginPath];
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Plugin installer"];
    [alert setInformativeText:@"Plugin installed successfully."];
    [alert setAlertStyle:NSInformationalAlertStyle];
    [alert runModal];
    
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
    
    [tableView reloadData];
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [imagingApps count];
}

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    ImagingAppDetails *item = [imagingApps objectAtIndex:row];

    if ([[tableColumn identifier] isEqualToString:@"Path"]) {
        return [item appBundlePath];
    }

    if ([[tableColumn identifier] isEqualToString:@"Id"]) {
        return [item appBundleIdentifier];
    }

    if ([[tableColumn identifier] isEqualToString:@"Version"]) {
        return [[item appBundleInfoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    
    return nil;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    if ([tableView selectedRow] == -1) {
        [installButton setEnabled:NO];
    } else {
        [installButton setEnabled:YES];
    }
}

- (BOOL)copyFolderAtPath:(NSString *)sourceFile toDestinationFolderAtPath:(NSString*)destinationFolder {
    NSFileManager * fileManager = [ NSFileManager defaultManager];
    NSError * error = nil;

    NSString* sourceFileName = [sourceFile lastPathComponent];
    NSString *dstFile = [destinationFolder stringByAppendingPathComponent:sourceFileName];
    
    if ( !( [ fileManager copyItemAtPath:sourceFile toPath:dstFile error:&error ]) )
    {
        NSLog(@"Could not copy report at path %@ to path %@. error %@",sourceFile, destinationFolder, error);
        return NO;
    }
    return YES;
}


@end
