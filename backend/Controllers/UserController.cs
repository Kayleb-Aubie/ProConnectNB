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

        return Ok(user); // Retourne un code 200 (tout a fonctionner) avec l'utilisateur en format JSON
    }


}