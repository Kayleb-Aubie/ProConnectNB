using backend.Services;
using Microsoft.AspNetCore.Mvc;

namespace backend.Controllers;

[ApiController] // Indique que cette classe est un controller d'API
[Route("api/users")] // l'URL de base pour ce controller

//class qui gere les endpoints relatifs aux utilisateurs
public class UserController(UserService service) : ControllerBase { // Injection de dependance (en constructeur) du service layer (addScoped non-necessaire car cest un controller)
    private readonly UserService _service = service; // assignement d'injection de dependance du service layer

    [HttpGet("{id}")] // api/users/1 (associer avec GetUser) (Donc le retour de cette methode sera pour les requetes GET a cette URL)
    public async Task<IActionResult> GetUser(int id) { // id vien de l'URL (endpoint handler)

        var user = await _service.GetUserById(id); // Appel au service layer pour obtenir l'utilisateur (besoin de await pour les methodes async)

        if (user == null) 
        {
            return NotFound($"Aucun utilisateur trouver avec l'ID {id}"); // Retourne un code 404 (utilisateur non trouve) // Affiche dans la console sur le navigateur
        }

        return Ok(user); // Retourne un code 200 (tout a fonctionner) avec l'utilisateur en format JSON
    }
    
    [HttpGet("test")] // api/users/test
    public async Task<IActionResult> GetTest() 
    {
        var message = await _service.GetTestMessage();

        return Ok(message);
    }

}