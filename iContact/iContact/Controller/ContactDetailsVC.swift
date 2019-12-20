//
//  AppDelegate.swift
//  iContact
//
//  Created by apple on 27/08/19.
//  Copyright © 2019 apple. All rights reserved.
// Email: kumarstslav@gmail.com

import UIKit
import CoreData
import SafariServices


class ContactDetailsVC: UIViewController
{

    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var dateOfBirthView: UIView!
    @IBOutlet weak var addressView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var ageButton: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var fullAgeView: UIView!
    @IBOutlet weak var fullAgeLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    
    
    var populateData:NSManagedObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bgView.isHidden = true
        fullAgeView.isHidden = true
        round(obj: callView)
        round(obj: messageView)
        round(obj: emailView)
        round(obj: dateOfBirthView)
        round(obj: addressView)
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
        self.profileImageView.clipsToBounds = true
        populateDataAction()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        let touch = touches.first!
        if touch.view == bgView{
            bgView.isHidden = true
            fullAgeView.isHidden = true
        }
    }
    
    
    @IBAction func callAction(_ sender: Any) {
        let num = Global.getStringValue(populateData?.value(forKey: "mobile") as AnyObject)
        
        if let phoneCallURL = URL(string: "telprompt://\(num)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    
    
    @IBAction func messageAction(_ sender: Any) {
        let num = Global.getStringValue(populateData?.value(forKey: "mobile") as AnyObject)
        let number = "sms:\(num)"
        UIApplication.shared.openURL(NSURL(string: number)! as URL)
    }
    
    @IBAction func emailAction(_ sender: Any) {
        let email = Global.getStringValue(populateData?.value(forKey: "email") as AnyObject)
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func openWebsiteAction(_ sender: Any) {
         let urlStr = Global.getStringValue(populateData?.value(forKey: "url") as AnyObject)
        
        let alert = UIAlertController(title: "URL", message: urlStr, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Using Safari default brawser", style: .default, handler: { (alertAction) in
            let Url = URL(string: urlStr)
            guard let url = URL(string: urlStr) else {
                Global.showAlertMessageWithOkButtonAndTitle("", andMessage: "No url found")
                return
            }
            let svc = SFSafariViewController(url: url)
            self.present(svc, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Using other brawser", style: .default, handler: { (alertAction) in
                guard let url = URL(string: urlStr) else {
                    Global.showAlertMessageWithOkButtonAndTitle("", andMessage: "No url found")
                    return
                }
                UIApplication.shared.open(url)
               }))
       
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func openMapAction(_ sender: Any) {
    }
    
    @IBAction func calculateAgeAction(_ sender: UIButton) {
        
        if sender.isSelected{
          bgView.isHidden = false
          fullAgeView.isHidden = false
        }
        else{
            ageButton.rotate360Degrees()
            // sleep(2)
            let age  = getAgeFromDOF(date: Global.getStringValue(populateData?.value(forKey: "dob") as AnyObject))
            ageButton.setTitle("\(age.0)", for: .normal)
            ageButton.setImage(nil, for: .normal)
            fullAgeLabel.text! = "\(age.0) Year, \(age.1) Month, \(age.2) Day"
            sender.isSelected = true
        }
       
    }
    
    @IBAction func editAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddContactVC") as! AddContactVC
        vc.isUpdate = true
        vc.populateData = populateData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func populateDataAction()
    {
        nameLabel.text! = Global.getStringValue(populateData?.value(forKey: "firstName") as AnyObject) + " \(Global.getStringValue(populateData?.value(forKey: "surname") as AnyObject))"
        
        mobileNumberLabel.text! = Global.getStringValue(populateData?.value(forKey: "mobile") as AnyObject)
        
        emailLabel.text! = Global.getStringValue(populateData?.value(forKey: "email") as AnyObject)
        
        dateOfBirthLabel.text! = Global.getDateFromString(stndFormat: "yyyy-MM-dd", getFormat: "dd, MMM yyyy", dateString: Global.getStringValue(populateData?.value(forKey: "dob") as AnyObject), isDate: true)
        
        companyNameLabel.text! = Global.getStringValue(populateData?.value(forKey: "company") as AnyObject)
        addressLabel.text! = Global.getStringValue(populateData?.value(forKey: "address") as AnyObject)
        
        createdDateLabel.text! = "Created at: " + Global.getStringValue(populateData?.value(forKey: "date") as AnyObject)
        
        let isImg = populateData?.value(forKey: "isImage") as! Bool
        
        if isImg{
            let imgData = populateData?.value(forKey: "image") as! Data
            self.profileImageView.image = UIImage(data: imgData)
        }
        else{
            self.profileImageView.setImage(string: nameLabel.text!, color: nil, circular: true, textAttributes: nil)
        }
        
    }
    
    func round(obj:UIView)
    {
        obj.layer.cornerRadius = obj.frame.height / 2
        obj.layer.borderColor = UIColor.lightGray.cgColor
        obj.layer.borderWidth = 1.0
    }
    
    
    func getAgeFromDOF(date: String) -> (Int,Int,Int) {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-dd"
        let dateOfBirth = dateFormater.date(from: date)
        print("dateOfBirth",dateOfBirth)
        if dateOfBirth == nil{
            return (0,0,0)
        }
        
        let calender = Calendar.current
        
        let dateComponent = calender.dateComponents([.year, .month, .day], from:
            dateOfBirth!, to: Date())
        
        return (dateComponent.year!, dateComponent.month!, dateComponent.day!)
    }
    
    
    
}


