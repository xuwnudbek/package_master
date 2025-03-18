import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:package_master/services/http_service.dart';
import 'package:package_master/services/storage_service.dart';
import 'package:package_master/utils/widgets/custom_snackbars.dart';

class AuthProvider extends ChangeNotifier {
  var loginController = TextEditingController();
  var passwordController = TextEditingController();

  bool isLoading = false;

  Future<bool> authLogin(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    var res = await HttpService.post(Api.login, {
      'username': loginController.text,
      'password': passwordController.text,
    });

    inspect(res);

    if (res['status'] == Result.success) {
      if (res['data']?['user']?['role']?['name'] != "packageMaster") {
        CustomSnackbars(context).warning("Bu dastur faqat \"Sifat Nazorati Master\" uchun!");
        isLoading = false;
        notifyListeners();
        return false;
      }

      await StorageService.write('token', res['data']['token']);
      await StorageService.write('user', res['data']['user']);

      CustomSnackbars(context).success('Sifat nazoratiga xush kelibsiz!');

      isLoading = false;
      notifyListeners();

      return true;
    } else {
      CustomSnackbars(context).error('Login yoki parol noto\'g\'ri!');

      isLoading = false;
      notifyListeners();

      return false;
    }
  }
}
