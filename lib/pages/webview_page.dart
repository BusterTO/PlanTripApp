import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:plantripapp/theme.dart';

class WebviewPage extends StatelessWidget {
  final String? title;
  final String? url;
  WebviewPage({Key? key, required this.url, this.title}) : super(key: key);

  final isLoading = true.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Get.theme.backgroundColor,
        systemOverlayStyle: Get.isDarkMode
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: InkWell(
            child: Icon(
              BootstrapIcons.chevron_left,
              size: 22,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            onTap: () {
              Get.back();
            },
          ),
        ),
        title:
            Text(title ?? "Information", style: Get.theme.textTheme.headline6),
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: EdgeInsets.zero,
        child: Obx(
          () => Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(url!)),
                onLoadStart: (controller, url) {
                  isLoading.value = true;
                },
                onLoadStop: (controller, url) {
                  isLoading.value = false;
                },
                onLoadError: (controller, url, code, message) {
                  isLoading.value = false;
                },
              ),
              if (isLoading.value)
                Container(
                  alignment: Alignment.center,
                  width: Get.width,
                  height: Get.height,
                  child: MyTheme.loading(),
                )
            ],
          ),
        ),
      ),
    );
  }
}
