---
date: 2013-01-11
title: Blog post - Mconf-Live 0.3
categories:
  - Archives
description: Blog post from 2013-01-11
type: Document
archived: true
---

We are glad to announce a new version of Mconf-Live, which introduces two new features:

* A new kind of participant that can only visualize the conference (but not transmit audio or video);
* A first version of the network monitor.

On the previous version when a user wanted to hear the conference, he was forced to enable his microphone as well. In addition, when the user enables his microphone, the system creates a stream that goes from the client to the server, even if he doesn”t want to talk, just listen. The problem is that every new audio stream creates a server-side overhead, because FreeSWITCH (that handles all the audio processing) generates an outcoming stream for each incoming stream. Each outcoming stream is formed by all the incoming streams except the correspondent incoming stream. The independence among outcoming streams makes it possible to send audio messages to a specific user, such as “You are now muted”.

The audio architecture was designed for high interactive sessions, but it doesn”t fit well on sessions with a low number of interactions but with many users, such as webinars. In theory the current architecture can handle a large number of participants (depending on the hardware), but often you will notice audio artifacts on the session, which are generated during the mixing process.

With this scenario in mind we proposed a simple architectural modification. When the user joins a session, he will receive an audio stream that is the result of all the other users streams mixed – this audio stream is called global stream, or global audio. Only when the user wants to talk that he will click on the headset icon and then join the session as a speaker. Internally the user will leave the global audio and create two new streams, an incoming stream and an outcoming stream, just like it was on the previous architecture.

The modification proposed (and implemented on Mconf-Live 0.3) aims to make the system more scalable and to increase the audio quality. The scalability improvement is due to the removal of the overhead that was generated during the mixing process. In the new architecture, the FreeSWITCH server will mix a smaller number of streams, and it will reduce the processing power needed for it. The audio quality improvement is justified by the same reason: mixing a online casino smaller number of streams will reduce the probability of annoying artifacts.

A side-effect of the proposed architecture is that the user is able to open an incoming stream without opening an outcoming stream. It will reduce by 50% the bandwith requirement to listen an audio session, making the system more friendly to low bandwidth connections.

The UI will remain almost the same, except by two aspects. First, the “Listeners” window now will show the users with the microphone activated, so it will be a “Speakers” window. Last, we added a new button on the toolbar that mutes or unmutes the user”s speakers (see the figure below). Since the user will join the session and start listening automatically with no action required, we had to create a mechanism to mute this audio. The effect of this button is local only – the other users will continue listening normally.

![](http://mconf.org/wp-content/uploads/2013/01/toolbar.png)

We are introducing also on Mconf-Live 0.3 a network monitor. The ability to watch how much bandwidth is being consumed by the system and the latency between the client and the server may help users to identify the reasons for a low quality experience. The bandwidth data is presented at the bottom of the screen and is updated each couple of seconds, and if the user places his mouse over the data, a more detailed window is presented with the bandwidth consumption and latency. This is a preliminary development, and it should evolve on next iterations.

![](http://mconf.org/wp-content/uploads/2013/01/network_monitor.png)

A test server was set up for the users to test the new version before the final deployment to the Mconf Network, it”s available on http://lab1.mconf.org and the source code is available on GitHub. Any feedback is appreciated, hope you enjoy it!
