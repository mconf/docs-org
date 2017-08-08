---
date: 2017-08-08
title: BigBlueButton Messages
categories:
  - BigBlueButton
description: A list of internal messages that go through redis on BigBlueButton
type: Document
---


### meeting_created_message

```json
{ payload:
   { duration: 0,
     external_meeting_id: 'random-578101',
     create_time: 1502212442238,
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     is_breakout: false,
     name: 'random-578101',
     moderator_pass: 'mp',
     recorded: false,
     voice_conf: '73583',
     viewer_pass: 'ap',
     create_date: 'Tue Aug 08 17:14:02 UTC 2017' },
  header:
   { name: 'meeting_created_message',
     version: '0.0.1',
     current_time: 1502212442257,
     timestamp: 8767670 } }

```


### presentation_conversion_progress_message

```js
{ payload:
   { code: 'CONVERT',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     presentation_name: 'default.pdf',
     message_key: 'SUPPORTED_DOCUMENT',
     presentation_id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240' },
  header:
   { name: 'presentation_conversion_progress_message',
     version: '0.0.1',
     current_time: 1502212443287,
     timestamp: 8768700 } }
```


### presentation_page_generated_message

```js
{ payload:
   { code: 'CONVERT',
     pages_completed: 1,
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     num_pages: 5,
     presentation_name: 'default.pdf',
     message_key: 'GENERATED_SLIDE',
     presentation_id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240' },
  header:
   { name: 'presentation_page_generated_message',
     version: '0.0.1',
     current_time: 1502212443634,
     timestamp: 8769047 } }
```


### presentation_conversion_done_message

```js
{ payload:
   { presentation:
      { current: false,
        pages: [Array],
        name: 'default.pdf',
        id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240' },
     code: 'CONVERT',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     message_key: 'CONVERSION_COMPLETED' },
  header:
   { name: 'presentation_conversion_done_message',
     version: '0.0.1',
     current_time: 1502212443950,
     timestamp: 8769363 } }
```


### presentation_shared_message

```js
{ payload:
   { presentation:
      { current: true,
        pages: [Array],
        name: 'default.pdf',
        id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240' },
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238' },
  header:
   { name: 'presentation_shared_message',
     version: '0.0.1',
     current_time: 1502212443951,
     timestamp: 8769364 } }
```


### presentation_page_changed_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     page:
      { width_ratio: 100,
        height_ratio: 100,
        txt_uri: 'http://10.0.3.85/bigbluebutton/presentation/0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/d2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/textfiles/1',
        num: 1,
        y_offset: 0,
        swf_uri: 'http://10.0.3.85/bigbluebutton/presentation/0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/d2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/slide/1',
        thumb_uri: 'http://10.0.3.85/bigbluebutton/presentation/0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/d2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/thumbnail/1',
        x_offset: 0,
        current: true,
        svg_uri: 'http://10.0.3.85/bigbluebutton/presentation/0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/d2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/svg/1',
        id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/1' } },
  header:
   { name: 'presentation_page_changed_message',
     version: '0.0.1',
     current_time: 1502212443951,
     timestamp: 8769364 } }
```


### register_user_request

```js
{ payload:
   { role: 'MODERATOR',
     avatarURL: 'http://10.0.3.85/client/avatar.png',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     name: 'User 1131066',
     auth_token: 'kobnx6ntqr4g',
     userid: 'lwzhlo27k2zf',
     external_user_id: 'lwzhlo27k2zf' },
  header:
   { name: 'register_user_request',
     version: '0.0.1',
     timestamp: 8842961 } }
```


### user_registered_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     recorded: false,
     user:
      { role: 'MODERATOR',
        extern_userid: 'lwzhlo27k2zf',
        authToken: 'kobnx6ntqr4g',
        name: 'User 1131066',
        avatarURL: 'http://10.0.3.85/client/avatar.png',
        userid: 'lwzhlo27k2zf' } },
  header:
   { name: 'user_registered_message',
     version: '0.0.1',
     current_time: 1502212517552,
     timestamp: 8842965 } }
```


### init_permission_settings_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     permissions:
      { lockOnJoinConfigurable: false,
        disablePrivateChat: false,
        disableMic: false,
        lockOnJoin: true,
        disableCam: false,
        lockedLayout: false,
        disablePublicChat: false } },
  header:
   { name: 'init_permission_settings_message',
     version: '0.0.1',
     timestamp: 8846758 } }
