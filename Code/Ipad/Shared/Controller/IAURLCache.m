//
//  IAURLCache.m
//  Trulia
//
//  Created by John Zorko on 11/7/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import "IAURLCache.h"
#import "ICAdSearchController.h"

@implementation IAURLCache

- (NSString *)mimeTypeForPath:(NSString *)originalPath {
	//
	// Current code only substitutes PNG images
	//
	return @"image/png";
}

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
	NSString *pathString = [[request URL] absoluteString];

	NSString *cachedURL = [[ICAdSearchController sharedInstance] getCachedURLForPrefetchedImageURL:pathString];
    
    if (!cachedURL) {
		return [super cachedResponseForRequest:request];
	} else {
        NSLog(@"* * getting %@ from cache", pathString);
        NSCachedURLResponse *cachedResponse = [cachedResponses objectForKey:pathString];
	
        if (cachedResponse) {
            return cachedResponse;
        }
	
        NSData *data = [NSData dataWithContentsOfFile:cachedURL];
        NSLog(@"* * cached data size: %lu", (unsigned long)[data length]);
        
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[request URL] MIMEType:[self mimeTypeForPath:pathString] expectedContentLength:[data length] textEncodingName:nil];
        cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
        
        if (!cachedResponses) {
            cachedResponses = [[NSMutableDictionary alloc] init];
        }
        
        [cachedResponses setObject:cachedResponse forKey:pathString];
        
        return cachedResponse;
    }
}

- (void)removeCachedResponseForRequest:(NSURLRequest *)request {
	NSString *pathString = [[request URL] path];
	
    if ([cachedResponses objectForKey:pathString]) {
		[cachedResponses removeObjectForKey:pathString];
	} else {
		[super removeCachedResponseForRequest:request];
	}
}

- (void)flush {
    cachedResponses = nil;
}

- (void)dealloc {
    [self flush];
}

@end
