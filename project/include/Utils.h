#ifndef EXTENSION_APPODEAL_UTILS_H
#define EXTENSION_APPODEAL_UTILS_H

extern "C" void sendExternalEvent(const char* type, const char* data);

namespace appodeal {
  int SampleMethod(int inputValue);
  void InitAppodeal(const char *appId, int adTypes, bool testing);
  void SetVerboseLog(bool isVerbose);
  int GetAdId(int adType);
}

#endif