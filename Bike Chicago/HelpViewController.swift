//
//  HelpViewController.swift
//  Bike Chicago
//
//  Created by Alush Benitez on 7/19/18.
//  Copyright © 2018 Alush Benitez. All rights reserved.
//
import UIKit

class HelpViewController: UIViewController {
    
    
    @IBOutlet weak var offRoadView: UIView!
    @IBOutlet weak var bufferedView: UIView!
    @IBOutlet weak var bikeLaneView: UIView!
    @IBOutlet weak var sharedLaneView: UIView!
    @IBOutlet weak var cycleTrackView: UIView!
    
    var offRoadColors: UIColor? = nil
    var bufferedColors: UIColor? = nil
    var bikeLaneColors: UIColor? = nil
    var sharedLaneColors: UIColor? = nil
    var cycleTrackColors: UIColor? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHelpColors()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addHelpColors() {
        offRoadView.backgroundColor = offRoadColors
        bufferedView.backgroundColor = bufferedColors
        bikeLaneView.backgroundColor = bikeLaneColors
        sharedLaneView.backgroundColor = sharedLaneColors
        cycleTrackView.backgroundColor = cycleTrackColors
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
