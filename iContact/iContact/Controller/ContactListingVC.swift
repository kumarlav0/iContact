//
//  AppDelegate.swift
//  iContact
//
//  Created by apple on 27/08/19.
//  Copyright © 2019 apple. All rights reserved.
// Email: kumarstslav@gmail.com


import UIKit
import Letters
import CoreData




class ContactListingVC: UIViewController
{
   
    @IBOutlet weak var sortBarButton: UIBarButtonItem!
    @IBOutlet weak var contactTableView: UITableView!
     var ContactData = [NSManagedObject]()
     var isCheckMark = false
     var imgCheckArr = [#imageLiteral(resourceName: "unchecked")]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       setupLongPressGesture()
        // Do any additional setup after loading the view.
      contactTableView.separatorColor = .clear
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getNewData(isAssending: true)
    }
    
    @IBAction func addNewContactAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddContactVC") as! AddContactVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var isAccending = true
    @IBAction func sortDataAction(_ sender: Any) {
        if isAccending{
            sortBarButton.image = #imageLiteral(resourceName: "desending")
            getNewData(isAssending: false)
            isAccending = false
        }
        else{
            sortBarButton.image = #imageLiteral(resourceName: "assending")
            getNewData(isAssending: true)
             isAccending = true
        }
      
    }
    
    @IBAction func checkAction(_ sender: UIButton) {
        
        
        
    }
    

}


extension ContactListingVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactTableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactTableViewCell
        
        let obj = ContactData[indexPath.row]
        
        let name = "\(obj.value(forKey: "firstName") as! String) \(obj.value(forKey: "surname") as! String)"
        let isImg = obj.value(forKey: "isImage") as! Bool
      
        if isImg{
              let imgData = obj.value(forKey: "image") as! Data
             cell.cellImageView.image = UIImage(data: imgData)
        }
        else{
             cell.cellImageView.setImage(string: name, color: nil, circular: true, textAttributes: nil)
        }
       
        cell.cellNameLable.text! = "\(obj.value(forKey: "firstName") as! String)" + " \(obj.value(forKey: "surname") as! String)"
        cell.cellNumberLable.text! = "\(obj.value(forKey: "mobile") as! String)"
       
       
        cell.selectionStyle = .none
        cell.cellCheckButton.tag = indexPath.row

        if isCheckMark{
           cell.cellCheckButton.isHidden = false
        }
        else{
            cell.cellCheckButton.isHidden = true
        }
        
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ContactDetailsVC") as! ContactDetailsVC
        
        vc.populateData = ContactData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            ContactData.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }
//
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // action one
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            print("Edit tapped")
            let dict =  self.ContactData[indexPath.row]
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddContactVC") as! AddContactVC
            vc.isUpdate = true
            vc.populateData = dict
            self.navigationController?.pushViewController(vc, animated: true)
        })
        editAction.backgroundColor = UIColor.gray
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            print("Delete tapped")
           // self.ContactData.remove(at: indexPath.row)
           // tableView.deleteRows(at: [indexPath], with: .fade)
            let dict =  self.ContactData[indexPath.row]
            let objId = Global.getStringValue(dict.value(forKey: "objId") as AnyObject)
            let name = Global.getStringValue(dict.value(forKey: "firstName") as AnyObject) + " " +  Global.getStringValue(dict.value(forKey: "surname") as AnyObject)
        self.AlertWithActionOKCancel(buttonTitle: "Delete", title: name, body: "Permanently Delete.", response: {_ in
            if CoreDataMethods.deleteSingleObj(objId: objId, entityName: CoreDataMethods.databaseName)
            {
                self.getNewData(isAssending: true)
            }
        })
         
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [editAction, deleteAction]
    }
    
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
       // longPressGesture.delegate = self
        self.contactTableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.contactTableView)
            if let indexPath = contactTableView.indexPathForRow(at: touchPoint) {
                print("indexPath::::",indexPath.row)
                isCheckMark = true
                contactTableView.reloadData()
            }
        }
        else{
            
        }
    }
    
    
}


extension ContactListingVC
{
    func getNewData(isAssending:Bool)
    {
        ContactData.removeAll()
        ContactData = CoreDataMethods.getAllData(entityName: CoreDataMethods.databaseName, isAssending: isAssending)
        contactTableView.reloadData()
    }
}
