using Dapper;
using Npgsql;
using backend.Models;
using Microsoft.VisualBasic;

namespace backend.Services;

public class UserService(IConfiguration config) // Injection de dependance (en constructeur) de la configuration a partir du Program.cs (addScoped necessaire car se nest pas un controller)
{
    private readonly IConfiguration _config = config; // assignment de la configuration

    public async Task<User?> GetUserById(int id) // Methode pour obtenir un utilisateur par son ID
    {
        try
        {
            var connectionString = _config.GetConnectionString("DefaultConnection"); // Obtention de la chaine de connexion a la base de donnees

            using NpgsqlConnection conn = new NpgsqlConnection(connectionString); // Creation de la connexion a la base de donnees

            await conn.OpenAsync(); // Force l'ouverture pour détecter les erreurs de connexion

            var sql = "SELECT id AS Id, prenom AS Prenom FROM users WHERE id = @id"; // Requete SQL pour obtenir l'utilisateur par ID
            var user = await conn.QueryFirstOrDefaultAsync<User>(sql, new { id }); // Execution de la requete avec Dapper

            return user;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Erreur lors de l'obtention de l'utilisateur: {ex.Message}");
            return null;
        }
    }

    public async Task<string> GetTestMessage()
    {
        String? conn = Environment.GetEnvironmentVariable("DefaultConnection");

        if (conn == null)
            return "NUlllll";
        else
            return conn;
    }

}