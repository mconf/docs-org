---
date: 2017-08-14
title: API Webhooks
categories:
  - APIs
description: Description of the events triggered by the webhooks
type: Document
tags:
  - draft
---

## List of events triggered by the webhooks

* meeting_created_message -> meeting-created
* meeting_destroyed_event -> meeting-ended
* user_joined_message -> user-joined
* user_left_message -> user-left
* user_listening_only -> user-audio-listen-only-enabled
* user_listening_only -> user-audio-listen-only-disabled
* user_joined_voice_message -> user-audio-voice-enabled
* user_left_voice_message -> user-audio-voice-disabled
* send_public_chat_message -> chat-public-message-sent
* send_private_chat_message -> chat-private-message-sent


### Other candidates (future)

* presenter_assigned_message -> presenter-changed
* user_status_changed_message -> user-status-changed
* get_chat_history_reply -> chat-messages
* poll_started_message -> poll-started
* show_poll_result_request_message -> poll-ended
* poll_stopped_message -> poll-stopped
* broadcast_layout_message -> layout-changed
* meeting_muted_message -> audio-all-muted
* user_voice_muted_message -> user-audio-muted
* send_lock_settings -> lock-settings-changed
* lock_layout_message -> layout-locked
* user_eject_from_meeting -> user-kicked
* user_voice_talking_message -> user-audio-talking
* user_shared_webcam_message -> user-cam-enabled
* user_unshared_webcam_message -> user-cam-disabled


## meeting-created

### Internal event

```json
{
   "payload": {
      "duration": 0,
      "external_meeting_id": "random-578101",
      "create_time": 1502212442238,
      "meeting_id": "0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238",
      "is_breakout": false,
      "name": "random-578101",
      "moderator_pass": "mp",
      "recorded": false,
      "voice_conf": "73583",
      "viewer_pass": "ap",
      "create_date": "Tue Aug 08 17:14:02 UTC 2017"
   },
   "header": {
      "name": "meeting_created_message",
      "version": "0.0.1",
      "current_time": 1502212442257,
      "timestamp": 8767670
   }
}
```

### Event sent via webhooks

```json
{
  "data": {
    "type": "event",
    "id": "meeting-created",
    "attributes": {
      "meeting": {
        "name": "random-578101",
        "external-meeting-id": "random-578101",
        "internal-meeting-id": "0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238",
        "is-breakout": false,
        "duration": 0,
        "create-time": 1502212442238,
        "create-date": "Tue Aug 08 17:14:02 UTC 2017",
        "moderator-pass": "mp",
        "viewer-pass": "ap",
        "recorded": false,
        "record": false,
        "voice-conf": 73583,
        "dial-number": "613-555-1234",
        "max-users": 12,
        "metadata": {
           "anything_set_here": "any-other",
           "anotherMeta": "123"
        }
      },
      "event": {
        "ts": 1502212442257
      }
    }
  }
}
```

## meeting-ended

### Internal event

```json
{
   "payload": {
      "meeting_id": "28311eecec6394e5c51be47a4eed381ab7f156c6-1502470514081"
   },
   "header": {
      "name": "meeting_destroyed_event",
      "version": "0.0.1",
      "current_time": 1502470522712,
      "timestamp": 95578982
   }
}
```

### Event sent via webhooks

```json
{
  "data": {
    "type": "event",
    "id": "meeting-ended",
    "attributes": {
      "meeting": {
        "external-meeting-id": "random-578101",
        "internal-meeting-id": "28311eecec6394e5c51be47a4eed381ab7f156c6-1502470514081"
      },
      "event": {
        "ts": 1502470522712
      }
    }
  }
}
```

## user-joined

### Internal event

```json
{
   "payload": {
      "meeting_id": "0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238",
      "user": {
         "role": "MODERATOR",
         "presenter": false,
         "locked": false,
         "extern_userid": "lwzhlo27k2zf",
         "phone_user": false,
         "webcam_stream": [],
         "emoji_status": "none",
         "voiceUser": {},
         "name": "User 1131066",
         "listenOnly": false,
         "avatarURL": "http://10.0.3.85/client/avatar.png",
         "userid": "lwzhlo27k2zf_1",
         "has_stream": false
      }
   },
   "header": {
      "name": "user_joined_message",
      "version": "0.0.1",
      "current_time": 1502212521389,
      "timestamp": 8846802
   }
}
```

### Event sent via webhooks

