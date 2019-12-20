//
//  AppDelegate.swift
//  iContact
//
//  Created by apple on 27/08/19.
//  Copyright © 2019 apple. All rights reserved.
// Email: kumarstslav@gmail.com

import UIKit
import FSCalendar
import CoreData

class AddContactVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FSCalendarDelegate,FSCalendarDataSource
{
    
    @IBOutlet weak var editCameraView: UIView!
    @IBOutlet weak var contactImageView: UIImageView!
    
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var surnameLabel: UITextField!
    @IBOutlet weak var companyNameLabel: UITextField!
    @IBOutlet weak var mobileNumberLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var pinCodeTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
   
    
    
    var ImagePicker = UIImagePickerController()
    var crntData = ""
    var imgData = Data()
    var isImagePicked = false
    let formatter = DateFormatter()
    var dateOfBirth = ""
    var gender = ""
    var populateData:NSManagedObject?
    var isUpdate = false
    var uuID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgView.isHidden = true
        calendarView.isHidden = true
        datePickerView.isHidden = true
        // Do any additional setup after loading the view.
        self.editCameraView.layer.cornerRadius = self.editCameraView.frame.height / 2
        self.contactImageView.layer.cornerRadius = self.contactImageView.frame.height / 2
        
         imgData = #imageLiteral(resourceName: "boss").pngData()! // Default Image
         ImagePicker.delegate = self
         formatter.dateFormat = "dd, MMM yyyy hh:mm a"
         crntData = formatter.string(from: Date())
        
