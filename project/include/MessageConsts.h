#ifndef EXTENSION_APPODEAL_MESSAGE_CONSTS_H
#define EXTENSION_APPODEAL_MESSAGE_CONSTS_H

inline const int EVENT_INIT         = 0;
inline const int EVENT_INTERSTITIAL = 1;
inline const int EVENT_REWARDED     = 2;

inline const int EVENTS_COUNT       = 3;

inline const char * appodealEvent(int id) {
  if (id < 0 || id >= EVENTS_COUNT) return NULL;
  return APPODEAL_EVENTS[id];
}

const char * APPODEAL_EVENTS[] = {
  "onInit",
  "onInterstitial",
  "onRewarded"
};

inline const int MSG_FAILURE     =  0;
inline const int MSG_SUCCESS     =  1;
inline const int MSG_LOADED      =  2;
inline const int MSG_LOAD_FAILED =  3;
inline const int MSG_SHOWN       =  4;
inline const int MSG_SHOW_FAILED =  5;
inline const int MSG_FINISHED    =  6;
inline const int MSG_CLICKED     =  7;
inline const int MSG_CLOSED      =  8;
inline const int MSG_EXPIRED     =  9;

inline const int MESSAGES_COUNT  = 10;

inline const char * appodealMessage(int id) {
  if (id < 0 || id >= MESSAGES_COUNT) return NULL;
  return APPODEAL_MESSAGES[id];
}

const char * APPODEAL_MESSAGES[] = {
  "Failure",
  "Success",
  "Loaded",
  "Load Failed",
  "Shown",
  "Show Failed",
  "Finished",
  "Clicked",
  "Closed",
  "Expired"
};

#endif