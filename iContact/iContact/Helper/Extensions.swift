//
//  Extensions.swift
//  MyNewDemos
//
//  Created by apple on 27/08/19.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
import UIKit


//  it is Used for storing Array of Images in Core Data.

typealias ImageArray = [UIImage]
typealias ImageArrayRepresentation = Data

extension Array where Element: UIImage {
    // Given an array of UIImages return a Data representation of the array suitable for storing in core data as binary data that allows external storage
    func coreDataRepresentation() -> ImageArrayRepresentation? {
        let CDataArray = NSMutableArray()
        
        for img in self {
            guard let imageRepresentation = img.pngData() else {
                print("Unable to represent image as PNG")
                return nil
            }
            let data : NSData = NSData(data: imageRepresentation)
            CDataArray.add(data)
        }
        
        return NSKeyedArchiver.archivedData(withRootObject: CDataArray)
    }
}

extension ImageArrayRepresentation {
    // Given a Data representation of an array of UIImages return the array
    func imageArray() -> ImageArray? {
        if let mySavedData = NSKeyedUnarchiver.unarchiveObject(with: self) as? NSArray {
            // TODO: Use regular map and return nil if something can't be turned into a UIImage
            let imgArray = mySavedData.flatMap({
                return UIImage(data: $0 as! Data)
            })
            return imgArray
        }
        else {
            print("Unable to convert data to ImageArray")
            return nil
        }
    }
}



extension UIButton {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 28.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as? CAAnimationDelegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}


extension UIViewController
{
    
    func AlertWithActionOK(buttonTitle:String,title:String,body:String,response: @escaping(_ isOk:Bool)-> Void )
    {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: buttonTitle, style: .default, handler: {(action:UIAlertAction) in
            response(true)
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func AlertWithActionOKCancel(buttonTitle:String,title:String,body:String,response: @escaping(_ isOk:Bool)-> Void )
    {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: buttonTitle, style: .default, handler: {(action:UIAlertAction) in
            response(true)
            alert.dismiss(animated: true, completion: nil)
        })
        
        let no = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(no)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
