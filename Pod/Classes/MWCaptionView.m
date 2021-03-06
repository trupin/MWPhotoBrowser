//
//  MWCaptionView.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 30/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MWCommon.h"
#import "MWCaptionView.h"
#import "MWPhoto.h"

static const CGFloat labelPadding = 10;


@implementation MWCaptionView

- (id)initWithPhoto:(id<MWPhoto>)photo {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)]; // Random initial frame
    if (self) {
        self.userInteractionEnabled = YES;
        _photo = photo;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
            [self setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
			[self setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
        }
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat maxHeight = 9999;
    if (_label.numberOfLines > 0) maxHeight = _label.font.leading*_label.numberOfLines;
    CGSize textSize;
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        textSize = [_label.text boundingRectWithSize:CGSizeMake(size.width - labelPadding*2, maxHeight)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:_label.font}
                                             context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [_label.text sizeWithFont:_label.font
                           constrainedToSize:CGSizeMake(size.width - labelPadding*2, maxHeight)
                               lineBreakMode:_label.lineBreakMode];
#pragma clang diagnostic pop
    }
    return CGSizeMake(size.width, textSize.height + labelPadding * 2);
}

- (void)setupCaption {
    _label = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(labelPadding, 0,
                                                       self.bounds.size.width-labelPadding*2,
                                                       self.bounds.size.height))];
    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _label.opaque = YES;
    _label.backgroundColor = [UIColor clearColor];
    if (SYSTEM_VERSION_LESS_THAN(@"6")) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        _label.textAlignment = UITextAlignmentCenter;
        _label.lineBreakMode = UILineBreakModeWordWrap;
#pragma clang diagnostic pop
    } else {
        _label.textAlignment = NSTextAlignmentCenter;
        _label.lineBreakMode = NSLineBreakByWordWrapping;
    }

    _label.numberOfLines = 0;
    _label.textColor = [UIColor whiteColor];
    if (SYSTEM_VERSION_LESS_THAN(@"7")) {
        // Shadow on 6 and below
        _label.shadowColor = [UIColor blackColor];
        _label.shadowOffset = CGSizeMake(1, 1);
    }

    _label.font = [UIFont fontWithName:@"Omnes-Medium" size:17.0];
    if ([_photo respondsToSelector:@selector(caption)]) {
        _label.text = [_photo caption] ? [_photo caption] : @" ";
    }
    [self addSubview:_label];
}


@end
