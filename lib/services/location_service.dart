import 'package:geolocator/geolocator.dart';

typedef LatLng = ({double lat, double lng});

/// Posição atual via GPS (somente com o app em primeiro plano).
/// Devolve `null` em qualquer falha — GPS desligado, permissão negada, plataforma
/// sem suporte, timeout — para que o chamador caia no fallback manual.
Future<LatLng?> currentPosition() async {
  try {
    if (!await Geolocator.isLocationServiceEnabled()) return null;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        timeLimit: Duration(seconds: 15),
      ),
    );
    return (lat: position.latitude, lng: position.longitude);
  } catch (_) {
    return null;
  }
}

double distanceMeters(LatLng a, LatLng b) =>
    Geolocator.distanceBetween(a.lat, a.lng, b.lat, b.lng);
