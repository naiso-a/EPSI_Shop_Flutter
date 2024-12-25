import 'dart:convert';
import 'package:epsi_shop/article.dart';
import 'package:epsi_shop/page/panier_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class ListeArticlePage extends StatelessWidget {
  const ListeArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('EPSI Shop'),
        actions: [
          IconButton(
            onPressed: () => context.go("/cart"),
            icon: Badge(
              label: Text(context.watch<Cart>().getAll().length.toString()),
              child: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Article>>(
        future: fetchListArticle(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data != null) {
            return ListArticles(listArticles: snapshot.data!);
          } else {
            return const Center(child: Text("Aucun article disponible"));
          }
        },
      ),
    );
  }

  Future<List<Article>> fetchListArticle() async {
    final url = Uri.parse("https://fakestoreapi.com/products");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => Article(
                  nom: item["title"],
                  description: item["description"],
                  prix: item["price"],
                  image: item["image"],
                  categorie: item["category"],
                ))
            .toList();
      } else {
        throw Exception("Erreur de chargement des articles");
      }
    } catch (e) {
      throw Exception("Erreur réseau: $e");
    }
  }
}

class ListArticles extends StatelessWidget {
  final List<Article> listArticles;

  const ListArticles({
    super.key,
    required this.listArticles,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listArticles.length,
      itemBuilder: (ctx, index) {
        final article = listArticles[index];
        return ListTile(
          onTap: () => ctx.go("/detail", extra: listArticles[index]),
          leading: Image.network(
            article.image,
            height: 80,
            width: 80,
            fit: BoxFit.cover,
          ),
          title: Text(article.nom),
          subtitle: Text(article.prixEuro()),
          trailing: IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () {
              context.read<Cart>().add(article);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Article ajouté au panier !")),
              );
            },
          ),
        );
      },
    );
  }
}