```


### permisssion_setting_initialized_message

```js
{ payload:
   { settings: 'Permissions(false,false,false,false,false,true,false)',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238' },
  header:
   { name: 'permisssion_setting_initialized_message',
     version: '0.0.1',
     current_time: 1502212521353,
     timestamp: 8846766 } }
```


### init_audio_settings_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     userid: 'lwzhlo27k2zf_1',
     muted: false },
  header:
   { name: 'init_audio_settings_message',
     version: '0.0.1',
     timestamp: 8846759 } }
```


### validate_auth_token

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     auth_token: 'kobnx6ntqr4g',
     userid: 'lwzhlo27k2zf_1' },
  header:
   { reply_to: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/lwzhlo27k2zf_1',
     name: 'validate_auth_token',
     version: '0.0.1',
     timestamp: 8846796 } }
```


### validate_auth_token_reply

```js
{ payload:
   { valid: 'true',
     reply_to: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/lwzhlo27k2zf_1',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     auth_token: 'kobnx6ntqr4g',
     userid: 'lwzhlo27k2zf_1' },
  header:
   { name: 'validate_auth_token_reply',
     version: '0.0.1',
     current_time: 1502212521389,
     timestamp: 8846802 } }
```


### user_joined_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     user:
      { role: 'MODERATOR',
        presenter: false,
        locked: false,
        extern_userid: 'lwzhlo27k2zf',
        phone_user: false,
        webcam_stream: [],
        emoji_status: 'none',
        voiceUser: [Object],
        name: 'User 1131066',
        listenOnly: false,
        avatarURL: 'http://10.0.3.85/client/avatar.png',
        userid: 'lwzhlo27k2zf_1',
        has_stream: false } },
  header:
   { name: 'user_joined_message',
     version: '0.0.1',
     current_time: 1502212521389,
     timestamp: 8846802 } }
```


### meeting_state_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     permissions:
      { disablePublicChat: false,
        lockOnJoin: true,
        disableCam: false,
        lockedLayout: false,
        lockOnJoinConfigurable: false,
        disableMic: false,
        disablePrivateChat: false },
     meetingMuted: false,
     userid: 'lwzhlo27k2zf_1' },
  header:
   { name: 'meeting_state_message',
     version: '0.0.1',
     current_time: 1502212521390,
     timestamp: 8846803 } }
```


### presenter_assigned_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     new_presenter_name: 'User 1131066',
     new_presenter_id: 'lwzhlo27k2zf_1',
     assigned_by: 'lwzhlo27k2zf_1',
     recorded: false },
  header:
   { name: 'presenter_assigned_message',
     version: '0.0.1',
     current_time: 1502212521390,
     timestamp: 8846803 } }
```


### user_status_changed_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     userid: 'lwzhlo27k2zf_1',
     value: 'true',
     status: 'presenter' },
  header:
   { name: 'user_status_changed_message',
     version: '0.0.1',
     current_time: 1502212521390,
     timestamp: 8846803 } }
```


### get_users_request_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { name: 'get_users_request_message',
     version: '0.0.1',
     timestamp: 8846861 } }
```


### get_users_reply

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     users: [ [Object] ],
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { name: 'get_users_reply',
     version: '0.0.1',
     current_time: 1502212521451,
     timestamp: 8846864 } }
```


### get_recording_status_request_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     userid: 'lwzhlo27k2zf_1' },
  header:
   { name: 'get_recording_status_request_message',
     version: '0.0.1',
     timestamp: 8846870 } }
```


### get_recording_status_reply

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     recording: false,
     recorded: false,
     userid: 'lwzhlo27k2zf_1' },
  header:
   { name: 'get_recording_status_reply',
     version: '0.0.1',
     current_time: 1502212521467,
     timestamp: 8846880 } }
```


### get_current_layout_request_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     userid: 'lwzhlo27k2zf_1' },
  header:
   { name: 'get_current_layout_request_message',
     version: '0.0.1',
     timestamp: 8847705 } }
```


### get_current_layout_reply_message