```json
{
  "data": {
    "type": "event",
    "id": "user-joined",
    "attributes": {
      "meeting": {
        "external-meeting-id": "random-578101",
        "internal-meeting-id": "0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238"
      },
      "user": {
        "name": "User 1131066",
        "role": "MODERATOR",
        "presenter": false,
        "internal-user-id": "lwzhlo27k2zf_1",
        "external-user-id": "lwzhlo27k2zf",
        "sharing-mic": false,
        "sharing-video": false,
        "listening-only": false
      },
      "event": {
        "ts": 1502212521389,
      }
    }
  }
}
```


## user-left

### Internal event

```json
{
  "payload": {
    "meeting_id": "0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238",
    "user": {
      "role": "MODERATOR",
      "presenter": true,
      "locked": false,
      "extern_userid": "lwzhlo27k2zf",
      "phone_user": false,
      "webcam_stream": [],
      "emoji_status": "none",
      "voiceUser": {},
      "name": "User 1131066",
      "listenOnly": false,
      "avatarURL": "http://10.0.3.85/client/avatar.png",
      "userid": "lwzhlo27k2zf_1",
      "has_stream": false
    }
  },
  "header": {
    "name": "user_left_message",
    "version": "0.0.1",
    "current_time": 1502212970704,
    "timestamp": 9296117
  }
}
```

### Event sent via webhooks

```json
{
  "data": {
    "type": "event",
    "id": "user-left",
    "attributes": {
      "meeting": {
        "external-meeting-id": "random-578101",
        "internal-meeting-id": "0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238"
      },
      "user": {
        "name": "User 1131066",
        "role": "MODERATOR",
        "presenter": false,
        "internal-user-id": "lwzhlo27k2zf_1",
        "external-user-id": "lwzhlo27k2zf",
        "sharing-mic": false,
        "sharing-video": false,
        "listening-only": false
      },
      "event": {
        "ts": 1502212970704
      }
    }
  }
}
```


## user-audio-listen-only-enabled

### Internal event

```json
{
  "payload": {
    "meeting_id": "0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238",
    "userid": "lwzhlo27k2zf_1",
    "listen_only": true
  },
  "header": {
    "name": "user_listening_only",
    "version": "0.0.1",
    "current_time": 1502212699862,
    "timestamp": 9025274
  }
}
```

### Event sent via webhooks

```json
{
  "data": {
    "type": "event",
    "id": "user-audio-listen-only-enabled",
    "attributes": {
      "meeting": {
        "external-meeting-id": "random-578101",
        "internal-meeting-id": "0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238"
      },
      "user": {
        "internal-user-id": "lwzhlo27k2zf_1",
        "external-user-id": "lwzhlo27k2zf"
      },
      "event": {
        "ts": 1502212699862
      }
    }
  }
}
```


## user-audio-listen-only-disabled

### Internal event

```json
{
  "payload": {
    "meeting_id": "0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238",
    "userid": "lwzhlo27k2zf_1",
    "listen_only": false
  },
  "header": {
    "name": "user_listening_only",
    "version": "0.0.1",
    "current_time": 1502212699862,
    "timestamp": 9025274
  }
}
```

### Event sent via webhooks

```json
{
  "data": {
    "type": "event",
    "id": "user-audio-listen-only-disabled",
    "attributes": {
      "meeting": {
        "external-meeting-id": "random-578101",
        "internal-meeting-id": "0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238"
      },
      "user": {
        "internal-user-id": "lwzhlo27k2zf_1",
        "external-user-id": "lwzhlo27k2zf"
      },
      "event": {
        "ts": 1502212521389,
      }
    }
  }
}
```


## user-audio-voice-enabled

### Internal event

```json
{
  "payload": {
    "meeting_id": "0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238",
    "recorded": false,
    "voice_conf": "73583",
    "user": {
      "role": "MODERATOR",
      "presenter": true,
      "locked": false,
      "extern_userid": "cypnwcc5j26c",
      "phone_user": false,
      "webcam_stream": [],
      "emoji_status": "none",
      "voiceUser": {},
      "name": "User 1131066",
      "listenOnly": false,
      "avatarURL": "http://10.0.3.85/client/avatar.png",
      "userid": "cypnwcc5j26c_1",
      "has_stream": false
    }
  },
  "header": {
    "name": "user_joined_voice_message",
    "version": "0.0.1",
    "current_time": 1502213029467,
    "timestamp": 9354880
  }
}
```

