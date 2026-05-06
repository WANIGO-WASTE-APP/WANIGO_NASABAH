import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // Cache untuk position dan ongoing request
  Position? _cachedPosition;
  Future<Position?>? _ongoingRequest;
  DateTime? _lastFetchTime;
  static const Duration _cacheValidity = Duration(minutes: 5);

  Future<bool> hasLocationPermission() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  Future<Position?> getCurrentPosition() async {
    // Return cached position jika masih valid
    if (_cachedPosition != null && _lastFetchTime != null) {
      final age = DateTime.now().difference(_lastFetchTime!);
      if (age < _cacheValidity) {
        print(
            'DEBUG - LocationService: Returning cached position, age: ${age.inSeconds}s');
        return _cachedPosition;
      }
    }

    // Jika ada request yang sedang berjalan, tunggu hasilnya
    if (_ongoingRequest != null) {
      print('DEBUG - LocationService: Waiting for ongoing request...');
      return await _ongoingRequest;
    }

    // Buat new request
    _ongoingRequest = _fetchPosition();
    final result = await _ongoingRequest;
    _ongoingRequest = null;
    return result;
  }

  Future<Position?> _fetchPosition() async {
    try {
      print('DEBUG - LocationService: Fetching fresh position...');

      // Cek permission dengan geolocator (lebih reliable)
      LocationPermission permission = await Geolocator.checkPermission();
      print('DEBUG - LocationService: Geolocator permission: $permission');

      if (permission == LocationPermission.denied) {
        print('DEBUG - LocationService: Requesting permission...');
        permission = await Geolocator.requestPermission();
        print('DEBUG - LocationService: After request: $permission');
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print('DEBUG - LocationService: Permission denied');
        return null;
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('DEBUG - LocationService: Service enabled: $serviceEnabled');
      if (!serviceEnabled) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Cache position
      _cachedPosition = position;
      _lastFetchTime = DateTime.now();
      print('DEBUG - LocationService: Position cached successfully');

      return position;
    } catch (e) {
      print('DEBUG - LocationService: Error getting position: $e');
      return null;
    }
  }

  /// Clear cache (useful untuk force refresh)
  void clearCache() {
    _cachedPosition = null;
    _lastFetchTime = null;
    print('DEBUG - LocationService: Cache cleared');
  }

  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(
      startLat,
      startLng,
      endLat,
      endLng,
    );
  }

  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)}m';
    } else {
      final km = distanceInMeters / 1000;
      return '${km.toStringAsFixed(1)}km';
    }
  }
}
