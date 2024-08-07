import 'package:absen_desa/ui/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewForm extends StatelessWidget {
  final TextEditingController controller;
  final String nama;
  final String hintText;
  final bool obscureText;
  final double horizontalPadding;

  const NewForm({
    super.key,
    required this.controller,
    required this.nama,
    required this.hintText,
    required this.obscureText,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: horizontalPadding, right: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nama,
            style: blackTextStyle.copyWith(fontSize: 16),
          ),

          const SizedBox(
            height: 10,
          ),

          //TextField
          TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryLightColor),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                hintText: hintText,
                hintStyle: blackTextStyle.copyWith(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

class PasswordForm extends StatelessWidget {
  final TextEditingController controller;
  final String nama;
  final String hintText;
  final double horizontalPadding;

  const PasswordForm({
    super.key,
    required this.controller,
    required this.nama,
    required this.hintText,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: horizontalPadding, right: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nama,
            style: blackTextStyle.copyWith(fontSize: 16),
          ),

          const SizedBox(
            height: 10,
          ),

          //TextField
          TextField(
            controller: controller,
            obscureText: true,
            inputFormatters: [
              LengthLimitingTextInputFormatter(12),
            ],
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryLightColor),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                hintText: hintText,
                hintStyle: blackTextStyle.copyWith(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
