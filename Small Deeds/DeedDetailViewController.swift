//
//  DeedDetailViewController.swift
//  Small Deeds
//
//  Created by Andrew Temena on 10/31/16.
//  Copyright © 2016 SmallDeeds. All rights reserved.
//

import UIKit

class DeedDetailViewController: UIViewController {

    var currentDeed: Deed?
    var currentUser: User?
    var currentPledge: Pledge?
    let client = ClientAPI();
    @IBOutlet weak var deedDescription: UITextField!
    @IBOutlet weak var deedTitle: UILabel!
    @IBOutlet weak var deedImpact: UILabel!
    @IBOutlet weak var deedActive: UILabel!
    @IBOutlet weak var deedInactive: UILabel!
    @IBOutlet weak var deedThresholdLabel: UILabel!
    @IBOutlet weak var deedThresholdSlider: UISlider!
    @IBOutlet weak var pledgeStatus: UILabel!
    @IBOutlet weak var pledgeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deedDescription.text = currentDeed?.description ?? "No Description available"
        deedTitle.text = currentDeed?.title
        deedImpact.text = String(describing: currentDeed!.impact)
        deedActive.text = String(describing: currentDeed!.active_pledges)
        deedInactive.text = String(describing: currentDeed!.inactive_pledges)
        
        if currentPledge != nil{
            pledgeButton.setTitle("Activate", for: UIControlState.normal)
            deedThresholdSlider.value = Float(currentPledge!.threshold)
            pledgeStatus.text = "Pledged"
            if(currentPledge?.active)!{
                pledgeButton.setTitle("Unpledge", for: UIControlState.normal)
                pledgeStatus.text = "Active"
            }
            
        }
        deedThresholdLabel.text = String(describing: deedThresholdSlider.value)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let step: Float = 50
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        deedThresholdLabel.text = String(describing: roundedValue)
    }

    @IBAction func newPledge(_ sender: UIButton) {
        if sender.titleLabel?.text == "Pledge"{
            let threshold = Int(deedThresholdSlider.value)
            var active = false
            if threshold < Int(deedActive.text!)!{
                active = true
            }
            let pledge = Pledge(deed: currentDeed!.id, threshold: threshold, active: active);
            client.createPledge(params: pledge.asDictionary(), completion: { (success, data) in
                if active{
                    self.pledgeButton.setTitle("Unpledge", for: UIControlState.normal)
                }else if !active{
                    self.pledgeButton.setTitle("Activate", for: UIControlState.normal)
                }
                return
            })
        } else if sender.titleLabel?.text == "Activate"{
            currentPledge?.active = true
            let pledge = currentPledge
            client.updatePledge(params: pledge?.asDictionary(), completion: {(succes, data) in
                return})
        } else if sender.titleLabel?.text == "Unpledge"{
            let pledge = currentPledge
            client.deletePledge(params: pledge?.asDictionary(), completion: {(succes, data) in
                return})
        }
    }
    // MARK: - Navigation

     @IBAction func Back(_ sender: UIBarButtonItem) {
    }
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
