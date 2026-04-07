import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class HealthService {
  static final HealthService _instance = HealthService._internal();
  factory HealthService() => _instance;
  HealthService._internal();

  final Health _health = Health();

  final List<HealthDataType> _dataTypes = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.HEART_RATE,
    HealthDataType.SLEEP_SESSION,
  ];

  /// Initialize and request health tracking permissions
  Future<bool> initializeAndRequestPermissions() async {
    try {
      // On Android, we should manually request the ACTIVITY_RECOGNITION permission 
      // if we want to seamlessly track steps locally alongside Health Connect sometimes.
      if (Platform.isAndroid) {
        await Permission.activityRecognition.request();
      }

      // Explicitly removed _health.configure(); here, as it MUST be mapped before runApp in Android 14 natively.
      
      // Request API permissions explicitly
      bool hasPermissions = await _health.hasPermissions(_dataTypes) ?? false;
      if (!hasPermissions) {
        bool authorized = await _health.requestAuthorization(_dataTypes);
        return authorized;
      }
      return true;
    } catch (e) {
      print("Health authorization error deeply: $e");
      // Fallback: throw the error forward so the UI can display exact Exception (e.g. SDK constraint, missing App).
      throw Exception(e.toString());
    }
  }

  /// Get today's totally accumulated step count
  Future<int> getTodaySteps() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    try {
      int? steps = await _health.getTotalStepsInInterval(startOfDay, now);
      return steps ?? 0;
    } catch (e) {
      print("Failed getting steps: $e");
      return 0;
    }
  }

  /// Get today's total active calories burned (kcal)
  Future<double> getTodayActiveCalories() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    try {
      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
          types: [HealthDataType.ACTIVE_ENERGY_BURNED], startTime: startOfDay, endTime: now);
      
      double totalCalories = 0.0;
      for (var point in data) {
        final val = point.value;
        if (val is NumericHealthValue) {
          totalCalories += val.numericValue.toDouble();
        }
      }
      return totalCalories;
    } catch (e) {
      print("Failed getting calories: $e");
      return 0.0;
    }
  }

  /// Get today's latest recorded heart rate (BPM)
  Future<int> getLatestHeartRate() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    try {
      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
          types: [HealthDataType.HEART_RATE], startTime: startOfDay, endTime: now);
      
      if (data.isEmpty) return 0;
      
      // Sort to get the most recent point
      data.sort((a, b) => b.dateTo.compareTo(a.dateTo));
      final val = data.first.value;
      if (val is NumericHealthValue) {
        return val.numericValue.toInt();
      }
      return 0;
    } catch (e) {
      print("Failed getting HR: $e");
      return 0;
    }
  }

  /// Get sleep duration for last night (hours)
  Future<String> getSleepDuration() async {
    final now = DateTime.now();
    // Start from yesterday evening to catch sleep
    final start = now.subtract(const Duration(hours: 24));
    try {
      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
          types: [HealthDataType.SLEEP_SESSION], startTime: start, endTime: now);
      
      if (data.isEmpty) return "0.0h";

      double totalSleepMins = 0;
      for (var point in data) {
         // Sleep data might come as minutes directly or we calculate diff
         final duration = point.dateTo.difference(point.dateFrom).inMinutes;
         if (duration > 0) {
            totalSleepMins += duration;
         }
      }
      
      double hours = totalSleepMins / 60.0;
      return "${hours.toStringAsFixed(1)}h";
    } catch (e) {
      print("Failed getting sleep: $e");
      return "0.0h";
    }
  }
}
