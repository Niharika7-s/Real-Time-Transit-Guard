import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class RealTimeTrackingService {
  io.Socket? _socket;
  final StreamController<Map<String, dynamic>> _locationUpdatesController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _statusUpdatesController = 
      StreamController<Map<String, dynamic>>.broadcast();
  bool _errorLoggedOnce = false;
  
  static const String defaultServerUrl = 'http://localhost:4000';
  
  Stream<Map<String, dynamic>> get locationUpdates => _locationUpdatesController.stream;
  Stream<Map<String, dynamic>> get statusUpdates => _statusUpdatesController.stream;
  
  void connect({String serverUrl = defaultServerUrl}) {
    // Avoid creating multiple socket connections
    if (_socket != null) {
      debugPrint('Socket already exists, skipping connection');
      return;
    }
    
    try {
      _socket = io.io(serverUrl, io.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .setTimeout(3000) // 3 second timeout
        .build());
        
      _socket!.onConnect((data) {
        debugPrint('✅ Connected to tracking server');
        // Join the real-time tracking room
        try {
          _socket!.emit('join_tracking', {'type': 'mobile_app'});
        } catch (e) {
          debugPrint('Error joining tracking room: $e');
        }
      });
      
      _socket!.onDisconnect((data) {
        debugPrint('❌ Disconnected from tracking server');
      });
      
      _socket!.onError((data) {
        // Only log once to avoid spam
        if (!_errorLoggedOnce) {
          debugPrint('Socket connection failed (no server running)');
          _errorLoggedOnce = true;
        }
      });
      
      // Listen for location updates with error handling
      _socket!.on('location_update', (data) {
        try {
          debugPrint('📍 Received location update: $data');
          _locationUpdatesController.add(data);
        } catch (e) {
          debugPrint('Error handling location update: $e');
        }
      });
      
      // Listen for status updates with error handling  
      _socket!.on('status_update', (data) {
        try {
          debugPrint('📊 Received status update: $data');
          _statusUpdatesController.add(data);
        } catch (e) {
          debugPrint('Error handling status update: $e');
        }
      });
      
      // Listen for deliveries updates specifically with error handling
      _socket!.on('delivery_update', (data) {
        try {
          debugPrint('🚚 Received delivery update: $data');
          _locationUpdatesController.add(data);
          _statusUpdatesController.add(data);
        } catch (e) {
          debugPrint('Error handling delivery update: $e');
        }
      });
    } catch (e) {
      debugPrint('Error connecting to tracking server: $e');
    }
  }
  
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    
    // Close streams properly to prevent memory leaks
    if (!_locationUpdatesController.isClosed) {
      _locationUpdatesController.close();
    }
    if (!_statusUpdatesController.isClosed) {
      _statusUpdatesController.close();
    }
  }
  
  void dispose() {
    disconnect();
  }
}




