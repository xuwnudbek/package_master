import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_master/services/storage_service.dart';
import 'package:package_master/ui/order/provider/order_provider.dart';
import 'package:package_master/ui/result/result_page.dart';
import 'package:package_master/utils/theme/app_colors.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        return LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    provider.initialize();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: (provider.orders.isEmpty || provider.isLoading) ? 1 : provider.orders.length,
                      itemExtent: (provider.orders.isEmpty || provider.isLoading) ? constraints.maxHeight : null,
                      itemBuilder: (context, index) {
                        if (provider.isLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(AppColors.primary),
                              strokeWidth: 2,
                            ),
                          );
                        }

                        if (provider.orders.isEmpty) {
                          return Center(
                            child: Text('Buyurtmalar topilmadi'),
                          );
                        }

                        final order = provider.orders[index];

                        String status = order['status'] == "tailoring"
                            ? "Tikilmoqda"
                            : order['status'] == "tailored"
                                ? "Tikib bo'lingan"
                                : "Noma'lum";

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ExpansionTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: AppColors.light,
                            collapsedBackgroundColor: AppColors.light,
                            title: Text.rich(
                              TextSpan(
                                text: '#${order['id']}',
                                style: textTheme.titleLarge?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' / ${order['name']}',
                                    style: textTheme.titleMedium?.copyWith(
                                      color: AppColors.dark,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            childrenPadding: EdgeInsets.all(16),
                            expandedAlignment: Alignment.centerLeft,
                            expandedCrossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // model
                              Row(
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: 'Model:',
                                      style: textTheme.bodyMedium,
                                      children: [
                                        TextSpan(
                                          text: ' ${order['order_model']?['model']?['name'] ?? "Unknown"}',
                                          style: textTheme.titleMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              // mato
                              Row(
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: 'Mato:',
                                      style: textTheme.bodyMedium,
                                      children: [
                                        TextSpan(
                                          text: ' ${order['order_model']?['material']?['name'] ?? "Nomalum"}',
                                          style: textTheme.titleMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              // status
                              Row(
                                children: [
                                  Text("Holat: "),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    child: Text(
                                      status,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: AppColors.light,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              // submodellar
                              Row(
                                children: [
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
                                          for (final submodel in order['order_model']?['submodels'] ?? [])
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
                                ],
                              ),
                              SizedBox(height: 8),
                              // o'lchamlar
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
                                    runSpacing: 4,
                                    children: [
                                      for (final size in order['order_model']?['sizes'] ?? [])
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
                              // narx
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      ),
                                      onPressed: () async {
                                        StorageService.write("order_id", order['id']);
                                        Get.to(() => ResultPage());
                                      },
                                      child: Text(
                                        'Natija kiritish',
                                        style: textTheme.titleSmall?.copyWith(
                                          color: AppColors.light,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
