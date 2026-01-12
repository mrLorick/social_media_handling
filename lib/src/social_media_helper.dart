import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



class SocialMediaHandling {
  SocialMediaHandling._();

  static Future<bool> hasNetwork({bool? showToast}) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.isEmpty ||
        connectivityResult.first == ConnectivityResult.none) {
      toast(msg: 'Please check your Internet Connection');
      return false;
    } else {
      return true;
    }
  }

  static Future<void> openFacebook(String url) async {
    try {
      final facebookUrl = url.startsWith('http') ? url : 'https://facebook.com/$url';
      if (await canLaunchUrl(Uri.parse(facebookUrl))) {
        await launchUrl(
          Uri.parse(facebookUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        toast(msg: 'Cannot open Facebook');
      }
    } catch (e) {
      debugPrint('Error opening Facebook: $e');
      toast(msg: 'Error opening Facebook');

    }
  }

  static Future<void> openInstagram(String input) async {
    try {
      String username = input;
      String webUrl;

      // If full URL is passed
      if (input.startsWith('http')) {
        webUrl = input;

        final uri = Uri.parse(input);
        if (uri.pathSegments.isNotEmpty) {
          username = uri.pathSegments.first;
        }
      } else {
        // Only username passed
        webUrl = 'https://www.instagram.com/$input/';
      }

      final appUrl = 'instagram://user?username=$username';

      if (await canLaunchUrl(Uri.parse(appUrl))) {
        await launchUrl(
          Uri.parse(appUrl),
          mode: LaunchMode.externalApplication,
        );
      } else if (await canLaunchUrl(Uri.parse(webUrl))) {
        await launchUrl(
          Uri.parse(webUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        toast(msg: 'Cannot open Instagram');
      }
    } catch (e) {
      debugPrint('Error opening Instagram: $e');
      toast(msg: 'Error opening Instagram');
    }
  }


  static Future<void> openWebsite(String url) async {
    try {
      String websiteUrl = url.trim();

      if (!websiteUrl.startsWith('http://') && !websiteUrl.startsWith('https://')) {
        websiteUrl = 'https://$websiteUrl';
      }
      final uri = Uri.parse(websiteUrl);
      bool launched = false;

      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          launched = true;
        }
      } catch (e) {
        debugPrint('External app launch failed: $e');
      }

      if (!launched) {
        try {
          await launchUrl(
            uri,
            mode: LaunchMode.inAppWebView,
            webViewConfiguration: const WebViewConfiguration(
              enableJavaScript: true,
              enableDomStorage: true,
            ),
          );
          launched = true;
        } catch (e) {
          debugPrint('In-app browser launch failed: $e');
        }
      }
    } catch (e) {
      debugPrint('URL launch error: $e');
      toast(msg: 'Cannot open website');
    }
  }

  static Future<void> openWhatsApp(String phoneNumber) async {
    try {
      final whatsappUrl = 'https://wa.me/$phoneNumber';
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(
          Uri.parse(whatsappUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        toast(msg: 'WhatsApp is not installed');
      }
    } catch (e) {
      debugPrint('Error opening WhatsApp: $e');
      toast(msg: 'Error opening WhatsApp');
    }
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    try {
      final telUrl = 'tel:$phoneNumber';
      if (await canLaunchUrl(Uri.parse(telUrl))) {
        await launchUrl(
          Uri.parse(telUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        toast(msg: 'Cannot make a call');
      }
    } catch (e) {
      debugPrint('Error making call: $e');
      toast(msg: 'Error making call');
    }
  }

  static Future<void> navigateToLocation({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(
      'google.navigation:q=$latitude,$longitude&mode=d',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      toast(msg: 'Navigation not available');
    }
  }


  static void toast({required String msg, bool isError = true, Duration? duration}) {
    BotToast.showCustomText(
        duration: duration ?? const Duration(seconds: 2),
        toastBuilder: (cancelFunc) => Align(
          alignment: const Alignment(0, 0.8),
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3),
                    blurRadius: 4.0,
                    spreadRadius: 0.0,
                    offset: const Offset(0.0, 2.0,),
                  )
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isError
                            ? Colors.red.withValues(alpha: 0.2)
                            : Colors.green.withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        isError ? Icons.error : Icons.done_all,
                        color: isError ? Colors.red : Colors.green,
                      ),
                    ),
                    xWidth(10),
                    Flexible(
                      child: Text(
                        msg,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: isError ? Colors.red : Colors.green,

                        ),
                      ),
                    ),
                    xWidth(10),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}


SizedBox yHeight(double height) {
  return SizedBox(
    height: height,
  );
}

SizedBox xWidth(double width) {
  return SizedBox(
    width: width,
  );
}
