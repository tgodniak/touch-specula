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

@implementation NSTouchBarItem (DFRAccess)

- (void)addToControlStrip {
    [NSTouchBarItem addSystemTrayItem:self];
    
    [self toggleControlStripPresence:true];
}

- (void)toggleControlStripPresence:(BOOL)present {
    DFRElementSetControlStripPresenceForIdentifier(self.identifier,
                                                   present);
}

@end

@implementation NSTouchBar (DFRAccess)

- (void)presentAsSystemModalForItem:(NSTouchBarItem *)item {
    [NSTouchBar presentSystemModalFunctionBar:self
                     systemTrayItemIdentifier:item.identifier];
}

- (void)dismissSystemModal {
    [NSTouchBar dismissSystemModalFunctionBar:self];
}

- (void)minimizeSystemModal {
    [NSTouchBar minimizeSystemModalFunctionBar:self];
}

@end

@implementation NSControlStripTouchBarItem

- (void)setIsPresentInControlStrip:(BOOL)present {
    _isPresentInControlStrip = present;
    
    if (present) {
        [super addToControlStrip];
    } else {
        [super toggleControlStripPresence:false];
    }
}

@end
