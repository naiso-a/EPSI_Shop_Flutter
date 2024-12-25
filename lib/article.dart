class Article {
  String nom;
  String description;
  num prix;
  String image;
  String categorie;
  Article({
    required this.nom,
    required this.description,
    required this.prix,
    required this.image,
    required this.categorie,
  });
  String prixEuro()=> "$prix€";
}