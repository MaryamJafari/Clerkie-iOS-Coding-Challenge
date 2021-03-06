//
//  Charts.swift
//  Clerkie iOS Coding Challenge
//
//  Created by Maryam Jafari on 9/17/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import UIKit

class Charts: UIViewController {
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    var base: Currency!
    var rates: [Rate]?
    var symbols: [Currency]!
    
    var activeViewController: UIViewController? {
        didSet {
            oldValue?.view.removeFromSuperview()
            
            guard let activeViewController = activeViewController else { return }
            activeViewController.view.frame = contentView.bounds
            contentView.addSubview(activeViewController.view)
            activeViewController.didMove(toParentViewController: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.tintColor = Constant().color
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 23)!]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:Constant().navigationColor]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationItem.title = "Analytics Dashboard"
        /*segmentedControl.setTitle("Bar1", forSegmentAt: 0)
         segmentedControl.setTitle("Pie1", forSegmentAt: 1)
         segmentedControl.setTitle("Line", forSegmentAt: 2)
         segmentedControl.setTitle("Bar2", forSegmentAt: 3)
         segmentedControl.setTitle("Pie2", forSegmentAt: 4)*/
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rates = [Rate(date: "2018-08-01", base: "kj", rates: ["1": 1.1, "2" : 2.2]) ,Rate(date: "2018-08-02", base: "kj", rates: ["1": 1.1, "2" : 2.2]) ,Rate(date: "2018-08-03", base: "kj", rates: ["1": 1.1, "2" : 2.2])]
        
        symbols = Currency.currencies
        base = symbols.first
        
        loadRates()
    }
    
    func loadRates() {
        let symbolNames = symbols.map { $0.name }
        
        DataStore.sharedStore.getRates(
            fromDateString: "2018-08-01",
            toDateString: "2016-08-10",
            base: base.name,
            symbols: symbolNames,
            success: { [weak self] rates in
                guard let strongSelf = self else { return }
                strongSelf.rates = rates
                strongSelf.showViewControllerForSegment(index: strongSelf.segmentedControl.selectedSegmentIndex)
                
            }, failure: { error in
                print("error: \(error?.localizedDescription)")
        })
    }
    
    func showViewControllerForSegment(index: Int) {
        
        let viewController = viewControllerForSegment(index: index)
        
        if let viewController = viewController as? Pie {
            viewController.base = base
            viewController.symbols = symbols
            viewController.rate = rates?.last
            
        } else if let viewController = viewController as? Bar {
            viewController.base = base
            viewController.symbols = symbols
            viewController.rates = rates
        }
        else if let viewController = viewController as? Line {
            
        }
        else if let viewController = viewController as? LineChart {
            
        }
        else if let viewController = viewController as? PieChart {
            
        }
        
        activeViewController = viewController
    }
    
    
    func viewControllerForSegment(index: Int) -> UIViewController {
        switch index {
        case 0:   return storyboard!.instantiateViewController(withIdentifier: "PieChart")
        case 1:   return storyboard!.instantiateViewController(withIdentifier: "Line")
        case 2:   return storyboard!.instantiateViewController(withIdentifier: "LineChart")
        case 3:   return storyboard!.instantiateViewController(withIdentifier: "Bar")
        //case 4:   return storyboard!.instantiateViewController(withIdentifier: "Pie")
        default:  return UIViewController()
        }
    }
}

// MARK: Actions

extension Charts {
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        showViewControllerForSegment(index: index)
    }
    
}