```js
{ payload:
   { requested_by_userid: 'lwzhlo27k2zf_1',
     layout: '',
     set_by_userid: 'system',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     locked: false },
  header:
   { name: 'get_current_layout_reply_message',
     version: '0.0.1',
     timestamp: 8847707 } }
```


### resize_and_move_slide

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     height_ratio: 100,
     width_ratio: 100,
     y_offset: 0,
     x_offset: 0 },
  header:
   { name: 'resize_and_move_slide',
     version: '0.0.1',
     timestamp: 8850295 } }
```


### presentation_page_resized_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     page:
      { width_ratio: 100,
        height_ratio: 100,
        txt_uri: 'http://10.0.3.85/bigbluebutton/presentation/0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/d2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/textfiles/1',
        num: 1,
        y_offset: 0,
        swf_uri: 'http://10.0.3.85/bigbluebutton/presentation/0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/d2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/slide/1',
        thumb_uri: 'http://10.0.3.85/bigbluebutton/presentation/0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/d2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/thumbnail/1',
        x_offset: 0,
        current: true,
        svg_uri: 'http://10.0.3.85/bigbluebutton/presentation/0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/d2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/svg/1',
        id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/1' } },
  header:
   { name: 'presentation_page_resized_message',
     version: '0.0.1',
     current_time: 1502212524884,
     timestamp: 8850297 } }
```


### get_presentation_info

```js
{ payload:
   { reply_to: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/lwzhlo27k2zf_1',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { name: 'get_presentation_info',
     version: '0.0.1',
     timestamp: 8850374 } }
```


### get_presentation_info_reply

```js
{ payload:
   { presenter:
      { name: 'User 1131066',
        assigned_by: 'lwzhlo27k2zf_1',
        userid: 'lwzhlo27k2zf_1' },
     presentation_info: { presenter: [Object], presentations: {} },
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     presentations: [ [Object] ],
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { reply_to: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/lwzhlo27k2zf_1',
     name: 'get_presentation_info_reply',
     version: '0.0.1',
     current_time: 1502212524973,
     timestamp: 8850386 } }
```


### send_caption_history_request_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { name: 'send_caption_history_request_message',
     version: '0.0.1',
     timestamp: 8850412 } }
```


### send_caption_history_reply_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     caption_history: {},
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { reply_to: 'lwzhlo27k2zf_1',
     name: 'send_caption_history_reply_message',
     version: '0.0.1',
     current_time: 1502212525005,
     timestamp: 8850418 } }
```


### desktop_share_get_info_request

```js
{ payload:
   { reply_to: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/lwzhlo27k2zf_1',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { name: 'desktop_share_get_info_request',
     version: '0.0.1',
     timestamp: 8850716 } }
```


### send_cursor_update

```js
{ payload:
   { x_percent: 0.7475592747559274,
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     y_percent: 0.5485820548582054 },
  header:
   { name: 'send_cursor_update',
     version: '0.0.1',
     timestamp: 8850811 } }
```


### presentation_cursor_updated_message

```js
{ payload:
   { x_percent: 0.7475592747559274,
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     y_percent: 0.5485820548582054 },
  header:
   { name: 'presentation_cursor_updated_message',
     version: '0.0.1',
     current_time: 1502212525402,
     timestamp: 8850815 } }
```


### request_whiteboard_annotation_history_request

```js
{ payload:
   { whiteboard_id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/1',
     reply_to: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/lwzhlo27k2zf_1',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { name: 'request_whiteboard_annotation_history_request',
     version: '0.0.1',
     timestamp: 8851226 } }
```


### get_chat_history_request

```js
{ payload:
   { reply_to: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/lwzhlo27k2zf_1',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { name: 'get_chat_history_request',
     version: '0.0.1',
     timestamp: 8854893 } }
```


### get_chat_history_reply

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     chat_history: [],
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { reply_to: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/lwzhlo27k2zf_1',
     name: 'get_chat_history_reply',
     version: '0.0.1',
     current_time: 1502212529482,
     timestamp: 8854895 } }
```


### go_to_slide

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     page: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/2' },
  header: { name: 'go_to_slide', version: '0.0.1', timestamp: 8903030 }
```

### start_poll_request_message

