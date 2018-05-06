//
//  FooterReuseableView.m
//  FlickerDemo
//
//  Created by Prashant Rastogi on 06/05/18.
//  Copyright © 2018 Prashant Rastogi. All rights reserved.
//

#import "FooterReuseableView.h"

@implementation FooterReuseableView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if( self )
    {
        self.loader = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.loader];
    }
    return self;
}

-(void)layoutSubviews{
    self.loader.center = self.center;
}

@end
