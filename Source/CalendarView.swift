//
//  CalendarView.swift
//  LandeoCalendar
//
//  Created by Sebastian Grabiński on 21.09.2017.
//  Copyright © 2017 Sebastian Grabiński. All rights reserved.
//

import UIKit
import EventKit

    /**
        An instance of ALCalendarView, or simply calendarView which
        displays and interacts grid view of Day-Cells.
    */

public class CalendarView: UIView {

    public weak var delegate : CalendarViewDelegate?
    public var eventsLoader = EventsLoader()
    var calendarModel = CalendarModel()
    
    lazy var calendar : Calendar = {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = TimeZone(abbreviation: "UTC")!
        return gregorian
    }()
    
    /**
        Calendar scroll direction
        - .horizontal
        - .vertical
    */
    
    public var direction : UICollectionViewScrollDirection = .horizontal {
        didSet {
            flowLayout.scrollDirection = direction
            self.collectionView.reloadData()
        }
    }
    
    /**
        Show EKEvents on map.
        Set true to show dotview under day label on cell representing event
    */
    
    public var showEkEvents : Bool = false {
        didSet {
            if showEkEvents {
                self.loadEKEvents()
            }
        }
    }
    
    /**
        Set property as true to highlight today cell
    */
    
    public var showToday: Bool = true {
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
            DispatchQueue.main.async { self.reloadData() }
        }
    }
    
    public var allowMultipleSelection : Bool = true {
        didSet {
            self.collectionView.allowsMultipleSelection = allowMultipleSelection
        }
    }
    
    //Initializer used to create calendarView instance
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.layoutIfNeeded()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
        self.layoutIfNeeded()
    }
    
    // MARK: Create Subviews
    var headerView: CalendarHeaderView!
    var collectionView: UICollectionView!

    private func setup() {
        
        self.setStartDate()
        self.setEndDate()
        self.initModel()
        
        self.clipsToBounds = true
        
        self.headerView = CalendarHeaderView(frame:CGRect.zero)
        self.addSubview(self.headerView)
        
        let layout = CalendarFlowLayout()
        layout.scrollDirection = self.direction;
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = self.cellSize(in: self.bounds)
        
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.addSubview(self.collectionView)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        setupCollectionView(layout: layout)
    }
    
    //Setup collectionView properties
    fileprivate func setupCollectionView(layout: CalendarFlowLayout) {
        self.collectionView.isPagingEnabled = true
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.register(DayCell.self, forCellWithReuseIdentifier: DayCell_ID)
        self.reloadData()
        checkSelectionType()
    }
    
    //Check collectionView selection type
    private func checkSelectionType() {
        switch CalendarStyle.cellSelectionType {
        case .single:
            self.collectionView.allowsMultipleSelection = false
        case .multiple:
            self.collectionView.allowsMultipleSelection = true
        case .range:
            print("")
        }
    }
    
    func loadEKEvents() {
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
    
    //Override flowLayout with custom one
    fileprivate var flowLayout: CalendarFlowLayout {
        return self.collectionView.collectionViewLayout as! CalendarFlowLayout
    }

    fileprivate func cellSize(in bounds: CGRect) -> CGSize {
        return CGSize(width: frame.size.width / 7.0, height: (frame.size.height - CalendarStyle.headerHeight) / 6.0)
    }
    
    fileprivate func resetCurrentDate() {
        guard let currentDate = self.currentDate else { return }
        self.collectionView.setContentOffset(
            self.scrollViewOffset(for: currentDate),
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
    
    fileprivate func initModel() {
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

//Public methods

extension CalendarView {
    
    public func reloadData() {
        self.collectionView.reloadData()
    }
    
    public func setCurrentDate(date: Date, animated: Bool = false) {
        guard (date > calendarModel.startDate) && (date < calendarModel.endDate) else { return }
        
        self.collectionView.setContentOffset(
            self.scrollViewOffset(for: date),
            animated: false
        )
        self.displayDateOnHeader(date)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.headerView.frame = CGRect( x:0.0, y:0.0, width: self.frame.size.width,height: CalendarStyle.headerHeight)
        self.collectionView.frame = CGRect(x: 0.0, y: CalendarStyle.headerHeight, width: self.frame.size.width, height: self.frame.size.height - CalendarStyle.headerHeight)
        flowLayout.itemSize = self.cellSize(in: self.bounds)
        
        self.resetCurrentDate()
        guard let current = currentDate else { return }
        self.setCurrentDate(date: current)
    }
    
}
