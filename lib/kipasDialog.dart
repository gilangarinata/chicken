
import 'dart:io';

import 'package:chicken_fan/dataResponse.dart';
import 'package:chicken_fan/progress_loading.dart';
import 'package:chicken_fan/statusResponse.dart';
import 'package:chicken_fan/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KipasDialog extends StatefulWidget {
  double minTemp;
  double maxTemp;
  String url;
  String title;

  KipasDialog({this.minTemp,this.maxTemp,this.url,this.title});

  @override
  _AddDeviceDialogState createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<KipasDialog> {
  @override
  Widget build(BuildContext context) {
    return DialogContent(widget.minTemp,widget.maxTemp,widget.url,widget.title);
  }
}

class DialogContent extends StatefulWidget {
  double minTemp;
  double maxTemp;
  String url;
  String title;

  DialogContent(this.minTemp,this.maxTemp,this.url,this.title);

  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {

  TextEditingController _onDurationController = new TextEditingController();
  TextEditingController _offDurationController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  String baseUrl;

  @override
  void initState() {
    super.initState();
  }

  Future<StatusResponse> saveData() async {
    setState(() {
      isLoading = true;
    });
    int onDurationInMinute;
    int offDurationInMinute;

    if(widget.title == "Amonia"){
      onDurationInMinute = (double.parse(_onDurationController.text)).toInt();
      offDurationInMinute = (double.parse(_offDurationController.text)).toInt();
    }else{
      onDurationInMinute = (double.parse(_onDurationController.text) * 10.0).toInt();
      offDurationInMinute = (double.parse(_offDurationController.text) * 10.0).toInt();
    }

    String url = "http://192.168.2.1/" +
        widget.url +"?min_temp="+
        onDurationInMinute.toString()+
        "&max_temp="+
        offDurationInMinute.toString()+
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


  @override
  Widget build(BuildContext context) {
      _onDurationController.text = widget.minTemp.toString();
      _offDurationController.text = widget.maxTemp.toString();

    return Dialog(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Material(
                  color: Colors.teal,
                  child: Container(
                    height: 50,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Text(widget.title,
                            style: TextStyle(color: Colors.white, fontSize: 20)),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(height: 25),
                      Row(
                        children: [
                          Container(
                              width : 90,
                              child: Text(widget.title == "Amonia" ? "Batas Tinggi" : "Suhu Minimum")),
                          SizedBox(width: 20,),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              controller: _onDurationController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Tidak boleh kosong";
                                }
                                return null;
                              },
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                hintText: "Suhu Minimum",
                                hintStyle: TextStyle(color: Colors.grey),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.grey, width: 1)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.grey, width: 1)),
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Text("\u2103")
                        ],
                      ),
                      Container(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width : 90,
                              child: Text(widget.title == "Amonia" ? "Batas Normal" : "Suhu Maksimum")),
                          SizedBox(width: 20,),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              controller: _offDurationController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Tidak boleh kosong";
                                }
                                return null;
                              },
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                hintText: "Suhu Maksimum",
                                hintStyle: TextStyle(color: Colors.grey),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.grey, width: 1)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.grey, width: 1)),
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Text("\u2103")
                        ],
                      ),

                      SizedBox(height: 20,),
                    ],
                  ),
                ),

                Container(
                  height: 80,
                  child: Stack(
                    children: [
                      Visibility(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                            width: double.infinity,
                            child: ElevatedButton(
                                child: Text(
                                    "Simpan".toUpperCase(),
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
                                onPressed: () async {
                                  var data = await saveData();
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if(data != null){
                                    Navigator.pop(context);
                                  }else{

                                  }
                                }
                            ),
                          ),
                        ),
                        visible: !isLoading,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Visibility(
                          child: ProgressLoading(color: Colors.white,size: 10,stroke: 1,),
                          visible: isLoading,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
