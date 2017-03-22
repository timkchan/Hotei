# Hotei - Wellness Activity Recommendation
![](figures/screen.png?raw=true)
<!-- ![](figures/demo.png?raw=true) -->

### 1. Overview of Hotei
The issues of stress and general emotional well being are important in the context of student life where almost 63% suffer from stress, and 27% of all students suffer from a mental problem of some sort. This project aims to help manage a student’s stress levels whilst helping them become more aware of their emotional well being. This will be done through the development of a smartphone app, making use of heart rate data from a wearable device to automatically detect moments of stress, a recommendation system to provide tailored activity suggestions to help them relieve such stress, and ultimately improve their over all emotional well being.

### 2. Hardware
* iPhone (iOs 10+)
* Polar H7 Heart Rate Sensor
* Apple Watch (Optional)

### 3. Files

#### Files under /Hotei (not all are shown):
The main project source code resides here.

* `Hotei.xcworkspace`:                  Entry point for iOS project. (Open this instead of .xcodeproj)

* `Hotei/`:                             Subdirectory holding iOS app development files
    * `Main.storyboard`:                UI Story board of iPhone

* `HoteiW/`:                            Subdirectory holding WatchOS app development storyboard
    * `Interface.storyboard`:           UI Story board of Apple Watch

* `HoteiW Extension/`:                  Subdirectory holding WatchOS app development files
    * `InterfaceController.swift`:      Watch logic

* `Pods/`:                              Subdirectory holding CocoaPods
    * `OpenCV/`:                        Subdirectory holding OpenCV lib
    * `Charts/`:                        Subdirectory holding Charts lib

* `Podfile`:                            CocoaPod setup file (Instrustion for CocoaPods to install external lib correctly)

#### Files under /Database (not all are shown):  // To be completed
The database source code resides here.

* `???`:                  ???

* `???/`:                             ??
    * `???`:                ??

#### Files in the root directory (not all are shown):
Auxiliary files go in here.

* `Coursework Instructions.pdf`:        Goal and instruction for this project

* `figures/`:                  			Subdirectory holding figures used in the report:
    * `System-overview.jpg`:   			High-level view of the ststem
    * `sysdia.jpg`:       				Flowchart of the Feedback State
    * `database.jpg`:    				Database relationships
    * `context.png`:          			Context fitering
    * `conf_user.PNG`:   				Confusion matrix
    * `screen.png`:   					Screenshots of the app on iPhone and AppleWatch

* `survey_results.ods`:					Training data for recommendations

* `README.md`:                          This file (readme)


### 4. Dependency
Notice that the project uses [CocoaPods] for installing external library. Please have it installed in advance.

* `Charts`:                            [Charts] lib for displaying charts
* `OpenCV`:                            [OpenCV] lib for machine learning


### 5. Running Hotei

Installing CocoaPods:

```sh
$ sudo gem install cocoapods
```

Clone this project
```sh
$ git clone https://github.com/timkchan/Hotei.git
```

Install dependencies (in repo root dir):
```sh
$ cd Hotei
$ pod install
```

Open Xcode project (in repo root dir):
```sh
$ cd Hotei
$ open Hotei.xcworkspace
```

Project uses CoreData and external libraries. It's recommended to clean and rebuild the project. Now the app should be ready to run on a simulator or an actual device.


### 6. Demo video   //Will be uploaded on 27thMar, 17
* Youtube: [View Video]
* Download: [Download Video]

### 7. Contribution
This is a 4th year class (EE4.67 – Mobile Healthcare and Machine Learning) project at Imperial College London supervised by prof. Yiannis Demiris

Team members:
* [Tim K. Chan](https://github.com/timkchan)
* [Ryan Dowse](https://github.com/RDowse)
* [Akshay Garigiparthy](https://github.com/Gar1G)
* [Sagar Patel](https://github.com/sagarpatel9410)
* [Nick Robertson](https://github.com/nar213/)


[View Video]: <???>
[Download Video]: <???>
[CocoaPods]: <https://cocoapods.org/>
[Charts]: <https://cocoapods.org/pods/Charts>
[OpenCV]: <https://cocoapods.org/pods/OpenCV>