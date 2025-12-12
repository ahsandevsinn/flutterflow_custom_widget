import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DemoScreen extends StatelessWidget {
  final DocumentSnapshot? doc;
  const DemoScreen({super.key,this.doc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(doc?['catagoryName']),),
    );
  }
}