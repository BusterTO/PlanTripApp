import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:plantripapp/core/my_pref.dart';
import 'package:plantripapp/core/xcontroller.dart';
import 'package:plantripapp/models/card_model.dart';
import 'package:plantripapp/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MyCardPage extends StatelessWidget {
  MyCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final XController x = XController.to;
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          body: SizedBox(
            width: Get.width,
            height: Get.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: Get.mediaQuery.padding.top),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 0, top: 8, bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: Get.back,
                        icon: const Icon(BootstrapIcons.chevron_left, size: 28),
                      ),
                      Text("My Credit Card",
                          style: Get.theme.textTheme.headline6),
                      IconButton(
                        onPressed: () {
                          addNewCard(MyPref.to);
                        },
                        icon: const Icon(BootstrapIcons.plus, size: 28),
                      ),
                    ],
                  ),
                ),
                //spaceHeight5,
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        spaceHeight10,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Obx(
                            () => listCard(x, MyPref.to, reloadCard.value),
                          ),
                        ),
                        spaceHeight50,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final reloadCard = false.obs;
  Widget listCard(
      final XController x, final MyPref myPref, final bool isReload) {
    final getStringCard = myPref.pMyCard.val;
    List<CardModel> cards = [];
    if (getStringCard != '') {
      List<dynamic> oldCards = jsonDecode(getStringCard);
      for (var element in oldCards) {
        cards.add(CardModel.fromMap(element));
      }
    }

    if (cards.isEmpty) {
      EasyLoading.showToast('Empty data card, add new card...');
    }

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (cards.isEmpty) {
        addNewCard(myPref);
      }
    });
    return cards.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset("assets/empty_data.png",
                      width: Get.width / 2),
                ),
                Text("Data not found".tr, style: textBold),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: cards.map((CardModel e) {
              //final int index = cards.indexOf(e);
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Get.theme.colorScheme.secondary.withOpacity(.5),
                      blurRadius: 5.0,
                      offset: const Offset(2, 5),
                    )
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("xxxx xxxx xxxx ${e.no!.substring(15)}",
                          style: textBold.copyWith(fontSize: 14)),
                      Text("${e.name}",
                          style: textSmall.copyWith(fontSize: 12)),
                      Container(
                        height: 33,
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${e.exp}",
                              style: textSmallGrey,
                            ),
                            Text("${e.provider}",
                                style: textSmall.copyWith(fontSize: 15)),
                            IconButton(
                              onPressed: () async {},
                              icon: Icon(BootstrapIcons.trash,
                                  size: 22, color: Get.theme.primaryColor),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          );
  }

  //add new card
  addNewCard(final MyPref myPref) {
    showCupertinoModalBottomSheet(
      context: Get.context!,
      builder: (context) => Container(
        width: Get.width,
        height: Get.height,
        color: Get.theme.backgroundColor,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: Get.width,
                height: Get.height,
                margin: const EdgeInsets.only(top: 40),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width,
                      child: Text(
                        "Add New Card".tr,
                        textAlign: TextAlign.center,
                        style: textBold.copyWith(fontSize: 18),
                      ),
                    ),
                    spaceHeight10,
                    childFormCreditCard(myPref),
                    spaceHeight5,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            margin: const EdgeInsets.only(
                                left: 0, right: 0, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Close",
                                    style: textSmall.copyWith(fontSize: 18))
                              ],
                            ),
                          ),
                        ),
                        spaceWidth10,
                        InkWell(
                          onTap: () async {
                            Get.back();

                            addDeleteCard(myPref, dataFormCard, true);

                            await Future.delayed(
                                const Duration(milliseconds: 1200), () {
                              reloadCard.value = !reloadCard.value;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            margin: const EdgeInsets.only(
                                left: 0, right: 0, bottom: 10),
                            decoration: BoxDecoration(
                              color: Get.theme.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Submit",
                                    style: textBold.copyWith(
                                        color: Colors.white, fontSize: 18))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    spaceHeight20,
                    spaceHeight20,
                  ],
                ),
              ),
              Positioned(
                top: 10,
                left: 0,
                child: Container(
                  margin: const EdgeInsets.only(top: 0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(BootstrapIcons.chevron_down, size: 30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static final dataFormCard = {
    "no": "",
    "exp": "",
    "cname": "",
    "cvv": "",
    "brand": "",
    "focus": "1",
  }.obs;

  static final brand = ''.obs;
  static final GlobalKey<FormState> formCardKey = GlobalKey<FormState>();

  static Widget childFormCreditCard(final MyPref myPref) {
    return Column(
      children: [
        Obx(
          () => CreditCardWidget(
            onCreditCardWidgetChange: (CreditCardBrand dtbrand) {
              debugPrint(dtbrand.brandName.toString());
              brand.value = dtbrand.brandName.toString();
            },
            cardNumber: dataFormCard['no'].toString(),
            expiryDate: dataFormCard['exp'].toString(),
            cardHolderName: dataFormCard['cname'].toString(),
            cvvCode: dataFormCard['cvv'].toString(),
            showBackView: int.parse(dataFormCard['focus'].toString()) == 1,
            cardBgColor: Get.theme.scaffoldBackgroundColor,
            obscureCardNumber: true,
            obscureCardCvv: true,
            height: 155,
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            width: Get.width,
            animationDuration: const Duration(milliseconds: 1000),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: CreditCardForm(
            cardNumber: dataFormCard['no'].toString(),
            expiryDate: dataFormCard['exp'].toString(),
            cardHolderName: dataFormCard['cname'].toString(),
            cvvCode: dataFormCard['cvv'].toString(),
            formKey: formCardKey, // Required
            onCreditCardModelChange: (CreditCardModel creditCardModel) {
              String cardNumber = creditCardModel.cardNumber;
              String expiryDate = creditCardModel.expiryDate;
              String cardHolderName = creditCardModel.cardHolderName;
              String cvvCode = creditCardModel.cvvCode;
              bool isCvvFocused = creditCardModel.isCvvFocused;

              dynamic valCard = {
                "no": cardNumber,
                "exp": expiryDate,
                "cname": cardHolderName,
                "cvv": cvvCode,
                "brand": brand.value,
                "focus": isCvvFocused ? "1" : "0",
              };

              dataFormCard.value = valCard;
            }, // Required
            themeColor: Colors.red,
            obscureCvv: true,
            obscureNumber: true,
            cardNumberDecoration: MyTheme.inputFormAccent(
              'XXXX XXXX XXXX XXXX',
              Get.theme.cardColor,
              Get.theme.primaryColor,
            ).copyWith(labelText: 'Number'),
            expiryDateDecoration: MyTheme.inputFormAccent(
              'XX/XX',
              Get.theme.cardColor,
              Get.theme.primaryColor,
            ).copyWith(
              labelText: 'Expired Date',
            ),
            cvvCodeDecoration: MyTheme.inputFormAccent(
              'XXX',
              Get.theme.cardColor,
              Get.theme.primaryColor,
            ).copyWith(
              labelText: 'CVV',
            ),
            cardHolderDecoration: MyTheme.inputFormAccent(
              'Card Holder Name',
              Get.theme.cardColor,
              Get.theme.primaryColor,
            ).copyWith(
              labelText: 'Card Holder',
            ),
          ),
        ),
      ],
    );
  }

  static addDeleteCard(
      final MyPref myPref, final dynamic card, final bool isNew) {
    final getStringCard = myPref.pMyCard.val;

    //is tobe deleted
    if (!isNew) {
      List<dynamic> newCards = [];

      List<dynamic> oldCards = jsonDecode(getStringCard);
      if (oldCards.length == 1) {
        myPref.pMyCard.val = '';
        return;
      }

      for (var element in oldCards) {
        if (element['no'] != card['no']) {
          newCards.add(element);
        }
      }

      myPref.pMyCard.val = jsonEncode(newCards);
      EasyLoading.showToast('Delete successful...');

      return;
    }

    if (card != null && card['no'] != null) {
      List<CardModel> myCards = [];

      if (getStringCard == '') {
        if (card != null && card['no'] != '') {
          myCards.add(
            CardModel(
              id: "1",
              name: "${card['cname']}",
              exp: "${card['exp']}",
              no: "${card['no']}",
              cvv: "${card['cvv']}",
              provider: "${card['brand']}",
            ),
          );
        }
      } else {
        List<dynamic> oldCards = jsonDecode(getStringCard);
        int idCard = 1;
        for (var element in oldCards) {
          myCards.add(CardModel.fromMap(element));
          idCard++;
        }

        //idCard++;
        myCards.add(
          CardModel(
            id: "$idCard",
            name: card['cname'],
            exp: card['exp'],
            no: card['no'],
            cvv: card['cvv'],
            provider: card['brand'],
          ),
        );
      }

      //save or update
      List<dynamic> dataCards = [];
      for (var element in myCards) {
        dataCards.add(element.toJson());
      }
      myPref.pMyCard.val = jsonEncode(dataCards);

      EasyLoading.showToast('Process successful...');
    }
  }
}
