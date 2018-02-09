//
//  TouchBar.h
//  TouchSpecula
//
//  Created by GoToo on 08/02/2018.
//  Copyright © 2018 GoToo. All rights reserved.
//

@import Cocoa;
@import Foundation;

extern void DFRElementSetControlStripPresenceForIdentifier(NSString *, BOOL);
extern void DFRSystemModalShowsCloseBoxWhenFrontMost(BOOL);

@interface NSTouchBarItem ()

+ (void)addSystemTrayItem:(NSTouchBarItem *)item;

@end

@interface NSTouchBarItem (DFRAccess)

- (void)addToControlStrip;

@end

@interface NSTouchBar ()

+ (void)presentSystemModalFunctionBar:(NSTouchBar *)touchBar
             systemTrayItemIdentifier:(NSString *)identifier;

@end

@interface NSTouchBar (DFRAccess)

- (void)presentAsSystemModalForItem:(NSTouchBarItem *)item;

@end

