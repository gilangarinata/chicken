
import 'dart:io';

import 'package:chicken_fan/dataResponse.dart';
import 'package:chicken_fan/progress_loading.dart';
import 'package:chicken_fan/statusResponse.dart';
import 'package:chicken_fan/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifWifiDialog extends StatefulWidget {

  @override
  _AddDeviceDialogState createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<NotifWifiDialog> {
  @override
  Widget build(BuildContext context) {
    return DialogContent();
  }
}

class DialogContent extends StatefulWidget {

  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {


  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Center(
              child: Column(
                children: [
                  Text("Anda belum terkoneksi dengan alat."),
                  Text("Silahkan koneksikan WIFI ke \"KIPAS : FAUZI BROILER\" "),
                ],
              ),
            ),
          ),
        ));
  }
}
