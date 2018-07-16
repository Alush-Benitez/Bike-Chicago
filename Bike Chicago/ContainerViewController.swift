//
//  ContainerViewController.swift
//  Bike Chicago
//
//  Created by Michael Filippini on 7/13/18.
//  Copyright © 2018 Alush Benitez. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    var centerNavigationController: UINavigationController!
    var centerViewController: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerViewController = ViewController()
        centerViewController.delegate = self
        
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMove(toParentViewController: self)    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
   
    extension ContainerViewController: ViewControllerDelegate {
        
        func toggleLeftPanel() {
        }
        
        
        func addLeftPanelViewController() {
        }
        
        
        func animateLeftPanel(shouldExpand: Bool) {
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


