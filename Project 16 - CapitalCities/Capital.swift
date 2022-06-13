//
//  Capital.swift
//  Project 16 - CapitalCities
//
//  Created by Vitali Vyucheiski on 4/29/22.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var web: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, web: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.web = web
    }
}
