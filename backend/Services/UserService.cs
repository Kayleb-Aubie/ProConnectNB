using Dapper;
using Npgsql;
using backend.Models;

namespace backend.Services;

public class UserService(IConfiguration config) { // Injection de dependance (en constructeur) de la configuration a partir du Program.cs (addScoped necessaire car se nest pas un controller)
    private readonly IConfiguration _config = config; // assignment de la configuration

    public async Task<User?> GetUserById(int id) 
    {
        using NpgsqlConnection conn = new NpgsqlConnection(_config.GetConnectionString("DefaultConnection")); // Creation de la connexion a la base de donnees (Npgsql pour PostgreSQL) avec la connection string du appsettings.json

        // Nous allons utiliser Dapper pour executer des requetes SQL de maniere simple et efficace
        var sql = "SELECT id, prenom FROM users WHERE id = @id"; // Requete SQL pour obtenir un utilisateur par son ID

        // Async car operation de base de donnees (I/O bound) qui peut prendre du temps
        return await conn.QueryFirstOrDefaultAsync<User>(sql, new { id }); // Dapper mappe automatiquement les colonnes SQL aux proprietes C# (par nom) ceci retourne un User avec ses proprietes remplies
    }

    public async Task<string> GetTestMessage() 
    {
        return "Test reussi";
    }

}