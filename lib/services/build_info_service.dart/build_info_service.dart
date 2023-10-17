import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:native_updater/native_updater.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../utilities/constants/remote_config_keys.dart';
import '../../utilities/extensions/string_extension.dart';
import '../remote_config/remote_config_service.dart';
import 'device_and_app_models.dart';

abstract class BuildInfoService {
  Future<DeviceInfoModel> get deviceInfo;
  Future<AppInfoModel> get appInfo;

  void promptUserToUpdate(BuildContext context);
}

class DeviceAndAppInfoServiceImpl implements BuildInfoService {
  final DeviceInfoPlugin deviceInfoPlugin;

  DeviceAndAppInfoServiceImpl({
    required this.deviceInfoPlugin,
  });

  DeviceInfoModel? _deviceInfo;
  AppInfoModel? _appInfo;

  @override
  Future<AppInfoModel> get appInfo async => _appInfo ??= await _fetchAppInfo();

  @override
  Future<DeviceInfoModel> get deviceInfo async =>
      _deviceInfo ??= await _fetchDeviceInfo();

  @override
  void promptUserToUpdate(BuildContext context) {
    NativeUpdater.displayUpdateAlert(
      context,
      forceUpdate:
          RemoteConfigService.instance.getBool(RemoteKeys.FORCE_APP_UDATE),
    );
  }

  Future<DeviceInfoModel> _fetchDeviceInfo() async {
    DeviceInfoModel deviceInfo;
    if (Platform.isIOS) {
      deviceInfo = await _fetchIosInfo();
    } else if (Platform.isAndroid) {
      deviceInfo = await _fetchAndroidInfo();
    } else {
      deviceInfo = DeviceInfoModel(
          deviceBrand: Platform.operatingSystem,
          deviceModel: Platform.operatingSystemVersion);
    }
    return deviceInfo;
  }

  Future<DeviceInfoModel> _fetchIosInfo() async {
    final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;

    final deviceBrand = iosInfo.name;
    final deviceModel = '${iosInfo.model}/${iosInfo.utsname.machine}';

    return DeviceInfoModel(
      deviceBrand: _limitToMaxLength(deviceBrand),
      deviceModel: _limitToMaxLength(deviceModel),
    );
  }

  Future<DeviceInfoModel> _fetchAndroidInfo() async {
    final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    final deviceBrand = androidInfo.brand;
    final deviceModel = androidInfo.model;

    return DeviceInfoModel(
      deviceBrand: _limitToMaxLength(deviceBrand),
      deviceModel: _limitToMaxLength(deviceModel),
    );
  }

  String _limitToMaxLength(String value) {
    return value.truncate(23);
  }

  Future<AppInfoModel> _fetchAppInfo() async {
    final info = await PackageInfo.fromPlatform();

    return AppInfoModel(
      packageName: info.packageName,
      buildNumber: info.buildNumber,
      versionNumber: info.version,
    );
  }
}
