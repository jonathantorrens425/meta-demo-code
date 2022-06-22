//
//  Movie.h
//  Flixter
//
//  Created by Jonathan Torrens on 6/21/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *posterPath;
@property (strong, nonatomic) NSString *overview;

- (id)initWithDictionary: (NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
