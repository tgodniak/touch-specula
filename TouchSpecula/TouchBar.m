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

@implementation NSTouchBarItem (DFRAccess)

- (void)addToControlStrip {
    [NSTouchBarItem addSystemTrayItem:self];
}

@end

@implementation NSTouchBar (DFRAccess)

- (void)presentAsSystemModalForItem:(NSTouchBarItem *)item {
    [NSTouchBar presentSystemModalFunctionBar:self systemTrayItemIdentifier:item.identifier];
}

@end


