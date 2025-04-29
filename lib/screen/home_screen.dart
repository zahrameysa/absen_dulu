import 'dart:async';
import 'package:absen_dulu/screen/annual_leave_screen.dart';
import 'package:absen_dulu/screen/check_out_screen.dart';
import 'package:absen_dulu/screen/history_screen.dart';
import 'package:absen_dulu/screen/permission_screen.dart';
import 'package:absen_dulu/screen/sick_screen.dart';
import 'package:absen_dulu/screen/edit_profile_screen.dart';
import 'package:absen_dulu/screen/check_in_screen.dart';
import 'package:absen_dulu/services/pref_handler.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String token = '';
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    getid();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  void getid() async {
    token = await PreferenceHandler.getToken();
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('hh:mm:ss a').format(_now);
    String formattedDate = DateFormat('EEE, d MMMM yyyy').format(_now);

    return Scaffold(
      body: Stack(
        children: [
          Text(token),
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg_home_screen.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );
                        },
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                            'assets/images/profile.jpg',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Zahra Meysa Putri',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '12345678 - Mobile Programming',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.logout, color: Colors.white),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Live Attendance',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formattedTime,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6A72C1),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(formattedDate),
                      const Divider(height: 24),
                      const Text(
                        'Office Hours',
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '08:00 AM - 05:00 PM',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CheckInScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D3B66),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Check In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const CheckOutScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D3B66),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Check Out',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: const [
                      Icon(Icons.chat_outlined, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'Requests',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      requestItem('Permission', 'assets/icons/permission.png'),
                      const SizedBox(width: 25),
                      requestItem('Sick', 'assets/icons/sick.png'),
                      const SizedBox(width: 25),
                      requestItem('Annual Leave', 'assets/icons/leave.png'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF0D3B66),
        unselectedItemColor: Colors.black45,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: ''),
        ],
      ),
    );
  }

  Widget requestItem(String title, String imagePath) {
    return InkWell(
      onTap: () {
        if (title == 'Permission') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PermissionScreen()),
          );
        } else if (title == 'Sick') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SickScreen()),
          );
        } else if (title == 'Annual Leave') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AnnualLeaveScreen()),
          );
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F0FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(imagePath, width: 40, height: 40),
          ),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }
}
