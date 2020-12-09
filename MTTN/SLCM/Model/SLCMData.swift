//
//  SLCMData.swift
//  MTTN
//
//  Created by Naman Jain on 05/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

var array = ["juggling quark matter...", "opening control valves to antimatter nacelles...", "fastening seatbelts in roadster...", "moving satellites into position...", "resolving transporter buffer...", "launching escape pods..", "distorting space-time continuum...", "rebooting the quantum computer...", "decoding the enigma...", "orbiting Pluto...", "rearranging the periodic table..", "counting moons around Jupiter..", "drinking wine with Tyrion"]

var savedAttendanceFilePath: String {
    let manager = FileManager.default
    let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
    return url!.appendingPathComponent("AttendanceNew").path
}

struct SLCMResponse: Decodable{
    let login: String?
    let Attendance: [String: Attendance]?
    let Credits: [String : Credits]?
    let Marks: [String: [String: MarksContainer]]?
    let user: String?
}

class Attendance: NSObject, Decodable, NSCoding{
    
    struct keys {
        static let Attended = "Attended"
        static let Missed = "Missed"
        static let Name = "Name"
        static let Percentage = "Percentage"
        static let Total = "Total"
        static let Code = "Code"
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(Attended, forKey: keys.Attended)
        aCoder.encode(Missed, forKey: keys.Missed)
        aCoder.encode(Name, forKey: keys.Name)
        aCoder.encode(Percentage, forKey: keys.Percentage)
        aCoder.encode(Total, forKey: keys.Total)
        aCoder.encode(Code, forKey: keys.Code)
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let att = aDecoder.decodeObject(forKey: keys.Attended) as? String{
            Attended = att
        }
        if let name = aDecoder.decodeObject(forKey: keys.Name) as? String{
            Name = name
        }
        if let percentage = aDecoder.decodeObject(forKey: keys.Percentage) as? String{
            Percentage = percentage
        }
        if let missed = aDecoder.decodeObject(forKey: keys.Missed) as? String{
            Missed = missed
        }
        if let total = aDecoder.decodeObject(forKey: keys.Total) as? String{
            Total = total
        }
        if let code = aDecoder.decodeObject(forKey: keys.Code) as? String{
            Code = code
        }
    }
    
    var Attended: String?
    var Missed: String?
    var Name: String?
    var Percentage: String?
    var Total: String?
    var Code: String?
    
    override init() {
    }
}

struct MarksContainer: Codable{
    let Obtained : String?
    let Total : String?
}

class Credits : NSObject, Decodable, NSCoding{
    
    struct keys {
        static let Credits = "Credits"
        static let Obtained = "Obtained"
        static let Total = "Total"
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(Credits , forKey: keys.Credits)
        aCoder.encode(Obtained, forKey: keys.Obtained)
        aCoder.encode(Total, forKey: keys.Total)
    }
       
   required init?(coder aDecoder: NSCoder) {
       if let cred = aDecoder.decodeObject(forKey: keys.Credits) as? String{
           Credits = cred
       }
       if let obt = aDecoder.decodeObject(forKey: keys.Obtained) as? String{
           Obtained = obt
       }
       if let tot = aDecoder.decodeObject(forKey: keys.Total) as? String{
           Total = tot
       }
   }
    
    var Credits: String?
    var Obtained  : String?
    var Total : String?
}

struct slcmCaptcha:Codable{
    var id :String?
    var login:String?
    var predicted_captcha:String?
    var url: String?
}
