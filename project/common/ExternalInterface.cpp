#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "Utils.h"
#include <iostream>


using namespace appodeal;

//AutoGCRoot* extCallback = NULL;
value * extCallback = NULL;

static void sendExternalEvent(const char *event, const char *data) {
  std::cout << "Appodeal CPP Event: "<<event<<", data: "<<data<<"\n";

  if (extCallback != NULL && val_is_function(*extCallback)) {
    //val_call2(extCallback->get(), alloc_string(event), alloc_string(data));

    val_call2(*extCallback, alloc_string(event), alloc_string(data));
  }
}


static void appodeal_init (value appId, value adTypes, value testing, value callback) {
  //extCallback = new AutoGCRoot(callback);
  std::cout << "Appodeal CPP INIT callback "<<" type: "<<val_type(callback)<<", function: "<<val_is_function(callback)<<"\n";
  //if (extCallback == NULL) extCallback = new AutoGCRoot(callback);
  if (extCallback == NULL) extCallback = alloc_root();
  //std::cout << "Appodeal CPP AGCR type: "<<val_type(extCallback->get())<<", function: "<<val_is_function(extCallback->get())<<"\n";
  if (val_is_function(callback)) {
    *extCallback = callback;
    std::cout << "Appodeal CPP Callback is a function!\n";
    //val_call2(*extCallback, alloc_string("EVT"), alloc_string("DT"));
    sendExternalEvent("Init", "Test");
  } else {
    std::cout << "Appodeal CPP Callback is NOT a function!\n";
  }
  InitAppodeal(val_string(appId), val_int(adTypes), val_bool(testing));
}
DEFINE_PRIM (appodeal_init, 4);



static value appodeal_sample_method (value inputValue) {
  int returnValue = SampleMethod(val_int(inputValue));
  return alloc_int(returnValue);
}
DEFINE_PRIM (appodeal_sample_method, 1);


static void appodeal_set_verbose (value verboseMode) {
  SetVerboseLog(val_bool(verboseMode));
}
DEFINE_PRIM (appodeal_set_verbose, 1);


static value appodeal_get_adid (value extAdType) {
  int adId = GetAdId(val_int(extAdType));
  return alloc_int(adId);
}
DEFINE_PRIM (appodeal_get_adid, 1);


extern "C" void appodeal_main () {
  val_int(0); // Fix Neko init
}
DEFINE_ENTRY_POINT (appodeal_main);

extern "C" int appodeal_register_prims () { return 0; }