import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gazachat/core/helpers/logger_debug.dart';
import 'package:gazachat/core/helpers/shared_prefences.dart';
import 'package:gazachat/core/shared/models/nearbay_device_info.dart';
import 'package:gazachat/core/shared/services/bluetooth_services.dart';

// Provider for managing Bluetooth state with discovered and connected devices
final nearbayStateProvider =
    StateNotifierProvider<BluetoothStateNotifier, BluetoothState>((ref) {
      return BluetoothStateNotifier();
    });

class BluetoothState {
  final List<NearbayDeviceInfo> discoveredDevices;
  final List<NearbayDeviceInfo> connectedDevices;
  final bool isAdvertising;
  final bool isDiscovering;
  final Stream<Map<String, String>>? messageStream;

  const BluetoothState({
    this.discoveredDevices = const [],
    this.connectedDevices = const [],
    this.isAdvertising = false,
    this.isDiscovering = false,
    this.messageStream,
  });

  BluetoothState copyWith({
    List<NearbayDeviceInfo>? discoveredDevices,
    List<NearbayDeviceInfo>? connectedDevices,
    bool? isAdvertising,
    bool? isDiscovering,
    Stream<Map<String, String>>? messageStream,
  }) {
    return BluetoothState(
      discoveredDevices: discoveredDevices ?? this.discoveredDevices,
      connectedDevices: connectedDevices ?? this.connectedDevices,
      isAdvertising: isAdvertising ?? this.isAdvertising,
      isDiscovering: isDiscovering ?? this.isDiscovering,
      messageStream: messageStream ?? this.messageStream,
    );
  }
}

class BluetoothStateNotifier extends StateNotifier<BluetoothState> {
  BluetoothStateNotifier() : super(const BluetoothState()) {
    _initializeListeners();
    // Expose message stream
    state = state.copyWith(messageStream: _bluetoothService.onMessageReceived);
  }

  final BluetoothServicesGazachat _bluetoothService =
      BluetoothServicesGazachat();

  StreamSubscription<NearbayDeviceInfo>? _deviceFoundSubscription;
  StreamSubscription<String>? _deviceLostSubscription;
  StreamSubscription<NearbayDeviceInfo>? _deviceConnectedSubscription;
  StreamSubscription<Map<String, String>>? _messageReceivedSubscription;

  void _initializeListeners() {
    // Listen for discovered devices
    _deviceFoundSubscription = _bluetoothService.onDeviceFound.listen((device) {
      LoggerDebug.logger.d('Device found: ${device.id}');
      _addDiscoveredDevice(device);
    });

    // Listen for lost devices
    _deviceLostSubscription = _bluetoothService.onDeviceLost.listen((deviceId) {
      LoggerDebug.logger.d('Device lost: $deviceId');
      _removeDevice(deviceId);
    });

    // Listen for connected devices
    _deviceConnectedSubscription = _bluetoothService.onDeviceConnected.listen((
      device,
    ) {
      LoggerDebug.logger.d('Device connected: ${device.id}');
      _addConnectedDevice(device);
    });

    // Listen for received messages
    _messageReceivedSubscription = _bluetoothService.onMessageReceived.listen((
      messageData,
    ) {
      // call my provider to handle the message

      LoggerDebug.logger.d(
        'Message received: ${messageData['message']} from ${messageData['senderId']}',
      );
      // You can handle received messages here or expose through another stream
    });
  }

  void _addDiscoveredDevice(NearbayDeviceInfo device) {
    // Check if device already exists in discovered list
    final existingIndex = state.discoveredDevices.indexWhere(
      (d) => d.id == device.id,
    );

    if (existingIndex == -1) {
      // Add new device
      final updatedDiscovered = [...state.discoveredDevices, device];
      state = state.copyWith(discoveredDevices: updatedDiscovered);
    }
  }

  void _addConnectedDevice(NearbayDeviceInfo device) {
    // Check if device already exists in connected list
    final existingIndex = state.connectedDevices.indexWhere(
      (d) => d.id == device.id,
    );

    if (existingIndex == -1) {
      // Add to connected devices
      final updatedConnected = [...state.connectedDevices, device];
      // Remove from discovered devices if it exists there
      final updatedDiscovered = state.discoveredDevices
          .where((d) => d.id != device.id)
          .toList();

      state = state.copyWith(
        connectedDevices: updatedConnected,
        discoveredDevices: updatedDiscovered,
      );
    }
  }