```js
{ payload:
   { poll_id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/2/1502212581838',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     poll_type: 'YN',
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { name: 'start_poll_request_message',
     version: '0.0.1',
     timestamp: 8907266 } }
```


### poll_started_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     poll:
      { answers: [Array],
        id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/2/1502212581870' },
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { name: 'poll_started_message',
     version: '0.0.1',
     timestamp: 8907299 } }
```


### show_poll_result_request_message

```js
{ payload:
   { poll_id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/2/1502212581870',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     show: true,
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { name: 'show_poll_result_request_message',
     version: '0.0.1',
     timestamp: 8909886 } }
```


### send_whiteboard_shape_message

```js
{ payload:
   { whiteboard_id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/2',
     shape:
      { shape_type: 'poll_result',
        wb_id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/2',
        shape: [Object],
        status: 'DRAW_END',
        id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/2/1502212581870' },
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { name: 'send_whiteboard_shape_message',
     version: '0.0.1',
     current_time: 1502212584488,
     timestamp: 8909901 } }
```


### poll_show_result_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     poll:
      { num_respondents: 0,
        num_responders: 0,
        answers: [Array],
        id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/2/1502212581870' } },
  header:
   { name: 'poll_show_result_message',
     version: '0.0.1',
     timestamp: 8909906 } }
```


### user_listening_only

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     userid: 'lwzhlo27k2zf_1',
     listen_only: true },
  header:
   { name: 'user_listening_only',
     version: '0.0.1',
     current_time: 1502212699862,
     timestamp: 9025274 } }
```


### send_public_chat_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     message:
      { toUsername: 'public_chat_username',
        fromUserID: 'lwzhlo27k2zf_1',
        fromTimezoneOffset: '180',
        fromTime: '1.502212736743E12',
        fromColor: '0',
        message: '1123',
        toUserID: 'public_chat_userid',
        fromUsername: 'User 1131066',
        chatType: 'PUBLIC_CHAT' } },
  header:
   { name: 'send_public_chat_message',
     version: '0.0.1',
     timestamp: 9062185 } }
```


### broadcast_layout_request_message

```js
{ payload:
   { layout: '<layout-block>\n  <layout name="Custom layout">\n    <window name="VideoDock" width="0.19444444444444445" height="0.3117408906882591" minWidth="-1" x="0" y="0.6855600539811066" draggable="true" resizable="true" order="2"/>\n    <window name="ChatWindow" width="0.2972222222222222" height="1" minWidth="-1" x="0.7013888888888888" y="0" draggable="true" resizable="true" order="1"/>\n    <window name="PresentationWindow" width="0.47152777777777777" height="0.8758434547908233" minWidth="-1" x="0.20694444444444443" y="0.004048582995951417" draggable="true" resizable="true" order="0"/>\n    <window name="UsersWindow" width="0.19444444444444445" height="0.6788124156545209" minWidth="-1" x="0" y="0" draggable="true" resizable="true" order="3"/>\n    <window name="CaptionWindow" hidden="true" order="4"/>\n  </layout>\n</layout-block>',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     userid: 'lwzhlo27k2zf_1' },
  header:
   { name: 'broadcast_layout_request_message',
     version: '0.0.1',
     timestamp: 9066807 } }
```


### broadcast_layout_message

```js
{ payload:
   { layout: '<layout-block>\n  <layout name="Custom layout">\n    <window name="VideoDock" width="0.19444444444444445" height="0.3117408906882591" minWidth="-1" x="0" y="0.6855600539811066" draggable="true" resizable="true" order="2"/>\n    <window name="ChatWindow" width="0.2972222222222222" height="1" minWidth="-1" x="0.7013888888888888" y="0" draggable="true" resizable="true" order="1"/>\n    <window name="PresentationWindow" width="0.47152777777777777" height="0.8758434547908233" minWidth="-1" x="0.20694444444444443" y="0.004048582995951417" draggable="true" resizable="true" order="0"/>\n    <window name="UsersWindow" width="0.19444444444444445" height="0.6788124156545209" minWidth="-1" x="0" y="0" draggable="true" resizable="true" order="3"/>\n    <window name="CaptionWindow" hidden="true" order="4"/>\n  </layout>\n</layout-block>',
     set_by_userid: 'system',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     locked: false,
     users: [] },
  header:
   { name: 'broadcast_layout_message',
     version: '0.0.1',
     timestamp: 9066814 } }
```


### user_emoji_status_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     emoji_status: 'applause',
     userid: 'lwzhlo27k2zf_1' },
  header:
   { name: 'user_emoji_status_message',
     version: '0.0.1',
     timestamp: 9079921 } }
