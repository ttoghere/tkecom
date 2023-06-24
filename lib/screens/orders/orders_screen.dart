import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tkecom/provider/order_provider.dart';
import 'package:tkecom/provider/products_provider.dart';
import 'package:tkecom/screens/orders/widgets/widgets_shelf.dart';
import 'package:tkecom/services/services_shelf.dart';
import 'package:tkecom/widgets/widgets_shelf.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    // Size size = Utils(context).getScreenSize;
    final ordersProvider = Provider.of<OrderProvider>(context);
    final orders = ordersProvider.orders;

    return FutureBuilder(
      future: ordersProvider.fetchOrders(),
      builder: (context, snapshot) {
        if (orders.isEmpty) {
          return const EmptyScreen(
            title: 'You didnt place any order yet',
            subtitle: 'order something and make me happy :)',
            buttonText: 'Shop now',
            imagePath: 'assets/images/cart.png',
          );
        } else {
          return Scaffold(
              appBar: AppBar(
                leading: const BackWidget(),
                elevation: 0,
                centerTitle: false,
                title: TextWidget(
                  text: 'Your orders (${orders.length})',
                  color: color,
                  textSize: 24.0,
                  isTitle: true,
                ),
                backgroundColor:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
              ),
              body: ListView.separated(
                shrinkWrap: true,
                itemCount: orders.length,
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                    child: ChangeNotifierProvider.value(
                      value: orders[index],
                      child: const OrderWidget(),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: color,
                    thickness: 1,
                  );
                },
              ));
        }
      },
    );
  }
}
