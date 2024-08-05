import 'dart:async';
import 'package:absen_desa/controller/storage_controller.dart';
import 'package:absen_desa/main.dart';
import 'package:absen_desa/model/pengguna.dart';
import 'package:absen_desa/ui/shared/gaps.dart';
import 'package:absen_desa/ui/shared/theme.dart';
import 'package:absen_desa/ui/widgets/buttons.dart';
import 'package:absen_desa/ui/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class AbsensiPage extends StatefulWidget {
  const AbsensiPage({super.key});

  @override
  State<AbsensiPage> createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage>
    with AutomaticKeepAliveClientMixin {
  bool isInOffice = false;
  Timer? _timer;
  final TextEditingController keteranganController = TextEditingController();
  Pengguna? user;
  double? userLat;
  double? userLong;

  int tipeAbsensi = 0;

  void loadUser() {
    StorageController storageController = Get.find<StorageController>();
    final userData = storageController.getData('user');
    if (userData != null) {
      setState(() {
        user = Pengguna.fromMap(userData);
      });
    }
  }

  Future<void> checkIsInOffice() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double officeLat = -7.083531362412237;
    double officeLong = 109.46181639697896;
    double distance = Geolocator.distanceBetween(
        position.latitude, position.longitude, officeLat, officeLong);
    if (mounted) {
      setState(() {
        userLat = position.latitude;
        userLong = position.longitude;
        isInOffice = distance < 50;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadUser();
    checkIsInOffice();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      checkIsInOffice();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: checkIsInOffice,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Lokasi Saat ini:",
                  textAlign: TextAlign.center,
                  style: blackTextStyle.copyWith(fontSize: 16),
                ),
                Text(
                  isInOffice ? "Di Dalam Kantor" : "Di Luar Kantor",
                  textAlign: TextAlign.center,
                  style: blackTextStyle.copyWith(
                      color: isInOffice ? kGreenColor : kRedColor,
                      fontSize: 20,
                      fontWeight: extraBold),
                ),
                gapH(16),
                Text(
                  "Tipe Absen:",
                  textAlign: TextAlign.center,
                  style: blackTextStyle.copyWith(fontSize: 16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Radio<int>(
                          value: 0,
                          groupValue: tipeAbsensi,
                          onChanged: (value) {
                            setState(() {
                              tipeAbsensi = value!;
                            });
                          },
                        ),
                        Text('Berangkat',
                            style: blackTextStyle.copyWith(
                                fontSize: 16, fontWeight: bold)),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<int>(
                          value: 1,
                          groupValue: tipeAbsensi,
                          onChanged: (value) {
                            setState(() {
                              tipeAbsensi = value!;
                            });
                          },
                        ),
                        Text('Pulang',
                            style: blackTextStyle.copyWith(
                                fontSize: 16, fontWeight: bold)),
                      ],
                    ),
                  ],
                ),
                gapH(16),
                Text(
                  "Keterangan:",
                  textAlign: TextAlign.center,
                  style: blackTextStyle.copyWith(fontSize: 16),
                ),
                gapH8,
                TextField(
                  controller: keteranganController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: const InputDecoration(
                      hintText: "Isi Keterangan (Opsional)",
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.black)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.black))),
                ),
                gapH24,
                Button(
                    text: "Absen Sekarang",
                    textColor: kWhiteColor,
                    startColor: kPrimaryColor,
                    endColor: kPrimaryColor,
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Center(
                          child: CircularProgressIndicator(
                            color: kWhiteColor,
                          ),
                        ),
                      );

                      final today = DateTime.now().toIso8601String();
                      final now = DateTime.now();
                      final todayStart = DateTime(now.year, now.month, now.day)
                          .toIso8601String();
                      final todayEnd =
                          DateTime(now.year, now.month, now.day, 23, 59, 59)
                              .toIso8601String();
                      final startTime =
                          DateTime(now.year, now.month, now.day, 8);
                      final endTime =
                          DateTime(now.year, now.month, now.day, 15);

                      if (!(now.isAfter(startTime) && now.isBefore(endTime))) {
                        Navigator.pop(context);
                        showToast(context, "Belum memasuki jam kerja");
                      } else {
                        try {
                          final berangkatResponse = await supabase
                              .from('absensi')
                              .select('id')
                              .eq('username', user!.username)
                              .gte('created_at', todayStart)
                              .lte('created_at', todayEnd)
                              .eq('tipe_absen', 0)
                              .limit(1);

                          if (tipeAbsensi == 0) {
                            if (berangkatResponse.isEmpty) {
                              await supabase.from('absensi').insert({
                                'id_user': user!.id,
                                'username': user!.username,
                                'status_absensi': isInOffice ? 1 : 0,
                                'latitude': userLat,
                                'longitude': userLong,
                                'tipe_absen': 0,
                                'keterangan': keteranganController.text.trim(),
                                'created_at': today
                              });
                              Navigator.pop(context);
                              showToast(context, "Absen berhasil.");
                            } else {
                              Navigator.pop(context);
                              showToast(context,
                                  "Anda sudah melakukan absen berangkat hari ini");
                            }
                          }

                          if (tipeAbsensi == 1) {
                            final pulangResponse = await supabase
                                .from('absensi')
                                .select('id')
                                .eq('username', user!.username)
                                .gte('created_at', todayStart)
                                .lte('created_at', todayEnd)
                                .eq('tipe_absen', 1)
                                .limit(1);
                            if (berangkatResponse.isNotEmpty) {
                              if (pulangResponse.isEmpty) {
                                await supabase.from('absensi').insert({
                                  'id_user': user!.id,
                                  'username': user!.username,
                                  'status_absensi': isInOffice ? 1 : 0,
                                  'latitude': userLat,
                                  'longitude': userLong,
                                  'tipe_absen': 1,
                                  'keterangan':
                                      keteranganController.text.trim(),
                                  'created_at': today
                                });
                                Navigator.pop(context);
                                showToast(context, "Absen berhasil.");
                              } else {
                                Navigator.pop(context);
                                showToast(context,
                                    "Anda sudah melakukan absen pulang hari ini");
                              }
                            } else {
                              Navigator.pop(context);
                              showToast(context,
                                  "Anda belum melakukan absen berangkat hari ini");
                            }
                          }
                        } catch (e) {
                          Navigator.pop(context);
                          showToast(context, e.toString());
                        }
                      }
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
