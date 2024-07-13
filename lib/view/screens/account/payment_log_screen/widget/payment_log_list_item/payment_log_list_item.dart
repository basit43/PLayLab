import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_lab/constants/my_strings.dart';
import 'package:play_lab/view/components/divider/custom_divider.dart';
import '../../../../../../core/helper/string_format_helper.dart';
import '../../../../../../../core/utils/my_color.dart';
import '../../.././../../../core/utils/dimensions.dart';
import '../../../../../../core/utils/styles.dart';
import '../../../../../../data/controller/payment_log/deposit_controller.dart';
import '../../../../../../data/model/deposit/deposit_history_main_response_model.dart';
import '../../../../../../view/components/buttons/custom_round_border_shape.dart';
import '../../../../../../view/components/buttons/custom_rounded_button.dart';
import '../../../../../../view/components/custom_rounded_icon_button.dart';

class DepositHistoryListItem extends StatelessWidget {
  const DepositHistoryListItem({Key? key,required this.listItem,required this.index,required this.currency}) : super(key: key);
  final Data listItem;
  final int index;
  final String currency;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        margin: Dimensions.lvContainerMargin,
        padding: Dimensions.padding,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: MyColor.otpBgColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildRow(header: MyStrings.trxId, value: listItem.trx??''),
            const SizedBox(height: 10,),
            const Divider(height: 1,color:  MyColor.colorHint,),
            const SizedBox(height: 10,),
            buildRow(header: MyStrings.planName, value: listItem.subscription?.plan?.name??''),
            const SizedBox(height: 10,),
            const Divider(height: 1,color: MyColor.colorHint),
            const SizedBox(height: 10,),
            buildRow(header: MyStrings.gateway, value: listItem.gateway?.name??''),
            const SizedBox(height: 10,),
            const Divider(height: 1,color:  MyColor.colorHint),
            const SizedBox(height: 10,),
            buildRow(header: MyStrings.amount, value: '${CustomValueConverter.twoDecimalPlaceFixedWithoutRounding(listItem.amount??'')} ${listItem.methodCurrency}'),
            const SizedBox(height: 10,),
            const  Divider(height: 1,color:  MyColor.colorHint,),
            const SizedBox(height: 10,),
            buildRow(header: MyStrings.status,
                value: listItem.status.toString()=='1'?MyStrings.complete
                    :listItem.status.toString()=='2'?MyStrings.pending
                    :listItem.status.toString()=='3'?MyStrings.cancel
                    :'',isStatus: true,status
                    :listItem.status!=null?listItem.status.toString():'1'),
            const SizedBox(height: 10,),
            const  Divider(height: 1,color:  MyColor.colorHint,),
            const SizedBox(height: 10,),
            buildRow(header: '', value: '',isDetails: true),
          ],
        ),
      )
    );

  }

  Widget buildRow({required String header,required String value,bool isStatus=false,bool isDetails=false,String status='3'}){

    Color statusBgColor=MyColor.bgColor;
    Color statusTextColor=status=='1'?MyColor.greenSuccessColor:status=='2'?MyColor.highPriorityPurpleColor:status=='3'?MyColor.closeRedColor:MyColor.secondaryColor;

    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex:2,child: Text(header.tr,style: mulishBold.copyWith(color: MyColor.colorWhite),)),
        isStatus?RoundedBorderContainer(borderColor:Colors.transparent,textColor:statusTextColor,bgColor: statusBgColor,text: value.tr):
        isDetails?
        CustomRoundedButton(horizontalPadding:20,verticalPadding:5,color: MyColor.primaryColor,text: MyStrings.details.tr, press: (){buildDetailsDialog(listItem);}):
        Expanded(flex: 4, child:Text(value.tr,textAlign: TextAlign.end,style: mulishRegular.copyWith(color: MyColor.colorWhite),))
      ],
    );
  }

  void buildDetailsDialog(Data listItem) {
    String siteCurrency=Get.find<DepositController>().currency;
    Get.defaultDialog(
        title: '',
        contentPadding: const EdgeInsets.all(0),
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: MyColor.textFieldColor,
        radius: 10,
        content: Container(
          padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(MyStrings.details.tr,style: mulishBold.copyWith(fontSize: Dimensions.fontLarge,color: MyColor.colorWhite),), SizedBox(height:40,width: 40,child: CustomRoundedIconButton(iconColor:MyColor.colorWhite,color: MyColor.closeRedColor, press: (){Get.back();})),

                ],
              ),
              const SizedBox(height: 16,) ,
              buildDialogContentRow(header: MyStrings.amount, value: '${CustomValueConverter.twoDecimalPlaceFixedWithoutRounding(listItem.amount??'')} $siteCurrency'),
              buildDialogContentRow(header: MyStrings.charge, value: '${CustomValueConverter.twoDecimalPlaceFixedWithoutRounding(listItem.charge??'')}$siteCurrency'),
              buildDialogContentRow(header: MyStrings.afterCharge, value: '${CustomValueConverter.twoDecimalPlaceFixedWithoutRounding(listItem.finalAmo??'')}$siteCurrency'),
              buildDialogContentRow(header: MyStrings.conversionRate, value: '${CustomValueConverter.twoDecimalPlaceFixedWithoutRounding(listItem.rate??'')}${listItem.methodCurrency}'),
              buildDialogContentRow(header: MyStrings.payableAmount, value: '${CustomValueConverter.twoDecimalPlaceFixedWithoutRounding(listItem.finalAmo??'')}${listItem.methodCurrency}'),
              buildDialogContentRow(header: MyStrings.date, value: '${listItem.date}',needBorder: false),
            ],
          ),
        )
    );
  }

  Widget buildDialogContentRow({required String header,required String value,bool needBorder = true,}){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(header.tr,style: mulishRegular.copyWith(color: MyColor.colorWhite),),
            Expanded(child: Text(value,textAlign:TextAlign.end,style: mulishBold.copyWith(color: MyColor.colorWhite),)),
          ],
        ),
        needBorder?const CustomDivider(space: 15,):const SizedBox(height: 10,)
      ],
    );
  }
}