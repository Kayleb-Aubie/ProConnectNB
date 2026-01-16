using backend.Services;

var builder = WebApplication.CreateBuilder(args); // Configuration et services DI (Dependency Injection), variable environnement etc..

builder.Services.AddControllers(); // Ajout des controllers automatique (API endpoints) (UserController.cs)
//(Scoped = une instance par requete http)
builder.Services.AddScoped<UserService>(); // Enregistrement du service UserService pour l'injection de dependance car se nest pas un controller donc pas fait automatique par le framework

builder.Logging.ClearProviders(); // Nettoyage des providers de logging par defaut
builder.Logging.AddConsole(); // Ajout du provider de logging pour la console

WebApplication app = builder.Build(); // Construction de l'application (apres avoir configurer les services et le builder)

app.MapControllers(); // Mappe les controllers (endpoints) pour l'application

app.UseDeveloperExceptionPage(); // Page d'exception detaillee pour le developpement (affiche les erreurs dans le navigateur)

app.Run(); // Demarre l'application et ecoute les requetes HTTP entrantes (roulement continu)