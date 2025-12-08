package extension.appodeal;

import lime.system.CFFI;
import lime.system.JNI;

class Appodeal {
	public static var inited (default, null): Bool = false;

	public static function Init(gameID: String): Void {
		#if android
		if (init_jni == null)
			init_jni = JNI.createStaticMethod("org/haxe/extension/AppodealSdk", "Init", "(Ljava/lang/String;)V");
		init_jni(gameID);
		inited = true;
		#end
	}

	public static function ShowInterstitial(): Void {
		#if android
		if (showInterstitial_jni == null)
			showInterstitial_jni = JNI.createStaticMethod("org/haxe/extension/AppodealSdk", "ShowInterstitial", "()V");
		showInterstitial_jni();
		#end
	}

	// private static var sample_method = CFFI.load("extension_appodeal", "extension_appodeal_sample_method", 1);
	#if android
	private static var init_jni = null;
	private static var showInterstitial_jni = null;
	#end
}
