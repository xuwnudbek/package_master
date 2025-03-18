
import 'package:flutter/material.dart';
import 'package:package_master/services/http_service.dart';
import 'package:package_master/services/storage_service.dart';
import 'package:package_master/utils/widgets/custom_snackbars.dart';

class ResultProvider extends ChangeNotifier {
  final TextEditingController packageQuantity = TextEditingController();
  final TextEditingController packageSize = TextEditingController();

  Map<String, dynamic> _order = {};
  Map<String, dynamic> get order => _order;
  set order(value) {
    _order = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  void initialize() async {
    isLoading = true;

    await getPackageOutcomes();

    isLoading = false;
  }

  Future<void> getPackageOutcomes() async {
    int? orderId = StorageService.read("order_id");
    if (orderId == null) return;

    var res = await HttpService.get("${Api.orders}/$orderId");
    if (res['status'] == Result.success) {
      order = res['data'] ?? {};
    }
  }

  Future<void> packageStore(
    BuildContext context,
  ) async {
    if (order.isEmpty) return;

    if (packageQuantity.text.isEmpty || packageSize.text.isEmpty) {
      CustomSnackbars(context).error("Iltimos, barcha maydonlarni to'ldiring");
      return;
    }

    var res = await HttpService.post(Api.packageStore, {
      "order_id": order['id'],
      "package_quantity": packageQuantity.text,
      "package_size": packageSize.text,
    });
    if (res['status'] == Result.success) {
      CustomSnackbars(context).success("Muvaffaqiyatli saqlandi");
      packageQuantity.clear();
      packageSize.clear();

      await getPackageOutcomes();
    } else {
      CustomSnackbars(context).error("Xatolik yuz berdi");
    }
  }
}
