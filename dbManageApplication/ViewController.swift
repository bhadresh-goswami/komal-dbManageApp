//
//  ViewController.swift
//  dbManageApplication
//
//  Created by tops-mac on 30/11/18.
//  Copyright © 2018 tops-mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var txtId: UITextField!
    
    
    @IBOutlet weak var txtName: UITextField!
    
    
    @IBOutlet weak var tblInfo: UITableView!
    
    
    var db:OpaquePointer?
    
    
    func dbOpenConnection() -> OpaquePointer? {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if sqlite3_open(appDelegate.dbPath, &db) == SQLITE_OK
        {
            return db
        }
        else
        {
            return nil
        }
        
    }
    var data = [[String:Any]]()
    
    func ReadData() -> [[String:Any]] {
    
        let SelectQuery = "select * from tblInfo"
        
        data = [[String:Any]]()
        
        
        var stmt:OpaquePointer?
        
        if sqlite3_prepare_v2(db, SelectQuery, -1, &stmt, nil) == SQLITE_OK{
            
            
            while sqlite3_step(stmt) == SQLITE_ROW
            {
                let id = sqlite3_column_int(stmt, 0)
                let name = String(cString:sqlite3_column_text(stmt, 1))
                
                let record = ["id":id,"name":name] as [String : Any]
                data.append(record)
            }
            
            tblInfo.reloadData()
            
            
            sqlite3_finalize(stmt)
            print("Query \(SelectQuery) Execute!")
        }
        else
        {
            print("Not able to run \(SelectQuery)!")
        }
        
        return data
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if dbOpenConnection() == nil{
            print("Database is not able to Open!")
        }
        else
        {
            ReadData()
        }
        //insert into tblInfo (id,name) (0,'abv')
        //update tblInfo set name = '' where  id = 0
        //delete from tblInfo where id = 0
        //select * from tblInfo
    
    
    }
    
    
    
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
   
        let InsertQuery = "Insert into tblInfo (id,name) values (\(txtId.text!),'\(txtName.text!)')"
        
        var stmt:OpaquePointer?
        
        if sqlite3_prepare_v2(db, InsertQuery, -1, &stmt, nil) == SQLITE_OK{
            sqlite3_step(stmt)
            sqlite3_finalize(stmt)
            print("Query \(InsertQuery) Execute!")
            ReadData()
        }
        else
        {
            print("Not able to run \(InsertQuery)!")
        }
        
        
        
    
    }
    
    
    
    @IBAction func btnUpdate(_ sender: UIBarButtonItem) {
        
        let UpdateQuery = "Update tblInfo Set name = '\(txtName.text!)' where id = \(txtId.text!)"
        
        var stmt:OpaquePointer?
        
        if sqlite3_prepare_v2(db, UpdateQuery, -1, &stmt, nil) == SQLITE_OK{
            sqlite3_step(stmt)
            sqlite3_finalize(stmt)
            print("Query \(UpdateQuery) Execute!")
            ReadData()
        }
        else
        {
            print("Not able to run \(UpdateQuery)!")
        }
        
        
        
    }
    
    @IBAction func btnDelete(_ sender: UIBarButtonItem) {
        let UpdateQuery = "delete from tblInfo where id = \(txtId.text!)"
        
        var stmt:OpaquePointer?
        
        if sqlite3_prepare_v2(db, UpdateQuery, -1, &stmt, nil) == SQLITE_OK{
            sqlite3_step(stmt)
            sqlite3_finalize(stmt)
            print("Query \(UpdateQuery) Execute!")
            ReadData()
        }
        else
        {
            print("Not able to run \(UpdateQuery)!")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = data[indexPath.row]
        
        cell.textLabel?.text = "\(item["name"]!)"
        cell.detailTextLabel?.text = "\(item["id"]!)"
        
        return cell
    }
    //delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        
        
        txtName.text = "\(item["name"]!)"
        txtId.text = "\(item["id"]!)"
        
        
        
    }
    
}
