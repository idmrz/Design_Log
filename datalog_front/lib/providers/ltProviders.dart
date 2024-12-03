import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/service.dart';
import '/DesignModels/letter_model.dart';

final ltListProvider = StateNotifierProvider<LTListNotifier, List<Letter>>((ref) {
  return LTListNotifier();
});

class LTListNotifier extends StateNotifier<List<Letter>> {
  LTListNotifier() : super([]);

  final Service service = Service();

  Future<void> fetchLatestLts() async {
    List<Letter> fetchedList = await service.fetchLatestLts();
    state = fetchedList;
  }

  Future<void> addLT(Letter newLT) async {
    await service.addLT(newLT);
    await fetchLatestLts();
  }
}
