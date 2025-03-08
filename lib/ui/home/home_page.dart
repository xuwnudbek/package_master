import 'package:flutter/material.dart';
import 'package:package_master/ui/order/provider/order_provider.dart';
import 'package:package_master/utils/widgets/app/custom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:package_master/ui/home/provider/home_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (context) => OrderProvider()..initialize(),
        ),
      ],
      child: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          final Map page = provider.menu[provider.selectedIndex];

          return Scaffold(
            appBar: AppBar(
              title: Text(
                '${page['title']}',
              ),
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(Icons.logout_rounded),
                  onPressed: () async {
                    await provider.logout(context);
                  },
                ),
              ],
            ),
            body: page['page'],
            bottomNavigationBar: CustomNavbar(),
          );
        },
      ),
    );
  }
}
