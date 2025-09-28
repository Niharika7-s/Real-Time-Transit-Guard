import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SimpleRouteService {
  /// Generate route points between two locations
  static List<LatLng> generateRoute({
    required LatLng startPoint,
    required LatLng endPoint,
  }) {
    List<LatLng> routePoints = [];
    
    // Add start point
    routePoints.add(startPoint);
    
    // Calculate intermediate points for a more realistic route
    final latDiff = endPoint.latitude - startPoint.latitude;
    final lngDiff = endPoint.longitude - startPoint.longitude;
    
    // Create waypoints along the route (simulate road network)
    for (int i = 1; i <= 8; i++) {
      final ratio = i / 9.0;
      
      // Add some curvature to simulate real roads
      double curveFactor = 0.0;
      if (i % 2 == 0) {
        curveFactor = 0.002; // Slight curve
      } else {
        curveFactor = -0.001; // Opposite curve
      }
      
      final lat = startPoint.latitude + (latDiff * ratio) + curveFactor;
      final lng = startPoint.longitude + (lngDiff * ratio) + (curveFactor * 0.5);
      
      routePoints.add(LatLng(lat, lng));
    }
    
    // Add end point
    routePoints.add(endPoint);
    
    return routePoints;
  }

  /// Calculate distance between two points (approximate)
  static double calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    final lat1Rad = point1.latitude * (3.14159265359 / 180);
    final lat2Rad = point2.latitude * (3.14159265359 / 180);
    final deltaLatRad = (point2.latitude - point1.latitude) * (3.14159265359 / 180);
    final deltaLngRad = (point2.longitude - point1.longitude) * (3.14159265359 / 180);

    final a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) * cos(lat2Rad) *
        sin(deltaLngRad / 2) * sin(deltaLngRad / 2);
    final c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  /// Estimate travel time based on distance
  static Duration estimateTravelTime(double distanceKm) {
    // Assuming average speed of 25 km/h in city traffic
    final hours = distanceKm / 25.0;
    return Duration(minutes: (hours * 60).round());
  }

  /// Create polylines for the route
  static Set<Polyline> createRoutePolylines(List<LatLng> routePoints) {
    return {
      Polyline(
        polylineId: PolylineId('route'),
        points: routePoints,
        color: Colors.blue,
        width: 4,
        patterns: [],
      ),
    };
  }

  /// Create markers for start, end, and driver positions
  static Set<Marker> createRouteMarkers({
    required LatLng startPoint,
    required LatLng endPoint,
    required LatLng driverPoint,
  }) {
    return {
      Marker(
        markerId: MarkerId('start'),
        position: startPoint,
        infoWindow: InfoWindow(title: 'Pickup Location', snippet: 'Warehouse'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
      Marker(
        markerId: MarkerId('end'),
        position: endPoint,
        infoWindow: InfoWindow(title: 'Delivery Location', snippet: 'Customer Address'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: MarkerId('driver'),
        position: driverPoint,
        infoWindow: InfoWindow(title: 'Driver', snippet: 'Current Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
  }
}
