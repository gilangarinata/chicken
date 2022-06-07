import 'dart:async';
import 'dart:io';

import 'package:chicken_fan/CelldeckDialog.dart';
import 'package:chicken_fan/dataResponse.dart';
import 'package:chicken_fan/kipasADialog.dart';
import 'package:chicken_fan/kipasDialog.dart';
import 'package:chicken_fan/statusResponse.dart';
import 'package:chicken_fan/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:open_settings/open_settings.dart';

class HomeScreen2 extends StatefulWidget {
  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> with TickerProviderStateMixin {

  bool notifWifiIsSHowing = false;
  DataResponse mDataResponse;
  String baseUrl;

  Future<DataResponse> getData() async {
    DateTime now = DateTime.now();
    int total = (now.hour * 3600) + (now.minute * 60) + (now.second);
    String url = "http://192.168.2.1/" + "getData2?timnow=" + total.toString();
    print(url);

    Response response;
    try{
      response = await Dio().get(
        url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        sendTimeout: 900,
        receiveTimeout: 900),
      );
    }catch(e){
      print(e);
      response = null;
    }

    if(response!=null) {
      if (response.statusCode == 200) {
        DataResponse results = DataResponse.fromJson(response.data);
        return results;
      } else {
        return null;
      }
    }else{
      return null;
    }
  }

  AnimationController _controllerKipasA;
  AnimationController _controllerKipas1;
  AnimationController _controllerKipas2;
  AnimationController _controllerKipas3;
  AnimationController _controllerKipas4;
  AnimationController _controllerKipas5;


