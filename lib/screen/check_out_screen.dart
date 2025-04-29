import 'dart:async';
import 'package:absen_dulu/services/check_out_service.dart';
import 'package:absen_dulu/services/geo_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _noteController = TextEditingController();
  final CheckOutService _checkOutService =
      CheckOutService(); // buat service baru

  LatLng? _currentPosition;
  String _currentAddress = "Mendeteksi lokasi...";
  bool _isLoadingLocation = true;
  bool _isCheckingOut = false;

  late Timer _timer;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startClock();
  }

  void _startClock() {
    _currentTime = _formatCurrentTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = _formatCurrentTime();
        });
      }
    });
  }

  String _formatCurrentTime() {
    return TimeOfDay.now().format(context);
  }

  @override
  void dispose() {
    _timer.cancel();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    _isLoadingLocation = true;
    setState(() {});
    try {
      final LatLng position = await determineUserLocation();
      await _getAddressFromLatLng(position);
      _currentPosition = position;
    } catch (e) {
      _currentAddress = 'Gagal mendapatkan lokasi.';
      print('Error fetching location: $e');
    } finally {
      _isLoadingLocation = false;
      setState(() {});
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        _currentAddress =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea} ${place.postalCode}";
      }
    } catch (e) {
      print('Error reverse geocoding: $e');
    }
  }

  Future<void> _handleCheckOut() async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lokasi belum tersedia. Coba lagi.')),
      );
      return;
    }

    setState(() => _isCheckingOut = true);

    try {
      final result = await _checkOutService.checkOut(
        lat: _currentPosition!.latitude,
        lng: _currentPosition!.longitude,
        address: _currentAddress,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Check-Out sukses!')),
      );
      Navigator.pop(context); // balik ke Home setelah sukses
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal Check-Out: $e')));
    } finally {
      setState(() => _isCheckingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoadingLocation
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  Positioned.fill(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition!,
                        zoom: 15,
                      ),
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      onMapCreated:
                          (controller) => _controller.complete(controller),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.4,
                    minChildSize: 0.3,
                    maxChildSize: 0.6,
                    builder: (context, scrollController) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: ListView(
                          controller: scrollController,
                          children: [
                            Center(
                              child: Text(
                                _currentTime,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: const [
                                Icon(Icons.location_on, color: Colors.black),
                                SizedBox(width: 8),
                                Text(
                                  "Your Location",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _currentAddress,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            // Row(
                            //   children: const [
                            //     Icon(Icons.notes, size: 20),
                            //     SizedBox(width: 8),
                            //     Text("Note (Optional)"),
                            //   ],
                            // ),
                            // const SizedBox(height: 8),
                            // TextField(
                            //   controller: _noteController,
                            //   decoration: InputDecoration(
                            //     hintText: "Add a note...",
                            //     border: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(12),
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D3B66),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                ),
                                onPressed:
                                    (_isCheckingOut || _currentPosition == null)
                                        ? null
                                        : _handleCheckOut,
                                child:
                                    _isCheckingOut
                                        ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                        : const Text(
                                          "Check Out",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
    );
  }
}
