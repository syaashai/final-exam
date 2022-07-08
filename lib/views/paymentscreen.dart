import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mytutor/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/user.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final double totalpayable;

  const PaymentScreen(
      {Key? key, required this.user, required this.totalpayable})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
    );
  }
}
