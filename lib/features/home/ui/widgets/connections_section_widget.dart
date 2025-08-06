import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gazachat/core/shared/providers/bluetooth_state_provider.dart';
import 'package:gazachat/core/shared/providers/managing_bluetooth_state_privder.dart';
import 'package:gazachat/core/theming/colors.dart';
import 'package:gazachat/core/theming/styles.dart';
import 'package:gazachat/features/home/providrs/user_data_provider.dart';

class ConnectionsSectionWidget extends ConsumerStatefulWidget {
  const ConnectionsSectionWidget({super.key});

  @override
  ConsumerState<ConnectionsSectionWidget> createState() =>
      _ConnectionsSectionWidgetState();
}

class _ConnectionsSectionWidgetState
    extends ConsumerState<ConnectionsSectionWidget> {
  bool _hasStartedDiscovery = false;
  bool _isExpanded = false;
  final int _maxVisibleDevices = 3; // Show only 3 devices initially

  @override
  void initState() {
    super.initState();
    // Start discovery only once when widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startDiscoveryIfNeeded();
    });
  }

  void _startDiscoveryIfNeeded() {
    final bluetoothState = ref.read(nearbayStateProvider);
    final isBluetoothOn = ref.read(isBluetoothOnProvider);

    // Only start discovery if bluetooth is on and discovery hasn't started yet
    if (isBluetoothOn &&
        !bluetoothState.isDiscovering &&
        !_hasStartedDiscovery) {
      ref.read(nearbayStateProvider.notifier).startDiscovery();
      _hasStartedDiscovery = true;
    }
  }

  // get username user by uuid from user data provider
  String? _getUsernameByUuid(String uuid2P) {
    final userData = ref.read(userDataProvider.notifier);
    final username = userData.getChatByUuid(uuid2P);
    if (username == null) return null;
    return username.username2P;
  }

  Widget _buildDeviceItem(dynamic device, bool isConnected) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ColorsManager.customGray.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isConnected
              ? ColorsManager.customGreen.withOpacity(0.3)
              : ColorsManager.mainColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isConnected
                  ? ColorsManager.customGreen
                  : ColorsManager.customOrange,
            ),
          ),
          SizedBox(width: 8.w),

          // Device name/username - flexible to take available space
          Expanded(
            child: Text(
              _getUsernameByUuid(device.uuid) ?? device.id,
              style: CustomTextStyles.font12WhiteRegular.copyWith(
                fontSize: 11.sp,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),

          // Connect button only if not connected
          if (!isConnected) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () {
                ref
                    .read(nearbayStateProvider.notifier)
                    .connectToDevice(device.id, device.uuid);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: ColorsManager.mainColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  context.tr("connect"),
                  style: CustomTextStyles.font12WhiteRegular.copyWith(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDevicesList(
    List<dynamic> discoveredDevices,
    List<dynamic> connectedDevices,
  ) {
    if (discoveredDevices.isEmpty) return const SizedBox.shrink();

    // Determine which devices to show
    List<dynamic> devicesToShow = _isExpanded
        ? discoveredDevices
        : discoveredDevices.take(_maxVisibleDevices).toList();

    return Column(
      children: [
        SizedBox(height: 8.h),
        Container(height: 1, color: ColorsManager.grayColor.withOpacity(0.3)),
        SizedBox(height: 8.h),

        // Devices list with constrained height when not expanded
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: _isExpanded
                ? double.infinity
                : 200.h, // Limit height when collapsed
          ),
          child: SingleChildScrollView(
            physics: _isExpanded
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            child: Column(
              children: devicesToShow.map((device) {
                final isConnected = connectedDevices.any(
                  (conn) => conn.id == device.id,
                );
                return _buildDeviceItem(device, isConnected);
              }).toList(),
            ),
          ),
        ),

        // Show expand/collapse button if there are more devices
        if (discoveredDevices.length > _maxVisibleDevices) ...[
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: ColorsManager.mainColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: ColorsManager.mainColor.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isExpanded
                        ? context.tr("show_less")
                        : "${context.tr("show_more")} (${discoveredDevices.length - _maxVisibleDevices})",
                    style: CustomTextStyles.font12WhiteRegular.copyWith(
                      fontSize: 10.sp,
                      color: ColorsManager.mainColor,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: ColorsManager.mainColor,
                    size: 16.w,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isBluetoothOn = ref.watch(isBluetoothOnProvider);
    final bluetoothState = ref.watch(nearbayStateProvider);

    // Check if bluetooth state changed and start discovery if needed
    ref.listen(isBluetoothOnProvider, (previous, next) {
      if (next && !bluetoothState.isDiscovering && !_hasStartedDiscovery) {
        _startDiscoveryIfNeeded();
      } else if (!next && _hasStartedDiscovery) {
        // Stop discovery if bluetooth is turned off
        ref.read(nearbayStateProvider.notifier).stopDiscovery();
        _hasStartedDiscovery = false;
        // Reset expansion state when bluetooth is turned off
        setState(() {
          _isExpanded = false;
        });
      }
    });

    // Access discovered devices
    final discoveredDevices = bluetoothState.discoveredDevices;
    final connectedDevices = bluetoothState.connectedDevices;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: ColorsManager.customGray.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: ColorsManager.mainColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header row with connection info
              Row(
                children: [
                  Icon(
                    isBluetoothOn
                        ? Icons.bluetooth_connected_rounded
                        : Icons.bluetooth_disabled_rounded,
                    color: isBluetoothOn
                        ? ColorsManager.mainColor
                        : ColorsManager.grayColor,
                    size: 20.w,
                  ),
                  SizedBox(width: 12.w),

                  // Connection info - flexible to take available space
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr("list_of_connection").trim(),
                          style: CustomTextStyles.font16WhiteRegular.copyWith(
                            fontSize: 14.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${context.tr("discovered")}: ${discoveredDevices.length} | ${context.tr("connected")}: ${connectedDevices.length}',
                          style: CustomTextStyles.font14GrayRegular.copyWith(
                            fontSize: 12.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Connect all button - only show if space allows and there are devices
                  if (discoveredDevices.isNotEmpty &&
                      isBluetoothOn &&
                      constraints.maxWidth > 300.w) ...[
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(nearbayStateProvider.notifier)
                            .connectToAllDiscoveredDevices();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorsManager.mainColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          context.tr("connect_all"),
                          style: CustomTextStyles.font12WhiteRegular.copyWith(
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ),
                  ],

                  SizedBox(width: 8.w),

                  // Connected count badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isBluetoothOn
                              ? ColorsManager.mainColor
                              : ColorsManager.grayColor,
                          isBluetoothOn
                              ? ColorsManager.mainColor.withOpacity(0.8)
                              : ColorsManager.grayColor.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: isBluetoothOn
                              ? ColorsManager.mainColor.withOpacity(0.3)
                              : ColorsManager.grayColor.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      connectedDevices.length.toString(),
                      style: CustomTextStyles.font16WhiteRegular.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),

              // Devices list
              _buildDevicesList(discoveredDevices, connectedDevices),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Stop discovery when widget is disposed
    if (_hasStartedDiscovery) {
      ref.read(nearbayStateProvider.notifier).stopDiscovery();
    }
    super.dispose();
  }
}
