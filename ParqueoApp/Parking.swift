//
//  Parking.swift
//  ParqueoApp
//
//  Created by internet on 5/13/15.
//  Copyright (c) 2015 internet. All rights reserved.
//
import UIKit
import CoreData
//@objc (Model)
@objc (Parking)
class Parking: NSManagedObject {

@NSManaged var address:String
@NSManaged var schedule:String
@NSManaged var rate:String
@NSManaged var id:String
@NSManaged var longitude:String
@NSManaged var latitude:String
    
}