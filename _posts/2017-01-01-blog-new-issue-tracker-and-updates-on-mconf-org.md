---
date: 2016-07-31
title: Blog post - New issue tracker and updates on Mconf.org
categories:
  - Archives
description: Blog post from 2016-07-31
type: Document
archived: true
---

In the past weeks, Mconf’s issue tracking has been migrated from our old internal Redmine server (that used to be on the domain “dev.mconf.org”) to GitHub. We needed more stability and a centralized point for code, issues and wiki, and GitHub is great for that. We now make full use of issues and pull requests in GitHub for all of our projects.

You can find the list of issues for each project in their GitHub Page. The main projects are:

* Mconf-Live: https://github.com/mconf/bigbluebutton/issues
* Mconf-Web: https://github.com/mconf/mconf-web/issues
* Mobile client: https://github.com/mconf/bbb-air-client

Moreover, a few days ago Mconf.org has received a few upgrades that improve both the web portal and the web conference backend. Here’s a short summary of what has been added in these updates.

Mconf-Web, the web portal, is now on version 2.2.0, a second update over the version 2.0.0 that was released a few months ago after several months of development. The latest update deployed to Mconf.org includes a few important things:

* Removal of the features “private messages”, “news”, and “spam reporting”. These features were on Mconf-Web since it first started as a customized version of the open source software Global Plaza. With years of development and usage, we realized that they were very underused and/or were not designed in the way we wanted them to be. This update removes those features, that in the future might be recreated, redesigned and implemented in a way we believe to be more useful for the users. This is also aligned with the goal of making the application simpler and easier to use, since it removes things that were actually more of a distraction than anything.
* Added translations to German and Spanish, thanks to the community of translator on Transifex!
* Improvements in the speed of some pages, specially the list of spaces. This page used to load very slowly since there are thousands of spaces in Mconf.org, but now the queries were improved and it now loads as fast as any other page.
* Several security fixes, bug fixes and code improvements in general. Upgraded libraries and refactoring of (usually old) code always results in gains in security and stability.

As for the web conference system, Mconf-Live, the development has also been going strong in the past months. The latest changes made available on Mconf.org are mostly back-end improvements, most of them related to the stability of the application. The biggest feature change in the past months is certainly the adoption of WebRTC for audio, that improved the quality of the conferences a lot.

The next version of Mconf-Live, to be released in the next few months, will be based on BigBlueButton 1.0, bringing with it all the features and improvements made on BigBlueButton 1.0 over 0.9 and still keeping all the features that are still unique to Mconf-Live.

To see more, sign in to your Mconf.org account (or create a new one) and try it out!

If you have comments or suggestions, reach us out on our contact page. For bugs and features, drop by our GitHub page to create an issue.