```


### mute_all_request_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     mute: true,
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { name: 'mute_all_request_message',
     version: '0.0.1',
     timestamp: 9085197 } }
```


### meeting_muted_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     meetingMuted: true },
  header:
   { name: 'meeting_muted_message',
     version: '0.0.1',
     current_time: 1502212759790,
     timestamp: 9085202 } }
```


### mute_user_in_voice_conf_request_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     voice_conf_id: '73583',
     voice_user_id: 'lwzhlo27k2zf_1',
     mute: true },
  header:
   { name: 'mute_user_in_voice_conf_request_message',
     version: '0.0.1',
     timestamp: 9085205 } }
```


### mute_all_except_presenter_request_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     mute: true,
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { name: 'mute_all_except_presenter_request_message',
     version: '0.0.1',
     timestamp: 9094221 } }
```


### send_lock_settings

```js
{ payload:
   { settings:
      { disable_private_chat: false,
        lock_on_join_configurable: false,
        lock_on_join: true,
        disable_microphone: false,
        disable_public_chat: false,
        disable_camera: true,
        locked_layout: false },
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     userid: 'lwzhlo27k2zf_1' },
  header:
   { name: 'send_lock_settings',
     version: '0.0.1',
     timestamp: 9100833 } }
```


### new_permission_settings

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     permissions:
      { disablePublicChat: false,
        lockOnJoin: true,
        disableCam: true,
        lockedLayout: false,
        lockOnJoinConfigurable: false,
        disableMic: false,
        disablePrivateChat: false },
     users: [ [Object] ] },
  header:
   { name: 'new_permission_settings',
     version: '0.0.1',
     current_time: 1502212775428,
     timestamp: 9100841 } }
```


### lock_layout_message

```js
{ payload:
   { set_by_userid: 'lwzhlo27k2zf_1',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     locked: false,
     users: [] },
  header:
   { name: 'lock_layout_message',
     version: '0.0.1',
     timestamp: 9100842 } }
```


### poll_stopped_message

```js
{ payload:
   { poll_id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/2/1502212593079',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { name: 'poll_stopped_message',
     version: '0.0.1',
     timestamp: 9192121 } }
```


### send_whiteboard_annotation_request

```js
{ payload:
   { annotation:
      { whiteboardId: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/1',
        thickness: 1,
        color: 13434624,
        points: [Array],
        status: 'DRAW_START',
        type: 'pencil',
        transparency: false,
        id: 'lwzhlo27k2zf_1-1-1502212870047' },
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { name: 'send_whiteboard_annotation_request',
     version: '0.0.1',
     timestamp: 9195467 } }
```


### clear_whiteboard_request

```js
{ payload:
   { whiteboard_id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/1',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { name: 'clear_whiteboard_request',
     version: '0.0.1',
     timestamp: 9211318 } }
```


### whiteboard_cleared_message

```js
{ payload:
   { whiteboard_id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/1',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { name: 'whiteboard_cleared_message',
     version: '0.0.1',
     current_time: 1502212885910,
     timestamp: 9211322 } }
```


### undo_whiteboard_request

```js
{ payload:
   { whiteboard_id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/1',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     requester_id: 'lwzhlo27k2zf_1' },
  header:
   { name: 'undo_whiteboard_request',
     version: '0.0.1',
     timestamp: 9212430 } }
```


### user_leaving_request

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     userid: 'lwzhlo27k2zf_1' },
  header:
   { name: 'user_leaving_request',
     version: '0.0.1',
     timestamp: 9296110 } }
```


### user_left_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     user:
      { role: 'MODERATOR',
        presenter: true,
        locked: false,
        extern_userid: 'lwzhlo27k2zf',
        phone_user: false,
        webcam_stream: [],
        emoji_status: 'none',
        voiceUser: [Object],
        name: 'User 1131066',
        listenOnly: false,
        avatarURL: 'http://10.0.3.85/client/avatar.png',
        userid: 'lwzhlo27k2zf_1',
        has_stream: false } },
  header:
   { name: 'user_left_message',
     version: '0.0.1',
     current_time: 1502212970704,
     timestamp: 9296117 } }
```


