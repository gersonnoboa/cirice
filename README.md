#  Cirice

A project that uses the Vision framework by Apple to detect faces and texts in an image supplied by the visitor through the camera. The project consists of two parts:
* An SDK, called CiriceSDK, which wraps around the Vision framework in order to provide face and text detection.
* An app, called Cirice, which integrates and calls this SDK to display the functionality to users.

## Origins of the name

[Cirice](https://www.youtube.com/watch?v=-0Ao4t_fe0I) is a song by the excellent Swedish metal band Ghost. According to [Loudwire](https://loudwire.com/ghost-2016-best-metal-performance-grammy/), Cirice earned the 2016 Grammy Award for Best Metal Performance. For those who attended the Metallica concert in Tartu in 2019, Cirice was part of the [setlist](https://www.setlist.fm/setlist/ghost/2019/raadi-airfield-tartu-estonia-739eca81.html) played by them. 

There's no additional hidden reason for the name; I just like the song and thought the name was cool.

## How to run the app

In order to make it as easy as possible for someone to test the whole app, CiriceSDK is a Swift package that is contained in the project. Thus, no additional setup of first or third-party dependency managers is needed. Only download the repository, build, and run. 

Because of the fact that a camera is used to take a picture, it is not recommended to use the app on a simulator. While it will not crash, the functionality is severely limited.

## Improvements

As I already used quite a sizeable amount of time doing this app, I have written some ideas for improvement instead of implementing them.

* The Cirice app has no tests, but the CiriceSDK does, as per internal requirements. However, because of the architectural decisions, testing the Cirice app would be straightforward, if time consuming.
* Because Vision is a framework and deals with CGImages, there are some errors that are hard to get, and thus I haven't been able to write tests for some of them. For example, parts where the UIImage is translated into a CGImage are not tested because I wasn't able to determine what makes this conversion to fail. This brings down the code coverage quite a bit. However, the code that doesn't deal with Vision directly is well tested.
* The application tries to use VIP (also called Clean Swift) as a basis for the architecture. It doesn't follow it to the letter, but the concepts are there. However, VIP didn't translate well to the CiriceSDK, which is why only the interactor was used. Also, because the `MainViewController` is so small, having an interactor and a presenter would have done more harm than good. Thus, it looks a little bit sloppy, but I preferred this instead of trying to force design elements that made no sense.
* As always, the UI can be improved.
* I decided to keep two different interactors for face and text extraction, even though they are small enough that they could all go to a single one.
* I didn't use SwiftLint, but I am satisfied with the formatting.