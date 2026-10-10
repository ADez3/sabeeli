import 'dart:typed_data';

/// Which 1° cells of the Earth are land: row 0 is the band at 89.5°N, column 0 the
/// meridian at 179.5°W. Coarse on purpose; it only shapes the dots of the globe.
class LandMask {
  const LandMask({
    required this.width,
    required this.height,
    required this.bits,
  });

  final int width;
  final int height;
  final Uint8List bits;

  bool isLand(double latitude, double longitude) {
    final row = (89.5 - latitude).round().clamp(0, height - 1);
    final col = (((longitude + 180) % 360) - 0.5).round().clamp(0, width - 1);
    final i = row * width + col;
    return bits[i >> 3] & (0x80 >> (i & 7)) != 0;
  }
}
