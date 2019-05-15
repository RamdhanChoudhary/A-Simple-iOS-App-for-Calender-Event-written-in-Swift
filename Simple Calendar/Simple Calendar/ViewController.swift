//
//  ViewController.swift
//  Simple Calendar
//
//  Created by RAMDHAN CHOUDHARY on 15/05/19.
//  Copyright © 2019 RDC. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //TODO: Make sure you goto Mobile calendar app and create new calender named "RDC Calendar"
        
        chekcCalenderAuthorization()
    }
    
    //MARK: To check Calendar permission
    func chekcCalenderAuthorization()
    {
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            insertEvent(store: eventStore)
        case .denied:
            print("Access denied")
        case .notDetermined:
            eventStore.requestAccess(to: .event, completion:
                {[weak self] (granted: Bool, error: Error?) -> Void in
                    if granted {
                        print("Permission Granted!! Add Event")
                        self!.insertEvent(store: eventStore)
                    } else {
                        print("Access denied")
                    }
            })
        default:
            print("Case default")
        }
    }
    
    //MARK: Prepare and Insert Event into Calendar
    func insertEvent(store: EKEventStore)
    {
        let calendars = store.calendars(for: .event)
        
        //Check list of Calendars and find out our custom calender named "RDC Calendar"
        for calendar in calendars
        {
            print(calendar.title)
            
            if calendar.title == "RDC Calendar"
            {
                //Prepare New Event
                let startDate = Date()
                let endDate = startDate.addingTimeInterval(2 * 60 * 60)
                let event = EKEvent(eventStore: store)
                event.calendar = calendar
                event.title = "New Meeting"
                event.startDate = startDate
                event.endDate = endDate
                do
                {
                    //Insert Event into Calendar in today current time
                    try store.save(event, span: .thisEvent)
                    print("Event created!! Please Check today's Events in Calender"  )
                }
                catch
                {
                    print("Error saving event in calendar")             }
            }
        }
    }
}

