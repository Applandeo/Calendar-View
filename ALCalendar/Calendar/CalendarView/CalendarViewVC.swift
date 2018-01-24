//
//  CalendarViewVC.swift
//  LandeoCalendar
//
//  Created by sebastian on 22.01.2018.
//  Copyright © 2018 Sebastian Grabiński. All rights reserved.
//

import UIKit

public class CalendarViewVC: UIViewController, CalendarViewDelegate {
    
    var calendarView: CalendarView!
    var okButton: UIButton!
    var cancelButton: UIButton!
    
    public var cellEventColor: UIColor!
    public var cellSelectionType: CalendarStyle.CellSelectionType!
    public var cellShape : CalendarStyle.CellShapeOptions!
    public var cellBackgroundColor : UIColor!
    public var cellBorderColor : UIColor!
    public var headerTextColor : UIColor!
    public var cellTextColor : UIColor!
    public var cellTodayTextColor : UIColor!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
            
        calendarView.delegate = self
        calendarView.showEkEvents = true
        calendarView.direction = .horizontal
        
        let today = Date()
        calendarView.setCurrentDate(date: today, animated: false)
        
        CalendarStyle.cellEventColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        CalendarStyle.cellSelectionType = .single
        CalendarStyle.cellShape = .round
        CalendarStyle.cellBackgroundColor = UIColor.clear
        CalendarStyle.cellTodayBackgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        CalendarStyle.cellBorderColor = #colorLiteral(red: 0.1664928794, green: 0.7488424182, blue: 0.8295294642, alpha: 1)
        CalendarStyle.headerTextColor = UIColor.black
        CalendarStyle.cellTextColor = UIColor.black
        CalendarStyle.cellTodayTextColor = UIColor.white
    }
    
    func setupUI() {
        
        self.calendarView = CalendarView(frame: .zero)
        self.okButton = UIButton()
        self.cancelButton = UIButton()
        
        okButton.setTitle("Ok", for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        
        okButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        
        okButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        
        self.view.addSubview(calendarView)
        self.view.addSubview(okButton)
        self.view.addSubview(cancelButton)
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        calendarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        calendarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -120).isActive = true
        calendarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        calendarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        okButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 8).isActive = true
        okButton.leadingAnchor.constraint(equalTo: calendarView.leadingAnchor).isActive = true
        okButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        cancelButton.topAnchor.constraint(equalTo: self.calendarView.bottomAnchor, constant: 8).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: self.calendarView.trailingAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(cellEventColor: UIColor, cellSelectionType: CalendarStyle.CellSelectionType, cellShape: CalendarStyle.CellShapeOptions, cellBackgroundColor: UIColor, cellTodayBackgroundColor: UIColor, cellBorderColor: UIColor, headerTextColor: UIColor, cellTextColor: UIColor, cellTodayTextColor: UIColor) {
        self.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTap() {
        dismiss(animated: true, completion: nil)
    }

    //MARK: - Delegate
    public func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
        print("Did Select: \(date) with \(events.count) events")
        for event in events {
            print("\t\"\(event.title)\" - Starting at:\(event.startDate)")
        }
    }
    
    public func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        print("Month : - \(date)")
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

