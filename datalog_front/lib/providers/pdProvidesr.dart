import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/service.dart';
import '/DesignModels/pdesign_model.dart';

final pdListProvider = StateNotifierProvider<PDListNotifier, List<Pdesign>>((ref) {
  return PDListNotifier();
});

class PDListNotifier extends StateNotifier<List<Pdesign>> {
  PDListNotifier() : super([]);

  final Service service = Service();

  Future<void> fetchLatestPds() async {
    List<Pdesign> fetchedList = await service.fetchLatestPds();
    state = fetchedList;
  }

  Future<void> addPD(Pdesign newPD) async {
    await service.addPD(newPD);
    await fetchLatestPds();
  }
}