### get_whiteboard_shapes_reply

```js
{ payload:
   { whiteboard_id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240/1',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     shapes: [],
     requester_id: 'c1nkzs3k1fla_1' },
  header:
   { reply_to: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238/c1nkzs3k1fla_1',
     name: 'get_whiteboard_shapes_reply',
     version: '0.0.1',
     current_time: 1502212983495,
     timestamp: 9308908 } }
```


### send_private_chat_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     message:
      { toUsername: 'User 1131066',
        fromUserID: 'c1nkzs3k1fla_1',
        fromTimezoneOffset: '180',
        fromTime: '1.502213004718E12',
        fromColor: '0',
        message: 'hey',
        toUserID: 'cypnwcc5j26c_1',
        fromUsername: 'User 1131066',
        chatType: 'PRIVATE_CHAT' } },
  header:
   { name: 'send_private_chat_message',
     version: '0.0.1',
     timestamp: 9330159 } }
```


### user_joined_voice_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     recorded: false,
     voice_conf: '73583',
     user:
      { role: 'MODERATOR',
        presenter: true,
        locked: false,
        extern_userid: 'cypnwcc5j26c',
        phone_user: false,
        webcam_stream: [],
        emoji_status: 'none',
        voiceUser: [Object],
        name: 'User 1131066',
        listenOnly: false,
        avatarURL: 'http://10.0.3.85/client/avatar.png',
        userid: 'cypnwcc5j26c_1',
        has_stream: false } },
  header:
   { name: 'user_joined_voice_message',
     version: '0.0.1',
     current_time: 1502213029467,
     timestamp: 9354880 } }
```


### mute_user_request_message

```js
{ payload:
   { user_id: 'cypnwcc5j26c_1',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     mute: true,
     requester_id: 'cypnwcc5j26c_1' },
  header:
   { name: 'mute_user_request_message',
     version: '0.0.1',
     timestamp: 9380233 } }
```


### user_voice_muted_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     recorded: false,
     voice_conf: '73583',
     user:
      { role: 'MODERATOR',
        presenter: true,
        locked: false,
        extern_userid: 'cypnwcc5j26c',
        phone_user: false,
        webcam_stream: [],
        emoji_status: 'none',
        voiceUser: [Object],
        name: 'User 1131066',
        listenOnly: false,
        avatarURL: 'http://10.0.3.85/client/avatar.png',
        userid: 'cypnwcc5j26c_1',
        has_stream: false } },
  header:
   { name: 'user_voice_muted_message',
     version: '0.0.1',
     current_time: 1502213054837,
     timestamp: 9380250 } }
```


### eject_user_from_meeting_request_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     ejected_by: 'cypnwcc5j26c_1',
     userid: 'c1nkzs3k1fla_1' },
  header:
   { name: 'eject_user_from_meeting_request_message',
     version: '0.0.1',
     timestamp: 9420854 } }
```


### eject_user_from_voice_conf_request_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     voice_conf_id: '73583',
     voice_user_id: '3' },
  header:
   { name: 'eject_user_from_voice_conf_request_message',
     version: '0.0.1',
     timestamp: 9420866 } }
```


### user_eject_from_meeting

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     ejected_by: 'cypnwcc5j26c_1',
     userid: 'c1nkzs3k1fla_1' },
  header:
   { name: 'user_eject_from_meeting',
     version: '0.0.1',
     timestamp: 9420869 } }
```


### disconnect_user_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     userid: 'c1nkzs3k1fla_1' },
  header:
   { name: 'disconnect_user_message',
     version: '0.0.1',
     current_time: 1502213095456,
     timestamp: 9420869 } }
```


### assign_presenter_request_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     new_presenter_name: 'User 1131066',
     new_presenter_id: 'i4gv010a3gfs_1',
     assigned_by: '1' },
  header:
   { name: 'assign_presenter_request_message',
     version: '0.0.1',
     timestamp: 9611601 } }
```


