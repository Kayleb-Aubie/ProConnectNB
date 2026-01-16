namespace backend.Models;

// Classe representant un utilisateur (resemblant la table users dans la base de donnees) pour que dapper puisse faire le mapping
public class User {
    public int Id { get; set; }
    public required string Prenom { get; set; } 
}