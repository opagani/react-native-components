//
//  MapViewGestureRecognizer.h
//  TruliaMap
//
//  Created by Daniel Lowrie on 2/23/11.
//  Copyright 2011 Trulia Inc. All rights reserved.
//
//	The purpose of this class is to know when a user interacts with the mapView
//  without preventing mapView interactions

#import <Foundation/Foundation.h>

typedef void (^TouchesEventBlock)(NSSet * touches, UIEvent * event);

@interface MapViewGestureRecognizer : UIGestureRecognizer {
	TouchesEventBlock touchesBeganCallback;
}
@property(copy) TouchesEventBlock touchesBeganCallback;


@end