  void _removeDevice(String deviceId) {
    // Remove from both discovered and connected lists
    final updatedDiscovered = state.discoveredDevices
        .where((d) => d.id != deviceId)
        .toList();
    final updatedConnected = state.connectedDevices
        .where((d) => d.id != deviceId)
        .toList();

    state = state.copyWith(
      discoveredDevices: updatedDiscovered,
      connectedDevices: updatedConnected,
    );
  }

  Future<void> startAdvertising() async {
    // Check if already advertising to prevent multiple calls
    if (state.isAdvertising) {
      LoggerDebug.logger.w('Advertising already in progress');
      return;
    }

    try {
      final String username = await SharedPrefHelper.getString('uuid');
      await _bluetoothService.startAdvertising(username);

      state = state.copyWith(isAdvertising: true);
      LoggerDebug.logger.d('Started advertising');
    } catch (e) {
      LoggerDebug.logger.e('Error starting advertising: $e');
      // Reset advertising state if it failed
      state = state.copyWith(isAdvertising: false);
    }
  }

  Future<void> stopAdvertising() async {
    try {
      await _bluetoothService.stopAdvertising();
      state = state.copyWith(isAdvertising: false);
      LoggerDebug.logger.d('Stopped advertising');
    } catch (e) {
      LoggerDebug.logger.e('Error stopping advertising: $e');
    }
  }

  Future<void> startDiscovery() async {
    // Check if already discovering to prevent multiple calls
    if (state.isDiscovering) {
      LoggerDebug.logger.w('Discovery already in progress');
      return;
    }

    try {
      final String username = await SharedPrefHelper.getString('uuid');
      await _bluetoothService.startDiscovery(username);

      state = state.copyWith(isDiscovering: true);
      LoggerDebug.logger.d('Started discovery');
    } catch (e) {
      LoggerDebug.logger.e('Error starting discovery: $e');
      // Reset discovery state if it failed
      state = state.copyWith(isDiscovering: false);
    }
  }

  Future<void> stopDiscovery() async {
    try {
      await _bluetoothService.stopDiscovery();
      state = state.copyWith(isDiscovering: false);
      LoggerDebug.logger.d('Stopped discovery');
    } catch (e) {
      LoggerDebug.logger.e('Error stopping discovery: $e');
    }
  }

  Future<void> connectToDevice(String deviceId, String uuid) async {
    try {
      final String username = await SharedPrefHelper.getString('uuid');

      // Find the device in discovered devices to get its username
      final device = state.discoveredDevices
          .where((d) => d.id == deviceId)
          .firstOrNull;
      if (device == null) {
        LoggerDebug.logger.e(
          'Device not found in discovered devices: $deviceId',
        );
        return;
      }

      await _bluetoothService.requestConnection(deviceId, uuid);
      LoggerDebug.logger.d('Requesting connection to: $deviceId');
    } catch (e) {
      LoggerDebug.logger.e('Error connecting to device: $e');
    }
  }

  // Connect to all discovered devices
  Future<void> connectToAllDiscoveredDevices() async {
    for (final device in state.discoveredDevices) {
      // Check if already connected
      final isAlreadyConnected = state.connectedDevices.any(
        (conn) => conn.id == device.id,
      );
      if (!isAlreadyConnected) {
        await connectToDevice(device.id, device.uuid);
        // Add small delay between connection attempts
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  Future<bool> sendMessageToDevice(String deviceId, String message) async {
    try {
      final result = await _bluetoothService.sendMessage(deviceId, message);
      LoggerDebug.logger.d('Message send result to $deviceId: $result');
      return result;
    } catch (e) {
      LoggerDebug.logger.e('Error sending message to device: $e');
      return false;
    }
  }

  Future<void> sendMessageToAll(String message) async {
    try {
      await _bluetoothService.sendMessageToAll(message);
      LoggerDebug.logger.d('Message sent to all connected devices');
    } catch (e) {
      LoggerDebug.logger.e('Error sending message to all devices: $e');
    }
  }

  // Get connected device by username
  NearbayDeviceInfo? getConnectedDeviceByUsername(String username) {
    try {
      return state.connectedDevices.firstWhere(
        (device) => device.uuid == username,
      );
    } catch (e) {
      return null;
    }
  }

  // Check if a specific user is connected
  bool isUserConnected(String username) {
    return state.connectedDevices.any((device) => device.uuid == username);
  }

  void clearAllDevices() {
    state = state.copyWith(discoveredDevices: [], connectedDevices: []);
  }

  @override
  void dispose() {
    _deviceFoundSubscription?.cancel();
    _deviceLostSubscription?.cancel();
    _deviceConnectedSubscription?.cancel();
    _messageReceivedSubscription?.cancel();
    _bluetoothService.dispose();
    super.dispose();
  }
}
