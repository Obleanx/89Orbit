import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'api_config.dart';

class SupabaseService {
  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: APIConfig.supabaseUrl,
        anonKey: APIConfig.supabaseAnonKey,
      );
      if (kDebugMode) print("Supabase initialized successfully");
    } catch (e) {
      if (kDebugMode) print("Error initializing Supabase: $e");
      rethrow;
    }
  }
}
