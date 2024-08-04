import 'dart:io';

import 'package:absen_desa/controller/storage_controller.dart';
import 'package:absen_desa/main.dart';
import 'package:absen_desa/model/pengguna.dart';
import 'package:absen_desa/ui/shared/gaps.dart';
import 'package:absen_desa/ui/shared/theme.dart';
import 'package:absen_desa/ui/widgets/card.dart';
import 'package:absen_desa/ui/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Pengguna? user;
  Future<List<Map<String, dynamic>>>? future;
  String? selectedMonth;
  List<String> months = [];
  List<String> positionsOrder = [
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

  @override
  void initState() {
    super.initState();
    _initializeMonths();
    _loadUser();
  }

  void _initializeMonths() {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    for (int i = 1; i <= currentMonth; i++) {
      DateTime date = DateTime(currentYear, i);
      months.add(DateFormat('MMMM yyyy').format(date));
    }
    selectedMonth = months.last;
  }

  String getExcelColumnName(int columnIndex) {
    if (columnIndex <= 0) {
      throw Exception('Column index must be greater than zero');
    }

    String columnName = '';
    while (columnIndex > 0) {
      columnIndex--;
      columnName = String.fromCharCode(columnIndex % 26 + 65) + columnName;
      columnIndex = (columnIndex / 26).floor();
    }
    return columnName;
  }

  Future<void> _loadUser() async {
    StorageController storageController = Get.find<StorageController>();
    final userData = storageController.getData('user');
    if (userData != null) {
      setState(() {
        user = Pengguna.fromMap(userData);
        _fetchHistory();
      });
    }
  }

  void _fetchHistory() {
    if (user != null && selectedMonth != null) {
      DateTime now = DateTime.now();
      int selectedMonthIndex = months.indexOf(selectedMonth!) + 1;
      DateTime startDate = DateTime(now.year, selectedMonthIndex, 1);
      DateTime endDate =
          DateTime(now.year, selectedMonthIndex + 1, 0, 23, 59, 59);

      setState(() {
        future = supabase
            .from('absensi')
            .select('id, created_at, tipe_absen, status_absensi, keterangan')
            .eq('username', user!.username)
            .gte('created_at', startDate.toIso8601String())
            .lte('created_at', endDate.toIso8601String())
            .order('created_at', ascending: false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadUser,
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: selectedMonth,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedMonth = newValue!;
                                _fetchHistory();
                              });
                            },
                            items: months
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: blackTextStyle.copyWith(
                                      fontWeight: medium),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            final excel.Workbook workbook =
                                new excel.Workbook();
                            final excel.Worksheet sheet =
                                workbook.worksheets[0];

                            //Judul
                            sheet.getRangeByName('A2:AI2').merge();
                            sheet.getRangeByName('A2:AI2').setText(
                                'BUKU ABSENSI / KEHADIRAN PERANGKAT DESA');
                            sheet.getRangeByName("A2").cellStyle.hAlign =
                                excel.HAlignType.center;

                            //Bulan
                            sheet.getRangeByName('A4:C4').merge();
                            sheet
                                .getRangeByName('A4')
                                .setText('Bulan ------------');

                            //Tahun
                            sheet.getRangeByName('AH4:AI4').merge();
                            sheet
                                .getRangeByName('AH4:AI4')
                                .setText('Tahun -----');

                            //Header - NO.
                            sheet.getRangeByName('A5:A6').merge();
                            sheet.getRangeByName('A5:A6').setText("NO.");
                            sheet.getRangeByName("A5:A6").cellStyle.hAlign =
                                excel.HAlignType.center;
                            sheet.getRangeByName("A5:A6").cellStyle.vAlign =
                                excel.VAlignType.center;

                            //Header - NAMA
                            sheet.getRangeByName('B5:B6').merge();
                            sheet.getRangeByName('B5:B6').setText("NAMA");
                            sheet.getRangeByName("B5:B6").cellStyle.hAlign =
                                excel.HAlignType.center;
                            sheet.getRangeByName("B5:B6").cellStyle.vAlign =
                                excel.VAlignType.center;

                            //Header - JABATAN.
                            sheet.getRangeByName('C5:C6').merge();
                            sheet.getRangeByName('C5:C6').setText("JABATAN");
                            sheet.getRangeByName("C5:C6").cellStyle.hAlign =
                                excel.HAlignType.center;
                            sheet.getRangeByName("C5:C6").cellStyle.vAlign =
                                excel.VAlignType.center;

                            //Header - TANGGAL DAN KETERANGAN.
                            sheet.getRangeByName('D5:AH5').merge();
                            sheet
                                .getRangeByName('D5:AH5')
                                .setText("TANGGAL DAN TANDA TANGAN");
                            sheet.getRangeByName("D5:AH5").cellStyle.hAlign =
                                excel.HAlignType.center;
                            sheet.getRangeByName("D5:AH5").cellStyle.vAlign =
                                excel.VAlignType.center;

                            //Header - Tanggal
                            for (int i = 0; i < 31; i++) {
                              final column = getExcelColumnName(
                                  4 + i); // Kolom D adalah kolom ke-4
                              sheet
                                  .getRangeByName("${column}6")
                                  .setText((i + 1).toString());
                              sheet
                                  .getRangeByName("${column}6")
                                  .cellStyle
                                  .hAlign = excel.HAlignType.center;
                              sheet
                                  .getRangeByName("${column}6")
                                  .cellStyle
                                  .vAlign = excel.VAlignType.center;
                            }

                            //Header - KETERANGAN.
                            sheet.getRangeByName('AI5:AI6').merge();
                            sheet
                                .getRangeByName('AI5:AI6')
                                .setText("KETERANGAN");
                            sheet.getRangeByName("AI5:AI6").cellStyle.hAlign =
                                excel.HAlignType.center;
                            sheet.getRangeByName("AI5:AI6").cellStyle.vAlign =
                                excel.VAlignType.center;

                            final excel.Range range1 =
                                sheet.getRangeByName('B1');
                            range1.setText('This is long text');

                            sheet.autoFitRow(1);

                            sheet.autoFitColumn(2);

                            final List<int> bytes = workbook.saveAsStream();
                            File('/storage/emulated/0/Download/excel.xlsx')
                                .writeAsBytes(bytes);

                            workbook.dispose();
                          },
                          child: Text(
                            'Download Rekap',
                            style: blackTextStyle.copyWith(fontWeight: medium),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: Column(
                          children: [
                            gapH32,
                            CircularProgressIndicator(),
                          ],
                        ));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text('Tidak ada yang tersedia',
                                style: blackTextStyle.copyWith(fontSize: 18)));
                      }
                      final absensis = snapshot.data!;
                      return MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: absensis.length,
                          itemBuilder: ((context, index) {
                            final absensi = absensis[index];
                            int tipeAbsensi = absensi['tipe_absen'];
                            int statusAbsensi = absensi['status_absensi'];
                            String keterangan = absensi['keterangan'];

                            DateTime createdAt =
                                DateTime.parse(absensi['created_at']);
                            String formattedTime =
                                DateFormat('dd-MM-yyyy - HH:mm')
                                    .format(createdAt);

                            return HistoryCard(
                                time: formattedTime,
                                tipeAbsensi: tipeAbsensi,
                                statusAbsensi: statusAbsensi,
                                keterangan: keterangan ?? "-");
                          }),
                        ),
                      );
                    },
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
