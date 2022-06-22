//
//  Car.m
//  DataModelsDemo
//
//  Created by Jonathan Torrens on 6/21/22.
//

#import "Car.h"

@implementation Car

-(id)initWithModel: (NSString *)model {
    self = [super init];
    self.model = model;
    
    return self;
}

- (NSString *)model {
    NSLog(@"My custom getter method is called");
    return _model;
}

-(void)setModel:(NSString *)model {
    NSLog(@"My custom setter method is called");
    _model = model;
}


@end
