import 'package:flutter/material.dart';
import 'package:package_master/ui/result/provider/result_provider.dart';
import 'package:package_master/utils/extensions/datetime_extension.dart';
import 'package:package_master/utils/theme/app_colors.dart';
import 'package:package_master/utils/widgets/custom_input.dart';
import 'package:provider/provider.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ChangeNotifierProvider<ResultProvider>(
      create: (context) => ResultProvider()..initialize(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Natija kiritish'),
          ),
          body: LayoutBuilder(builder: (context, constraints) {
            return Consumer<ResultProvider>(
              builder: (context, provider, _) {
                return RefreshIndicator(
                  onRefresh: () async {
                    provider.initialize();
                  },
                  child: ListView(
                    children: [
                      provider.isLoading
                          ? SizedBox(
                              height: constraints.maxHeight,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : provider.order.isEmpty
                              ? SizedBox(
                                  height: constraints.maxHeight,
                                  child: Center(
                                    child: Text("Buyurtma haqida malumot topilmadi"),
                                  ),
                                )
                              : Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.light,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${provider.order['name']}',
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              text: 'Submodellar:',
                                              style: textTheme.bodyMedium,
                                            ),
                                          ),
                                          Wrap(
                                            spacing: 4,
                                            runSpacing: 4,
                                            children: [
                                              for (final submodel in provider.order['order_model']?['submodels'] ?? [])
                                                Chip(
                                                  padding: EdgeInsets.all(2),
                                                  backgroundColor: AppColors.primary,
                                                  label: Text(
                                                    submodel?['submodel']?['name'] ?? 'Unknown',
                                                    style: textTheme.bodyMedium?.copyWith(
                                                      color: AppColors.light,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              text: 'O\'lchamlar:',
                                              style: textTheme.bodyMedium,
                                            ),
                                          ),
                                          Wrap(
                                            spacing: 4,
                                            children: [
                                              for (final size in provider.order['order_model']?['sizes'] ?? [])
                                                Chip(
                                                  padding: EdgeInsets.all(2),
                                                  backgroundColor: AppColors.primary,
                                                  label: Text(
                                                    size['size']?['name'] ?? 'Unknown',
                                                    style: textTheme.bodyMedium?.copyWith(
                                                      color: AppColors.light,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              text: 'Natijalarni kiritish:',
                                              style: textTheme.bodyMedium,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            spacing: 8,
                                            children: [
                                              Expanded(
                                                child: CustomInput(
                                                  controller: provider.packageQuantity,
                                                  hint: "Miqdori",
                                                ),
                                              ),
                                              Expanded(
                                                child: CustomInput(
                                                  controller: provider.packageSize,
                                                  hint: "Sig'imi",
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          TextButton(
                                            onPressed: () async {
                                              await provider.packageStore(context);
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("Natijani kiritish"),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                      SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(8),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: ((provider.order['package_outcomes'] ?? []) as List).length,
                        itemBuilder: (context, index) {
                          final package = provider.order['package_outcomes'][index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              tileColor: AppColors.light,
                              dense: true,
                              title: Text.rich(
                                TextSpan(children: [
                                  TextSpan(
                                    text: "${package['package_quantity'] ?? 0}",
                                  ),
                                  TextSpan(text: " x ", style: textTheme.bodyMedium),
                                  TextSpan(
                                    text: "${package['package_size'] ?? 0}",
                                  ),
                                  TextSpan(text: " = ", style: textTheme.bodyMedium),
                                  TextSpan(
                                    text: "${package['package_quantity'] * package['package_size']} ta",
                                  ),
                                ]),
                                style: textTheme.bodyMedium,
                              ),
                              subtitle: Text(
                                DateTime.parse(package['created_at'] ?? "").toLocal().toYMDHS,
                                style: textTheme.bodyMedium,
                              ),
                              trailing: Icon(Icons.check_circle, color: AppColors.primary),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        );
      },
    );
  }
}