  BuildContext dialogContext;
  @override
  void initState() {
    super.initState();
    _controllerKipasA = AnimationController(vsync: this, duration: Duration(milliseconds: 3000));
    _controllerKipas1 = AnimationController(vsync: this, duration: Duration(milliseconds: 3000));
    _controllerKipas2 = AnimationController(vsync: this, duration: Duration(milliseconds: 3000));
    _controllerKipas3 = AnimationController(vsync: this, duration: Duration(milliseconds: 3000));
    _controllerKipas4 = AnimationController(vsync: this, duration: Duration(milliseconds: 3000));
    _controllerKipas5 = AnimationController(vsync: this, duration: Duration(milliseconds: 3000));

    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(
        oneSec, (Timer t) async {
          var data;
          try{
             data = await getData().timeout(Duration(milliseconds: 7000));
          }catch(e){
            data = null;
          }

        if(data != null){
          setState(() {
            this.mDataResponse = data;
          });
          if(notifWifiIsSHowing) Navigator.pop(dialogContext);
          return;
        }
        print("DT isnull");
        if(!notifWifiIsSHowing){
          showDialog(
              context: context,
            builder: (BuildContext context) {
              dialogContext = context;
              notifWifiIsSHowing = true;
              return Dialog(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 30),
                      child: Center(
                        child: Column(
                          children: [
                            Text("Anda belum terkoneksi dengan alat."),
                            Text("Silahkan koneksikan WIFI anda ke"),
                            Text(" \"KIPAS : FAUZI BROILER\" ",style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(height: 20,),
                            ElevatedButton(
                                child: Text(
                                    "Koneksikan Sekarang",
                                    style: TextStyle(fontSize: 14)
                                ),
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                            side: BorderSide(color: Colors.teal)
                                        )
                                    )
                                ),
                                onPressed: () {
                                  OpenSettings.openWIFISetting();
                                }
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
            },

          ).then((value) {
              notifWifiIsSHowing = false;
          });
        }
    });
  }


  @override
  Widget build(BuildContext context) {


    if(mDataResponse != null){
      if(mDataResponse.fanA.statusRelay){
        _controllerKipasA.repeat();
      }else{
        _controllerKipasA.stop();
      }

      if(mDataResponse.fan1.statusRelay){
        _controllerKipas1.repeat();
      }else{
        _controllerKipas1.stop();
      }

      if(mDataResponse.fan2.statusRelay){
        _controllerKipas2.repeat();
      }else{
        _controllerKipas2.stop();
      }

      if(mDataResponse.fan3.statusRelay){
        _controllerKipas3.repeat();
      }else{
        _controllerKipas3.stop();
      }

      if(mDataResponse.fan4.statusRelay){
        _controllerKipas4.repeat();
      }else{
        _controllerKipas4.stop();
      }

      if(mDataResponse.heater.statusRelay){
        _controllerKipas5.repeat();
      }else{
        _controllerKipas5.stop();
      }
    }


    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    LineIcons.lowTemperature,
                                    size: 50,
                                    color: Colors.blueGrey,
                                  ),
                                  SizedBox(width: 5,),
                                  Text(mDataResponse != null ? mDataResponse.temperature.toString() : "0"  , style: TextStyle(fontSize: 30, color: Colors.blueGrey),),
                                  Text("\u2103", style: TextStyle(fontSize: 18, color: Colors.blueGrey),)
                                ],
                              ),
                              Text("Suhu kandang Lt2", style: TextStyle(fontSize: 10),),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    LineIcons.tint,
                                    size: 50,
                                    color: Colors.blueGrey,
                                  ),
                                  SizedBox(width: 5,),
                                  Text(mDataResponse != null ? mDataResponse.humidity.toString() : "0" , style: TextStyle(fontSize: 30, color: Colors.blueGrey),),
                                  Text("%", style: TextStyle(fontSize: 18, color: Colors.blueGrey),)
                                ],
                              ),
                              Text("Kelembaban", style: TextStyle(fontSize: 10),),
                            ],
                          ),

                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                LineIcons.tint,
                                size: 50,
                                color: Colors.blueGrey,
                              ),
                              SizedBox(width: 5,),
                              Text(mDataResponse != null ? mDataResponse.amonia.toString() : "0" , style: TextStyle(fontSize: 30, color: Colors.blueGrey),),
                              Text("PPM", style: TextStyle(fontSize: 18, color: Colors.blueGrey),)
                            ],
                          ),
                          Text("Amonia", style: TextStyle(fontSize: 10),),
                        ],
                      )
                    ],
                  ),
                )),

            getFanALayout(context),
            getCelldeckLayout(context),
            getLampLayout(context),
            getFan1Layout(context),
            getFan2Layout(context),
            getFan3Layout(context),
            getFan4Layout(context),
            getFan5Layout(context),

            // SizedBox(height: 100,),
            // getCounterLayout(context)
          ],
        ),
      ),
    );
  }

  Widget getFanALayout(BuildContext context){
    return InkWell(
      onTap: (){
        showDialog(
            context: context,
            builder: (_) => KipasADialog(data: mDataResponse != null ? mDataResponse.fanA : null,lantai: 2,)).then((value) {
          if (value) {

          }
        });
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 0, vertical: 2),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(6)),
            color: Colors.white,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Intermitten 1", style: TextStyle(fontSize: 18),),
                          SizedBox(height: 10,),
                          AnimatedBuilder(
                            animation: _controllerKipasA,
                            builder: (_, widget) {
                              return Transform.rotate(
                                angle: _controllerKipasA.value * 10,
                                child: widget,
                              );
                            },
                            child: Icon(LineIcons.radiation, size: 30, color: mDataResponse != null ? mDataResponse.fanA.statusRelay ? Colors.red : Colors.black54 : Colors.black54,),
                          ),
                          Row(
                            children: [
                              Text(mDataResponse != null ? mDataResponse.fanA.statusRelay ? "Hidup" : "Mati" : "Mati", style: TextStyle(fontSize: 10,color: mDataResponse != null ? mDataResponse.fanA.statusRelay ? Colors.red : Colors.black54 : Colors.black54),),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Lama Hidup", style: TextStyle(fontSize: 14),),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(mDataResponse != null ? mDataResponse.fanA.onDuration.toString() : "0", style: TextStyle(fontSize: 24, color: Colors.blueGrey),),
                              Text(" Menit", style: TextStyle(fontSize: 10),),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text("Sisa ", style: TextStyle(fontSize: 10),),
                              Text(mDataResponse != null ? Utils.millisToMinutesSecon(mDataResponse.fanA.onLeftDuration)  : "0", style: TextStyle(fontSize: 12, color: Colors.red),),
                              Text("", style: TextStyle(fontSize: 10),),
                            ],
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Lama Mati", style: TextStyle(fontSize: 14),),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(mDataResponse != null ? mDataResponse.fanA.offDuration.toString()  : "0", style: TextStyle(fontSize: 24, color: Colors.blueGrey),),
                              Text(" Menit", style: TextStyle(fontSize: 10),),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text("Sisa ", style: TextStyle(fontSize: 10),),
                              Text(mDataResponse != null ? Utils.millisToMinutesSecon(mDataResponse.fanA.offLeftDuration).toString()  : "0", style: TextStyle(fontSize: 12, color: Colors.red),),
                              Text("", style: TextStyle(fontSize: 10),),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getCelldeckLayout(BuildContext context){
    return InkWell(
      onTap: (){
        showDialog(
            context: context,
            builder: (_) => CelldeckDialog(data: mDataResponse != null ? mDataResponse.cellDeck : null,lantai: 2,)).then((value) {
          if (value) {

          }
        });
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 0, vertical: 2),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(6)),
            color: Colors.white,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Intermitten 2", style: TextStyle(fontSize: 18),),
                          SizedBox(height: 10,),
                          Icon(LineIcons.wind, size: 30, color: mDataResponse != null ? mDataResponse.cellDeck.statusRelay ? Colors.red : Colors.black54 : Colors.black54,),
                          Row(
                            children: [
                              Text(mDataResponse != null ? mDataResponse.cellDeck.statusRelay ? "Hidup" : "Mati" : "Mati", style: TextStyle(fontSize: 10,color: mDataResponse != null ? mDataResponse.cellDeck.statusRelay ? Colors.red : Colors.black54 : Colors.black54),),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Lama Hidup", style: TextStyle(fontSize: 14),),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(mDataResponse != null ? mDataResponse.cellDeck.onDuration.toString() : "0", style: TextStyle(fontSize: 24, color: Colors.blueGrey),),
                              Text(" Menit", style: TextStyle(fontSize: 10),),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text("Sisa ", style: TextStyle(fontSize: 10),),
                              Text(mDataResponse != null ? Utils.millisToMinutesSecon(mDataResponse.cellDeck.onLeftDuration).toString() : "0", style: TextStyle(fontSize: 12, color: Colors.red),),
                            ],
                          ),

                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Lama Mati", style: TextStyle(fontSize: 14),),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(mDataResponse != null ? mDataResponse.cellDeck.offDuration.toString() : "0", style: TextStyle(fontSize: 24, color: Colors.blueGrey),),
                              Text(" Menit", style: TextStyle(fontSize: 10),),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text("Sisa ", style: TextStyle(fontSize: 10),),
                              Text(mDataResponse != null ? Utils.millisToMinutesSecon(mDataResponse.cellDeck.offLeftDuration).toString() : "0", style: TextStyle(fontSize: 12, color: Colors.red),),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getLampLayout(BuildContext context){
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 0, vertical: 2),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(6)),
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Timer", style: TextStyle(fontSize: 18),),
                        SizedBox(height: 10,),
                        Icon(LineIcons.lightbulb, size: 30, color: mDataResponse != null ? mDataResponse.lamp.statusRelay ? Colors.red : Colors.black54 : Colors.black54,),
                        Row(
                          children: [
                            Text(mDataResponse != null ? mDataResponse.lamp.statusRelay ? "Hidup" : "Mati" : "Mati", style: TextStyle(fontSize: 10,color: mDataResponse != null ? mDataResponse.lamp.statusRelay ? Colors.red : Colors.black54 : Colors.black54),),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: (){
                        DatePicker.showTimePicker(context,
                            showTitleActions: true,
                            showSecondsColumn: false,
                            onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                                int hour = date.hour * 3600;
                                int minutes = date.minute * 60;
                                var totalHour = hour + minutes;
                                print(totalHour.toString());
                                saveDataLamp(totalHour.toString(), mDataResponse != null ? mDataResponse.lamp.lampOffHour.toString() : "0");
                            }, currentTime: DateTime.now(), locale: LocaleType.id);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Jam Hidup", style: TextStyle(fontSize: 14),),
                          SizedBox(height: 5,),
                          Text(mDataResponse != null ? Utils.seconToMillisSecon(mDataResponse.lamp.lampOnHour).toString() : "0", style: TextStyle(fontSize: 24, color: Colors.blueGrey),),
                          SizedBox(height: 5,),

                        ],
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        DatePicker.showTimePicker(context,
                            showTitleActions: true,
                            showSecondsColumn: false,
                            onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              int hour = date.hour * 3600;
                              int minutes = date.minute * 60;
                              var totalHour = hour + minutes;
                              print(totalHour.toString());
                              saveDataLamp(mDataResponse != null ? mDataResponse.lamp.lampOnHour.toString() : "0",totalHour.toString());
                            }, currentTime: DateTime.now(), locale: LocaleType.id);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Jam Mati", style: TextStyle(fontSize: 14),),
                          SizedBox(height: 5,),
                          Text(mDataResponse != null ? Utils.seconToMillisSecon(mDataResponse.lamp.lampOffHour).toString() : "0", style: TextStyle(fontSize: 24, color: Colors.blueGrey),),
                          SizedBox(height: 5,),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getFan1Layout(BuildContext context){
    return InkWell(
      onTap: (){
        if(mDataResponse != null){
          double minTemp = mDataResponse.fan1.minTemp.toDouble() / 10.0;
          double maxTemp = mDataResponse.fan1.maxTemp.toDouble() / 10.0;
          String url = "setFan12";
          String title = "Thermo 1";

          showDialog(
              context: context,
              builder: (_) => KipasDialog(minTemp: minTemp,maxTemp: maxTemp, url: url,title: title,)).then((value) {
            if (value) {

            }
          });
        }
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 0, vertical: 2),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(6)),
            color: Colors.white,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Thermo 1", style: TextStyle(fontSize: 18),),
                          SizedBox(height: 10,),
                          AnimatedBuilder(
                            animation: _controllerKipas1,
                            builder: (_, child) {
                              return Transform.rotate(
                                angle: _controllerKipas1.value * 2 * 3.14159265358979,
                                child: child,
                              );
                            },
                            child: Icon(LineIcons.radiation, size: 30, color: mDataResponse != null ? mDataResponse.fan1.statusRelay ? Colors.red : Colors.black54 : Colors.black54,),
                          ),
                          Row(
                            children: [
                              Text(mDataResponse != null ? mDataResponse.fan1.statusRelay ? "Hidup" : "Mati" : "Mati", style: TextStyle(fontSize: 10,color: mDataResponse != null ? mDataResponse.fan1.statusRelay ? Colors.red : Colors.black54 : Colors.black54,),),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Suhu Minimal", style: TextStyle(fontSize: 14),),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(mDataResponse != null ? (mDataResponse.fan1.minTemp.toDouble() / 10.0).toString() : "0", style: TextStyle(fontSize: 24, color: Colors.blueGrey),),
                              Text(" \u2103", style: TextStyle(fontSize: 10),),
                            ],
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Suhu Maksimal", style: TextStyle(fontSize: 14),),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(mDataResponse != null ? (mDataResponse.fan1.maxTemp.toDouble() / 10.0).toString() : "0", style: TextStyle(fontSize: 24, color: Colors.blueGrey),),
                              Text(" \u2103", style: TextStyle(fontSize: 10),),
                            ],
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getFan2Layout(BuildContext context){
    return InkWell(
      onTap: (){
        if(mDataResponse != null){
          double minTemp = mDataResponse.fan2.minTemp.toDouble() / 10.0;
          double maxTemp = mDataResponse.fan2.maxTemp.toDouble() / 10.0;
          String url = "setFan22";
          String title = "Thermo 2";

          showDialog(
              context: context,
              builder: (_) => KipasDialog(minTemp: minTemp,maxTemp: maxTemp, url: url,title: title,)).then((value) {
            if (value) {

            }
          });
        }
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 0, vertical: 2),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(6)),
            color: Colors.white,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Thermo 2", style: TextStyle(fontSize: 18),),
                          SizedBox(height: 10,),
                          AnimatedBuilder(
                            animation: _controllerKipas2,
                            builder: (_, child) {
                              return Transform.rotate(
                                angle: _controllerKipas2.value * 2 * 3.14159265358979,
                                child: child,
                              );
                            },
                            child: Icon(LineIcons.radiation, size: 30, color: mDataResponse != null ? mDataResponse.fan2.statusRelay ? Colors.red : Colors.black54 : Colors.black54,),
                          ),
                          Row(
                            children: [
                              Text(mDataResponse != null ? mDataResponse.fan2.statusRelay ?  "Hidup" : "Mati" : "Mati", style: TextStyle(fontSize: 10,color: mDataResponse != null ? mDataResponse.fan2.statusRelay ? Colors.red : Colors.black54 : Colors.black54,),),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Suhu Minimal", style: TextStyle(fontSize: 14),),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(mDataResponse != null ? (mDataResponse.fan2.minTemp.toDouble() / 10.0).toString() : "0", style: TextStyle(fontSize: 24, color: Colors.blueGrey),),
                              Text(" \u2103", style: TextStyle(fontSize: 10),),
                            ],
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Suhu Maksimal", style: TextStyle(fontSize: 14),),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(mDataResponse != null ? (mDataResponse.fan2.maxTemp.toDouble() / 10.0).toString() : "0", style: TextStyle(fontSize: 24, color: Colors.blueGrey),),
                              Text(" \u2103", style: TextStyle(fontSize: 10),),
                            ],
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getFan3Layout(BuildContext context){
    return InkWell(
      onTap: (){
        if(mDataResponse != null){
          double minTemp = mDataResponse.fan3.minTemp.toDouble() / 10.0;
          double maxTemp = mDataResponse.fan3.maxTemp.toDouble() / 10.0;
          String url = "setFan32";
          String title = "Thermo 3";

          showDialog(
              context: context,
              builder: (_) => KipasDialog(minTemp: minTemp,maxTemp: maxTemp, url: url,title: title,)).then((value) {
            if (value) {

            }
          });
        }
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 0, vertical: 2),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(6)),
            color: Colors.white,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Thermo 3", style: TextStyle(fontSize: 18),),
                          SizedBox(height: 10,),
                          AnimatedBuilder(
                            animation: _controllerKipas2,
                            builder: (_, child) {
                              return Transform.rotate(
                                angle: _controllerKipas2.value * 2 * 3.14159265358979,
                                child: child,
                              );
                            },
                            child: Icon(LineIcons.radiation, size: 30, color: mDataResponse != null ? mDataResponse.fan3.statusRelay ? Colors.red : Colors.black54 : Colors.black54,),
                          ),
                          Row(
                            children: [
                              Text(mDataResponse != null ? mDataResponse.fan3.statusRelay ?  "Hidup" : "Mati" : "Mati", style: TextStyle(fontSize: 10,color: mDataResponse != null ? mDataResponse.fan3.statusRelay ? Colors.red : Colors.black54 : Colors.black54,),),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Suhu Minimal", style: TextStyle(fontSize: 14),),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(mDataResponse != null ? (mDataResponse.fan3.minTemp.toDouble() / 10.0).toString() : "0", style: TextStyle(fontSize: 24, color: Colors.blueGrey),),
                              Text(" \u2103", style: TextStyle(fontSize: 10),),
                            ],
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Suhu Maksimal", style: TextStyle(fontSize: 14),),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(mDataResponse != null ? (mDataResponse.fan3.maxTemp.toDouble() / 10.0).toString(): "0", style: TextStyle(fontSize: 24, color: Colors.blueGrey),),
                              Text(" \u2103", style: TextStyle(fontSize: 10),),
                            ],
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getFan4Layout(BuildContext context){
    return InkWell(
      onTap: (){
        if(mDataResponse != null){
          double minTemp = mDataResponse.fan4.minTemp.toDouble() / 10.0;
          double maxTemp = mDataResponse.fan4.maxTemp.toDouble() / 10.0;
          String url = "setFan42";
          String title = "Thermo 4";

          showDialog(
              context: context,
              builder: (_) => KipasDialog(minTemp: minTemp,maxTemp: maxTemp, url: url,title: title,)).then((value) {
            if (value) {

            }
          });
        }
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 0, vertical: 2),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(6)),
            color: Colors.white,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Thermo 4", style: TextStyle(fontSize: 18),),
                          SizedBox(height: 10,),
                          AnimatedBuilder(
                            animation: _controllerKipas2,
                            builder: (_, child) {
                              return Transform.rotate(
                                angle: _controllerKipas2.value * 2 * 3.14159265358979,
                                child: child,
                              );
                            },
                            child: Icon(LineIcons.radiation, size: 30, color: mDataResponse != null ? mDataResponse.fan4.statusRelay ? Colors.red : Colors.black54 : Colors.black54,),
                          ),
                          Row(
                            children: [
                              Text(mDataResponse != null ? mDataResponse.fan4.statusRelay ?  "Hidup" : "Mati" : "Mati", style: TextStyle(fontSize: 10,color: mDataResponse != null ? mDataResponse.fan4.statusRelay ? Colors.red : Colors.black54 : Colors.black54,),),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Suhu Minimal", style: TextStyle(fontSize: 14),),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(mDataResponse != null ? (mDataResponse.fan4.minTemp.toDouble() / 10.0).toString() : "0", style: TextStyle(fontSize: 24, color: Colors.blueGrey),),
                              Text(" \u2103", style: TextStyle(fontSize: 10),),
                            ],
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Suhu Maksimal", style: TextStyle(fontSize: 14),),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(mDataResponse != null ? (mDataResponse.fan4.maxTemp.toDouble() / 10.0).toString() : "0", style: TextStyle(fontSize: 24, color: Colors.blueGrey),),
                              Text(" \u2103", style: TextStyle(fontSize: 10),),
                            ],
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getFan5Layout(BuildContext context){
    return InkWell(
      onTap: (){
        if(mDataResponse != null){
          double minTemp = mDataResponse.heater.minTemp.toDouble() / 10.0;
          double maxTemp = mDataResponse.heater.maxTemp.toDouble() / 10.0;
          String url = "setHeater2";
          String title = "Amonia";

          showDialog(
              context: context,
              builder: (_) => KipasDialog(minTemp: minTemp,maxTemp: maxTemp, url: url,title: title,)).then((value) {
            if (value) {

            }
          });
        }
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 0, vertical: 2),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(6)),
            color: Colors.white,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Amonia", style: TextStyle(fontSize: 18),),
                          SizedBox(height: 10,),
                          AnimatedBuilder(
                            animation: _controllerKipas2,
                            builder: (_, child) {
                              return Transform.rotate(
                                angle: _controllerKipas2.value * 2 * 3.14159265358979,
                                child: child,
                              );
                            },
                            child: Icon(LineIcons.radiation, size: 30, color: mDataResponse != null ? mDataResponse.heater.statusRelay ? Colors.red : Colors.black54 : Colors.black54,),
                          ),
                          Row(
                            children: [
                              Text(mDataResponse != null ? mDataResponse.heater.statusRelay ?  "Hidup" : "Mati" : "Mati", style: TextStyle(fontSize: 10,color: mDataResponse != null ? mDataResponse.heater.statusRelay ? Colors.red : Colors.black54 : Colors.black54,),),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Batas Tinggi", style: TextStyle(fontSize: 14),),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(mDataResponse != null ? (mDataResponse.heater.minTemp.toDouble()).toString() : "0", style: TextStyle(fontSize: 24, color: Colors.blueGrey),),
                              Text(" \u2103", style: TextStyle(fontSize: 10),),
                            ],
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Batas Normal", style: TextStyle(fontSize: 14),),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(mDataResponse != null ? (mDataResponse.heater.maxTemp.toDouble()).toString() : "0", style: TextStyle(fontSize: 24, color: Colors.blueGrey),),
                              Text(" \u2103", style: TextStyle(fontSize: 10),),
                            ],
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<StatusResponse> saveDataLamp(String onHour, String offHour) async {
    setState(() {

    });

    String url = "http://192.168.2.1/" +
        "setLamp2?on_hour="+
        onHour+
        "&off_hour="+
        offHour+
        "&is_active=1";

    print(url);

    Response response = await Dio().get(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
    );
    if (response.statusCode == 200) {
      StatusResponse results = StatusResponse.fromJson(response.data);
      return results;
    } else {
      return null;
    }
  }



  Widget getCounterLayout(BuildContext context){
    return InkWell(
      onTap: (){

      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 0, vertical: 2),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(6)),
            color: Colors.white,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Jumlah Kertas", style: TextStyle(fontSize: 14),),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(mDataResponse != null ? mDataResponse.counter.toString() : "0", style: TextStyle(fontSize: 34, color: Colors.blueGrey),),
                            ],
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                      ElevatedButton(
                          child: Text(
                              "Reset",
                              style: TextStyle(fontSize: 14)
                          ),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: Colors.teal)
                                  )
                              )
                          ),
                          onPressed: () {
                              resetCounter("onHour", "offHour");
                          }
                      )
                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<StatusResponse> resetCounter(String onHour, String offHour) async {
    setState(() {

    });

    String url = "http://192.168.2.1/reset";

    print(url);

    Response response = await Dio().get(
      url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
    );
    if (response.statusCode == 200) {
      StatusResponse results = StatusResponse.fromJson(response.data);
      return results;
    } else {
      return null;
    }
  }
}
