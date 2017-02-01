//
//  NotificationService.swift
//  TRLNotificationServiceExtension
//
//  Created by Pavlo Popovychenko on 1/25/17.
//  Copyright © 2017 Trulia Inc. All rights reserved.
//

import UserNotifications
import TRLAdvancedNotifications

class NotificationService: UNNotificationServiceExtension {
    
    var service : MyNotificationService?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        service = MyNotificationService()
        service?.didReceive(request, withContentHandler: contentHandler)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        service?.serviceExtensionTimeWillExpire()
    }
    
}
