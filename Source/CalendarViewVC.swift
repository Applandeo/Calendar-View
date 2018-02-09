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
    var stackView: UIStackView!
    
    public var cellEventColor: UIColor? = #colorLiteral(red: 0.9888451695, green: 0.9434358478, blue: 0.2444635034, alpha: 1)
    public var cellSelectionType: CalendarStyle.CellSelectionType? = .single
    public var cellShape : CalendarStyle.CellShapeOptions? = .round
    public var cellBackgroundColor : UIColor? = #colorLiteral(red: 0.1594840586, green: 0.1951329112, blue: 0.2491612434, alpha: 1)
    public var cellTodayBackgroundColor : UIColor? = #colorLiteral(red: 0.9905124307, green: 0.9440224767, blue: 0.244779706, alpha: 1)
    public var cellBorderColor : UIColor? = #colorLiteral(red: 0.9888451695, green: 0.9434358478, blue: 0.2444635034, alpha: 1)
    public var headerTextColor : UIColor? = #colorLiteral(red: 0.9888451695, green: 0.9434358478, blue: 0.2444635034, alpha: 1)
    public var cellTextColor : UIColor? = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    public var cellTodayTextColor : UIColor? = #colorLiteral(red: 0.1581553817, green: 0.1959567666, blue: 0.2506937683, alpha: 1)
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
                
        calendarView.delegate = self
        calendarView.showEkEvents = true
        calendarView.direction = .horizontal
        calendarView.allowMultipleSelection = true
        calendarView.backgroundColor = #colorLiteral(red: 0.1594840586, green: 0.1951329112, blue: 0.2491612434, alpha: 1)
        
        let today = Date()
        calendarView.setCurrentDate(date: today, animated: false)

        CalendarStyle.cellEventColor = cellEventColor!
        CalendarStyle.cellSelectionType = cellSelectionType!
        CalendarStyle.cellShape = cellShape!
        CalendarStyle.cellBackgroundColor = cellBackgroundColor!
        CalendarStyle.cellTodayBackgroundColor = cellTodayBackgroundColor!
        CalendarStyle.cellBorderColor = cellBorderColor!
        
        CalendarStyle.headerTextColor = headerTextColor!
        CalendarStyle.cellTextColor = cellTextColor!
        CalendarStyle.cellTodayTextColor = cellTodayTextColor!
        CalendarStyle.textAlligment = .left
        
    }
    
    func setupUI() {
        
        self.calendarView = CalendarView(frame: .zero)
        self.okButton = UIButton()
        self.cancelButton = UIButton()
        self.stackView = UIStackView()
        
        okButton.setTitle("Ok", for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        
        okButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        
        okButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        
        cancelButton.titleLabel?.textAlignment = .center
        okButton.titleLabel?.textAlignment = .center
        
        stackView.distribution = .fillEqually
        
        cancelButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        okButton.backgroundColor = #colorLiteral(red: 0.12773031, green: 0.6113714576, blue: 0.9892446399, alpha: 1)
        
        self.view.addSubview(calendarView)
        self.view.addSubview(stackView)
        self.stackView.addArrangedSubview(okButton)
        self.stackView.addArrangedSubview(cancelButton)

        self.setupConstraints()
    }
    
    func setupConstraints() {
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        calendarView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        calendarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -150).isActive = true
        calendarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        calendarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        
        stackView.leadingAnchor.constraint(equalTo: self.calendarView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.calendarView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.calendarView.bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience public init (cellEventColor: UIColor?,
                            cellSelectionType: CalendarStyle.CellSelectionType?,
                            cellShape: CalendarStyle.CellShapeOptions? ,
                            cellBackgroundColor: UIColor?,
                            cellTodayBackgroundColor: UIColor? ,
                            cellBorderColor: UIColor?,
                            headerTextColor: UIColor?,
                            cellTextColor: UIColor?,
                            cellTodayTextColor: UIColor?) {
        
        self.init()

        self.cellEventColor = cellEventColor
        self.cellSelectionType = cellSelectionType
        self.cellShape = cellShape
        self.cellBackgroundColor = cellBackgroundColor
        self.cellTodayBackgroundColor = cellTodayBackgroundColor
        self.cellBorderColor = cellBorderColor
        self.headerTextColor = headerTextColor
        self.cellTextColor = cellTextColor
        self.cellTodayTextColor = cellTodayTextColor
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
    
    deinit {
        print("DEINIT")
    }
    
}

