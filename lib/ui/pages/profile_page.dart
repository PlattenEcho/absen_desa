import 'package:absen_desa/controller/storage_controller.dart';
import 'package:absen_desa/model/pengguna.dart';
import 'package:absen_desa/ui/shared/gaps.dart';
import 'package:absen_desa/ui/shared/theme.dart';
import 'package:absen_desa/ui/widgets/buttons.dart';
import 'package:absen_desa/ui/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Pengguna? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    StorageController storageController = Get.find<StorageController>();
    final userData = storageController.getData('user');
    if (userData != null) {
      setState(() {
        _user = Pengguna.fromMap(userData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        color: kWhiteColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _user == null
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      gapH24,
                      const Icon(
                        Icons.account_circle,
                        size: 150,
                      ),
                      Text(
                        _user!.namaLengkap,
                        style: blackTextStyle.copyWith(
                            fontSize: 20, fontWeight: bold),
                      ),
                      Text(
                        _user!.jabatan,
                        style: blackTextStyle.copyWith(fontSize: 16),
                      ),
                      gapH12,
                      Text(
                        'Username: ${_user!.username}',
                        style: blackTextStyle.copyWith(fontSize: 16),
                      ),
                      gapH24,
                      Button(
                          text: "Log Out",
                          textColor: kWhiteColor,
                          startColor: kRedColor,
                          endColor: kRedColor,
                          onPressed: () {
                            StorageController storageController =
                                Get.find<StorageController>();
                            storageController.removeData('isLoggedIn');
                            storageController.removeData('user');
                            Navigator.pushReplacementNamed(
                                context, '/start-screen');
                            showToast(context, "Anda telah berhasil logout");
                          })
                    ],
                  ),
            Column(
              children: [
                Text(
                  'Dibuat oleh KKN TIM II UNDIP 2023/2024',
                  textAlign: TextAlign.center,
                  style: blackTextStyle.copyWith(fontSize: 14),
                ),
                Text(
                  'DESA GUNUNGBATU',
                  textAlign: TextAlign.center,
                  style: blackTextStyle.copyWith(fontSize: 14),
                ),
                Text(
                  'IG @journey.gunungbatu',
                  style: blackTextStyle.copyWith(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
