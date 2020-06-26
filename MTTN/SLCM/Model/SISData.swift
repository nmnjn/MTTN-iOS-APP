//
//  SISData.swift
//  MTTN
//
//  Created by Naman Jain on 21/12/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

struct SISResponse: Codable{
    let login: String?
    let Attendance: [String: [String: [String: String]]]?
//    let Marks: [String: [String: MarksContainer]]?
    let Name: String?
}

struct attSt{
    let subject: [String: [String: String]]?
}

struct SISattendance: Codable{
    
    var subjectName: String?
    var theoryPerc: String?
    var theoryAttd: String?
    var theoryHeld: String?
    var clinicsPerc: String?
    var clinicsAttd: String?
    var clinicsHeld: String?
    var practicalPerc: String?
    var practicalAttd: String?
    var practicalHeld: String?
    var sgtPerc: String?
    var sgtAttd: String?
    var sgtHeld: String?
    
}

