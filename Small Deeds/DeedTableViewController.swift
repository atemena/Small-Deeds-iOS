//
//  DeedTableViewController.swift
//  Small Deeds
//
//  Created by Andrew Temena on 10/23/16.
//  Copyright © 2016 SmallDeeds. All rights reserved.
//

import UIKit

class DeedTableViewController: UITableViewController {
    
    var token:String = ""
    
    //MARK: Properties
    let keychain = KeychainWrapper()
    let client = ClientAPI()
    var deeds = [Deed]()
    var pledges = [Pledge]()
    var deedPledgeMap = [Int: Pledge]()
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        getUserPledges()
    }
    
    func loadSampleDeeds(){
        client.getDeeds(completion:{(_ success: Bool, _ json: JSON?) -> () in
            for (index,subJson):(String, JSON) in json! {
                let deed = Deed(title:subJson["title"].stringValue, description:subJson["description"].stringValue, id: subJson["id"].int!)!
                self.deeds += [deed]
            }
            self.tableView.reloadData()
            return ()
        } )
        //TODO: Implement later
        //self.refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)

    }
    
    func getUserPledges(){
        client.getPledges(params: ["token": token as AnyObject], completion:{(_ success: Bool, _ json: JSON?) -> () in
            for (index,subJson):(String, JSON) in json! {
                let pledge = Pledge(deed:subJson["deed"].int!, threshold:subJson["threshold"].int!, active: subJson["active"].bool)
                pledge.id = subJson["id"].int
                self.pledges += [pledge]
                self.deedPledgeMap[pledge.deed] = pledge
            }
            self.loadSampleDeeds()
            self.tableView.reloadData()
            return ()
        } )
    }
    
    // Implement later
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    

    
    @IBAction func pledgePressed(_ sender: UIButton) {
        let buttonPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPoint)
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        if segue.identifier == "showDetail"{
            let navControler =  segue.destination as! UINavigationController
            let nextScene = navControler.topViewController as! DeedDetailViewController
            
            // Pass the selected object to the new view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedDeed = deeds[indexPath.row]
                nextScene.currentDeed = selectedDeed
                nextScene.currentPledge = deedPledgeMap[selectedDeed.id]
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return deeds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DeedTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DeedTableViewCell
        let deed = deeds[indexPath.row]
        let deedsPledged = Array(self.deedPledgeMap.keys)
        
        cell.deedTitleLabel.text = deed.title
        cell.deedDescriptionTextView.text = deed.description
        if deedsPledged.contains(deed.id) {
            cell.deedPledgeButton.setTitle("Details", for: UIControlState.normal)
            cell.deedPledgeStatus.isHidden = false
            cell.deedPledgeStatus.text = "Pledged!"
            if (self.deedPledgeMap[deed.id]?.active)!{
                cell.deedPledgeStatus.text = "Active!"
            }
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