        if isUpdate{
            populateDataAction()
        }
        else{
            
        }
    }
    
    
    @IBAction func editImageAction(_ sender: Any) {
    ForGalleryCamera()
    }
    
    @IBAction func saveContactAction(_ sender: Any) {
        if validateTextFields(){
            if isUpdate{
               updateContactObj()
            }
            else{
                addContactObj()
            }
            
        }
    }
    
    @IBAction func selectDateOfBirthAction(_ sender: Any) {
        bgView.isHidden = false
        datePickerView.isHidden = false
    }
    
    
    @IBAction func selectedDateAction(_ sender: Any) {
        // "1994-10-12"
        formatter.dateFormat = "yyyy-MM-dd"
        self.dateOfBirth = formatter.string(from: datePicker.date)
        formatter.dateFormat = "dd, MMM, yyyy"
        dateOfBirthTextField.text! = formatter.string(from: datePicker.date)
        bgView.isHidden = true
        datePickerView.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first!
        if touch.view == bgView{
            bgView.isHidden = true
            datePickerView.isHidden = true
        }
    }
    
    
    func addContactObj()
    {
       let uniqueId = UUID().uuidString
       let arr = [uniqueId,"\(firstNameLabel.text!)","\(surnameLabel.text!)","\(mobileNumberLabel.text!)","\(emailLabel.text!)","\(addressTextField.text!)",self.dateOfBirth,"\(companyNameLabel.text!)","\(pinCodeTextField.text!)","\(crntData)","\(urlTextField.text!)"]
        
        if CoreDataMethods.insertNewObj(forEntityName: CoreDataMethods.databaseName, keys: CoreDataMethods.keys, values: arr, isImage: self.isImagePicked, imageData: imgData){
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func updateContactObj()
    {
       
        let arr = [self.uuID,"\(firstNameLabel.text!)","\(surnameLabel.text!)","\(mobileNumberLabel.text!)","\(emailLabel.text!)","\(addressTextField.text!)",self.dateOfBirth,"\(companyNameLabel.text!)","\(pinCodeTextField.text!)","\(crntData)","\(urlTextField.text!)"]
        
        
        if CoreDataMethods.updateSingleObj(forEntityName: CoreDataMethods.databaseName, objId: self.uuID, keys: CoreDataMethods.keys, values: arr, isImage: self.isImagePicked, imageData: imgData){
            print("Updated.............. Congrates.....")
            Global.showAlertMessageWithOkButtonAndTitle("", andMessage: "Updated successfully.")
            let vc = storyboard?.instantiateViewController(withIdentifier: "ContactListingVC") as! ContactListingVC
                 self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
    }
    
    
    
    
    func validateTextFields() -> Bool
    {
        if firstNameLabel.text!.count <= 0{
            print("Error.....")
            Global.showAlertMessageWithOkButtonAndTitle("", andMessage: "Enter name")
            return false
        }
        else  if surnameLabel.text!.count <= 0{
             print("Error.....")
            Global.showAlertMessageWithOkButtonAndTitle("", andMessage: "Enter surname")
            return false
        }
        else  if companyNameLabel.text!.count <= 0{
             print("Error.....")
            Global.showAlertMessageWithOkButtonAndTitle("", andMessage: "Enter company name")
             return false
        }
        else  if mobileNumberLabel.text!.count <= 0{
             print("Error.....")
            Global.showAlertMessageWithOkButtonAndTitle("", andMessage: "Enter mobile number")
             return false
        }else{
            return true
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        formatter.dateFormat = "dd, MM, yyy"
        let dt = formatter.string(from: date)
        print("Selected Data::::",dt)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if var pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.contactImageView.image = pickedImage
            imgData = pickedImage.jpegData(compressionQuality: 1.0)!
            self.isImagePicked = true
        }
        else{
             self.isImagePicked = false
        }
        picker.dismiss(animated: true, completion: nil)
    }

}




//for ImagePickerView
extension AddContactVC{
    //for Image Gallery and camera
    func ForGalleryCamera()  {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            ImagePicker.sourceType = UIImagePickerController.SourceType.camera
            ImagePicker.allowsEditing = true
            self.present(ImagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        ImagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        ImagePicker.allowsEditing = true
        self.present(ImagePicker, animated: true, completion: nil)
    }
    
    
    
    func populateDataAction()
    {
        firstNameLabel.text! = Global.getStringValue(populateData?.value(forKey: "firstName") as AnyObject)
        
        surnameLabel.text! = Global.getStringValue(populateData?.value(forKey: "surname") as AnyObject)
        companyNameLabel.text! = Global.getStringValue(populateData?.value(forKey: "company") as AnyObject)
        mobileNumberLabel.text! = Global.getStringValue(populateData?.value(forKey: "mobile") as AnyObject)
        emailLabel.text! = Global.getStringValue(populateData?.value(forKey: "email") as AnyObject)
        dateOfBirthTextField.text! = Global.getDateFromString(stndFormat: "yyyy-MM-dd", getFormat: "dd, MMM yyyy", dateString: Global.getStringValue(populateData?.value(forKey: "dob") as AnyObject), isDate: true)
        
        self.dateOfBirth = Global.getStringValue(populateData?.value(forKey: "dob") as AnyObject)
        
        addressTextField.text! = Global.getStringValue(populateData?.value(forKey: "address") as AnyObject)
        urlTextField.text! = Global.getStringValue(populateData?.value(forKey: "url") as AnyObject)
        pinCodeTextField.text! = Global.getStringValue(populateData?.value(forKey: "pincode") as AnyObject)
        
        self.uuID = Global.getStringValue(populateData?.value(forKey: "objId") as AnyObject)
        print(" self.uuID::::::", self.uuID)
        let isImg = populateData?.value(forKey: "isImage") as! Bool
        isImagePicked = isImg
        if isImg{
            let imgData = populateData?.value(forKey: "image") as! Data
            self.contactImageView.image = UIImage(data: imgData)
            self.imgData = (UIImage(data: imgData)?.pngData())!
        }
        else{
            self.contactImageView.setImage(string: firstNameLabel.text! + " " + surnameLabel.text!, color: nil, circular: true, textAttributes: nil)
        }
        
    }
    
    
}



