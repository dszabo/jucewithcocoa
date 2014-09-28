#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    __weak IBOutlet NSButton* closeButton;
    __weak IBOutlet NSButton* installButton;
    __weak IBOutlet NSTextField *labelFindApps;
    __weak IBOutlet NSTableView *tableView;
    
    NSMetadataQuery *mdQuery;
    NSMutableArray *imagingApps;
    NSString *pluginFileToCopy;
}

- (IBAction)closeClicked:(id)sender;
- (IBAction)installClicked:(id)sender;

@end

