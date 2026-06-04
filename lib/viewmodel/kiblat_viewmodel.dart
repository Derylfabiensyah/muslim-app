import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:async';

class KiblatViewModel extends ChangeNotifier {
  // Koordinat Ka'bah (Makkah)
  static const double _kaabaLatitude = 21.4225;
  static const double _kaabaLongitude = 39.8262;

  double? _heading; // Arah kompas device (derajat dari utara)
  double? _qiblaDirection; // Arah kiblat dari lokasi user (derajat dari utara)
  double? _latitude;
  double? _longitude;
  String? _error;
  bool _isLoading = true;
  bool _hasPermission = false;
  StreamSubscription<CompassEvent>? _compassSubscription;

  // Getters
  double? get heading => _heading;
  double? get qiblaDirection => _qiblaDirection;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get hasPermission => _hasPermission;

  /// Menghitung derajat rotasi jarum kiblat
  /// = arah kiblat - arah kompas (heading device)
  double get qiblaFromNorth {
    if (_qiblaDirection == null || _heading == null) return 0;
    return (_qiblaDirection! - _heading!) * (pi / 180);
  }

  /// Menghitung jarak ke Ka'bah dalam km
  double get distanceToKaaba {
    if (_latitude == null || _longitude == null) return 0;
    return _calculateDistance(
      _latitude!, _longitude!, _kaabaLatitude, _kaabaLongitude,
    );
  }

  /// Inisialisasi kompas dan lokasi
  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Cek apakah location service aktif
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _error = 'Layanan lokasi tidak aktif. Aktifkan GPS Anda.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Cek & minta permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _error = 'Izin lokasi ditolak. Aktifkan di pengaturan.';
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _error = 'Izin lokasi ditolak permanen. Buka pengaturan untuk mengaktifkan.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      _hasPermission = true;

      // Dapatkan lokasi
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      _latitude = position.latitude;
      _longitude = position.longitude;

      // Hitung arah kiblat
      _qiblaDirection = _calculateQiblaDirection(
        _latitude!, _longitude!,
      );

      // Start compass listener
      _startCompass();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Gagal mendapatkan lokasi: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mulai mendengarkan kompas
  void _startCompass() {
    _compassSubscription = FlutterCompass.events?.listen((event) {
      _heading = event.heading;
      notifyListeners();
    });
  }

  /// Hitung arah kiblat dari posisi user ke Ka'bah
  /// Menggunakan formula Great Circle Bearing
  double _calculateQiblaDirection(double lat, double lng) {
    final double lat1 = lat * pi / 180;
    final double lng1 = lng * pi / 180;
    const double lat2 = _kaabaLatitude * pi / 180;
    const double lng2 = _kaabaLongitude * pi / 180;

    final double dLng = lng2 - lng1;

    final double y = sin(dLng) * cos(lat2);
    final double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);

    double bearing = atan2(y, x);
    bearing = bearing * 180 / pi; // Konversi ke derajat
    bearing = (bearing + 360) % 360; // Normalisasi ke 0-360

    return bearing;
  }

  /// Hitung jarak antara 2 titik koordinat (Haversine formula)
  double _calculateDistance(
      double lat1, double lng1, double lat2, double lng2) {
    const double R = 6371; // Radius bumi dalam km
    final double dLat = (lat2 - lat1) * pi / 180;
    final double dLng = (lng2 - lng1) * pi / 180;

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLng / 2) *
            sin(dLng / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }
}
