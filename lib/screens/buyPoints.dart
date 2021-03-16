import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:subsbooster/constant.dart';
import 'package:subsbooster/screens/userProfile.dart';



class BuyPointsScreen extends StatefulWidget {
  @override
  _BuyPointsScreenState createState() => _BuyPointsScreenState();
}

class _BuyPointsScreenState extends State<BuyPointsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){Get.back();},),
        title: Text("Buy Points",),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: (){
              Get.to(
                  UserProfile()
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text("450", style: TextStyle(fontSize: 15),),
                    SizedBox(width: 5,),
                    Container(
                      padding: EdgeInsets.all(1),
                      decoration: icondecoration,
                      child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: icondecoration,
                          child: Icon(FontAwesome.dollar, size: 12,)),
                    ),
                    SizedBox(width: 10,),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        child: Container(

          child: ListView(
            padding:EdgeInsets.symmetric(horizontal: 15,vertical: 15) ,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
               Buy(points:"+150000",dollars: 0.99,),
               Buy(points:"+170000",dollars: 1.99,),
               Buy(points:"+180000",dollars: 9.99,),
               Buy(points:"+120000",dollars: 10.99,),
               Buy(points:"+110000",dollars: 12.99,),
               Buy(points:"+100000",dollars: 11.99,),
               Buy(points:"+130000",dollars: 15.99,),
            ],
          ),
        ),
      ),
    );
  }
}

class Buy extends StatelessWidget {
  final points;
  final dollars;
  Buy({this.points,this.dollars});
  showBillSheet(BuildContext context){
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Weekly VIP Membership",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                              SizedBox(height: 4,),
                              Text("Lofty123@gmail.com",style: TextStyle(fontSize: 12,color: KGreyColor),)
                            ],
                          ),
                          Text("Rs 160.00",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 15),
      child: Container(
        margin: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(points.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                SizedBox(width: 6,),
                Container(
                  padding: EdgeInsets.all(1),
                  decoration:BoxDecoration(
                    border: Border.all(color: Colors.black,width: 2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Container(
                      padding: EdgeInsets.all(2),
                      decoration:BoxDecoration(
                        border: Border.all(color: Colors.black,width: 2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(FontAwesome.dollar,size: 12,color: Colors.black,)),
                ),
              ],
            ),
            FlatButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: KSecondaryColor,
              minWidth: 120,
              onPressed: (){
                showBillSheet(context);
              }
              ,child: FittedBox(
                child: Text(dollars.toString()+"\$", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: KPrimaryColor),)),
            ),
          ],
        ),
      ),
    );
  }
}
