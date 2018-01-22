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
    
    @IBOutlet weak var singleStandard: UIButton!
    @IBOutlet weak var singleModal: UIButton!
    
    @IBOutlet weak var multipleStandard: UIButton!
    @IBOutlet weak var multipleModal: UIButton!
    
    @IBOutlet weak var rangeStandard: UIButton!
    @IBOutlet weak var rangeModal: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var multipleContainerView: UIView!
    @IBOutlet weak var rangeContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 10
        multipleContainerView.layer.cornerRadius = 10
        rangeContainerView.layer.cornerRadius = 10
    }
    
    @IBAction func testButtonPressed(_ sender: Any) {
        let vc = CalendarViewVC(nibName: nil, bundle: nil)
        present(vc, animated: true, completion: nil)
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
