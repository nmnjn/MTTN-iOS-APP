//
//  Networking.swift
//  MTTN
//
//  Created by Naman Jain on 11/06/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import Foundation
import Disk

enum SLCMError{
    
    case userNotLoggedIn
    case cannotFindSLCMUrl
    case connectionToSLCMFailed
    case incorrectUserPassword
    case noAttendanceData
    case userLoggedOutDuringFetch
    case internalServerError
    case serverOffline
}

struct Networking {
    static let sharedInstance = Networking()
    
    // https://api.myjson.com/bins/1d5sm0
    
    
    func fetchSLCMData(Parameters: [String: String], dataCompletion: @escaping (_ Data: [Attendance], _ Marks: [String: [String: MarksContainer]]? , _ Credits: [Credits] ) -> (),  errorCompletion: @escaping (_ ErrorMessage: SLCMError) -> ()){
        
        guard let urlString = UserDefaults.standard.string(forKey: "SLCM") else{
            errorCompletion(SLCMError.cannotFindSLCMUrl)
            return
        }
        
        var attendance = [Attendance]()
        var credits = [Credits]()
        
        let url = NSURL(string: "\(urlString)_again")
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url! as URL)
        
        request.httpMethod = "POST"
        
        print("----------- FETCHING SLCM DATA ------------")
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: Parameters, options: .prettyPrinted)
        }catch let error {
            print("error in forming http body: \(error.localizedDescription)")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if let error = error{
                print("here" , error)
                errorCompletion(SLCMError.connectionToSLCMFailed)
                return
            }
            if let data = data{
                do{
                    let result = try JSONDecoder().decode(SLCMResponse.self, from: data)
                    if let status = result.login {
                        if status == "unsuccessful"{
                            errorCompletion(SLCMError.incorrectUserPassword)
                            return
                        }
                    }
                    if let user = result.user {
                        UserDefaults.standard.set(user, forKey: "SLCMUser")
                        UserDefaults.standard.synchronize()
                    }
                    
                    if let data = result.Credits {
                        for item in data {
                            credits.append(item.value)
                        }
                    }
                    
                    if let data = result.Attendance {
                        for item in data{
                            attendance.append(item.value)
                        }
                        if attendance.count == 0 {
                            errorCompletion(SLCMError.noAttendanceData)
                        }else{
                            attendance = attendance.sorted(by: { (at1, at2) -> Bool in
                                guard let p1 = at1.Percentage, let p2 = at2.Percentage else { return false }
                                var floatP1 = Float(p1)
                                var floatP2 = Float(p2)
                                
                                if at1.Total == "0"{
                                    floatP1 = 101.0
                                }
                                if at2.Total == "0"{
                                    floatP2 = 101.0
                                }
                                return floatP1! < floatP2!

                            })
                            dataCompletion(attendance, result.Marks ?? nil , credits)
                            
                            self.saveSLCMData(Attendance: attendance)
                            if let marks = result.Marks{
                                self.saveSLCMMarks(Marks: marks)
                            }
                            
                        }
                    }else{
                        errorCompletion(SLCMError.internalServerError)
                        return
                    }
                }catch {
                        print(error)
                        errorCompletion(SLCMError.serverOffline)
                        return
                }
            }
        })
        
        task.resume()
    }
    
    
    func fetchSISData(Parameters: [String: String], dataCompletion: @escaping (_ Data: [String: [SISattendance]]) -> (),  errorCompletion: @escaping (_ ErrorMessage: SLCMError) -> ()){
        guard let urlString = UserDefaults.standard.string(forKey: "SIS") else{
            errorCompletion(SLCMError.cannotFindSLCMUrl)
            return
        }
        
//        let urlString = "http://backend.manipalthetalk.org:8000/attendance"//"http://137.116.139.139:8100/attendance"

        var attendance = [String: [SISattendance]]()
        
        let url = NSURL(string: urlString) //"http://68.183.81.48:6969/attendance") //
        
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url! as URL)
        
        request.httpMethod = "POST"
        
        print("----------- FETCHING SIS DATA ------------")
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: Parameters, options: .prettyPrinted)
        }catch let error {
            print("error in forming http body: \(error.localizedDescription)")
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if let error = error{
                print(error)
                errorCompletion(SLCMError.connectionToSLCMFailed)
                return
            }
            if let data = data{
//                print(String(data: data, encoding: .utf8))
                do{
                    let result = try JSONDecoder().decode(SISResponse.self, from: data)
                    if let status = result.login {
                        if status == "unsuccessful"{
                            errorCompletion(SLCMError.incorrectUserPassword)
                            return
                        }
                    }
                    if let user = result.Name {
                        UserDefaults.standard.set(user, forKey: "SISUser")
                        UserDefaults.standard.synchronize()
                    }

                    if let data = result.Attendance {
                        for semester in data{
                            var semesterAttendance = [SISattendance]()
                            for item in semester.value{
                                let value = item.value
                                var theoryPercKey = ""
                                var theoryAttdKey = ""
                                var theoryHeldKey = ""
                                var clinicPercKey = ""
                                var clinicAttdKey = ""
                                var clinicHeldKey = ""
                                var sgtPercKey = ""
                                var sgtAttdKey = ""
                                var sgtHeldKey = ""
                                var pracPercKey = ""
                                var pracAttdKey = ""
                                var pracHeldKey = ""
                                for key in value.keys{
                                    if key.lowercased().contains("theo") && key.lowercased().contains("%"){
                                        theoryPercKey = key
                                    }
                                    if key.lowercased().contains("theo") && key.lowercased().contains("att"){
                                        theoryAttdKey = key
                                    }
                                    if key.lowercased().contains("theo") && key.lowercased().contains("held"){
                                        theoryHeldKey = key
                                    }
                                    if key.lowercased().contains("clin") && key.lowercased().contains("%"){
                                        clinicPercKey = key
                                    }
                                    if key.lowercased().contains("clin") && key.lowercased().contains("att"){
                                        clinicAttdKey = key
                                    }
                                    if key.lowercased().contains("clin") && key.lowercased().contains("held"){
                                        clinicHeldKey = key
                                    }
                                    if key.lowercased().contains("prac") && key.lowercased().contains("%"){
                                        pracPercKey = key
                                    }
                                    if key.lowercased().contains("prac") && key.lowercased().contains("att"){
                                        pracAttdKey = key
                                    }
                                    if key.lowercased().contains("prac") && key.lowercased().contains("held"){
                                        pracHeldKey = key
                                    }
                                    if key.lowercased().contains("sgt") && key.lowercased().contains("%"){
                                        sgtPercKey = key
                                    }
                                    if key.lowercased().contains("sgt") && key.lowercased().contains("att"){
                                        sgtAttdKey = key
                                    }
                                    if key.lowercased().contains("sgt") && key.lowercased().contains("held"){
                                        sgtHeldKey = key
                                    }
                                    
                                }
                                let subject = value["Subject name"] ?? value["Subject"]
                                if let subName = subject{
                                    var att = SISattendance()
    //                                print(subName)
                                    att.subjectName = subName
                                    
                                    if value[theoryPercKey] == ""{
    //                                    print("No Theory Value")
                                    }else{
                                        att.theoryPerc = value[theoryPercKey]
                                        att.theoryAttd = value[theoryAttdKey]
                                        att.theoryHeld = value[theoryHeldKey]
                                    }
                                    
                                    if value[clinicPercKey] == ""{
//                                        print("No Clinics Value")
                                    }else{
                                        att.clinicsPerc = value[clinicPercKey]
                                        att.clinicsAttd = value[clinicAttdKey]
                                        att.clinicsHeld = value[clinicHeldKey]
                                    }
                                    if value[sgtPercKey] == ""{
    //                                    print("No SGT Value")
                                    }else{
                                        att.sgtPerc = value[sgtPercKey]
                                        att.sgtAttd = value[sgtAttdKey]
                                        att.sgtHeld = value[sgtHeldKey]
                                    }
                                    if value[pracPercKey] == ""{
    //                                    print("No Practical Value")
                                    }else{
                                        att.practicalPerc = value[pracPercKey]
                                        att.practicalAttd = value[pracAttdKey]
                                        att.practicalHeld = value[pracHeldKey]
                                    }
                                    semesterAttendance.append(att)
                                } else { continue }
                            }
                            
                            attendance[semester.key] = semesterAttendance.sorted(by: { (at1, at2) -> Bool in
                                guard let p1 = at1.subjectName, let p2 = at2.subjectName else { return false }
                                return p1 < p2
                            })
                        }
                        if attendance.count == 0 {
                            errorCompletion(SLCMError.noAttendanceData)
                        }else{
                            dataCompletion(attendance)
                            self.saveSISData(Attendance: attendance)
                        }
                    }else{
                        errorCompletion(SLCMError.internalServerError)
                        return
                    }
                }catch _{
                        errorCompletion(SLCMError.serverOffline)
                        return
                }
            }
        })
        
        task.resume()
    }
    
    func saveSLCMData(Attendance: [Attendance]){
        print("----------- SAVING SLCM DATA ------------")
        NSKeyedArchiver.archiveRootObject(Attendance, toFile: savedAttendanceFilePath)
        
        let date = Date()
        UserDefaults.standard.set(date, forKey: "lastFetchedSLCM")
        UserDefaults.standard.synchronize()
    }
    
    func saveSLCMMarks(Marks: [String: [String: MarksContainer]]){
            do{
                try Disk.save(Marks, to: .caches, as: "marks.json")
            }catch let error{
                print(error)
            }
        }
    
    func saveSLCMCredits(Credits : [String : String]){
        do{
            try Disk.save(Credits, to: .caches, as: "credits.json")
        }catch let error{
            print(error)
        }
    }
        
    func getSavedMarksFromCache() -> [String: [String: MarksContainer]]? {
            do{
                let retrievedData = try Disk.retrieve("marks.json", from: .caches, as: [String: [String: MarksContainer]].self)
                return retrievedData
            }catch{
                return nil
            }
    }
    
    func saveSISData(Attendance: [String: [SISattendance]]){
        print("----------- SAVING SIS DATA ------------")
        do{
            try Disk.save(Attendance, to: .caches, as: "sisAttendance.json")
        }catch let error{
            print(error)
        }
    }
    
    func getSavedSisAttendanceFromCache() -> [String: [SISattendance]]? {
            do{
                let retrievedData = try Disk.retrieve("sisAttendance.json", from: .caches, as: [String: [SISattendance]].self)
                return retrievedData
            }catch{
                return nil
            }
    }
    
}
