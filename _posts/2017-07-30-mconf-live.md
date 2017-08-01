---
date: 2017-01-30
title: About Mconf-Live
categories:
  - Getting Started
  - Mconf-Live
set: getting-started
set_order: 2
description: All about Mconf-Live, Mconf's web conference server
type: Document
---

## About

Mconf-Live is an open source web conference system based on [BigBlueButton](http://bigbluebutton.org). It is part of the Mconf project, which includes a web portal with social network characteristics, a mobile client and a Global Webconference Network with load balancing, real-time monitoring and usage reports.

## Installation

* In a standalone server (similar to how BigBlueButton is usually installed), use the instructions provided in [this repository](https://github.com/mconf-cookbooks/mconf-live-solo).


## Changelog

### mconf-live0.7.1 (July 27th 2015)
* Improved Spanish translation
* Fixed the bug when using forceListenOnly=true, and the users were not able to share microphone
* Better background image loading

### mconf-live0.7.0 (July 19th 2015)
* Based on [BigBlueButton 0.9.0](https://github.com/bigbluebutton/bigbluebutton/releases/tag/v0.9.0-release) ([see the release notes](http://code.google.com/p/bigbluebutton/wiki/ReleaseNotes))
* Refactoring of the layouts module
* Faster WebRTC connection, with auto-reconnect

### mconf-live0.6.2 (February 6th 2015)
* Support for all new features introduced on [BigBlueButton 0.9.0 Beta](https://github.com/bigbluebutton/bigbluebutton/tree/ab9753344aaca7d77aa7c4ab1cf82068a5d4bb7b) ([see the release notes](http://code.google.com/p/bigbluebutton/wiki/ReleaseNotes))
* Keep the support for the features that were part of the previous release
* Ability to download the chat
* Ability to create multiple shared notes windows

### mconf-live0.5.3 (May 16th 2014)
* Proper detection of the Java version (needed for desktop sharing)
* Improved the desktop sharing windows usability
* Interactive full screen

### mconf-live0.5.2 (April 2nd 2014)
* New video dock without the internal MDI windows
* Video parametrization is now done by profiles defined in an XML file

### mconf-live0.5.1 (February 27th 2014)
* New parametrization on config.xml to add a background image on the main canvas, a custom copyright message and a logo in the top left corner

### mconf-live0.5.0 (January 13th 2014)
* Support for audio WebRTC on Google Chrome
* Possibility to download the presentations during the session. Presenter is able to allow or not the users to download his presentation file

### mconf-live0.4.3 (December 2nd 2013)
* Support for presenter hardware to change the slides of the presentation (as well as the arrow keys)
* Possibility to download the HTML5 playback to a local storage and watch it as the normal online presentation playback (Mozilla Firefox only)

### mconf-live0.4.2 (November 8th 2013)
* Updated the base version for BigBlueButton 0.81 (final release)
* Ability for the moderator to change the role of other participants (promote viewer to moderator, or demote moderator do viewer)

### mconf-live0.4.1 (October 18th 2013)
* Updated the base version for BigBlueButton 0.81 RC3
* New button on the UI to control the recording (start and stop)
* New possibilities of participants status (raise hand, agreed, disagreed, be right back, speak slower, speak faster, speak louder, speak softer, smiles)

### mconf-live0.4 (October 2nd 2013)
* Support for all new features introduced on BigBlueButton 0.81 RC2 ([see the release notes](http://code.google.com/p/bigbluebutton/wiki/ReleaseNotes))
* Keep the support for the features that were part of the previous release

### mconf-live0.3.4 (August 9th 2013)

* Better sync of the recordings playback (audio-video and video-video)
* Included the desktop sharing in the recordings
* Possibility for the moderator to remember the choice about the guests (allow or deny all)
* Better shared notes module: no need to an external notes server, save notes to file, minor fixes)

### mconf-live0.3.3 (June 6th 2013)

* Fixed the duplicated audio when the user pauses the playback
* Enable the recording server to host recordings from more than one web portal
* Enable the ability to specify the start time of the recording playback (using &t=0h0m0s, just like YouTube)
* Fixed bugs on recordings processing scripts (updated the rap scripts to BigBlueButton master)

### mconf-live0.3.2 (June 2nd 2013)

* Revisited the interface to start transmitting audio and video, making the actions more explicit in text

### mconf-live0.3.1 (May 17th 2013)

* Upgraded the version of the desktop sharing applet from 0.8 to 0.8.1, which consumes much less network resources
* Fixed the bug that was preventing users on Windows to listen the conference if they don't have a microphone connected

### mconf-live0.3beta5 (April 13th 2013)
* Fixed the bug that was preventing the deskshare window to close on participants
* Fixed the bug that was preventing Android client users to join the voice conference properly on servers behind NAT
* Fixed the race condition that was making possible to create more than one global audio stream on the server
* Removed the FreeSWITCH sounds like "You are now muted" and "You are currently the only person in this conference"
* Changed the interface of the Network Monitor that was annoying some users

### mconf-live0.3beta1 to mconf-live0.3beta4
* Source code: https://github.com/mconf/bigbluebutton/tree/mconf-live0.3
* Based on BigBlueButton 0.8
* New kind of participant that only receives audio and video but doesn't transmit anything until he wants to (details in [this blog post](http://mconf.org/posts/2013/01/11/mconf-live-0-3/))
* Preliminary version of the network monitor, that indicates to the user how much bandwidth the webconference is consuming and the latency between the user and the server
* Moderadors and viewers have the ability to select the camera resolution they want to broadcast (only available for moderators on previous versions)
* Ability to share more than one camera at the same time
* Bug fixes

### mconf-live0.2 (9th November 2012)
* Source code: https://github.com/mconf/bigbluebutton/tree/mconf-live0.2
* Based on BigBlueButton 0.8
* Layout manager - users can set pre-defined window layouts independently, and moderators can lock the layout of everyone in the session
* Guest role - moderators must allow or deny the presence of a given user that tries to join a session as guest
* Fully automation of the installation and updates of the software and configurations using Chef (http://www.opscode.com/chef/)

### bbb0.8-mconf0.1 (May 2012)
* Source code: https://github.com/mconf/bigbluebutton/tree/mconf-bbb0.8
* Based on BigBlueButton 0.8 Beta 2
* Notes window, an area for text collaboration
* Preliminary version of the layout manager - users can set pre-defined window layouts independently

## Roadmap

* _To be defined..._

## BigBlueButton

BigBlueButton (BBB) is the base webconferencing system used by Mconf. It is developed in Java and Flash, and is one of the best open source webconferencing softwares (if not the best) today.

* [BigBlueButton.org](http://www.bigbluebutton.org/)
* [BigBlueButton Docs](http://docs.bigbluebutton.org)
