import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gazachat/core/helpers/logger_debug.dart';
import 'package:gazachat/core/theming/styles.dart';
import 'package:gazachat/core/widgets/feature_unavailable_dialog.dart';
import 'package:gazachat/core/widgets/loading_animation.dart';
import 'package:location/location.dart';

class AttachmentOptions extends StatefulWidget {
  const AttachmentOptions({super.key, this.onLocationSelected});
  final Function(LocationData)? onLocationSelected;

  @override
  State<AttachmentOptions> createState() => _AttachmentOptionsState();
}

class _AttachmentOptionsState extends State<AttachmentOptions> {
  LocationData? _location;
  bool _isLoading = false;

  void _getLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Location location = Location();

      bool serviceEnabled;
      PermissionStatus permissionGranted;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          setState(() {
            _isLoading = false;
          });
          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location service is disabled')),
            );
          }
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          setState(() {
            _isLoading = false;
          });
          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permission denied')),
            );
          }
          return;
        }
      }

      _location = await location.getLocation();

      // Call the callback if provided
      widget.onLocationSelected?.call(_location!);

      // Close the bottom sheet and return the location data
      if (mounted) {
        Navigator.pop(context, _location);
      }
    } catch (e) {
      LoggerDebug.logger.e('Error getting location: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to get location')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          // Options
          ListTile(
            leading: const Icon(Icons.photo, color: Colors.white),
            title: Text(
              context.tr("photo"),
              style: CustomTextStyles.font16WhiteRegular,
            ),
            onTap: () {
              FeatureUnavailableDialog.show(
                context,
                title: context.tr(
                  "feature_unavailable_send_image_message_title",
                ),
                description: context.tr(
                  "feature_unavailable_send_image_message_description",
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.videocam, color: Colors.white),
            title: Text(
              context.tr("video"),
              style: CustomTextStyles.font16WhiteRegular,
            ),
            onTap: () {
              FeatureUnavailableDialog.show(
                context,
                title: context.tr(
                  "feature_unavailable_send_video_message_title",
                ),
                description: context.tr(
                  "feature_unavailable_send_video_message_description",
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_file, color: Colors.white),
            title: Text(
              context.tr("file"),
              style: CustomTextStyles.font16WhiteRegular,
            ),
            onTap: () {
              FeatureUnavailableDialog.show(
                context,
                title: context.tr(
                  "feature_unavailable_send_file_message_title",
                ),
                description: context.tr(
                  "feature_unavailable_send_file_message_description",
                ),
              );
            },
          ),
          ListTile(
            enabled: !_isLoading, // Disable tile when loading
            leading: _isLoading
                ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: const CustomLoadingAnimation(size: 30),
                  )
                : const Icon(Icons.location_on, color: Colors.white),
            title: Text(
              _isLoading
                  ? context.tr("getting_location")
                  : context.tr("location"),
              style: CustomTextStyles.font16WhiteRegular.copyWith(
                color: _isLoading
                    ? Colors.white.withOpacity(0.7)
                    : Colors.white,
              ),
            ),
            onTap: _isLoading ? null : _getLocation,
          ),
        ],
      ),
    );
  }
}
