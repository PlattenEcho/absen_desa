import 'package:absen_desa/services/auth.dart';
import 'package:absen_desa/ui/shared/gaps.dart';
import 'package:absen_desa/ui/shared/theme.dart';
import 'package:absen_desa/ui/widgets/buttons.dart';
import 'package:absen_desa/ui/widgets/textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.black,
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: kBlackColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0.0),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Login",
                        style: blackTextStyle.copyWith(
                            fontSize: 32, fontWeight: FontWeight.bold)),
                    gapH24,
                    NewForm(
                        controller: _usernameController,
                        nama: "Username",
                        hintText: "Masukkan Username",
                        obscureText: false,
                        horizontalPadding: 0),
                    gapH8,
                    NewForm(
                        controller: _passwordController,
                        nama: "Password",
                        hintText: "Masukkan Password",
                        obscureText: true,
                        horizontalPadding: 0),
                    gapH32,
                    Button(
                      text: "Login",
                      textColor: kWhiteColor,
                      startColor: kPrimary2Color,
                      endColor: kPrimaryColor,
                      onPressed: () async {
                        authenticateUser(
                            context,
                            _usernameController.text.trim(),
                            _passwordController.text.trim());
                      },
                    ),
                    gapH(8),
                    Center(
                      child: RichText(
                          text: TextSpan(
                              style:
                                  blackTextStyle.copyWith(color: Colors.black),
                              children: <TextSpan>[
                            const TextSpan(text: "Belum punya akun? "),
                            TextSpan(
                                text: "Klik di sini",
                                style: blackTextStyle.copyWith(
                                    color: kPrimary2Color),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                        context, '/register-page');
                                  })
                          ])),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
