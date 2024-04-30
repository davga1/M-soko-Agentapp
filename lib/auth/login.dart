import 'package:agentapp/common/constant.dart';
import 'package:agentapp/services/functions/authFunctions.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});


  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

 
  String email = '';
  String password = '';
  String fullname = '';
  bool login = false;

// -----------------------------------------------------------------
TextEditingController fullNameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
  dynamic errorTextFullname;
  dynamic errorTextEmail;
  dynamic errorTextPassword;
  bool obscureText = true;
// -----------------------------------------------------------------
 @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: h,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          "assets/images/rect.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome to\nM-Soko\nAgent",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 10,
                            width: 40,
                            decoration: BoxDecoration(
                              color: logoColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 174,
                      left: 200,
                      child: Container(
                        height: 132,
                        width: 132,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: logoColor,
                        ),
                        child: Image.asset(
                          "assets/images/logo2.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Image.asset("assets/images/Looper.png"),
                    ),
                    Positioned(
                      top: 300,
                      child: SizedBox(
                        height: 462,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          child: Form(
                            key: _formKey,
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  login
                                      ? Container()
                                      : Text(
                                          "Full Name",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: appColor),
                                        ),
                                  // ======== Full Name ========
                                  login
                                      ? Container()
                                      : TextFormField(
                                        controller: fullNameController,
                                          keyboardType: TextInputType.name,
                                          key: const ValueKey('fullname'),
                                          decoration: InputDecoration(
                                              errorText: errorTextFullname,
                                              hintText: 'Enter Full Name',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                          onChanged: (value) => {
                                            if (value.isEmpty)
                                              {
                                                setState(
                                                  () {
                                                    errorTextFullname = null;
                                                  },
                                                )
                                              }
                                            else if (value.length < 2)
                                              {
                                                setState(() {
                                                  errorTextFullname =
                                                      'Please enter full name';
                                                })
                                              }
                                            else
                                              {
                                                setState(() {
                                                  errorTextFullname = null;
                                                  fullname = value;
                                                })
                                              }
                                          },
                                        ),
                                  Text(
                                    "Email",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: appColor),
                                  ),
                                  TextFormField(
                                    controller: emailController,
                                    key: const ValueKey('email'),
                                    decoration: InputDecoration(
                                        errorText: errorTextEmail,
                                        hintText: "Enter Email",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          errorTextEmail = null;
                                        });
                                      } else if (value.length > 5 &&
                                          value.contains('@gmail.com')) {
                                        //add another mail domains if you need, this is just for tests
                                        setState(() {
                                          errorTextEmail = null;
                                          email = value;
                                        });
                                      } else {
                                        setState(() {
                                          errorTextEmail =
                                              'Please enter valid email';
                                        });
                                      }
                                    },
                                  ),
                                  Text(
                                    "Password",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: appColor),
                                  ),
                                  // ======== Password ========
                                  TextFormField(
                                    controller:passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    key: const ValueKey('password'),
                                    obscureText: obscureText,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              obscureText = !obscureText;
                                            });
                                          },
                                        ),
                                        errorText: errorTextPassword,
                                        hintText: 'Enter Password',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        setState(() {
                                          errorTextPassword = null;
                                        });
                                      } else if (!value
                                          .contains(RegExp("[A-Z]")) && login == false) {
                                        setState(() {
                                          errorTextPassword =
                                              'Password should have at least one uppercase letter';
                                        });
                                      } else if(value.length < 6 && login == false){
                                        setState(() {
                                          errorTextPassword = 'Password should contain at least 6 letters';
                                        });
                                      }
                                      else {
                                        setState(() {
                                          errorTextPassword = null;
                                          password = value;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 55,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              appColor, // Set the background color
                                          foregroundColor:
                                              whiteColor, // Set the text color
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                            (email.isNotEmpty &&
                                                    password.isNotEmpty)
                                                ? login
                                                    ? AuthServices.signinUser(
                                                        email,
                                                        password,
                                                        context)
                                                    : AuthServices.signupUser(
                                                        email,
                                                        password,
                                                        fullname,
                                                        context)
                                                : null;
                                          }
                                        },
                                        child:
                                            Text(login ? 'Login' : 'Signup')),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextButton(
                                    style: const ButtonStyle(),
                                    onPressed: () {
                                      setState(() {
                                        login = !login;
                                        print(login);
                                        password = '';
                                        email = '';
                                        fullname = '';
                                        emailController.clear();
                                        passwordController.clear();
                                        fullNameController.clear();
                                        errorTextEmail = null;
                                        errorTextFullname = null;
                                        errorTextPassword = null;
                                      });
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: login
                                                ? "Don't have an account? "
                                                : "Already have an account? ",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextSpan(
                                            text: login ? "Signup" : "Login",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.blue,
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
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
