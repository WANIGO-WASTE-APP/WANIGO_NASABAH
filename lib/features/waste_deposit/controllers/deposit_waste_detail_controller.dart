import 'package:get/get.dart';
import 'package:wanigo_nasabah/data/models/waste_catalog_model.dart';
import 'package:wanigo_nasabah/data/repositories/auth_repository.dart';

class DepositWasteDetailController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final int itemId;
  final RxBool isLoading = true.obs;
  final Rx<WasteCatalogItem?> itemDetail = Rx<WasteCatalogItem?>(null);

  DepositWasteDetailController({required this.itemId});

  @override
  void onInit() {
    super.onInit();
    fetchItemDetail();
  }

  Future<void> fetchItemDetail() async {
    try {
      isLoading.value = true;
      final result = await _authRepository.getWasteCatalogDetail(itemId);
      if (result != null) {
        itemDetail.value = result;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
