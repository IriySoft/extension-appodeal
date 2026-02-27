#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "Utils.h"


using namespace appodeal;

static value appodeal_sample_method (value inputValue) {
  int returnValue = SampleMethod(val_int(inputValue));
  return alloc_int(returnValue);
}
DEFINE_PRIM (appodeal_sample_method, 1);


static void appodeal_set_verbose (value inputValue) {
  SetVerboseLog(val_bool(inputValue));
}
DEFINE_PRIM (appodeal_set_verbose, 1);


static int appodeal_get_adid (value inputValue) {
  int adId = GetAdId(val_int(inputValue));
  return alloc_int(adId);
}
DEFINE_PRIM (appodeal_get_adid, 1);


static void appodeal_init (value inputValue) {
  Init(val_string(inputValue));
}
DEFINE_PRIM (appodeal_init, 1);


extern "C" void appodeal_main () {
  val_int(0); // Fix Neko init
}
DEFINE_ENTRY_POINT (appodeal_main);

extern "C" int appodeal_register_prims () { return 0; }