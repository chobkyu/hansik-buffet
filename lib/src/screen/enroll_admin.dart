import 'package:flutter/material.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';

class EnrollAdmin extends StatefulWidget {
  const EnrollAdmin({super.key});

  @override
  State<EnrollAdmin> createState() => _EnrollAdminState();
}

class _EnrollAdminState extends State<EnrollAdmin> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(title: '관리자 페이지'),
      ),
      body: SingleChildScrollView(),
    );
  }
}
