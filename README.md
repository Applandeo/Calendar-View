# ALCalendar

 Simple, customizable calendar for your app!


## Installing

###### CocoaPods:
    
   	platform :ios, '10.0'
	use_frameworks!

	target '<Your Target Name>' do
    	pod 'Alamofire', '~> 4.5'
	end

After that simply go with:

	pod install



#### Setup

Simply add `UIView` on the `ViewController` and subclass it as `CalendarView`

In the ViewController connect view using IBOutlet

    @IBOutlet weak var calendarView: CalendarView!

or simply add `CalendarView` and set frame or constraints

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
You can change scroll direction 
	`calendarView.scrollDirection = .horizontal ` or  `calendarView.scrollDirection.vertical`
    
#### EkEvents 

Simply set `calendarView.loadEkEvents = true` to load EKEvents

#### Selection Type
##### Multiple 
Simply set

`CalendarStyle.cellSelectionType = .multiple`

For multiple cell selection
##### Single 
If you want to choose just one cell set

`CalendarStyle.cellSelectionType = .single`
##### Range
For range picking set

`CalendarStyle.cellSelectionType = .range`
	
#### Cell Shape
You can choose cell shape

##### Round
`CalendarStyle.cellShape = .round`
##### Square
`CalendarStyle.cellShape = .square`




## License

	Copyright 2017, Applandeo sp. z o.o.

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	   http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
