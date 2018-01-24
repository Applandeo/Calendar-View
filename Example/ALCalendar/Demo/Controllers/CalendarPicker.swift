//
//  CalendarPicker.swift
//  LandeoCalendar
//
//  Created by sebastian on 15.12.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit
import ALCalendar

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
    @IBOutlet weak var dialogContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 10
        multipleContainerView.layer.cornerRadius = 10
        rangeContainerView.layer.cornerRadius = 10
        dialogContainerView.layer.cornerRadius = 10
    }
    
    @IBAction func testButtonPressed(_ sender: Any) {
        let vc = CalendarViewVC()
        vc.view.superview?.frame.size = CGSize(width: 300, height: 350)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.view.backgroundColor = UIColor.white
        present(vc, animated: true, completion: nil)
        print("dupex")
    }
    
}

//MARK: - Presentation section

extension CalendarPicker {
    
    @IBAction func singleButtonPressed(_ sender: Any) {
        let calendarView = SinglePickerVC(nibName: nil, bundle: nil)
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
