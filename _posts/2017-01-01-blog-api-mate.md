---
date: 2012-12-03
title: Blog post - API Mate
categories:
  - Archives
description: Blog post from 2012-12-03
type: Document
archived: true
---

A while ago, a tool called API Buddy (see more about it here and here, and access the application here) was developed by Omar Shamas to help in the access to BigBlueButton”s API. It has been extremely useful for us during development and also for the monitoring of our servers.

A few months ago we developed a similar application that was integrated in our load balancer. Since it”s tightly integrated with the load balancer and our network”s infrastructure, it is only available to administrators. But today we are releasing it for everyone to use!

The application is available in the link below and it follows the same idea of the API Buddy: it provides links to all API calls casino online in a BigBlueButton or Mconf-Live server. To avoid confusion, the application was named API Mate — another idea borrowed from the API Buddy :)

* [Access the API Mate here](http://mconf.org/tools/api-mate)

![](http://mconf.org/wp-content/uploads/2012/12/Screenshot-from-2012-12-02-221930.png)

It has a few things more than the API Buddy though:

* Updated with all calls in BigBlueButton 0.8 (recordings, for instance).
* The user casino online can set “meta_” parameters or even any other custom parameter you might need (useful when developing something new in the API).
* Has links to the mobile API and links to join a conference from Mconf-Mobile or BBB-Android (links with the protocol “bigbluebutton://”).
* The interface is more dynamic: the links are automatically updated when the parameters are updated by the user.

Moreover, the API Mate was developed using a small javascript library that we called bigbluebutton-api-js. In short, it is a library that gets the address and the salt of your web conference server and returns links to all API calls possible. Getting the links, you just need to show them in an interface such as the API Mate”s. This library is open source and it”s available on GitHub.

![](http://mconf.org/wp-content/uploads/2012/12/Screenshot-from-2012-12-02-230212.png)

We hope this tool will be as useful for other people as it is being to us. Ideas and suggestions for improvement are always welcome, of course!
