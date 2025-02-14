import 'package:agaram_admin/Widget/comon_appbar.dart';
import 'package:agaram_admin/common/Common%20color.dart';
import 'package:flutter/material.dart';

class ViewhubScreen extends StatefulWidget {
  const ViewhubScreen({super.key});

  @override
  State<ViewhubScreen> createState() => _ViewhubScreenState();
}

class _ViewhubScreenState extends State<ViewhubScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: common_appbar("View Hub Details")
    );
  }
}
