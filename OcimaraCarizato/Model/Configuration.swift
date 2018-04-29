//
//  Configuration.swift
//  OcimaraCarizato
//
//  Created by Ocimara Barcellos on 21/04/2018.
//  Copyright © 2018 Ocimara Barcellos. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
    case cotDolar = "dolar"
    case txIOF = "iof"
}

class Configuration {
    let defaults = UserDefaults.standard
    static var shared: Configuration = Configuration()

  var calc = Calculator.shared
    
   var cotDolar: String {
        get {
            return defaults.value(forKey: UserDefaultsKeys.cotDolar.rawValue) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.cotDolar.rawValue)
        }
    }
    
    var txIOF: String {
        get {
            return defaults.value(forKey: UserDefaultsKeys.txIOF.rawValue) as! String
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.txIOF.rawValue)
        }
    }
    
    private init() {
        
        if ((defaults.value(forKey: UserDefaultsKeys.cotDolar.rawValue)) == nil) {
            defaults.set(calc.getFormattedValue(of: 3.41, withCurrency: ""), forKey: UserDefaultsKeys.cotDolar.rawValue)
            defaults.synchronize()
        }
        
        if ((defaults.value(forKey: UserDefaultsKeys.txIOF.rawValue)) == nil) {
            defaults.set(calc.getFormattedValue(of: 6.38, withCurrency: ""), forKey: UserDefaultsKeys.txIOF.rawValue)
            defaults.synchronize()
        }
     
    }
    
}
