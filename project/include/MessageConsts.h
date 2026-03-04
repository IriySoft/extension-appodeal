#ifndef EXTENSION_APPODEAL_MESSAGE_CONSTS_H
#define EXTENSION_APPODEAL_MESSAGE_CONSTS_H

const int EVENT_INIT         = 0;
const int EVENT_INTERSTITIAL = 1;
const int EVENT_REWARDED     = 2;

const int EVENTS_COUNT       = 3;

const char * APPODEAL_EVENTS[] = {
  "onInit",
  "onInterstitial",
  "onRewarded"
};

const char * appodealEvent(int id) {
  if (id < 0 || id >= EVENTS_COUNT) return NULL;
  return APPODEAL_EVENTS[id];
}

const int MSG_FAILURE     =  0;
const int MSG_SUCCESS     =  1;
const int MSG_LOADED      =  2;
const int MSG_LOAD_FAILED =  3;
const int MSG_SHOWN       =  4;
const int MSG_SHOW_FAILED =  5;
const int MSG_FINISHED    =  6;
const int MSG_CLICKED     =  7;
const int MSG_CLOSED      =  8;
const int MSG_EXPIRED     =  9;

const int MESSAGES_COUNT  = 10;

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

const char * appodealMessage(int id) {
  if (id < 0 || id >= MESSAGES_COUNT) return NULL;
  return APPODEAL_MESSAGES[id];
}



#endif