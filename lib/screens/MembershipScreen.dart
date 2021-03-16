import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:subsbooster/constant.dart';

class MembershipScreen extends StatefulWidget {
  @override
  _MembershipScreenState createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
   showBillSheet(){
     showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.all(0),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  child: Container(
                      width: Get.width,
                      padding: EdgeInsets.only(left: 20,top: 10,bottom: 10),
                      child: Text(
                        "Google Play",
                        style: TextStyle(fontSize: 14,color: KGreyColor),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15,left: 15,right: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child:Image.asset("assets/subsbooster.png",height: 40,width: 40,),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Weekly VIP Membership",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                              SizedBox(height: 4,),
                              Text("Lofty123@gmail.com",style: TextStyle(fontSize: 12,color: KGreyColor),)
                            ],
                          )
                        ],
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 20,bottom: 20,left: 5),
                        child: Text("Add a payment method to complete your purchase. Your payment information is only visible to Google,",
                          style: TextStyle(fontSize: 14,color: KGreyColor),),
                      ),

                      Container(
                        padding: EdgeInsets.only(left: 20,top: 15,bottom: 15),
                        width: Get.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: KGreyColor.withOpacity(0.4),width: 0.5),
                        ),
                        child: Row(
                          children: [
                            Icon(FontAwesome.mobile,color: Colors.green,size: 26,),
                            SizedBox(width: 10,),
                            Text("Add Jazz billing",style: TextStyle(fontSize: 14),),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.only(left: 20,top: 15,bottom: 15),
                        width: Get.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: KGreyColor.withOpacity(0.4),width: 0.5),
                        ),
                        child: Row(
                          children: [
                            Icon(FontAwesome.credit_card,color: Colors.green,size: 16,),
                            SizedBox(width: 18,),
                            Text("Add credit or debit card",style: TextStyle(fontSize: 14),),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                )
              ],
            ),
          );
        }
        );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "SubsBooster",
        ),
        centerTitle: true,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    "450",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: icondecoration,
                    child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: icondecoration,
                        child: Icon(
                          FontAwesome.dollar,
                          size: 12,
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(15),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            Card(
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {},
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/vip.png",
                        height: 100,
                      ),
                      Text(
                        "BENEFITS",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "20% Off on Campaigns",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Increased Daily Limits ( +50)",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Remove Ads",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Card(
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  showBillSheet();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "1 Week",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "1.99\$",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Card(
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  showBillSheet();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "1 Month ( Save 40% )",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "4.99\$",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Card(
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  showBillSheet();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "3 Month ( Save 50% )",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "11.99\$",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Card(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Note : Subscriptions are renewed according to specified peroid. in case you want to stop, renew at anytime, you must enter Google Play Store - Menu - Subscriptions  SubsBoster - Cancle Subscription",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
