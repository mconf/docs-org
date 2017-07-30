---
date: 2017-01-30
title: API LB
categories:
  - LB
  - APIs
description: The API of the Load Balancer
type: Document
---

## About

The Load Balancer (LB) implements [BigBlueButton's standard API](http://code.google.com/p/bigbluebutton/wiki/081API), so that any application that integrates with Mconf-Live/BigBlueButton can also be used with the Load Balancer. This includes [Mconf-Web](https://github.com/mconf/mconf-web/wiki) and the integrations listed in [BigBlueButton's website](http://www.bigbluebutton.org/open-source-integrations/).

However, the LB's API currently has some small differences from BigBlueButton's API and more could be added in the future. But it is extremely important that, even with these small differences, the existent 3rd-party applications should not need to be adapted to use the Mconf infrastructure.

This API is built on top of the API of the **latest Mconf-Live**, that is based on **BigBlueButton 0.81**. Therefore, it supports everything from this version of Mconf-Live, with the differences described below and with a few restrictions described in the end of this page. To see everything that is supported by this API, read also these links:

* Latest version of Mconf-Live: https://github.com/mconf/wiki/wiki/Mconf-Live-API-Changes
* Base version of BigBlueButton in use: http://code.google.com/p/bigbluebutton/wiki/081API

The differences between the API of the LB and the API of Mconf-Live/BigBlueButton are described below, as well as are the new API calls that were added to the LB.



## Root path

#### Base URL

`/bigbluebutton/api/`

#### What changed

Accessing the root path of the API will return information about the server. In the Load Balancer some information was added to the **response** to include details about itself.

#### Response

| Change | Param Name | When Returned | Type | Description |
|:------:|:----------:|:-------------:|:----:|:-----------:|
| Added | `custom` | Always | Block | Only a tag to group other tags. |
| Added | `name` | Always | String | Name of the application. |
| Added | `version` | Always | String | Current version of the application. |
| Added | `deploy` | Always | Number | Current deploy number (incremental since the first deploy). |
| Added | `revision` | Always | String | Current git revision. |

#### Example response

```xml
<response>
   <returncode>SUCCESS</returncode>
   <version>0.8</version>
   <custom> <!-- Added -->
      <name>mconf-lb</name> <!-- Added -->
      <version>0.3.0</version> <!-- Added -->
      <deploy>16</deploy> <!-- Added -->
      <revision>66c201586e9eecf233108cfb69ff771de3b21d6a</revision> <!-- Added -->
   </custom>
</response>
```




## Create

#### Base URL

`/bigbluebutton/api/create`


#### What changed

Some metadata keys are used internally by the Load Balancer, so they **cannot** be used by the integrations. If a `create` call has one of the reserved metadata keys, the Load Balancer will respond with an error.

#### Restricted keys

| Key | Description |
|:------:|:----------:|
| `mconflb-guid` | A globally unique identifier used to identify the load balancer |
| `mconflb-institution` | The institution (id) that created the meeting |
| `mconflb-institution-name` | The institution (name) that created the meeting |
| `mconflb-rec-server` | The recording server (id) where the recording will be stored |
| `mconflb-rec-server-url` | The recording server (url) where the recording will be stored |
| `mconflb-rec-server-key` | The recording server (public key) where the recording will be stored |

#### Example response

This response will be returned if any of the metadata keys in the table above are used in a `create` call. This is a failure response, so the `create` call will **not** be completed (i.e. the meeting will not be created).

```xml
<response>
   <returncode>FAILED</returncode>
   <messageKey>invalidParameters</messageKey>
   <message>The URL you supplied has parameters that are not accepted.</message>
</response>
```


#### Create via POST

Works in the same way it is done in [BigBlueButton's API](http://code.google.com/p/bigbluebutton/wiki/081API#Preupload_Slides) (read this link for more details) and is used to pre-upload slides when a meeting is created.

To test it you can use the command line tool `curl`. First save the following content in a file named `post_data.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?> 
<modules> 
    <module name="presentation"> 
        <document url="http://www.samplepdf.com/sample.pdf" /> 
    </module> 
</modules> 
```
Then generate a link to a create call and run:

```bash
curl -i -X POST --data-binary @post_data.xml '<your create call link>' --header "Content-Type:application/xml" 
```
Then, when you join the target web conference you should see [this pdf](http://www.samplepdf.com/sample.pdf) as the startup presentation.

You can also test it using the [API Mate](http://mconf.github.io/api-mate/).

#### Indicating a preferred server

Using `preferredServer=<server>` as an extra parameter in a `create` call, the caller is able to select a server in which the web conference will be created in spite of the load balancing algorithm. If the entered server is invalid, does not correspond to a server in the load balancer, or corresponds to a server that is disabled, this parameter will be ignored and a server will be selected using the standard load balancing algorithm. Only a single server can be passed at a time.

The identifier for a server is the server's IP or domain name. In the Mconf Network, these identifiers are the names shown [in the dashboard](http://lb2.mconf.org/dashboard) (e.g. `rnp-bsb.mconf.org` and `mconf1.ufrgs.br`). To get the list of servers available programmatically, use the API call [`getServers`](#wiki-get-servers)

Example call:

```text
http://yourserver.com/bigbluebutton/api/create?name=abc&meetingID=abc&record=false&preferredServer=143.10.10.198&checksum=345bc221f9e332702d77fdbac3862636c8aba239
```


#### Passing a voice bridge

Voice bridges are the internal numbers used by the web conference server to identify the channel used to share voice in a meeting. A voice bridge can be passed to the `create` call using the parameter `voiceBridge`.

Recommended values for voice bridges are five-digits numbers starting with 7 (i.e. `[70000..79999]`).

There's a particularity of the load balancer in dealing with voice bridges: it will not allow duplicated voice bridges in a single server. So if you pass a voice bridge in the `create` call and this voice bridge is already being used *in the server that was selected to hold your meeting*, the load balancer will automatically generate a unique voice bridge for your meeting and use this new number. This number is then returned in the response of the `create` call.

If your voice bridge is already being used but by a meeting *in a different server*, then there's no problem, the voice bridge you informed will be used.

Overall, integrations should *always* check the response of the `create` call to see if the voice bridge passed in the parameters was the one actually used to create the meeting.




## Get Recordings

What changed: Parameters were added to the API call.

#### Base URL

`/bigbluebutton/api/getRecordings`

Parameters:

| Change | Param Name | When Returned | Type | Description |
|:------:|:----------:|:-------------:|:----:|:------------|
| Added | `meta` | Optional | String | You can pass one or more metadata values to filter the recordings returned. If multiple metadata values are passed, will only return recordings that match *all* of them. The format of these parameters is the same as the metadata passed to the `create` call. For more information see [this page](https://code.google.com/p/bigbluebutton/wiki/API#Create_Meeting) |

Note: If multiple filtering parameters are used in conjunction (e.g. `meta_` and `meetingID`), only recordings that match *all* of the parameters passed will be returned.

Example Requests:

```bash
http://yourserver.com/bigbluebutton/api/getRecordings?meta_presenter=joe&meta_category=education&checksum=1234
```





## Get Servers

This is a custom API call available only on the Load Balancer.

#### Base URL

`/bigbluebutton/api/getServers`


#### Description

Returns a list of servers available in the Load Balancer with information about their status, geographic position and address.

#### Example call:

```text
http://yourserver.com/bigbluebutton/api/getServers?checksum=146ad52c5c82b4d948b661eb87cf6c09bd2a73fa
```

#### Example response:

```xml
<response>
  <returncode>SUCCESS</returncode>
  <servers>
    <server> <!-- a server that is enabled -->
      <name>server1.org</name>
      <address>server1.org</address>
      <url>http://server1.org</url>
      <apiUrl>http://server1.org/bigbluebutton/api</apiUrl>
      <status>2</status>
      <disableState>2</disableState>
      <geoloc>
        <address>server1.org</address>
        <ip>200.0.1.2</ip>
        <countryCode>BR</countryCode>
        <countryCode3>BRA</countryCode3>
        <countryName>Brazil</countryName>
        <city>Porto Alegre</city>
        <latitude>-30.033300399780273</latitude>
        <longitude>-51.20000076293945</longitude>
        <continentCode>SA</continentCode>
      </geoloc>
      <isDisabled>false</isDisabled>
    </server>
    <server> <!-- a server that is disabled -->
      <name>server2.org</name>
      <address>server2.org</address>
      <url>http://server2.org</url>
      <status>2</status>
      <disableState>1</disableState>
      <geoloc>
        <address>server2.org</address>
        <ip>81.0.1.2</ip>
        <countryCode>DE</countryCode>
        <countryCode3>DEU</countryCode3>
        <countryName>Germany</countryName>
        <city>Berlin</city>
        <latitude>50.033987987897</latitude>
        <longitude>13.20890898799</longitude>
        <continentCode>EU</continentCode>
      </geoloc>
      <isDisabled>true</isDisabled>
    </server>
  </servers>
<response>
```

#### Parameters

This call requires no parameters.

#### Tags in the response

Tags in the response:

|  parameter | type |  meaning  |
|:----------:|:---------:|:-----:|
| name | string | The string used to identify this server in the Load Balancer |
| address | string | The IP or domain of the server |
| url | string | The full URL of the server, including protocol and port (if not a default port) |
| apiUrl | string | The full URL of the server including the API path. The URL that should be used to call API methods in this server. |
| status | integer | The status of the server in the monitoring system. Can be: `0` undefined; `1` pending (a request is being made); `2` up (the server is up and running); `3` down (the server is down); `4` unreachable (the server is unreachable). These statuses are based on [the statuses of hosts on nagios](http://nagios.sourceforge.net/docs/3_0/hostchecks.html). |
| disableState | boolean | The flag that controls whether the server is `0` forcibly enabled; `1` forcibly disabled; or `3` in automatic mode. Automatic mode means that the server will be automatically disabled if its monitoring information are indicating the load balancer to disable it (according to rules specified in the load balancer). For example, if the CPU load is higher than ~70% or if the server is not responding at all. The other modes are used by admins to forcibly enable or disable a server, ignoring the status of the services. |
| geoloc | - | A tag with nested tags including information about the geographic location of the server. This location is acquired from [GeoIP](http://www.maxmind.com/en/geolocation_landing) using the server's address. *Any* of its nested tags can be empty. The available tags are shown in the example above. |
| isDisabled | boolean | `true` if the server is disabled (either by an administrator or automatically by the Load Balancer), or `false` otherwise. Notice that if `disabledByLB` is `true`, this will always be `true` as well, otherwise this can be either `true` (disabled by an admin) or `false` (the server is enabled). If you just need to know if the server is enabled or not and don't need to know the reasons, use this flag. |

#### Possible failure responses

* Invalid checksum (returns the standard response as returned by BigBlueButton/Mconf-Live, see an example in [this section](#wiki-standard-error-responses))
* Unauthorized access (read [this section](#wiki-all-calls-authorization))






## Get Meeting Events

This is a custom API call available only on the Load Balancer.

#### Base URL

`/bigbluebutton/api/getMeetingEvents`

#### Description

Returns a list of meetings that happened during the period selected and the users that participated in these meetings.

This call requires no parameters. If no parameters are specified, the call will return **the last 50 meetings that had at least 1 user in it**. The response is always **ordered by `createdAt` (when the meeting started) in descending order (the last meetings that happened are in the top)**.

#### Example calls

```text
http://yourserver.com/bigbluebutton/api/getMeetingEvents?checksum=146ad52c5c82b4d948b661eb87cf6c09bd2a73fa
http://yourserver.com/bigbluebutton/api/getMeetingEvents?createdAt=2014-01-10&createdAt=2014-01-20&users=2&limit=20&checksum=146ad52c5c82b4d948b661eb87cf6c09bd2a73fa
```

#### Example response

```xml
<response>
  <returncode>SUCCESS</returncode>
  <events>
    <event> <!-- a meeting that had participants -->
      <meetingID>random-789</meetingID>
      <name>random-789</name>
      <createdAt>1391035535000</createdAt>
      <endedAt>1391035779000</endedAt>
      <server>
        <name>server1.mconf.org</name>
        <url>http://server1.mconf.org</url>
      </server>
      <users>
        <user>
          <name>User 7181646</name>
          <role>moderator</role>
          <createdAt>1391035535000</createdAt>
        </user>
      </users>
      <query>
        <attendeePW>ap</attendeePW>
        <meetingID>random-789</meetingID>
        <meta_community>English Class 2</meta_community>
        <meta_origin>myserver</meta_origin>
        <meta_room_id>123</meta_room_id>
        <moderatorPW>mp</moderatorPW>
        <name>random-789</name>
        <record>false</record>
        <voiceBridge>75842</voiceBridge>
        <welcome><br>Welcome to <b>%%CONFNAME%%</b>!</welcome>
      </query>
    </event>
    <event> <!-- a meeting that had no participants -->
      <meetingID>random-123</meetingID>
      <name>random-123</name>
      <createdAt>1391035256000</createdAt>
      <endedAt>1391035353000</endedAt>
      <server>
        <name>server2.mconf.org</name>
        <url>http://server2.mconf.org</url>
      </server>
      <users />
      <query>
        <meetingID>random-123</meetingID>
      </query>
    </event>
  </events>
<response>
```

#### Example of an empty response

```xml
<response>
  <returncode>SUCCESS</returncode>
  <events/>
</response>
```


#### Parameters

No parameters are required, but the following parameters are accepted:

| Param Name | Required / Optional | Type | Description |
|:----------:|:-------------:|:----:|:-----------:|
| `createdAt` | Optional | Date | Return only meetings created on this day or later. Use the format `YYYY-MM-DD` (year-month-day). |
| `endedAt` | Optional | Date | Return only meetings that ended on this day or before it. Meetings that are happening right now will not be returned. Use the format `YYYY-MM-DD` (year-month-day). |
| `users` | Optional | Number | Return only meetings that had at least this number of users (default: 1). |
| `limit` | Optional | Number | Limit the number of results (default: 50; maximum: 100). |

#### Tags in the response

|  parameter | type |  meaning  |
|:----------:|:---------:|:-----:|
| meetingID | string | The ID the identifies the meeting, as used in the `create` call. |
| name | string | The name of the meeting, as used in the `create` call. |
| createdAt | timestamp | The timestamp for when the meeting was created (when the `create` call was performed).  |
| endedAt | timestamp | The timestamp for when the meeting ended. |
| server | - | A tag with nested tags that describe the server in which the meeting happened. Contains the tags: `name`: a string that identifies the server in the Load Balancer; `url`: the base URL of the server. |
| users | - | A list of all the users that participated in the meeting. See details in the table below. |
| query | - | A list of all the parameters passed to the `create` call when this meeting was created. Used specially to get additional metadata that was passed to the `create` call. |

Tags inside `<users>`:

|  parameter | type |  meaning  |
|:----------:|:---------:|:-----:|
| name | string | The name of the user, the same as `fullName` in a `join` call. |
| role | string | The role of the user in the meeting, one of the options: `attendee`, `moderator`. |
| createdAt | timestamp | The timestamp for when the user joined the meeting (when the `join` call was performed).  |

Note: This call might return several `<user>` blocks for the same person in case that person joined the meeting several times. Each `<user>` block correspond to a `join` call, and will have a different `createdAt` than the other blocks for the same user.

#### Possible failure responses

* Invalid checksum (returns the standard response as returned by BigBlueButton/Mconf-Live, see an example in [this section](#wiki-standard-error-responses))
* Unauthorized access (read [this section](#wiki-all-calls-authorization))
* Invalid parameter (see an example in [this section](#wiki-standard-error-responses))


## Config XML

Calls to set the `config.xml` in a web conference server are calls from Mconf-Live/BigBlueButton that are also implemented in the LB. There are a few differences in these calls when made to the LB that you should be aware of.

#### Base URL

`/bigbluebutton/api/getDefaultConfigXML`

`/bigbluebutton/api/setConfigXML`

#### getDefaultConfigXML

Will return the default `config.xml` file that can be used to customize any of the servers connected to the LB.

##### Differences from Mconf-Live/BigBlueButton

In the XML in the response, all URLs will be relative to the LB. So the response might include a tag like the one below:

```xml
<skinning enabled="true" url="http://lb.mconf.org/client/branding/css/BBBDefault.css.swf"/>
```

You can see the URL pointing to `http://lb.mconf.org/client/branding/css/BBBDefault.css.swf`, even though this URL works only in Mconf-Live/BigBlueButton servers and will return an error if you try to access it in the LB. But this is not wrong. The LB will automatically adjust the XML back to the correct URLs on `setConfigXML`.

#### setConfigXML

Will set a `config.xml` in the server that is holding the target meeting.

##### Differences from Mconf-Live/BigBlueButton

The LB expects to receive a `config.xml` where all URLs point to the address of the LB, not to the address of the target web conference server! Just like the `config.xml` returned by the LB on `getDefaultConfigXML`. It will then automatically adjust the URLs to the target server.



## All calls: authorization

#### What changed

The LB checks whether the 3rd-party application is allowed to perform the actions it is trying to perform in the API. In a `create` call, for example, if the parameter `record` is set to `true`, the LB will check if the 3rd-party application is actually allowed to record meetings or not. If it is, the call proceeds as normal. Otherwise the LB responds with an error message.

**All API calls** are subjected to this verification, so all of the API calls could return one of the errors described below.

#### New error responses 

| messageKey | message | When it happens? |
|:------:|:----------:|:----------:|
| `permissionDenied` | This application is not currently allowed to access this API. | General error for whenever the application has no access at all to the API. |
| `permissionDenied` | This application is not allowed to record meetings. | When a `create` call tries to record but the application is not allowed to. |
| `permissionDenied` | This application is not allowed to have any more concurrent meetings. | When a `create` call fails because the 3rd-party application already reached its limit in the number of concurrent meetings. |

#### Example of an error response

```xml
<response>
   <returncode>FAILED</returncode>
   <messageKey>permissionDenied</messageKey>
   <message>This application is not currently allowed to access this API.</message>
</response>
```


## Standard error responses

This section contains examples of some standard error responses returned by the LB and, some of them, also by Mconf-Live/BigBlueButton. These are not all the possible error responses, just the most common ones.

#### Checksum error

```xml
<response>
  <returncode>FAILED</returncode>
  <messageKey>checksumError</messageKey>
  <message>You did not pass the checksum security check.</message>
</response>
```

#### Invalid meetingID

```xml
<response>
  <returncode>FAILED</returncode>
  <messageKey>invalidMeetingIdentifier</messageKey>
  <message>The meeting ID that you supplied did not match any existing meetings.</message>
</response>
```

#### Missing meetingID

```xml
<response>
  <returncode>FAILED</returncode>
  <messageKey>missingParamMeetingID</messageKey>
  <message>You must specify a meeting ID for the meeting.</message>
</response>
```

#### Invalid parameters

```xml
<response>
  <returncode>FAILED</returncode>
  <messageKey>invalidParameters</messageKey>
  <message>The URL you supplied has parameters that are not accepted.</message>
</response>
```


## Current limitations

There's currently no knowledge of anything from in the API of Mconf-Live/BigBlueButton that is not available in the API of the Load Balancer :thumbsup:

If you happen to come across anything missing in the API of the LB, please contact us.




***



# In Development

## Get Meetings

#### Base URL

`/bigbluebutton/api/getMeetings`

#### What changed

Information was added to the **response**. It includes the server in which the meeting is being held.

#### Example response

```xml
<response>
   <returncode>SUCCESS</returncode>
   <meetings>
     <meeting>
       <meetingID>93b8fac2-1373658348</meetingID>
       <meetingName>My Meeting</meetingName>
       <createTime>1410298186908</createTime>
       <attendeePW>ap</attendeePW>
       <moderatorPW>mp</moderatorPW>
       <hasBeenForciblyEnded>false</hasBeenForciblyEnded>
       <running>true</running>
       <participantCount>2</participantCount>
       <listenerCount>0</listenerCount>
       <videoCount>0</videoCount>
       <voiceBridge>75992</voiceBridge>
       <dialNumber>613-123-1234</dialNumber>
       <server> <!-- Added -->
         <name>my-server.org</name> <!-- Added -->
         <address>my-server.org</address> <!-- Added -->
         <url>http://my-server.org</url> <!-- Added -->
       </server> <!-- Added -->
     </meeting>
   </meetings>
</response>
```
