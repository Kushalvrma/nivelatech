import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nivelatech/src/crypto_dashboard/page/crypto_dashboard_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto List with Price Monitoring',
      home: CryptoListPage(),
    );
  }
}
