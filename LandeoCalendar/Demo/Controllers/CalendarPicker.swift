//
//  CalendarPicker.swift
//  LandeoCalendar
//
//  Created by sebastian on 15.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit

class CalendarPicker: UIViewController {
    
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var singleStandard: SelectionButtons!
    @IBOutlet weak var singleModal: SelectionButtons!
    
    @IBOutlet weak var multipleStandard: SelectionButtons!
    @IBOutlet weak var multipleModal: SelectionButtons!
    
    @IBOutlet weak var rangeStandard: SelectionButtons!
    @IBOutlet weak var rangeModal: SelectionButtons!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addGradient()
        self.addButtonsStyling()
    }
    
}

//MARK: - Set UI

extension CalendarPicker {
    
    func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        let topColor = #colorLiteral(red: 0.3293722868, green: 0.329434514, blue: 0.3293683529, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.1882103086, green: 0.1882497072, blue: 0.1882078648, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        self.gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

//MARK: - Presentation section

extension CalendarPicker {
    @IBAction func singleButtonPressed(_ sender: Any) {
        let calendarView = self.storyboard?.instantiateViewController(withIdentifier: "SinglePicker") as! SinglePickerVC
        present(calendarView, animated: true, completion: nil)
    }
    
    @IBAction func singleModalPressed(_ sender: Any) {
        let calendarView = self.storyboard?.instantiateViewController(withIdentifier: "SinglePickerModal") as! SinglePickerVCModal
        
        calendarView.modalPresentationStyle = .overCurrentContext
        calendarView.modalTransitionStyle = .crossDissolve
        present(calendarView, animated: true, completion: nil)
    }
    
    @IBAction func multipleButtonPressed(_ sender: Any) {
        let calendarView = self.storyboard?.instantiateViewController(withIdentifier: "MultiplePicker") as! MultiplePickerVC
        present(calendarView, animated: true, completion: nil)
    }
    
    @IBAction func multipleModalButtonPressed(_ sender: Any) {
        let calendarView = self.storyboard?.instantiateViewController(withIdentifier: "MultiplePickerModal") as! MultiplePickerVCModal
        calendarView.modalPresentationStyle = .overCurrentContext
        calendarView.modalTransitionStyle = .crossDissolve
        present(calendarView, animated: true, completion: nil)
    }
    
    @IBAction func rangeMarkButtonPressed(_ sender: Any) {
        let calendarView = self.storyboard?.instantiateViewController(withIdentifier: "RangePicker") as! RangePickerVC
        present(calendarView, animated: true, completion: nil)
    }
    
    @IBAction func rangeModalButtonPressed(_ sender: Any) {
        let calendarView = self.storyboard?.instantiateViewController(withIdentifier: "RangePickerModal") as! RangePickerVCModal
        calendarView.modalPresentationStyle = .overCurrentContext
        calendarView.modalTransitionStyle = .crossDissolve
        present(calendarView, animated: true, completion: nil)
    }
    
    
    
}
