//
//  Constants.swift
//  Skywell_FedirKorniienko
//
//  Created by Fedir Korniienko on 03.06.17.
//  Copyright © 2017 fedir. All rights reserved.
//

import Foundation

struct StoryboardIds {
    
    static let MainViewController: String = "MainViewController"
    static let AddCarViewController: String = "AddCarViewController"
    static let MapViewController: String = "MapViewController"
    static let InfoCarViewController: String = "InfoCarViewController"

    
}
class Localization: NSObject {
    
    class func currentLanguage(forDevice: Bool = false) -> String {
        let userDef = UserDefaults.standard
        var languageArray: NSArray
        if forDevice {
            let language = userDef.object(forKey: "AppleLocale") as! String
            let currentLanguageWithoutLocale = language.substring(to: language.index(language.startIndex, offsetBy: 2))
            return currentLanguageWithoutLocale
        } else {
            languageArray = userDef.object(forKey: "AppleLanguages") as! NSArray
        }
        let currentLanguage = languageArray.firstObject as! String
        let currentLanguageWithoutLocale = currentLanguage.substring(to: currentLanguage.index(currentLanguage.startIndex, offsetBy: 2))
        return currentLanguageWithoutLocale
    }
    class func setLanguageTo(_ lang: String) {
        let userDef = UserDefaults.standard
        userDef.set([lang, currentLanguage()], forKey: "AppleLanguages")
        userDef.synchronize()
    }
    
    class func doTheExchange() {
        exchangeMethods(Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: #selector(Bundle.specialLocalizedStringForKey(_:value:table:)))

    }
    
    class func exchangeMethods(_ cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
        let origMethod: Method = class_getInstanceMethod(cls, originalSelector);
        let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector);
        if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
            class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
            method_exchangeImplementations(origMethod, overrideMethod);
        }
    }
}

extension Bundle {
    func specialLocalizedStringForKey(_ key: String, value: String?, table tableName: String?) -> String {
        if self == Bundle.main {
            let currentLanguage = Localization.currentLanguage()
            var bundle = Bundle();
            if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
                bundle = Bundle(path: _path)!
            } else {
                let _path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
                bundle = Bundle(path: _path)!
            }
            return (bundle.specialLocalizedStringForKey(key, value: value, table: tableName))
        } else {
            return (self.specialLocalizedStringForKey(key, value: value, table: tableName))
        }
    }
}
   

