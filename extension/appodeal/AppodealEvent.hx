package extension.appodeal;

enum abstract AppodealEvent(String) from String to String {

  // Callback event categories to avoid typos
  final EVENT_INIT          = "onInit";
  final EVENT_INTERSTITIAL  = "onInterstitial";
  final EVENT_REWARDED      = "onRewarded";

  // Callback messages to avoid typos
  final MSG_FAILURE     = "Failure";
  final MSG_SUCCESS     = "Success";
  final MSG_LOADED      = "Loaded";
  final MSG_LOAD_FAILED = "Load Failed";
  final MSG_SHOWN       = "Shown";
  final MSG_SHOW_FAILED = "Show Failed";
  final MSG_FINISHED    = "Finished";
  final MSG_CLICKED     = "Clicked";
  final MSG_CLOSED      = "Closed";
  final MSG_EXPIRED     = "Expired";
}
