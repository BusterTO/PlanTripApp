import 'dart:convert';
import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/widgets/input_container.dart';

class ItemUploadImage extends StatelessWidget {
  final String? counter;
  final String? uriToUpload;
  final bool? uploading;
  final bool? selected;
  final int? type;

  final Function(String image)? callback;

  ItemUploadImage({
    Key? key,
    required this.counter,
    this.uriToUpload,
    this.uploading = false,
    this.selected = false,
    this.type,
    this.callback,
  }) : super(key: key) {
    if (type != null) {
      final XController x = XController.to;
      if (type == 1 && selected!) {
        Future.microtask(() => pickImageSource(x, 1));
      } else if (type == 2 && selected!) {
        Future.microtask(() => pickImageSource(x, 2));
      }
    }

    if (uriToUpload != null && uriToUpload != '') {
      Future.microtask(() => imagePath.value = uriToUpload!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          if (uploading!)
            const SizedBox(
              height: 80,
              width: 80,
              child: Align(
                alignment: Alignment.center,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          Obx(
            () => SizedBox(
              child: InputContainer(
                backgroundColor: selected!
                    ? Get.theme.primaryColor.withOpacity(.3)
                    : Colors.transparent,
                child: imagePath.value == ''
                    ? Image.asset(
                        "assets/image_default_trans.png",
                        height: 80,
                        width: 80,
                        fit: BoxFit.fitWidth,
                      )
                    : imagePath.value.contains('http')
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: ExtendedImage.network(
                              imagePath.value,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: ExtendedImage.file(
                              File(imagePath.value),
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            left: 0,
            child: SizedBox(
              width: 80,
              child: Text(
                counter!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (uploading!)
            Positioned(
              top: 15,
              right: 10,
              child: SizedBox(
                child: Icon(
                  BootstrapIcons.trash,
                  size: 13,
                  color: Get.theme.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  final double maxHeight = 512;
  final double maxWidth = 512;
  final imagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  pickImageSource(final XController x, final int tipe) async {
    // pick gallery
    if (tipe == 1) {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
      );
      if (image != null) {
        imagePath.value = image.path;

        Future.microtask(() {
          String? base64Image =
              base64Encode(File(image.path).readAsBytesSync());
          startUpload(x, base64Image, x.basename(image.path));
        });
      }
    }
    // camera photo
    else {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
      );
      if (image != null) {
        imagePath.value = image.path;

        Future.microtask(() {
          String? base64Image =
              base64Encode(File(image.path).readAsBytesSync());
          startUpload(x, base64Image, x.basename(image.path));
        });
      }
    }
  }

  startUpload(final XController x, final String base64Image,
      final String fileName) async {
    String idUser = x.thisUser.value.id!;

    var dataPush = jsonEncode({
      "filename": fileName,
      "id": idUser,
      "image": base64Image,
    });

    //debugPrint(dataPush);
    var path = "upload/upload_image_temp";
    //debugPrint(link);

    try {
      final Response? result = await x.provider.pushResponse(path, dataPush);
      dynamic dataresult = jsonDecode(result!.bodyString!);
      //debugPrint(_result);

      //EasyLoading.dismiss();
      if (dataresult['code'] == '200') {
        //EasyLoading.showSuccess("Process success...");
        String fileUploaded = "${dataresult['result']['file']}";
        debugPrint(fileUploaded);

        Future.microtask(() => callback!(fileUploaded));
      } else {
        EasyLoading.showError("Process failed...");
      }
      String respCode = result.statusCode == 200
          ? dataresult['code'] == '200'
              ? "Uploaded"
              : "ErrorServer"
          : "ServerError";

      debugPrint(respCode);
    } catch (e) {
      debugPrint("Error ItemUploadImage ${e.toString()}");
    }
  }
}
