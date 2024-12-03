import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/service.dart';
import '/DesignModels/wd_model.dart';

final wdListProvider = StateNotifierProvider<WDListNotifier, List<WD>>((ref) {
  return WDListNotifier();
});

class WDListNotifier extends StateNotifier<List<WD>> {
  WDListNotifier() : super([]);

  final Service service = Service();

  Future<void> fetchLatestWds() async {
    List<WD> fetchedList = await service.fetchLatestWds();
    state = fetchedList;
  }

  Future<void> addWD(WD newWD) async {
    await service.addWD(newWD);
    await fetchLatestWds();
  }
}
