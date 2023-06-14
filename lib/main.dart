import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tkecom/consts/consts_shelf.dart';
import 'package:tkecom/inner_screens/cat_screen.dart';
import 'package:tkecom/inner_screens/inner_screens_shelf.dart';
import 'package:tkecom/provider/auth_provider.dart';
import 'package:tkecom/provider/cart_provider.dart';
import 'package:tkecom/provider/dark_theme_provider.dart';
import 'package:tkecom/provider/products_provider.dart';
import 'package:tkecom/provider/recently_viewed_provider.dart';
import 'package:tkecom/provider/wishlist_provider.dart';
import 'package:tkecom/screens/btm_bar.dart';
import 'package:tkecom/screens/screens_shelf.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return AuthProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return themeChangeProvider;
        }),
        ChangeNotifierProvider(create: (_) {
          return ProductsProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return CartProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return WishlistProvider();
        }),
        ChangeNotifierProvider(create: (_) {
          return RecentlyViewedProvider();
        })
      ],
      child:
          Consumer<DarkThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'TKEcom',
            theme: Styles.themeData(themeProvider.getDarkTheme, context),
            initialRoute: BottomBarScreen.routeName,
            routes: {
              OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
              BottomBarScreen.routeName: (context) => const BottomBarScreen(),
              FeedsScreen.routeName: (ctx) => const FeedsScreen(),
              ProductDetails.routeName: (ctx) => const ProductDetails(),
              WishlistScreen.routeName: (ctx) => const WishlistScreen(),
              HomeScreen.routeName: (context) => const HomeScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              ViewedRecentlyScreen.routeName: (ctx) =>
                  const ViewedRecentlyScreen(),
              RegisterScreen.routeName: (ctx) => const RegisterScreen(),
              LoginScreen.routeName: (ctx) => const LoginScreen(),
              ForgetPasswordScreen.routeName: (ctx) =>
                  const ForgetPasswordScreen(),
              CategoryScreen.routeName: (context) => const CategoryScreen()
            });
      }),
    );
  }
}
