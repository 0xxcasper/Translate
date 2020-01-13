//
//  String+Extention.swift
//  TextToSpeak
//
//  Created by admin on 30/12/2019.
//  Copyright © 2019 SangNX. All rights reserved.
//

import Foundation
import AVFoundation

extension String {
    
    //validate email
    func isValidEmail()-> Bool{
        if self.count > 254 {
            return false
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return email.evaluate(with: self)
    }
    
    //validate phone number
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && self.count == 10
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func isEmptyOrWhitespace() -> Bool {
        if(self.isEmpty) {
            return true
        }
        return (self.trimmingCharacters(in: CharacterSet.whitespaces) == "")
    }
    
    func toDateTime(_ dateFormat: String = "dd.MM.yyyy HH:mm:ss") -> Date {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = dateFormat
        //Parse into NSDate
        let dateFromString : Date? = dateFormatter.date(from: self)
        
        //Return Parsed Date
        return dateFromString!
    }
    
    func getLocationString() -> String {
        if self.contains(".") {
            let arrStringLocation = self.components(separatedBy: ". ")
            if let locationStr = arrStringLocation.last {
                return locationStr
            } else {
                return ""
            }
        }
        return self
    }
    
    func convertStringToDate(format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)!
        return date
    }
    
    func configAVSpeechUtterance() -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: self)
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-GB_compact")
//        utterance.rate = rate
//        utterance.pitchMultiplier = pitch
        return utterance
    }
    
}

extension DateFormatter
{
    func convertDateFormatterToString(date:Date, format:String) -> String {
        self.dateFormat = format
        return self.string(from: date)
    }
}
