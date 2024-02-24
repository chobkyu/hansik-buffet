// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin_example/src/screen/home_screen.dart';
import 'package:kakao_map_plugin_example/src/service/login_service.dart';
import 'package:kakao_map_plugin_example/src/service/signup_service.dart';
import 'package:kakao_map_plugin_example/src/widget/app_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSignUpScreen = false;
  final _formKey = GlobalKey<FormState>();
  static const storage = FlutterSecureStorage();

  static Login login = Login();
  static SignUpService signUpService = SignUpService();

  String userName = '';
  String userNickName = '';
  String userPassword = '';
  String userId = '';
  bool signflag = false;

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
    super.initState();
    try {
      getUser();
      print('object');
    } catch (err) {
      print(err);
    }
  }

  void getUser() async {
    print(await storage.read(key: 'token'));
    String? token = await storage.read(key: 'token');

    if (token != null) {
      if (!mounted) return;
      // Navigator.push(
      //   context,
      //   PageRouteBuilder(
      //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //       var begin = const Offset(0.0, 1.0);
      //       var end = Offset.zero;
      //       var curve = Curves.ease;
      //       var tween =
      //           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      //       return SlideTransition(
      //         position: animation.drive(tween),
      //         child: child,
      //       );
      //     },
      //     pageBuilder: (context, animation, secondaryAnimation) =>
      //         const HomeScreen(),
      //   ),
      // );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(title: 'Login'),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeIn,
            top: 180,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              padding: const EdgeInsets.all(20),
              height: isSignUpScreen ? 350.0 : 250.0,
              width: MediaQuery.of(context).size.width - 40,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.amber[700],
                  borderRadius: BorderRadius.circular(15)),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 25),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignUpScreen = false;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: !isSignUpScreen
                                      ? Colors.white
                                      : Colors.white54,
                                ),
                              ),
                              if (!isSignUpScreen)
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color: !isSignUpScreen
                                      ? Colors.white
                                      : Colors.white54,
                                ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignUpScreen = true;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                'SIGNUP',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSignUpScreen
                                      ? Colors.white
                                      : Colors.white54,
                                ),
                              ),
                              if (isSignUpScreen)
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color: isSignUpScreen
                                      ? Colors.white
                                      : Colors.white54,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isSignUpScreen)
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              //텍스트 필드
                              TextFormField(
                                key: const ValueKey(1),
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 4) {
                                    return 'Please enter at least 4 characters';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  userName = value!;
                                },
                                onChanged: (value) {
                                  userName = value;
                                },
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.account_circle,
                                    color: Colors.white,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
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
                                    color: Colors.white54,
                                  ),
                                  contentPadding: EdgeInsets.all(10),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              //텍스트 필드
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                key: const ValueKey(2),
                                onSaved: (value) {
                                  userId = value!;
                                },
                                onChanged: (value) {
                                  userId = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.insert_drive_file_outlined,
                                    color: Colors.white,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(35),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(35),
                                    ),
                                  ),
                                  hintText: 'User ID',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white54,
                                  ),
                                  contentPadding: EdgeInsets.all(10),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              //텍스트 필드
                              TextFormField(
                                key: const ValueKey(3),
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 6) {
                                    return 'Please enter at least 6 characters long.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  userPassword = value!;
                                },
                                onChanged: (value) {
                                  userPassword = value;
                                },
                                obscureText: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(35),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(35),
                                    ),
                                  ),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Colors.white54),
                                  contentPadding: EdgeInsets.all(10),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              //텍스트 필드
                              TextFormField(
                                key: const ValueKey(4),
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 6) {
                                    return 'Please enter at least 6 characters long.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  userNickName = value!;
                                },
                                onChanged: (value) {
                                  userNickName = value;
                                },
                                //obscureText: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.supervised_user_circle_outlined,
                                    color: Colors.white,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(35),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(35),
                                    ),
                                  ),
                                  hintText: 'User NickName',
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Colors.white54),
                                  contentPadding: EdgeInsets.all(10),
                                ),
                              ),
                              const SizedBox(
                                height: 9,
                              ),
                              const Text(
                                '사업자로 회원 가입하기',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    if (!isSignUpScreen)
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                key: const ValueKey(5),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty || value.contains('@')) {
                                    return 'Please enter a valid email address';
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
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(35),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(35),
                                    ),
                                  ),
                                  hintText: 'User Email',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white54,
                                  ),
                                  contentPadding: EdgeInsets.all(10),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                key: const ValueKey(6),
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 4) {
                                    return 'Please enter at least 6 characters long.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  userPassword = value!;
                                },
                                onChanged: (value) {
                                  userPassword = value;
                                },
                                obscureText: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(35),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(35),
                                    ),
                                  ),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Colors.white54),
                                  contentPadding: EdgeInsets.all(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
            top: isSignUpScreen ? 498 : 390,
            right: 0,
            left: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.amber[900],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: GestureDetector(
                  onTap: () async {
                    if (isSignUpScreen) {
                      _tryValidation();
                      if (signflag) {
                        try {
                          final user = await signUpService.signUp(
                              userId, userPassword, userName, userNickName);

                          String token = user.token;
                          print(token);
                          await storage.write(key: 'token', value: token);

                          if (!mounted) return;
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const HomeScreen();
                          }));
                        } catch (err) {
                          print(err);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Please check your email and password'),
                              backgroundColor: Colors.black,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Please check your email and password'),
                            backgroundColor: Colors.black,
                          ),
                        );
                      }
                    }

                    if (!isSignUpScreen) {
                      _tryValidation();

                      try {
                        final user = await login.getToken(userId, userPassword);
                        print(user);
                        String token = user.token;
                        print(user.token);
                        //https://velog.io/@jakob1/Flutter%EB%A1%9C-%EB%A1%9C%EA%B7%B8%EC%9D%B8-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0
                        await storage.write(key: 'token', value: token);

                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => const HomeScreen()),
                          ),
                        ); //로그인 안되어있을 시 처리 예정
                      } catch (err) {
                        print(err);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Please check your email and password'),
                            backgroundColor: Colors.black,
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 233, 132, 0),
                          Color.fromARGB(255, 233, 184, 62),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          //button
          Positioned(
            top: MediaQuery.of(context).size.height - 240,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Text(
                  isSignUpScreen ? 'or Signup with' : 'or Signin with',
                  style: const TextStyle(color: Colors.white),
                ),
                TextButton.icon(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: const Size(155, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.amber[900]),
                  icon: const Icon(Icons.add),
                  label: const Text('Google'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
