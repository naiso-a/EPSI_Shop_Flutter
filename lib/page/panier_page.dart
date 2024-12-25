import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:epsi_shop/article.dart';

class Cart extends ChangeNotifier {
  final List<Article> _articles = [];

  void add(Article article) {
    _articles.add(article);
    notifyListeners();
  }

  void remove(Article article) {
    _articles.remove(article);
    notifyListeners();
  }

  List<Article> getAll() {
    return List.unmodifiable(_articles);
  }

  int count() {
    return _articles.length;
  }

  double totalPrice() { 
    final total =_articles.fold(0.0, (sum, item) => sum + item.prix);
    return total * 1.20;
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Votre Panier"),
      ),
      body: cart.getAll().isEmpty
          ? const Center(child: Text("Votre panier est vide."))
          : ListView.builder(
              itemCount: cart.getAll().length,
              itemBuilder: (ctx, index) {
                final article = cart.getAll()[index];
                return ListTile(
                  leading: Image.network(article.image, width: 50),
                  title: Text(article.nom),
                  subtitle: Text('${article.prix.toStringAsFixed(2)} €'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () => context.read<Cart>().remove(article),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Total : ${cart.totalPrice().toStringAsFixed(2)} €',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
