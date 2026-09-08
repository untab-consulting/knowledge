var builder = WebApplication.CreateBuilder(args);

builder.Services.AddHealthChecks();
builder.Services.AddEndpointsApiExplorer();

var app = builder.Build();

app.MapHealthChecks("/health");

app.MapGet("/api/v1", () => Results.Ok(new
{
    name = "Knowledge API",
    version = "v1",
    status = "ok"
}));

app.Run();
