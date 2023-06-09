import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tkecom/models/products_model.dart';
import 'package:tkecom/provider/products_provider.dart';
import 'package:tkecom/services/services_shelf.dart';
import 'package:tkecom/widgets/widgets_shelf.dart';

class OnSaleScreen extends StatelessWidget {
  static const routeName = "/OnSaleScreen";
  const OnSaleScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    ProductsProvider productProviders = context.read<ProductsProvider>();
    List<ProductModel> onSaleProducts = productProviders.getOnSaleProducts;
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: 'Products on sale',
          color: color,
          textSize: 24.0,
          isTitle: true,
        ),
      ),
      body: onSaleProducts.isEmpty
          ? EmptyProductsListWidget(
              color: color,
              text: 'No products on sale yet!,\nStay tuned',
            )
          : GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              // crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height * 0.50),
              children: List.generate(onSaleProducts.length, (index) {
                return ChangeNotifierProvider.value(
                    value: onSaleProducts[index], child: const OnSaleWidget());
              }),
            ),
    );
  }
}

class EmptyProductsListWidget extends StatelessWidget {
  const EmptyProductsListWidget({
    super.key,
    required this.color,
    required this.text,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Image.asset(
                'assets/images/box.png',
              ),
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: color, fontSize: 30, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
