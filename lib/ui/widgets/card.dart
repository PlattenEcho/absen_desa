import 'package:absen_desa/ui/shared/theme.dart';
import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  final String time;
  final int tipeAbsensi;
  final int statusAbsensi;
  final String keterangan;

  const HistoryCard(
      {super.key,
      required this.time,
      required this.tipeAbsensi,
      required this.statusAbsensi,
      required this.keterangan});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4, // 3/4 of the width
            child: ListTile(
              title: Text(
                time,
                style: blackTextStyle.copyWith(fontSize: 18, fontWeight: bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tipeAbsensi == 0
                        ? 'Hadir'
                        : tipeAbsensi == 1
                            ? 'Ijin'
                            : "Terlambat",
                    style:
                        blackTextStyle.copyWith(fontSize: 16, fontWeight: bold),
                  ),
                  Row(
                    children: [
                      Text(
                        'Status Absen: ',
                        style: blackTextStyle.copyWith(fontSize: 14),
                      ),
                      Text(
                        statusAbsensi == 1
                            ? "Di Dalam Kantor"
                            : "Di Luar Kantor",
                        style: statusAbsensi == 1
                            ? greenTextStyle.copyWith(
                                fontSize: 14, fontWeight: bold)
                            : redTextStyle.copyWith(
                                fontSize: 14, fontWeight: bold),
                      )
                    ],
                  ),
                  Text(
                    'Keterangan: $keterangan',
                    style: blackTextStyle.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.14,
            width:
                MediaQuery.of(context).size.width * 0.15, // Ensures 1/5 width
            decoration: BoxDecoration(
                color: tipeAbsensi == 0
                    ? kGreenColor
                    : tipeAbsensi == 1
                        ? kYellowColor
                        : kOrangeColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8), // Adjust as needed
                  bottomRight: Radius.circular(8), // Adjust as needed
                )),
            alignment: Alignment.center,
            child: Text(
              tipeAbsensi == 0
                  ? 'H'
                  : tipeAbsensi == 1
                      ? 'I'
                      : "T",
              style:
                  whiteTextStyle.copyWith(fontSize: 28, fontWeight: extraBold),
            ),
          ),
        ],
      ),
    );
  }
}
