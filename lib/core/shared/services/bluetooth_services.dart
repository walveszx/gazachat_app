import 'dart:async';
import 'dart:typed_data';
import 'package:gazachat/core/helpers/logger_debug.dart';
import 'package:gazachat/core/shared/models/nearbay_device_info.dart';
import 'package:nearby_connections/nearby_connections.dart';

class BluetoothServicesGazachat {
  // Streams for device events
  final StreamController<NearbayDeviceInfo> _deviceFoundController =
      StreamController<NearbayDeviceInfo>.broadcast();
  final StreamController<String> _deviceLostController =
      StreamController<String>.broadcast();
  final StreamController<NearbayDeviceInfo> _deviceConnectedController =
      StreamController<NearbayDeviceInfo>.broadcast();
  final StreamController<Map<String, String>> _messageReceivedController =
      StreamController<Map<String, String>>.broadcast();

  // Getters for streams
  Stream<NearbayDeviceInfo> get onDeviceFound => _deviceFoundController.stream;
  Stream<String> get onDeviceLost => _deviceLostController.stream;
  Stream<NearbayDeviceInfo> get onDeviceConnected =>
      _deviceConnectedController.stream;
  Stream<Map<String, String>> get onMessageReceived =>
      _messageReceivedController.stream;

  // start advertising
  Future<void> startAdvertising(String userName) async {
    final Strategy strategy = Strategy.P2P_STAR;
    try {
      await Nearby().startAdvertising(
        userName,
        strategy,
        onConnectionInitiated: (String id, ConnectionInfo info) {
          // Called whenever a discoverer requests connection
          LoggerDebug.logger.w(
            'Connection initiated: $id, UserName: ${info.endpointName}',
          );
          // Automatically accept all connections
          acceptConnection(id);
        },
        onConnectionResult: (String id, Status status) {
          // Called when connection is accepted/rejected
          LoggerDebug.logger.w(
            'Connection result: $id, Status: ${status.toString()}',
          );
          if (status == Status.CONNECTED) {
            // Add connected device to stream
            final device = NearbayDeviceInfo(
              id: id,
              uuid: '', // We'll get this from the connection info or messages
              serviceId: "free.palestine.gazachat",
            );
            _deviceConnectedController.add(device);
          }
        },
        onDisconnected: (String id) {
          // Called whenever a discoverer disconnects from advertiser
          LoggerDebug.logger.w('Disconnected from: $id');
          _deviceLostController.add(id);
        },
        serviceId: "free.palestine.gazachat", // uniquely identifies your app
      );
    } catch (exception) {
      LoggerDebug.logger.e('Error starting advertising: $exception');
    }
  }

  // start startDiscovery
  Future<void> startDiscovery(String userName) async {
    final Strategy strategy = Strategy.P2P_STAR;

    try {
      await Nearby().startDiscovery(
        userName,
        strategy,
        onEndpointFound: (String id, String userName, String serviceId) {
          // Called whenever an advertiser is found
          LoggerDebug.logger.w(
            'Endpoint found: $id, UserName: $userName, ServiceId: $serviceId',
          );

          // Create device info and add to stream
          final device = NearbayDeviceInfo(
            id: id,
            uuid: userName, // Using userName as UUID
            serviceId: serviceId,
          );
          _deviceFoundController.add(device);

          // DO NOT automatically request connection here
          // Let the UI or user decide when to connect
        },
        onEndpointLost: (String? id) {
          LoggerDebug.logger.w('Endpoint lost: $id');
          if (id != null) {
            _deviceLostController.add(id);
          }
        },
        serviceId: "free.palestine.gazachat",
      );
    } catch (e) {
      LoggerDebug.logger.e('Error starting discovery: $e');
    }
  }

  // Stop advertising
  Future<void> stopAdvertising() async {
    try {
      await Nearby().stopAdvertising();
      LoggerDebug.logger.d('Stopped advertising');
    } catch (e) {
      LoggerDebug.logger.e('Error stopping advertising: $e');
    }
  }

  // Stop discovery
  Future<void> stopDiscovery() async {
    try {
      await Nearby().stopDiscovery();
      LoggerDebug.logger.d('Stopped discovery');
    } catch (e) {
      LoggerDebug.logger.e('Error stopping discovery: $e');
    }
  }

  // Request connection to a device
  Future<void> requestConnection(String deviceId, String userName) async {
    try {
      await Nearby().requestConnection(
        userName,
        deviceId,
        onConnectionInitiated: (String id, ConnectionInfo info) {
          LoggerDebug.logger.w(
            'Connection initiated to: $id, UserName: ${info.endpointName}',
          );
          // Automatically accept the connection
          acceptConnection(id);
        },
        onConnectionResult: (String id, Status status) {
          LoggerDebug.logger.w('Connection result: $id, Status: $status');
          if (status == Status.CONNECTED) {
            final device = NearbayDeviceInfo(
              id: id,
              uuid: userName, // Use the username passed in
              serviceId: "free.palestine.gazachat",
            );
            _deviceConnectedController.add(device);
          }
        },
        onDisconnected: (String id) {
          LoggerDebug.logger.w('Disconnected from: $id');
          _deviceLostController.add(id);
        },
      );
    } catch (e) {
      LoggerDebug.logger.e('Error requesting connection: $e');
    }
  }

  // Accept connection
  Future<void> acceptConnection(String deviceId) async {
    try {
      await Nearby().acceptConnection(
        deviceId,
        onPayLoadRecieved: (String endpointId, Payload payload) {
          // Handle received messages
          if (payload.type == PayloadType.BYTES) {
            final String message = String.fromCharCodes(payload.bytes!);
            LoggerDebug.logger.d('Message received from $endpointId: $message');

            // Add received message to stream
            _messageReceivedController.add({
              'senderId': endpointId,
              'message': message,
            });
          }
        },
      );
      LoggerDebug.logger.d('Accepted connection from: $deviceId');
    } catch (e) {
      LoggerDebug.logger.e('Error accepting connection: $e');
    }
  }

  // Send message to a specific device
  Future<bool> sendMessage(String deviceId, String message) async {
    try {
      final Uint8List bytes = Uint8List.fromList(message.codeUnits);
      await Nearby().sendBytesPayload(deviceId, bytes);
      LoggerDebug.logger.d('Message sent to $deviceId: $message');
      return true;
    } catch (e) {
      LoggerDebug.logger.e('Error sending message to $deviceId: $e');
      return false;
    }
  }

  // Send message to all connected devices
  Future<void> sendMessageToAll(String message) async {
    try {
      final Uint8List bytes = Uint8List.fromList(message.codeUnits);
      await Nearby().sendBytesPayload('', bytes); // Empty string sends to all
      LoggerDebug.logger.d('Message sent to all connected devices: $message');
    } catch (e) {
      LoggerDebug.logger.e('Error sending message to all devices: $e');
    }
  }

  // Dispose streams
  void dispose() {
    _deviceFoundController.close();
    _deviceLostController.close();
    _deviceConnectedController.close();
    _messageReceivedController.close();
  }
}
