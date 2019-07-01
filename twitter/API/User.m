//
//  User.m
//  twitter
//
//  Created by jordan487 on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    // initialiazes an object with the parent class's initializer. The returned value is assigned to self.
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        // Initialize any other properties
    }
    return self;
}

@end