### Event sent via webhooks

```json
{
  "data": {
    "type": "event",
    "id": "user-audio-voice-enabled",
    "attributes": {
      "meeting": {
        "external-meeting-id": "random-578101",
        "internal-meeting-id": "0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238"
      },
      "user": {
        "internal-user-id": "lwzhlo27k2zf_1",
        "external-user-id": "lwzhlo27k2zf"
      },
      "event": {
        "ts": 1502213029467
      }
    }
  }
}
```


## user-audio-voice-disabled

### Internal event

```json
{
  "payload": {
    "meeting_id": "0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238",
    "recorded": false,
    "voice_conf": "73583",
    "user": {
      "role": "MODERATOR",
      "presenter": true,
      "locked": false,
      "extern_userid": "cypnwcc5j26c",
      "phone_user": false,
      "webcam_stream": [],
      "emoji_status": "none",
      "voiceUser": {},
      "name": "User 1131066",
      "listenOnly": false,
      "avatarURL": "http://10.0.3.85/client/avatar.png",
      "userid": "cypnwcc5j26c_1",
      "has_stream": false
    }
  },
  "header": {
    "name": "user_left_voice_message",
    "version": "0.0.1",
    "current_time": 1502213329446,
    "timestamp": 9654859
  }
}
```

### Event sent via webhooks

```json
{
  "data": {
    "type": "event",
    "id": "user-audio-voice-disabled",
    "attributes": {
      "meeting": {
        "external-meeting-id": "random-578101",
        "internal-meeting-id": "0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238"
      },
      "user": {
        "internal-user-id": "cypnwcc5j26c_1",
        "external-user-id": "cypnwcc5j26c"
      },
      "event": {
        "ts": 1502213329446
      }
    }
  }
}
```


## chat-public-message-sent

### Internal event

```json
{
  "payload": {
    "meeting_id": "0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238",
    "message": {
      "toUsername": "public_chat_username",
      "fromUserID": "lwzhlo27k2zf_1",
      "fromTimezoneOffset": "180",
      "fromTime": "1.502212736743E12",
      "fromColor": "0",
      "message": "1123",
      "toUserID": "public_chat_userid",
      "fromUsername": "User 1131066",
      "chatType": "PUBLIC_CHAT"
    }
  },
  "header": {
    "name": "send_public_chat_message",
    "version": "0.0.1",
    "timestamp": 9062185
  }
}
```

### Event sent via webhooks

```json
{
  "data": {
    "type": "event",
    "id": "chat-public-message-sent",
    "attributes": {
      "meeting": {
        "external-meeting-id": "random-578101",
        "internal-meeting-id": "0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238"
      },
      "chat-message": {
        "message": "1123",
        "sender": {
          "internal-user-id": "lwzhlo27k2zf_1",
          "external-user-id": "lwzhlo27k2zf",
          "timezone-offset": "180",
          "time": "1.502212736743E12"
        }
      },
      "event": {
        "ts": 1502213329446
      }
    }
  }
}
```


## chat-private-message-sent

### Internal event

```json
{
  "payload": {
    "meeting_id": "0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238",
    "message": {
      "toUsername": "User 1131066",
      "fromUserID": "c1nkzs3k1fla_1",
      "fromTimezoneOffset": "180",
      "fromTime": "1.502213004718E12",
      "fromColor": "0",
      "message": "hey",
      "toUserID": "cypnwcc5j26c_1",
      "fromUsername": "User 1131066",
      "chatType": "PRIVATE_CHAT"
    }
  },
  "header": {
    "name": "send_private_chat_message",
    "version": "0.0.1",
    "timestamp": 9330159
  }
}
```

### Event sent via webhooks

```json
{
  "data": {
    "type": "event",
    "id": "chat-private-message-sent",
    "attributes": {
      "meeting": {
        "external-meeting-id": "random-578101",
        "internal-meeting-id": "0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238"
      },
      "chat-message": {
        "message": "1123",
        "sender": {
          "internal-user-id": "lwzhlo27k2zf_1",
          "external-user-id": "lwzhlo27k2zf",
          "timezone-offset": "180",
          "time": "1.502212736743E12"
        },
        "receiver": {
          "internal-user-id": "cypnwcc5j26c_1",
          "external-user-id": "cypnwcc5j26c"
        }
      },
      "event": {
        "ts": 1502213329446
      }
    }
  }
}
```
