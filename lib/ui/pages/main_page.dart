import 'package:absen_desa/ui/pages/absensi_page.dart';
import 'package:absen_desa/ui/pages/history_page.dart';
import 'package:absen_desa/ui/pages/profile_page.dart';
import 'package:absen_desa/ui/shared/theme.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final int pageIndex;
  const MainPage({
    super.key,
    required this.pageIndex,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  static const List<Widget> _pages = <Widget>[
    AbsensiPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  static const List<String> _appBarTitle = <String>[
    'Absensi',
    'History',
    'Profile'
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SafeArea(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              color: kPrimaryColor,
              child: Text(_appBarTitle[_selectedIndex],
                  style: whiteTextStyle.copyWith(
                      fontSize: 24, fontWeight: extraBold)),
            ),
          )),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          elevation: 10.0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_calendar_rounded),
              label: 'Absensi',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: 'History',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.black,
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: kBlackColor,
          selectedItemColor: kPrimaryColor,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
