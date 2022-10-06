import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_button.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_pass_textfeild.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_text_feild.dart';
import 'package:sixvalley_vendor_app/view/screens/auth/auth_screen.dart';

import '../../../utill/images.dart';
import '../../base/custom_snackbar.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  TextEditingController fNameController = TextEditingController(text: "");
  TextEditingController lNameController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController phoneController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController cPasswordController = TextEditingController(text: "");
  TextEditingController shopNameController = TextEditingController(text: "");
  TextEditingController shopAddressController = TextEditingController(text: "");
  var isButtonLoading = false.obs;
  var image = File("/").obs;
  var logo = File("/").obs;
  var banner = File("/").obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "UPLOAD LOGO",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Obx(() {
                      return Card(
                          child: logo.value.path != "/"
                              ? Image.file(
                                  File(logo.value.path),
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                )
                              : InkWell(
                                  onTap: () async {
                                    try {
                                      var result = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);

                                      if (result != null) {
                                        Get.defaultDialog(
                                          title: "Update Logo",
                                          middleText:
                                              "Are you sure to update the seleted logo?",
                                          contentPadding: EdgeInsets.all(8),
                                          content: Image.file(
                                            File(result.path),
                                            fit: BoxFit.fitWidth,
                                            width: Get.width - 100,
                                          ),
                                          confirm: Column(
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: CustomButton(
                                                    btnTxt: "Select",
                                                    onTap: () {
                                                      logo.update((val) {
                                                        logo = File(result.path)
                                                            .obs;
                                                      });
                                                      Get.back();
                                                    },
                                                  )),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        Get.showSnackbar(const GetSnackBar(
                                          backgroundColor: Colors.red,
                                          message:
                                              "Please select a File to upload",
                                          duration:
                                              Duration(milliseconds: 3000),
                                        ));
                                      }
                                    } on PlatformException catch (e) {
                                      Get.showSnackbar(GetSnackBar(
                                        backgroundColor: Colors.red,
                                        message: "Failed: $e",
                                        duration:
                                            const Duration(milliseconds: 3000),
                                      ));
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        Images.placeholder_image,
                                        fit: BoxFit.cover,
                                        height: 150,
                                        width: Get.width - 100,
                                      ),
                                      Container(
                                        color: Colors.black.withOpacity(0.3),
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                    }),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "UPLOAD IMAGE",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    width: Get.width - 100,
                    child: Obx(() {
                      return Card(
                          child: image.value.path != "/"
                              ? Image.file(
                                  File(image.value.path),
                                  fit: BoxFit.cover,
                                  height: 150,
                                  width: Get.width - 100,
                                )
                              : InkWell(
                                  onTap: () async {
                                    try {
                                      var result = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);

                                      if (result != null) {
                                        Get.defaultDialog(
                                          title: "Update Image",
                                          middleText:
                                              "Are you sure to update the seleted image?",
                                          contentPadding: EdgeInsets.all(8),
                                          content: Image.file(
                                            File(result.path),
                                            fit: BoxFit.fitWidth,
                                            width: Get.width - 100,
                                          ),
                                          confirm: Column(
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: CustomButton(
                                                    btnTxt: "Select",
                                                    onTap: () {
                                                      image.update((val) {
                                                        image =
                                                            File(result.path)
                                                                .obs;
                                                      });
                                                      Get.back();
                                                    },
                                                  )),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        Get.showSnackbar(const GetSnackBar(
                                          backgroundColor: Colors.red,
                                          message:
                                              "Please select a File to upload",
                                          duration:
                                              Duration(milliseconds: 3000),
                                        ));
                                      }
                                    } on PlatformException catch (e) {
                                      Get.showSnackbar(GetSnackBar(
                                        backgroundColor: Colors.red,
                                        message: "Failed: $e",
                                        duration:
                                            const Duration(milliseconds: 3000),
                                      ));
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        Images.placeholder_image,
                                        fit: BoxFit.cover,
                                        height: 150,
                                        width: Get.width - 100,
                                      ),
                                      Container(
                                        color: Colors.black.withOpacity(0.3),
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                    }),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "UPLOAD BANNER",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    width: Get.width - 100,
                    child: Obx(() {
                      return Card(
                          child: banner.value.path != "/"
                              ? Image.file(
                                  File(banner.value.path),
                                  fit: BoxFit.cover,
                                  height: 150,
                                  width: Get.width - 100,
                                )
                              : InkWell(
                                  onTap: () async {
                                    try {
                                      var result = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);

                                      if (result != null) {
                                        Get.defaultDialog(
                                          title: "Update Banner",
                                          middleText:
                                              "Are you sure to update the seleted banner?",
                                          contentPadding: EdgeInsets.all(8),
                                          content: Image.file(
                                            File(result.path),
                                            fit: BoxFit.fitWidth,
                                            width: Get.width - 100,
                                          ),
                                          confirm: Column(
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: CustomButton(
                                                    btnTxt: "Select",
                                                    onTap: () {
                                                      banner.update((val) {
                                                        banner =
                                                            File(result.path)
                                                                .obs;
                                                      });
                                                      Get.back();
                                                    },
                                                  )),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        Get.showSnackbar(const GetSnackBar(
                                          backgroundColor: Colors.red,
                                          message:
                                              "Please select a File to upload",
                                          duration:
                                              Duration(milliseconds: 3000),
                                        ));
                                      }
                                    } on PlatformException catch (e) {
                                      Get.showSnackbar(GetSnackBar(
                                        backgroundColor: Colors.red,
                                        message: "Failed: $e",
                                        duration:
                                            const Duration(milliseconds: 3000),
                                      ));
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        Images.placeholder_image,
                                        fit: BoxFit.cover,
                                        height: 150,
                                        width: Get.width - 100,
                                      ),
                                      Container(
                                        color: Colors.black.withOpacity(0.3),
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                    }),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
          Container(
              margin: EdgeInsets.only(
                  left: Dimensions.PADDING_SIZE_LARGE,
                  right: Dimensions.PADDING_SIZE_LARGE,
                  bottom: Dimensions.PADDING_SIZE_SMALL),
              child: CustomTextField(
                border: true,
                hintText: getTranslated('enter_first_name', context),
                textInputType: TextInputType.name,
                controller: fNameController,
              )),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Container(
              margin: EdgeInsets.only(
                  left: Dimensions.PADDING_SIZE_LARGE,
                  right: Dimensions.PADDING_SIZE_LARGE,
                  bottom: Dimensions.PADDING_SIZE_DEFAULT),
              child: CustomTextField(
                border: true,
                hintText: getTranslated('enter_last_name', context),
                textInputType: TextInputType.name,
                controller: lNameController,
              )),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Container(
              margin: EdgeInsets.only(
                  left: Dimensions.PADDING_SIZE_LARGE,
                  right: Dimensions.PADDING_SIZE_LARGE,
                  bottom: Dimensions.PADDING_SIZE_DEFAULT),
              child: CustomTextField(
                border: true,
                hintText: getTranslated('enter_email_address', context),
                textInputType: TextInputType.emailAddress,
                controller: emailController,
              )),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Container(
              margin: EdgeInsets.only(
                  left: Dimensions.PADDING_SIZE_LARGE,
                  right: Dimensions.PADDING_SIZE_LARGE,
                  bottom: Dimensions.PADDING_SIZE_DEFAULT),
              child: CustomTextField(
                border: true,
                prefix: Text("+91  "),
                hintText: getTranslated('enter_phone_number', context),
                textInputType: TextInputType.phone,
                controller: phoneController,
              )),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Container(
              margin: EdgeInsets.only(
                  left: Dimensions.PADDING_SIZE_LARGE,
                  right: Dimensions.PADDING_SIZE_LARGE,
                  bottom: Dimensions.PADDING_SIZE_DEFAULT),
              child: CustomPasswordTextField(
                border: true,
                hintTxt: getTranslated('password', context),
                textInputAction: TextInputAction.done,
                controller: passwordController,
              )),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Container(
              margin: EdgeInsets.only(
                  left: Dimensions.PADDING_SIZE_LARGE,
                  right: Dimensions.PADDING_SIZE_LARGE,
                  bottom: Dimensions.PADDING_SIZE_DEFAULT),
              child: CustomPasswordTextField(
                border: true,
                hintTxt: getTranslated('password', context),
                textInputAction: TextInputAction.done,
                controller: cPasswordController,
              )),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Container(
              margin: EdgeInsets.only(
                  left: Dimensions.PADDING_SIZE_LARGE,
                  right: Dimensions.PADDING_SIZE_LARGE,
                  bottom: Dimensions.PADDING_SIZE_DEFAULT),
              child: CustomTextField(
                border: true,
                hintText: getTranslated('shop_name', context),
                textInputType: TextInputType.text,
                controller: shopNameController,
              )),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Container(
              margin: EdgeInsets.only(
                  left: Dimensions.PADDING_SIZE_LARGE,
                  right: Dimensions.PADDING_SIZE_LARGE,
                  bottom: Dimensions.PADDING_SIZE_DEFAULT),
              child: CustomTextField(
                border: true,
                hintText: getTranslated('shop_address', context),
                textInputType: TextInputType.text,
                controller: shopAddressController,
              )),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_LARGE),
              child: TextButton(
                onPressed: () async {
                  if (fNameController.text.isEmpty) {
                    showCustomSnackBar(
                        getTranslated('enter_first_name', context), context);
                  } else if (lNameController.text.isEmpty) {
                    showCustomSnackBar(
                        getTranslated('enter_last_name', context), context);
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(emailController.text)) {
                    showCustomSnackBar(
                        getTranslated('enter_valid_email', context), context);
                  } else if (phoneController.text.length != 10) {
                    showCustomSnackBar(
                        getTranslated('enter_phone_number', context), context);
                  } else if (passwordController.text.length < 6) {
                    showCustomSnackBar(
                        getTranslated('password_should_be', context), context);
                  } else if (cPasswordController.text !=
                      passwordController.text) {
                    showCustomSnackBar("Password missmatch", context);
                  } else if (shopNameController.text.isEmpty) {
                    showCustomSnackBar(
                        getTranslated('shop_name', context), context);
                  } else if (shopAddressController.text.isEmpty) {
                    showCustomSnackBar(
                        getTranslated('shop_address', context), context);
                  } else if (logo.value.path == "/") {
                    showCustomSnackBar("Please upload a valid Logo", context);
                  } else if (image.value.path == "/") {
                    showCustomSnackBar("Please upload a valid Image", context);
                  } else if (banner.value.path == "/") {
                    showCustomSnackBar("Please upload a valid Banner", context);
                  } else {
                    dio.FormData formData = dio.FormData.fromMap({
                      "image": await dio.MultipartFile.fromFile(
                          image.value.path,
                          filename: image.value.path.split('/').last,
                          contentType: MediaType('image', 'png')),
                      "logo": await dio.MultipartFile.fromFile(logo.value.path,
                          filename: logo.value.path.split('/').last,
                          contentType: MediaType('image', 'png')),
                      "banner": await dio.MultipartFile.fromFile(
                          banner.value.path,
                          filename: image.value.path.split('/').last,
                          contentType: MediaType('image', 'png')),
                      "email": emailController.text,
                      "shop_address": shopAddressController.text,
                      "f_name": fNameController.text,
                      "l_name": lNameController.text,
                      "shop_name": shopNameController.text,
                      "phone": "+91" + phoneController.text,
                      "password": passwordController.text,
                      "status": "approved",
                    });
                    isButtonLoading.update((val) {
                      isButtonLoading.value = true;
                    });
                    var myDio = dio.Dio();
                    myDio.options.headers["Content-Type"] =
                        "multipart/form-data";
                    await myDio
                        .post(
                      "https://ncpanel.sourcecodescript.in/api/v2/seller/auth/register",
                      data: formData,
                      options: dio.Options(
                        validateStatus: (status) => true,
                      ),
                    )
                        .then((value) {
                      isButtonLoading.update((val) {
                        isButtonLoading.value = false;
                      });

                      log(json.encode(value.data));
                      if (value.statusCode == 200) {
                        Get.showSnackbar(GetSnackBar(
                          backgroundColor: Colors.green,
                          message: value.data["message"],
                          duration: Duration(milliseconds: 3000),
                        ));
                        Get.offAll(AuthScreen());
                      } else {
                        Get.showSnackbar(GetSnackBar(
                          backgroundColor: Colors.red,
                          message: value.data["message"],
                          duration: const Duration(milliseconds: 3000),
                        ));
                      }
                    });
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: Obx(() {
                  return Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: Offset(0, 1))
                        ],
                        borderRadius: BorderRadius.circular(
                            Dimensions.PADDING_SIZE_EXTRA_SMALL)),
                    child: isButtonLoading.value
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(getTranslated('signup', context),
                            style: titilliumSemiBold.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE,
                              color: Theme.of(context).highlightColor,
                            )),
                  );
                }),
              )),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () => Get.off(AuthScreen()),
            child: Text(getTranslated('have_a_account_login', context),
                style: robotoRegular.copyWith(
                    color: Theme.of(context).primaryColor)),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
        ],
      ),
    );
  }
}
