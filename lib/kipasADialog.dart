
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chicken_fan/dataResponse.dart';
import 'package:chicken_fan/progress_loading.dart';
import 'package:chicken_fan/statusResponse.dart';
import 'package:chicken_fan/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KipasADialog extends StatefulWidget {
  FanA data;
  int lantai;
  BluetoothConnection connection;

  KipasADialog({this.data,this.lantai,this.connection});

  @override
  _AddDeviceDialogState createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<KipasADialog> {
  @override
  Widget build(BuildContext context) {
    return DialogContent(widget.data,widget.lantai,widget.connection);
  }
}

class DialogContent extends StatefulWidget {
  FanA data;

  BluetoothConnection connection;
  int lantai;
  DialogContent(this.data, this.lantai,this.connection);

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
    int onDurationInMinute = int.parse(_onDurationController.text);
    int offDurationInMinute = int.parse(_offDurationController.text);

    String url = "";
    if(widget.lantai == 1) {
      Map data = {
        "key" : "setFanA",
        "value1" : onDurationInMinute,
        "value2" : offDurationInMinute
      };
      List<int> list = utf8.encode(json.encode(data) + "\n");
      Uint8List bytes = Uint8List.fromList(list);
      print(data);
      widget.connection.output.add(bytes);
    }else{
      url = "http://192.168.2.1/" +
          "setFanA2?on_duration=" +
          onDurationInMinute.toString() +
          "&off_duration=" +
          offDurationInMinute.toString() +
          "&is_active=1";
    }

    print(url);

    // Response response = await Dio().get(
    //   url,
    //   options: Options(headers: {
    //     HttpHeaders.contentTypeHeader: "application/json",
    //   }),
    // );
    // if (response.statusCode == 200) {
    //   StatusResponse results = StatusResponse.fromJson(response.data);
    //   return results;
    // } else {
    //   return null;
    // }
  }


  @override
  Widget build(BuildContext context) {
    if(widget.data != null){
      _onDurationController.text = widget.data.onDuration.toString();
      _offDurationController.text = widget.data.offDuration.toString();
    }

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
                        Text("Intermitten 1",
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
                              child: Text("Lama Hidup")),
                          SizedBox(width: 20,),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _onDurationController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Tidak boleh kosong";
                                }
                                return null;
                              },
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                hintText: "Lama Hidup",
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
                          Text("Menit")
                        ],
                      ),
                      Container(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width : 90,
                              child: Text("Lama Mati")),
                          SizedBox(width: 20,),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _offDurationController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Tidak boleh kosong";
                                }
                                return null;
                              },
                              style: TextStyle(fontSize: 18),
                              decoration: InputDecoration(
                                hintText: "Lama Mati",
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
                          Text("Menit")
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
