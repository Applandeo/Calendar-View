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
        let vc = CalendarViewVC(cellEventColor: #colorLiteral(red: 0.9905124307, green: 0.9440224767, blue: 0.244779706, alpha: 1), cellSelectionType: .single, cellShape: .round , cellBackgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), cellTodayBackgroundColor: #colorLiteral(red: 0.9905124307, green: 0.9440224767, blue: 0.244779706, alpha: 1), cellBorderColor: #colorLiteral(red: 0.9905124307, green: 0.9440224767, blue: 0.244779706, alpha: 1), headerTextColor: #colorLiteral(red: 0.9905009866, green: 0.9394227862, blue: 0.3849801421, alpha: 1), cellTextColor: #colorLiteral(red: 0.9996390939, green: 1, blue: 0.9997561574, alpha: 1), cellTodayTextColor: #colorLiteral(red: 0.1594840586, green: 0.1951329112, blue: 0.2491612434, alpha: 1))
        vc.modalPresentationStyle = .currentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6888204225)
        present(vc, animated: true, completion: nil)
    }
    
}

//MARK: - Presentation section

extension CalendarPicker {
    
    @IBAction func singleButtonPressed(_ sender: Any) {
        let calendarView = self.storyboard?.instantiateViewController(withIdentifier: "SinglePickerVC") as! SinglePickerVC
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
