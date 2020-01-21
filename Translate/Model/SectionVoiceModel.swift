//
//  SectionVoiceModel.swift
//  Translate
//
//  Created by Sang on 1/21/20.
//  Copyright © 2020 SangNX. All rights reserved.
//

import Foundation

struct SectionVoiceModel{

    var code : String!
    var listVoices : [VoiceModel]!
    var title : String!
    var hello: String!
    
    init(fromDictionary dictionary: [String:Any]) {
        code = dictionary["code"] as? String
        listVoices = [VoiceModel]()
        if let countryArray = dictionary["listVoices"] as? [[String:Any]]{
            for dic in countryArray{
                let value = VoiceModel(fromDictionary: dic)
                listVoices.append(value)
            }
        }
        title = dictionary["title"] as? String
        hello = dictionary["hello"] as? String
    }

    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        if code != nil{
            dictionary["code"] = code
        }
        if listVoices != nil{
            var dictionaryElements = [[String:Any]]()
            for countryElement in listVoices {
                dictionaryElements.append(countryElement.toDictionary())
            }
            dictionary["listVoices"] = dictionaryElements
        }
        if title != nil{
            dictionary["title"] = title
        }
        if hello != nil{
            dictionary["hello"] = hello
        }
        return dictionary
    }

}
