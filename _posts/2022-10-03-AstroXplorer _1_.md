---
category: tech
title: "AstroXplorer [1]"
date: 2022-10-03
image: /blog/media/3e8c3d_AstroXplorerPodcasts.png
---

AstroXplorer is an application that allows the user the view various data about the Earth and other celestial bodies in our solar system - primarily Earth and Mars. You can find the project on <a data-id="https://github.com/DavidJerman/AstroXplorer" data-type="URL" href="https://github.com/DavidJerman/AstroXplorer">GitHub</a>.

The application consists of multiple tabs, each with its own topic, function. As such it offers the following content:

- Welcome (image)

- Mars Rover Manifest

- Mars Rover Imagery

- EPIC Daily Blue Marble

- Earth View

- Podcasts

## The APIs used here

The primary APIs used here are the <a data-id="https://api.nasa.gov/" data-type="URL" href="https://api.nasa.gov/">NASA Open APIs</a>. The APIs are all free to use and offer a variety of information about Earth, Mars, NASA, space weather etc. The other API used in this project for the Earth View Tab is the <a data-id="https://www.earthdata.nasa.gov/engage/open-data-services-and-software/api/gibs-api" data-type="URL" href="https://www.earthdata.nasa.gov/engage/open-data-services-and-software/api/gibs-api">GIBS API</a>, which provides the user with map tiles for various different maps of Earth (surface temperature, humidity over time etc.).

## Quickly about the code

The app was developed using C++ and the Qt graphics library. Qt is generally speaking, a cross-platform software for creating GUIs, as well as (cross-platform) applications. It offers everything from multi-media processing, supports OpenGL and allows the user to easily create an app interface with just a couple of mouse clicks. It however differs from other similar software in ways such as handling events. The main reason I choose Qt over something similar is mainly the ease of use and its cross-platform nature.

## Welcome Image Tab

The Welcome (image) tab is the default tab, that is opened/selected upon opening the application. It obtains the image of the day and displays it to the user along with the image's description and title, as well as the date of the image of the date - the date usually being the same as the date of opening the application. The image is obtained using the NASA APOD API and thus it takes some time for the image to load. Sometimes there is no image available and there is only a video link. In this case the user is only provided with a video link. The video unfortunately cannot be played directly in the application, since the WebView widget was deprecated in the newer versions of Qt (this project using Qt 6.3 C++ API).

![Image](/blog/media/137d21_AstroXplorerWelcome.png)

*Welcome Image Tab*

## Mars Rover Manifest

The Mars Rover Manifest contains information about the three Mars Rovers: Curiosity, Opportunity and Spirit. Each of the rovers has information about the cameras that it has, maximum number of sols, when the mission has ended and started etc. This information is especially useful when using the Mars Rover Imagery tab to obtain the rover imagery, as that tab requires the user to specify the date(s) of images, that the user wants to view. The API used here is the Mars Rover Imagery API, also provided by NASA.

![Image](/blog/media/f0c999_AstroXplorerMarsRoverManifest.png)

*The Opportunity Rover information shown in the MRM Tab*

## Mars Rover Imagery

![Image](/blog/media/61448f_AstroXplorerMarsRoverImagery.png)

*The Browsing Tab of the MRI Tab - showing images for the Rear Hazard Camera of the Curiosity rover on the 120th sol*

This tab allows the user to explore the Martian rovers' imagery. The user can either browse the photos by a specific date or sol (Martian day) and obtain and view images for a specific date. The user can also download images using the download tab, by selecting the cameras and rovers, as well as specifying what period of time the images should be from. This uses the same API as the Mars Rover Manifest tab. It is to be noted that downloading a lot of images might consume a lot of API calls - which are limited for standard users to 1000 calls per hour. The images are saved in the downloads folder in the root directory of the application, though it might be a good idea to let the user decide where the images should be saved.

## <a href="https://github.com/DavidJerman/AstroXplorer#epic-daily-blue-marble"></a>EPIC Daily Blue Marble

This tab allows the user to obtain images of the Earth captured by the DSCOVR's EPIC imagery instrument. The user can either type in the date - though it is to be noted, that some days have no imagery - or can use the provided slider to choose from the dates that do contain imagery. Two types of images are available: normal and enhanced. The tab also displays information about each image: coordinates, version, and various distances from and to other celestial objects, as well as a title, date and a caption. Usually each date contains multiple images, taken at different times of the day and using the play button, the user can, for most dates, view the animation of a rotating Earth. The API used here is the EPIC API, provided by NASA.

![Image](/blog/media/b834f3_AstroXplorerEPICDailyBlueMarbleSearch.png)

*EPIC Tab downloading the images for a specified date*

![Image](/blog/media/722c20_AstroXplorerEPICDailyBlueMarbleEarthGIF.gif)

*Animation of a rotating Earth*

## <a href="https://github.com/DavidJerman/AstroXplorer#earth-view"></a>Earth View

This is a yet uncomplete tab, however it is going to function similar to Google Maps, except there won't be any advanced features such as route planning, markers etc., however the user will be able to choose among various different maps depicting everything from Earth temperatures, wind speeds to the Earth's relief. The map tiles are loaded on the run and when needed, so the user does not have to load the entire map to view it. The tab uses the GIBS API provided by NASA.

![Image](/blog/media/1d802d_AstroXplorerEarthView.png)

*A map displaying Earth air temperatures*

## <a href="https://github.com/DavidJerman/AstroXplorer#podcasts"></a>Podcasts

This tab allows the user to play podcasts, that can be loaded from RSS files. It works with any RSS file that is properly formatted and has all the audio controls that one would expect - volume control, next/previous song, skip time, save as favorite, search podcast/episode, auto-play etc. This tab does not use an API, since it obtains all the data using the provided RSS files - each file representing a podcast.

![Image](/blog/media/3e8c3d_AstroXplorerPodcasts.png)

*The Podcasts Tab*
