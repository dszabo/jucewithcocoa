//
//  AppDelegate.h
//  PluginInstaller
//
//  Created by Daniel Szabo on 28/09/14.
//
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSButton* closeButton;
    IBOutlet NSTextField *labelFindApps;
    
    __weak IBOutlet NSTableView *tableView;
    NSMetadataQuery *mdQuery;
    NSMutableArray *imagingApps;
}

- (IBAction)closeClicked:(id)sender;

@end

