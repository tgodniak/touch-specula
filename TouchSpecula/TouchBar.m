//
//  TouchBar.m
//  TouchSpecula
//
//  Created by GoToo on 09/02/2018.
//  Copyright © 2018 GoToo. All rights reserved.
//

@import Foundation;

#include "TouchBar.h"

extern void DFRSystemModalShowsCloseBoxWhenFrontMost(BOOL);
extern void DFRElementSetControlStripPresenceForIdentifier(NSString *string, BOOL enabled);

@interface NSTouchBarItem ()
+ (void)addSystemTrayItem:(NSTouchBarItem *)item;
@end

@interface NSTouchBar ()
+ (void)presentSystemModalFunctionBar:(NSTouchBar *)touchBar systemTrayItemIdentifier:(NSString *)identifier;
@end

void controlStrippify(NSView *view, NSString *identifier) {
    DFRSystemModalShowsCloseBoxWhenFrontMost(YES);
    
    NSCustomTouchBarItem *touchBarItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
    touchBarItem.view = view;
    [NSTouchBarItem addSystemTrayItem:touchBarItem];
    
    DFRElementSetControlStripPresenceForIdentifier(identifier, YES);
}
