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
  StreamSubscription<Position>? _positionStreamSubscription;
  final TextEditingController keteranganController = TextEditingController();
  final FocusNode keteranganFocusNode = FocusNode();
  Pengguna? user;
  double? userLat;
  double? userLong;

  int tipeAbsensi = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;

  void loadUser() {
    StorageController storageController = Get.find<StorageController>();
    final userData = storageController.getData('user');
    if (userData != null) {
      setState(() {
        user = Pengguna.fromMap(userData);
      });
    }
  }

  Future<void> checkIsInOffice(Position position) async {
    double officeLat = -7.083531362412237;
    double officeLong = 109.46181639697896;
    double distance = Geolocator.distanceBetween(
        position.latitude, position.longitude, officeLat, officeLong);
    if (mounted) {
      setState(() {
        userLat = position.latitude;
        userLong = position.longitude;
        isInOffice = distance < 50;
        isLoading = false;
      });
    }
  }

  void startLocationStream() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Minimal perubahan jarak untuk memicu update
      ),
    ).listen((Position position) {
      checkIsInOffice(position);
    });
  }

  @override
  void initState() {
    super.initState();
    loadUser();
    Geolocator.requestPermission().then((permission) {
      if (permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever) {
        startLocationStream();
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    keteranganFocusNode.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
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
                              Text('Izin',
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
                        maxLines: 3,
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
                            final todayStart =
                                DateTime(now.year, now.month, now.day)
                                    .toIso8601String();
                            final todayEnd = DateTime(
                                    now.year, now.month, now.day, 23, 59, 59)
                                .toIso8601String();
                            final startTime =
                                DateTime(now.year, now.month, now.day, 8);
                            final lateTime =
                                DateTime(now.year, now.month, now.day);
                            final endTime =
                                DateTime(now.year, now.month, now.day, 23, 59);

                            if (!(now.isAfter(startTime) &&
                                now.isBefore(endTime))) {
                              Navigator.pop(context);
                              showToast(context, "Belum memasuki jam kerja");
                            } else {
                              try {
                                final todayResponse = await supabase
                                    .from('absensi')
                                    .select('id')
                                    .eq('username', user!.username)
                                    .gte('created_at', todayStart)
                                    .lte('created_at', todayEnd)
                                    .limit(1);

                                if (tipeAbsensi == 0) {
                                  if (todayResponse.isEmpty) {
                                    await supabase.from('absensi').insert({
                                      'id_user': user!.id,
                                      'username': user!.username,
                                      'status_absensi': isInOffice ? 1 : 0,
                                      'latitude': userLat,
                                      'longitude': userLong,
                                      'tipe_absen':
                                          !now.isAfter(lateTime) ? 0 : 2,
                                      'keterangan':
                                          keteranganController.text.trim(),
                                      'created_at': today
                                    });
                                    Navigator.pop(context);
                                    if (!now.isAfter(lateTime)) {
                                      showToast(context, "Absen berhasil.");
                                    } else {
                                      showToast(context,
                                          "Absen berhasil. Anda tercatat sebagai terlambat karena melebihi jam 08:00.");
                                    }
                                  } else {
                                    Navigator.pop(context);
                                    showToast(context,
                                        "Anda sudah melakukan absen hadir hari ini");
                                  }
                                }

                                if (tipeAbsensi == 1) {
                                  if (todayResponse.isEmpty) {
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
                                        "Anda sudah melakukan absen izin hari ini");
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
