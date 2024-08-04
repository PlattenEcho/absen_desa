import 'package:absen_desa/services/auth.dart';
import 'package:absen_desa/ui/shared/gaps.dart';
import 'package:absen_desa/ui/shared/theme.dart';
import 'package:absen_desa/ui/widgets/buttons.dart';
import 'package:absen_desa/ui/widgets/textfield.dart';
import 'package:absen_desa/ui/widgets/toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String dropdownvalue = "Kepala Desa";

  final List<String> itemsMap = [
    'Kepala Desa',
    'Sekretaris Desa',
    'Kepala Urusan Tata Usaha dan Umum',
    'Kepala Urusan Keuangan',
    'Kepala Urusan Perencanaan',
    'Kepala Seksi Pemerintahan',
    'Kepala Seksi Kesejahteraan',
    'Kepala Seksi Pelayanan',
    'Kepala Dusun 1',
    'Kepala Dusun 2',
    'Kepala Dusun 3',
    'Kepala Dusun 4',
  ];

  bool validateInputs() {
    if (_namaController.text.trim().isEmpty) {
      showToast(context, "Nama lengkap tidak boleh kosong");
      return false;
    }
    if (_usernameController.text.trim().isEmpty) {
      showToast(context, "Username tidak boleh kosong");
      return false;
    }
    if (_passwordController.text.trim().isEmpty) {
      showToast(context, "Password tidak boleh kosong");
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      resizeToAvoidBottomInset: false,
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
        elevation: 0.0,
      ),
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
                  Text(
                    "Register",
                    style: blackTextStyle.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  gapH24,
                  NewForm(
                    controller: _namaController,
                    nama: "Nama Lengkap",
                    hintText: "Masukkan Nama Lengkap",
                    obscureText: false,
                    horizontalPadding: 0,
                  ),
                  gapH8,
                  Text(
                    "Jabatan",
                    style: blackTextStyle.copyWith(fontSize: 16),
                  ),
                  gapH(10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryLightColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    value: dropdownvalue,
                    icon: Icon(Icons.keyboard_arrow_down),
                    items: itemsMap.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: blackTextStyle.copyWith(),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                  gapH8,
                  NewForm(
                    controller: _usernameController,
                    nama: "Username",
                    hintText: "Masukkan Username",
                    obscureText: false,
                    horizontalPadding: 0,
                  ),
                  gapH8,
                  NewForm(
                    controller: _passwordController,
                    nama: "Password",
                    hintText: "Masukkan Password",
                    obscureText: true,
                    horizontalPadding: 0,
                  ),
                  gapH32,
                  Button(
                    text: "Register",
                    textColor: kWhiteColor,
                    startColor: kPrimary2Color,
                    endColor: kPrimaryColor,
                    onPressed: () async {
                      await createUser(
                        context,
                        _namaController.text.trim(),
                        dropdownvalue,
                        _usernameController.text.trim(),
                        _passwordController.text.trim(),
                      );
                    },
                  ),
                  gapH(8),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: blackTextStyle.copyWith(color: Colors.black),
                        children: <TextSpan>[
                          const TextSpan(text: "Sudah punya akun? "),
                          TextSpan(
                            text: "Klik di sini",
                            style:
                                blackTextStyle.copyWith(color: kPrimary2Color),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, '/login-page');
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
