import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:quran_app/core/theme/app_colors.dart';
import 'package:quran_app/core/constants/app_constants.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  double? _qiblaDirection; // Qibla bearing from North
  double _deviceHeading = 0; // Current compass heading
  String _locationText = 'Mendeteksi lokasi...';
  bool _loading = true;
  String? _errorMessage;
  StreamSubscription<CompassEvent>? _compassSubscription;
  StreamSubscription<Position>? _positionSubscription;

  // Kaaba coordinates
  static const double _kaabaLat = 21.4225;
  static const double _kaabaLon = 39.8262;

  // Low-pass filter variables for smoother compass
  final double _filterFactor = 0.15; // Lower means smoother but slower response
  double? _lastValidHeading;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _calculateQibla();
    _startCompass();
  }

  void _startCompass() {
    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (event.heading != null && mounted) {
        setState(() {
          double newHeading = event.heading!;
          
          if (_lastValidHeading == null) {
            _deviceHeading = newHeading;
            _lastValidHeading = newHeading;
          } else {
            // Handle wrap-around at 360/0 degrees
            double diff = newHeading - _lastValidHeading!;
            if (diff > 180) {
              _lastValidHeading = _lastValidHeading! + 360;
            } else if (diff < -180) {
              _lastValidHeading = _lastValidHeading! - 360;
            }
            
            // Apply low-pass filter
            _deviceHeading = _lastValidHeading! + _filterFactor * (newHeading - _lastValidHeading!);
            
            // Normalize back to 0-360
            _deviceHeading = _deviceHeading % 360;
            if (_deviceHeading < 0) _deviceHeading += 360;
            
            _lastValidHeading = _deviceHeading;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _calculateQibla() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Layanan lokasi tidak aktif. Silakan aktifkan GPS.';
          _loading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Izin lokasi ditolak';
            _loading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage =
              'Izin lokasi ditolak secara permanen. Buka pengaturan untuk mengizinkan.';
          _loading = false;
        });
        return;
      }

      // Start listening to location updates for real-time accuracy
      // This allows the app to refine the GPS coordinate while the user walks/adjusts
      _positionSubscription?.cancel(); // Cancel any existing stream
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 2, // update if moved > 2 meters
        ),
      ).listen((Position position) {
        if (mounted) {
          _computeAndSetQibla(position);
        }
      });
      
      // Get an initial reading quickly
      Position? position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        _computeAndSetQibla(position);
      }

      // Then get current with high accuracy + timeout
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        ),
      );

      _computeAndSetQibla(position);
    } catch (e) {
      setState(() {
        if (_qiblaDirection == null) {
          _errorMessage = 'Gagal mendapatkan lokasi. Coba lagi.';
        }
        _loading = false;
      });
    }
  }

  void _computeAndSetQibla(Position position) {
    var userLat = position.latitude * (math.pi / 180);
    var userLon = position.longitude * (math.pi / 180);
    var kaabaLat = _kaabaLat * (math.pi / 180);
    var kaabaLon = _kaabaLon * (math.pi / 180);

    var dLon = kaabaLon - userLon;
    var y = math.sin(dLon);
    var x = math.cos(userLat) * math.tan(kaabaLat) -
        math.sin(userLat) * math.cos(dLon);
    var bearing = math.atan2(y, x) * (180 / math.pi);
    bearing = (bearing + 360) % 360;

    setState(() {
      _qiblaDirection = bearing;
      _locationText =
          'Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}';
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Calculate the angle to rotate the compass:
    // The qibla arrow should point at (_qiblaDirection - _deviceHeading) degrees
    final double qiblaRelative = _qiblaDirection != null
        ? (_qiblaDirection! - _deviceHeading) * (math.pi / 180)
        : 0;
    final double compassRotation = -_deviceHeading * (math.pi / 180);

    return Scaffold(
      appBar: AppBar(
        title: Text('Kompas Kiblat',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: _loading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text('Mencari lokasi...', style: theme.textTheme.bodyMedium),
                ],
              ),
            )
          : _errorMessage != null && _qiblaDirection == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_off_rounded,
                            size: 56, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text(_errorMessage!,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _init,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(height: 24),
                    // Direction text
                    Text(
                      'Arah Kiblat',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    if (_qiblaDirection != null)
                      Text(
                        '${_qiblaDirection!.toStringAsFixed(1)}°',
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.primarySurface,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusRound),
                      ),
                      child: Text(
                        'Dari Utara (Searah Jarum Jam)',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const Spacer(),

                    // Compass visual — rotates with device heading
                    if (_qiblaDirection != null)
                      SizedBox(
                        width: 280,
                        height: 280,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Compass ring — rotates opposite to device heading
                            AnimatedRotation(
                              turns: compassRotation / (2 * math.pi),
                              duration: const Duration(milliseconds: 300),
                              child: SizedBox(
                                width: 280,
                                height: 280,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 280,
                                      height: 280,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: theme.colorScheme.outline
                                              .withValues(alpha: 0.3),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    ..._buildDirectionMarkers(theme),
                                  ],
                                ),
                              ),
                            ),
                            // Qibla arrow — rotates relative to device heading
                            AnimatedRotation(
                              turns: qiblaRelative / (2 * math.pi),
                              duration: const Duration(milliseconds: 300),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.mosque_rounded,
                                        color: Colors.white, size: 24),
                                  ),
                                  Container(
                                    width: 3,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          AppColors.primary,
                                          AppColors.primary
                                              .withValues(alpha: 0.1),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Center dot
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),

                    // Device heading info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Heading: ${_deviceHeading.toStringAsFixed(0)}°',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Location
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on_rounded,
                              color: theme.textTheme.bodySmall?.color,
                              size: 16),
                          const SizedBox(width: 6),
                          Text(_locationText,
                              style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),

                    // Note
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 8, 32, 32),
                      child: Text(
                        'Arahkan panah masjid ke depan Anda untuk menemukan arah Kiblat',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
    );
  }

  List<Widget> _buildDirectionMarkers(ThemeData theme) {
    const directions = ['U', 'T', 'S', 'B'];
    return List.generate(4, (i) {
      final angle = i * 90.0 * (math.pi / 180);
      return Transform.rotate(
        angle: angle,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              directions[i],
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: i == 0
                    ? AppColors.error
                    : theme.textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ),
      );
    });
  }
}
