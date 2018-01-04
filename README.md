# ALCalendar
---
 Simple, customizable calendar for your app!


## Installing

###### CocoaPods:
    
        use_frameworks!
        target ‚<Your target Name>’ do
        pod 'ALCalendar'
    end



#### Setup

Simply add `UIView` on the `ViewController` and subclass it as `CalendarView`

In the ViewController connect view using IBOutlet

    @IBOutlet weak var calendarView: CalendarView!

or simply add `CalendarView`

	var calendarView = CalendarView()

After that in viewDidLoad() simply set delegate, current date and ... that's all! You have fully working calendar 😎

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.delegate = self
        
        let today = Date()
        calendarView.setDisplayDate(date: today, animated: false)
    }
 
	

## Styling
We have dedicated enum `CalendarStyle` for styling of our calendar.
Properties that you can modify:

    cellEventColor
    cellSelectionType
    cellShape
    cellBackgroundColor
    cellTodayBackgroundColor
    cellBorderColor
    headerTextColor
    cellTextColor
    cellTodayTextColor
    
#### Scroll Direction
You can change scrolling direction 
	`calendarView.scrollDirection = .horizontal ` or  `calendarView.scrollDirection.vertical`
    
#### EkEvents 

Simply set `calendarView.loadEkEvents = true` to load EKEvents

#### Selection Type
##### Multiple 
`CalendarStyle.cellSelectionType = .multiple`
##### Single 
`CalendarStyle.cellSelectionType = .single`
##### Range
`CalendarStyle.cellSelectionType = .range`
	
#### Cell Shape

##### Round
`CalendarStyle.cellShape = .round`
##### Square
`CalendarStyle.cellShape = .square`




## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
