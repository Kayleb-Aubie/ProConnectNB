using Dapper;
using Npgsql;
using backend.Models;

namespace backend.Services;

public class UserService(IConfiguration config) { // Injection de dependance (en constructeur) de la configuration a partir du Program.cs (addScoped necessaire car se nest pas un controller)
    private readonly IConfiguration _config = config; // assignment de la configuration

    public async Task<User?> GetUserById(int id)
    {
        try
        {
            var connectionString = _config.GetConnectionString("DefaultConnection"); // Obtention de la chaine de connexion a la base de donnees

            using NpgsqlConnection conn = new NpgsqlConnection(connectionString); // Creation de la connexion a la base de donnees

            await conn.OpenAsync(); // Force l'ouverture pour détecter les erreurs de connexion

            var rows = await conn.QueryAsync("SELECT id, prenom FROM users");
            foreach (var row in rows)
            {
                Console.WriteLine($"ROW: {row.id} - {row.prenom}");
            }

            var sql = "SELECT id, prenom FROM users WHERE id = @id"; // Requete SQL pour obtenir l'utilisateur par ID
            var user = await conn.QueryFirstOrDefaultAsync<User>(sql, new { id }); // Execution de la requete avec Dapper

            if (user == null)
            {
                Console.WriteLine($"Aucun utilisateur trouvé avec l'ID {id}");
            }
            else
            {
                Console.WriteLine($"Utilisateur trouvé: {user.Prenom} (ID: {user.Id})");
            }

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
        return "Test reussi";
    }

}