class Personnel {
  int id;
  String matricule;
  String nom;
  String postnom;
  String prenom;
  String genre;
  String date_naissance;
  String telephone;
  String adresse;
  dynamic image_profil; // Can be null
  int user_id;
  int profession_id;
  int is_active;
  DateTime created_at;
  DateTime updated_at;

  Personnel({
    required this.id,
    required this.matricule,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.genre,
    required this.date_naissance,
    required this.telephone,
    required this.adresse,
    this.image_profil,
    required this.user_id,
    required this.profession_id,
    required this.is_active,
    required this.created_at,
    required this.updated_at,
  });

  factory Personnel.fromJson(Map<String, dynamic> json) => Personnel(
    id: json["id"],
    matricule: json["matricule"],
    nom: json["nom"],
    postnom: json["postnom"],
    prenom: json["prenom"],
    genre: json["genre"],
    date_naissance: json["date_naissance"],
    telephone: json["telephone"],
    adresse: json["adresse"],
    image_profil: json["image_profil"],
    user_id: json["user_id"],
    profession_id: json["profession_id"],
    is_active: json["is_active"],
    created_at: DateTime.parse(json["created_at"]),
    updated_at: DateTime.parse(json["updated_at"]),
  );
}