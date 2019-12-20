//
//  Global.swift
//  MyNewDemos
//
//  Created by apple on 03/09/19.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
import  UIKit
import SystemConfiguration



class Global: NSObject {

    class var sharedInstance: Global {
        struct Static {
            static let instance: Global = Global()
        }
        return Static.instance
    }
    
    static func timezoneStringFromTimezone(_ timeZone: TimeZone) -> String {
        let seconds: Int = timeZone.secondsFromGMT()
        NSLog("TZ : %@ : Seconds %ld", timeZone.abbreviation()!, Int(seconds))
        let h: Int = Int(seconds) / 3600
        let m: Int = Int(seconds) / 60 % 60
        var strGMT: String = ""
        if h >= 0 {
            strGMT = String(format: "+%02d:%02d", h, m)
        }
        else {
            strGMT = String(format: "%03d:%02d", h, m)
        }
        var stringGMT: String = "GMT "
        stringGMT = stringGMT + strGMT
        return stringGMT
    }
    
    static func showAlertMessageWithOkButtonAndTitle(_ strTitle: String, andMessage strMessage: String)
    {
        if objc_getClass("UIAlertController") == nil
        {
            let alert: UIAlertView = UIAlertView(title: strTitle, message: strMessage, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "")
            alert.show()
            
        }
        else
        {
            let alertController: UIAlertController = UIAlertController(title:strTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
            let ok: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(ok)
            
            let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
            topWindow.rootViewController = UIViewController()
            topWindow.windowLevel = UIWindow.Level.alert + 1
            topWindow.makeKeyAndVisible()
            topWindow.rootViewController!.present(alertController, animated: true, completion: {
                
            })
        }
    }
    
    //MARK: - String Methods
    
    /// Trim for String
    static func Trim(_ value: String) -> String {
        let value = value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return value
    }
    // checks whether string value exists or it contains null or null in string
    static func stringExists(_ str: String) -> Bool {
        var strString : String? = str
        
        if strString == nil {
            return false
        }
        
        if strString == String(describing: NSNull()) {
            return false
        }
        if (strString == "<null>") {
            return false
        }
        if (strString == "(null)") {
            return false
        }
        strString = Global.Trim(str)
        if (str == "") {
            return false
        }
        if strString?.count == 0 {
            return false
        }
        return true
    }
    
    // returns string value after removing null and unwanted characters
    
    static func getStringValue(_ str: AnyObject) -> String {
        if str is NSNull {
            return ""
        }
        else{
            
            var strString : String? = str as? String
            if Global.stringExists(strString!) {
                strString = strString!.replacingOccurrences(of: "\t", with: " ")
                strString = Global.Trim(strString!)
                if (strString == "{}") {
                    strString = ""
                }
                if (strString == "()") {
                    strString = ""
                }
                if (strString == "null") {
                    strString = ""
                }
                return strString!
            }
            return ""
        }
    }
    
    
    
    static func getDateFromString(stndFormat: String,getFormat: String,dateString: String,isDate: Bool) -> String
    {
        let dateFormatter = DateFormatter()
        var date_time_string = ""
        
        if isDate == true
        {
            dateFormatter.dateFormat = stndFormat          //"yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = getFormat    //"E,dd MMM, yyyy"
            if date != nil
            {
                date_time_string = dateFormatter.string(from: date!)
            }
            else
            {
                date_time_string = ""
            }
        }
        else
        {
            dateFormatter.dateFormat = stndFormat          //"yyyy-MM-dd"
            let time = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = getFormat    //"E,dd MMM, yyyy"
            if time != nil
            {
                date_time_string = dateFormatter.string(from: time!)
            }
            else
            {
                date_time_string = ""
            }
        }
        
        return date_time_string
    }
    
    
    class func isInternetAvailable() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    
    class func makeBlurImage(_ targetView:UIView?)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = targetView!.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        targetView?.addSubview(blurEffectView)
    }
    
}
