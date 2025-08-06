import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Stream provider that directly listens to FlutterBluePlus
final bluetoothStateStreamProvider = StreamProvider<BluetoothAdapterState>((
  ref,
) {
  return FlutterBluePlus.adapterState;
});

// Provider that returns boolean based on bluetooth state
final isBluetoothOnProvider = Provider<bool>((ref) {
  final bluetoothStateAsync = ref.watch(bluetoothStateStreamProvider);

  return bluetoothStateAsync.when(
    data: (state) => state == BluetoothAdapterState.on,
    loading: () => false, // Default to false while loading
    error: (error, stack) => false, // Default to false on error
  );
});

// Optional: Keep the original StateProvider if you need manual control
final bluetoothStateProvider = StateProvider<BluetoothAdapterState>((ref) {
  return BluetoothAdapterState.unknown;
});

// Alternative: StreamProvider that directly listens to FlutterBluePlus stream
final bluetoothStreamProvider = StreamProvider<BluetoothAdapterState>((ref) {
  return FlutterBluePlus.adapterState;
});

// Provider that watches the stream and returns boolean
final isBluetoothOnStreamProvider = Provider<bool>((ref) {
  final bluetoothStateAsync = ref.watch(bluetoothStreamProvider);
  return bluetoothStateAsync.when(
    data: (state) => state == BluetoothAdapterState.on,
    loading: () => false, // Default to false while loading
    error: (_, __) => false, // Default to false on error
  );
});

