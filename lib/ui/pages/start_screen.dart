import 'package:absen_desa/ui/shared/gaps.dart';
import 'package:absen_desa/ui/shared/theme.dart';
import 'package:absen_desa/ui/widgets/buttons.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    dynamic parentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: parentWidth / 3,
            height: parentWidth / 3,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/logo.png'),
            )),
          ),
          gapH12,
          Text(
            'AbsenDesa',
            textAlign: TextAlign.center,
            style: blackTextStyle.copyWith(fontSize: 24, fontWeight: bold),
          ),
          gapH24,
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Button(
                    text: "Login",
                    textColor: kWhiteColor,
                    startColor: kPrimaryColor,
                    endColor: kPrimaryColor,
                    onPressed: () {
                      Navigator.pushNamed(context, '/login-page');
                    }),
                gapH12,
                ButtonOutline(
                    text: "Register",
                    textColor: kPrimaryColor,
                    borderColor: kPrimaryColor,
                    onPressed: () {
                      Navigator.pushNamed(context, '/register-page');
                    })
              ],
            ),
          )
        ]),
      ),
    );
  }
}
