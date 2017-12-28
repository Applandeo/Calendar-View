//
//  CalendarView.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 21.09.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit
import EventKit

class CalendarView: UIView {

    var delegate : CalendarViewDelegate?
    var eventsLoader = EventsLoader()
    var calendarModel = CalendarModel()
    
    lazy var calendar : Calendar = {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = TimeZone(abbreviation: "UTC")!
        return gregorian
    }()
    
    var direction : UICollectionViewScrollDirection = .horizontal {
        didSet {
            flowLayout.scrollDirection = direction
            self.collectionView.reloadData()
        }
    }
    
    var showEkEvents : Bool = false {
        didSet {
            if showEkEvents {
                self.loadEvents()
            }
        }
    }
    
    var showToday: Bool = true {
        didSet {
            self.setCurrentDate(date: today, animated: false)
        }
    }

    let today = Date()
    public var currentDate: Date?
    
    var events: [CalendarEvent] = [] {
        didSet {
            calendarModel.eventsByIndexPath.removeAll()
            for event in events {
                guard let indexPath = self.indexPathForDate(event.startDate) else { continue }
                var eventsForIndexPath = calendarModel.eventsByIndexPath[indexPath] ?? []
                eventsForIndexPath.append(event)
                calendarModel.eventsByIndexPath[indexPath] = eventsForIndexPath
            }
            DispatchQueue.main.async { self.collectionView.reloadData() }
        }
    }

    var allowMultipleSelection : Bool = false {
        didSet {
            self.collectionView.allowsMultipleSelection = allowMultipleSelection
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
        self.layoutIfNeeded()
    }
    
    // MARK: Create Subviews
    var headerView: CalendarHeaderView!
    var collectionView: UICollectionView!

    private func setup() {
        self.setupModel()
        self.setStartDate()
        self.setEndDate()
        self.clipsToBounds = true
        
        self.headerView = CalendarHeaderView(frame:CGRect.zero)
        self.addSubview(self.headerView)
        
        let layout = CalendarFlowLayout()
        layout.scrollDirection = self.direction;
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = self.cellSize(in: self.bounds)
        
        setupCollectionView(layout: layout)
    }
    
    fileprivate func setupCollectionView(layout: CalendarFlowLayout) {
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.isPagingEnabled = true
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.register(DayCell.self, forCellWithReuseIdentifier: DayCell_ID)
        self.addSubview(self.collectionView)
        checkSelectionStyle()
    }
    
    fileprivate func checkSelectionStyle() {
        switch CalendarStyle.cellSelectionType {
        case .single:
            self.collectionView.allowsMultipleSelection = false
        case .multiple:
            self.collectionView.allowsMultipleSelection = true
        case .range:
            print("")
        }
    }
    
    private func loadEvents() {
        var startDateComponents = DateComponents()
        startDateComponents.year = -2
        guard let startDate = self.calendar.date(byAdding: startDateComponents, to: today) else { return }
        
        var endDateComponents = DateComponents()
        endDateComponents.year = 2
        guard let endDate = self.calendar.date(byAdding: endDateComponents, to: today) else { return }
        
        eventsLoader.load(from: startDate, to: endDate) { (event) in
            if let events = event {
                self.events = events
            }
        }
    }
    
    fileprivate var flowLayout: CalendarFlowLayout {
        return self.collectionView.collectionViewLayout as! CalendarFlowLayout
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.headerView.frame = CGRect( x:0.0, y:0.0, width: self.frame.size.width,height: CalendarStyle.headerHeight)
        self.collectionView.frame = CGRect(x: 0.0, y: CalendarStyle.headerHeight, width: self.frame.size.width, height: self.frame.size.height - CalendarStyle.headerHeight)
        flowLayout.itemSize = self.cellSize(in: self.bounds)
        
        self.resetDisplayDate()
        guard let displayDate = currentDate else { return }
        self.setCurrentDate(date: displayDate)
    }
    
    private func cellSize(in bounds: CGRect) -> CGSize {
        return CGSize(width: frame.size.width / 7.0, height: (frame.size.height - CalendarStyle.headerHeight) / 6.0)
    }

    func reloadData() {
        self.collectionView.reloadData()
    }
    
    func setCurrentDate(date: Date, animated: Bool = false) {
        guard (date > calendarModel.startDate) && (date < calendarModel.endDate) else { return }
        
        self.collectionView.setContentOffset(
            self.scrollViewOffset(for: date),
            animated: false
        )
        self.displayDateOnHeader(date)
    }
    
    fileprivate func resetDisplayDate() {
        guard let displayDate = self.currentDate else { return }
        self.collectionView.setContentOffset(
            self.scrollViewOffset(for: displayDate),
            animated: false
        )
    }
    
    fileprivate func scrollViewOffset(for date: Date) -> CGPoint {
        var point = CGPoint.zero
        guard let sections = self.indexPathForDate(date)?.section else { return point }
        let collectionViewWidth = self.collectionView.frame.size.width
        let collectionViewHeight = self.collectionView.frame.size.height
        
        switch self.direction {
        case .horizontal:
            point.x = CGFloat(sections) * collectionViewWidth
        case .vertical:
            point.y = CGFloat(sections) * collectionViewHeight
        }
        return point
    }
    
    fileprivate func setupModel() {
        calendarModel.eventsByIndexPath = [IndexPath:[CalendarEvent]]()
        calendarModel.selectedIndexPaths = [IndexPath]()
        calendarModel.selectedDates = [Date]()
        calendarModel.monthInfoForSection = [Int:(firstDay:Int, daysTotal:Int)]()
    }
    
    fileprivate func setStartDate() {
        var dateComponents = DateComponents()
        dateComponents.year = -10
        guard let startDate = self.calendar.date(byAdding: dateComponents, to: today) else { return }
        calendarModel.startDate = startDate
    }
    
    fileprivate func setEndDate() {
        var dateComponents = DateComponents()
        dateComponents.year = 10
        guard let endDate = self.calendar.date(byAdding: dateComponents, to: today) else { return }
        calendarModel.endDate = endDate
    }
}