### user_left_voice_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     recorded: false,
     voice_conf: '73583',
     user:
      { role: 'MODERATOR',
        presenter: true,
        locked: false,
        extern_userid: 'cypnwcc5j26c',
        phone_user: false,
        webcam_stream: [],
        emoji_status: 'none',
        voiceUser: [Object],
        name: 'User 1131066',
        listenOnly: false,
        avatarURL: 'http://10.0.3.85/client/avatar.png',
        userid: 'cypnwcc5j26c_1',
        has_stream: false } },
  header:
   { name: 'user_left_voice_message',
     version: '0.0.1',
     current_time: 1502213329446,
     timestamp: 9654859 } }
```


### user_voice_talking_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     recorded: false,
     voice_conf: '73583',
     user:
      { role: 'VIEWER',
        presenter: false,
        locked: true,
        extern_userid: 'qrxxbthmowj6',
        phone_user: false,
        webcam_stream: [],
        emoji_status: 'none',
        voiceUser: [Object],
        name: 'User 1131066',
        listenOnly: false,
        avatarURL: 'http://10.0.3.85/client/avatar.png',
        userid: 'qrxxbthmowj6_1',
        has_stream: false } },
  header:
   { name: 'user_voice_talking_message',
     version: '0.0.1',
     current_time: 1502214523052,
     timestamp: 10848465 } }
```


### user_share_webcam_request_message

```js
{ payload:
   { stream: 'medium-qrxxbthmowj6_1-1502214530909',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     userid: 'qrxxbthmowj6_1' },
  header:
   { name: 'user_share_webcam_request_message',
     version: '0.0.1',
     timestamp: 10856340 } }
```


### user_shared_webcam_message

```js
{ payload:
   { stream: 'medium-qrxxbthmowj6_1-1502214530909',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     recorded: false,
     userid: 'qrxxbthmowj6_1' },
  header:
   { name: 'user_shared_webcam_message',
     version: '0.0.1',
     current_time: 1502214530944,
     timestamp: 10856357 } }
```


### user_unshare_webcam_request_message

```js
{ payload:
   { stream: '',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     userid: 'qrxxbthmowj6_1' },
  header:
   { name: 'user_unshare_webcam_request_message',
     version: '0.0.1',
     timestamp: 10875073 } }
```


### user_unshared_webcam_message

```js
{ payload:
   { stream: 'medium-qrxxbthmowj6_1-1502214530909',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     recorded: false,
     userid: 'qrxxbthmowj6_1' },
  header:
   { name: 'user_unshared_webcam_message',
     version: '0.0.1',
     current_time: 1502214549710,
     timestamp: 10875123 } }
```


### vote_poll_user_request_message

```js
{ payload:
   { poll_id: 'c4c0fe537877278ab2a17edcace7a008386d286f-1502215082577/1/1502215264252',
     user_id: 'qrxxbthmowj6_3',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     question_id: 0,
     answer_id: 0 },
  header:
   { name: 'vote_poll_user_request_message',
     version: '0.0.1',
     timestamp: 11592559 } }
```


### user_voted_poll_message

```js
{ payload:
   { presenter_id: 'gtyw18d0yjnf_1',
     meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     poll:
      { num_respondents: 2,
        num_responders: 1,
        answers: [Array],
        id: 'c4c0fe537877278ab2a17edcace7a008386d286f-1502215082577/1/1502215264252' } },
  header:
   { name: 'user_voted_poll_message',
     version: '0.0.1',
     timestamp: 11592600 } }
```


### share_presentation

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     share: true,
     presentation_id: 'd2d9a672040fbde2a47a10bf6c37b6a4b5ae187f-1502212442240' },
  header:
   { name: 'share_presentation',
     version: '0.0.1',
     timestamp: 11721045 } }
```


### remove_presentation

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     presentation_id: 'c4c0fe537877278ab2a17edcace7a008386d286f-1502215082577' },
  header:
   { name: 'remove_presentation',
     version: '0.0.1',
     timestamp: 11737603 } }
```


### presentation_removed_message

```js
{ payload:
   { meeting_id: '0a168dbfbe554287381bf0cfe27e015e33207702-1502212442238',
     presentation_id: 'c4c0fe537877278ab2a17edcace7a008386d286f-1502215082577' },
  header:
   { name: 'presentation_removed_message',
     version: '0.0.1',
     timestamp: 11737611 } }
```
