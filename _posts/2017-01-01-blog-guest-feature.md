---
date: 2013-03-26
title: Blog post - Guest feature
categories:
  - Archives
description: Blog post from 2013-03-26
type: Document
archived: true
---

The “guest” feature was added to Mconf-Live at the end of the last year and it adds an important feature to the system: it allows a moderator to control who can access the meeting from within a meeting.

When a guest user wants to join in the meeting he will need that a user with moderator privileges approve his entrance. If a meeting has more than one moderator, a guest pop-up window will appear in the top right side asking if you allow the new user to enter in the meeting. If there isn”t a moderator in the meeting, the system stores the list of users that are waiting permission to enter and show it as soon as a moderator joins.

The picture below is the moderator view when a guest tries to join:

![](http://mconf.org/wp-content/uploads/2013/03/ModeratorView1.png)

The moderator can allow a user to enter clicking on the green button or deny his access by clicking on the red button. He can allow all the guests that are waiting clicking on “allow everyone” or deny them clicking on “deny everyone”.  He can also check the “remember” option, meaning that the same action casino online will be taken for the next users that try to join the meeting (useful to allow or deny everyone from now on).

You can change the default option that you chose clicking in the setting button.

![](http://mconf.org/wp-content/uploads/2013/03/BBBSettings-1024x771.png)

The picture below shows the guest waiting screen:

![](http://mconf.org/wp-content/uploads/2012/09/GuestView-1024x544.png)

The picture below shows the message that appear when the moderator denied access to the guest:

![](http://mconf.org/wp-content/uploads/2012/09/GuestDenied-1024x551.png)

Implementation details:

Without the guest feature, it”s the web application (or integration as usually called) that decides if a user has permissions to join a meeting. In Mconf this is done by Mconf-Web. With online casino the guest feature this is still valid, but now the web application can also tell the web conference server that the user can join the meeting but only after being explicitly accepted by a moderator.

The implementation of the guest feature was done by adding a new parameter to the “join” API call. This parameter is called “guest” and is optional. If present and set to “true”, the user joining the conference will be treated as a guest. If not present, the API will behave as it does today (i.e. the password will define if the user is a moderator or an attendee).

The passwords in the “join” API call are still used to define the role of the user, even if he is set as a guest. So if the API call has the moderator password and the parameter guest set, the user will “pre-join” the meeting, wait for a moderator to approve his entrance, and when he finally joins he will be a moderator (i.e. even moderators have to be approved when they are set as guests).

In Mconf-Web (and so in mconf.org) now only moderators will automatically join a meeting without being a guest. If a user is a normal attendee, he will be set as guest.

You can read more details about the changes in the API at our wiki: https://code.google.com/p/mconf/wiki/MconfLiveApiChanges#Join_Meeting
