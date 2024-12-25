import 'package:epsi_shop/article.dart';
import 'package:epsi_shop/page/detail_article_page.dart';
import 'package:epsi_shop/page/liste_article_page.dart';
import 'package:epsi_shop/page/panier_page.dart'; 
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final router = GoRouter(routes: [
    GoRoute(
      path: "/",
      builder: (ctx, state) => const ListeArticlePage(),
      routes: [
        GoRoute(
            path: "/detail",
            builder: (context, state) {
              final article = state.extra as Article;
              return DetailArticlePage(article: article);
          },
        ),
        GoRoute(
          path: "cart",
          builder: (ctx, state) => const CartPage(), 
        ),
      ],
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cart()), 
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
      ),
    );
  }
}
