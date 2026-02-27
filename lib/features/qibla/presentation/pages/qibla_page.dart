import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class QiblaPage extends StatelessWidget {
  const QiblaPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data:
    const double compassHeading = 195.0; // User's device heading
    const double qiblaDirection = 295.0; // Direction of Qibla from user

    // The angle of the user's phone relative to North
    final phoneAngle = compassHeading * (math.pi / 180);
    // The final angle for the Qibla pointer on the screen
    final qiblaPointerAngle = (qiblaDirection - compassHeading) * (math.pi / 180);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kompas Kiblat'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Arahkan bagian atas ponsel Anda ke',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '${qiblaDirection.toStringAsFixed(1)}° N',
            style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          SizedBox(
            width: 300,
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // The compass background that rotates with the phone's heading
                Transform.rotate(
                  angle: -phoneAngle,
                  child: SvgPicture.asset('assets/images/compass_rose.svg'),
                ),
                // The Qibla direction pointer (static relative to the compass rose)
                 Transform.rotate(
                  angle: qiblaPointerAngle,
                  child: const Icon(Icons.mosque, color: Colors.green, size: 50),
                ),
                // The phone's needle (always points "up" on the screen)
                SvgPicture.asset('assets/images/compass_needle.svg'),
                // A small dot in the center
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          Text(
            'Lokasi: Jakarta, Indonesia (Mock)',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
