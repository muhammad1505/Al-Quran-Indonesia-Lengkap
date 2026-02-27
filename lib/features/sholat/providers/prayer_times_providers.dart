import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quran_app/features/sholat/data/repositories/mock_prayer_times_repository_impl.dart';
import 'package:quran_app/features/sholat/domain/entities/prayer_times.dart';
import 'package:quran_app/features/sholat/domain/repositories/prayer_times_repository.dart';

part 'prayer_times_providers.g.dart';

// Provider for the repository
@riverpod
PrayerTimesRepository prayerTimesRepository(PrayerTimesRepositoryRef ref) {
  // Return the mock implementation
  return MockPrayerTimesRepositoryImpl();
}

// Provider to get prayer times.
// This will be a family so we can pass parameters in the future.
// For now, the mock implementation ignores them.
@riverpod
Future<PrayerTimes> prayerTimes(PrayerTimesRef ref) {
  final repository = ref.watch(prayerTimesRepositoryProvider);
  // Using mock location for now
  return repository.getPrayerTimes(city: 'London', country: 'UK');
}
