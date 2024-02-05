// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';
import 'package:kakao_map_plugin_example/src/widget/home_button.dart';

class UpdateMyInfo extends StatefulWidget {
  const UpdateMyInfo({super.key});

  @override
  State<UpdateMyInfo> createState() => _UpdateMyInfoState();
}

class _UpdateMyInfoState extends State<UpdateMyInfo> {
  static const storage = FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  bool signflag = false;
  String userName = '';
  String userNickName = '';
  String userPassword = '';
  String userId = '';

  final _valueList = ['1', '2', '3'];
  String? _selectedValue = '1';

  void _tryValidation() {
    final isValid =
        _formKey.currentState!.validate(); //폼필드 안 validator를 작동시킬 수 있음
    if (isValid) {
      _formKey.currentState!.save();
      signflag = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String getImgUrl(List<dynamic> img) {
    if (img.isNotEmpty) {
      return img[0].toString();
    } else {
      return 'https://puda.s3.ap-northeast-2.amazonaws.com/client/yi69q6kuvwww.nzyura.com_4GPji3FQ_69b3935b2c0c1a72a22a4bfb4182fe970dc91f1f.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(title: 'My Page'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 600,
          height: 700,
          //color: Colors.amber[50],
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                          'https://puda.s3.ap-northeast-2.amazonaws.com/client/yi69q6kuvwww.nzyura.com_4GPji3FQ_69b3935b2c0c1a72a22a4bfb4182fe970dc91f1f.jpg'),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    key: const ValueKey(1),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userId = value!;
                    },
                    onChanged: (value) {
                      userId = value;
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Colors.amber,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35),
                        ),
                      ),
                      hintText: 'UserName',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(137, 56, 54, 54),
                      ),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    key: const ValueKey(2),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userId = value!;
                    },
                    onChanged: (value) {
                      userId = value;
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Colors.amber,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35),
                        ),
                      ),
                      hintText: 'User ID',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(137, 56, 54, 54),
                      ),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    key: const ValueKey(3),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userId = value!;
                    },
                    onChanged: (value) {
                      userId = value;
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Colors.amber,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35),
                        ),
                      ),
                      hintText: 'User Nick Name',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(137, 56, 54, 54),
                      ),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    key: const ValueKey(4),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userId = value!;
                    },
                    onChanged: (value) {
                      userId = value;
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Colors.amber,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(35),
                        ),
                      ),
                      hintText: 'User Password',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(137, 56, 54, 54),
                      ),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // DropdownButton(
                  //   items: _valueList.map(
                  //     (value) {
                  //       return DropdownMenuItem(
                  //         value: value,
                  //         child: Text(value),
                  //       );
                  //     },
                  //   ).toList(),
                  //   onChanged: (value) {
                  //     setState(
                  //       () {
                  //         _selectedValue = value;
                  //       },
                  //     );
                  //   },
                  //   borderRadius: BorderRadius.circular(10),
                  //   style: const TextStyle(
                  //       //te
                  //       fontSize: 20 //font size on dropdown button
                  //       ),
                  // ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                        //background color of dropdown button
                        border: Border.all(
                          color: Colors.amber,
                          // width: 3,
                        ), //border of dropdown button
                        borderRadius: BorderRadius.circular(
                            50), //border raiuds of dropdown button
                        boxShadow: const <BoxShadow>[
                          //apply shadow on Dropdown button
                          BoxShadow(
                              color: Colors.white, //shadow for button
                              blurRadius: 5) //blur radius of shadow
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: DropdownButton(
                        value: _selectedValue,
                        items: _valueList.map(
                          (value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                        onChanged: (value) {
                          setState(
                            () {
                              _selectedValue = value;
                            },
                          );
                        },
                        icon: const Padding(
                            //Icon at tail, arrow bottom is default icon
                            padding: EdgeInsets.only(left: 20),
                            child: Icon(Icons.arrow_circle_down_sharp)),
                        iconEnabledColor: Colors.grey, //Icon color
                        style: const TextStyle(
                            //te
                            color: Colors.black, //Font color
                            fontSize: 20 //font size on dropdown button
                            ),

                        dropdownColor: Colors.white, //dropdown background color
                        underline: Container(), //remove underline
                        isExpanded: true, //make true to make width 100%
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  HomeButton(
                    text: 'update',
                    move: () {},
                    color: Colors.amber,
                  )
                ],
                //column's children
              ),
            ),
          ),
        ),
      ),
    );
  }
}
