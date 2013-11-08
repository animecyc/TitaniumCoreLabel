/**
 * A Titanium label replacement made to be used with the TitaniumAnimator module
 *
 * Copyright (C) 2013 Seth Benjamin
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#import <objc/runtime.h>
#import "CoreLabel.h"
#import "TopTiModule.h"

@implementation CoreLabel

- (UILabel*)label
{
    Ivar labelIV = class_getInstanceVariable([super class], "label");
    UILabel* label_ = object_getIvar(self, labelIV);

	if (label_ == nil)
	{
        TopTiModule *module = [[[TopTiModule alloc] init] autorelease];
        NSString* versionCode = (NSString*)[module performSelector:@selector(version)];

        label_ = [[AUIAnimatableLabel alloc] initWithFrame:CGRectZero];

        [label_ setBackgroundColor:[UIColor clearColor]];

        if ([versionCode isEqualToString:@"3.1.3"])
        {
            [self addSubview:label_];
        }
        else
        {
            Ivar wrapperViewIV = class_getInstanceVariable([super class], "wrapperView");
            UIView* wrapperView_ = [[UIView alloc] initWithFrame:[self bounds]];

            [wrapperView_ addSubview:label_];
            [wrapperView_ setClipsToBounds:YES];
            [wrapperView_ setUserInteractionEnabled:NO];

            [self addSubview:wrapperView_];

            object_setIvar(self, wrapperViewIV, wrapperView_);
        }

        object_setIvar(self, labelIV, label_);
    }

	return label_;
}

@end