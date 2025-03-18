import 'package:flutter/material.dart';
import 'package:package_master/services/http_service.dart';

enum OrderStatus { tailoring, tailored }

class OrderProvider extends ChangeNotifier {
  OrderStatus _orderStatus = OrderStatus.tailoring;
  OrderStatus get orderStatus => _orderStatus;
  set orderStatus(OrderStatus value) {
    _orderStatus = value;
    notifyListeners();
  }

  List _orders = [];
  List get orders => _orders;
  set orders(List value) {
    _orders = value;
    notifyListeners();
  }

  List _groups = [];
  List get groups => _groups;
  set groups(List value) {
    _groups = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  OrderProvider();

  void initialize() async {
    isLoading = true;

    await getOrders();
    // await getGroups();

    isLoading = false;
  }

  Future<void> getOrders() async {
    var res = await HttpService.get(Api.orders);
    if (res['status'] == Result.success) {
      orders = res['data'] ?? [];
    }
  }

}
