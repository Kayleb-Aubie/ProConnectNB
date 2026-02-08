using backend.Services;

var builder = WebApplication.CreateBuilder(args); // Configuration et services DI (Dependency Injection), variable environnement etc..

builder.Services.AddControllers(); // Ajout des controllers automatique (API endpoints) (UserController.cs)
//(Scoped = une instance par requete http)
builder.Services.AddScoped<UserService>(); // Enregistrement du service UserService pour l'injection de dependance car se nest pas un controller donc pas fait automatique par le framework (Mais on lutilise pas car on a pas azure payant)

WebApplication app = builder.Build(); // Construction de l'application (apres avoir configurer les services et le builder)

// TODO: Enlever les commentaires si on veut utiliser l'API Key
// Middleware pour la gestion de l'API Key (regarder si on a la bonne clef dans les headers)
/*
app.Use(async (context, next) =>
{
    var config = context.RequestServices.GetRequiredService<IConfiguration>();
    var apiKey = config["ApiKey"];

    if (!context.Request.Headers.TryGetValue("x-api-key", out var providedKey))
    {
        context.Response.StatusCode = 401;
        await context.Response.WriteAsync("Missing API Key");
        return;
    }

    if (providedKey != apiKey)
    {
        context.Response.StatusCode = 403;
        await context.Response.WriteAsync("Invalid API Key");
        return;
    }

    await next();
});
*/

app.MapControllers(); // Mappe les controllers (endpoints) pour l'application

app.UseDeveloperExceptionPage(); // Page d'exception detaillee pour le developpement (affiche les erreurs dans le navigateur)

app.Run(); // Demarre l'application et ecoute les requetes HTTP entrantes (roulement continu)