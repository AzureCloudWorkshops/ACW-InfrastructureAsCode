using Azure.Core;
using Azure.Identity;
using ContactWebEFCore6.Data;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using MyContactManagerData;
using MyContactManagerRepositories;
using MyContactManagerServices;
using Azure.Extensions.AspNetCore.Configuration.Secrets;


var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(connectionString));
var mcmdContext = builder.Configuration.GetConnectionString("MyContactManager");
builder.Services.AddDbContext<MyContactManagerDbContext>(options =>
    options.UseSqlServer(connectionString));
builder.Services.AddDatabaseDeveloperPageExceptionFilter();

//TODO: Add this back in when you have a database connection to perform migrations on startup
//var contextOptions = new DbContextOptionsBuilder<ApplicationDbContext>()
//    .UseSqlServer(connectionString)
//    .Options;
//using (var context = new ApplicationDbContext(contextOptions))
//{
//    context.Database.Migrate();
//}

//var contextOptions2 = new DbContextOptionsBuilder<MyContactManagerDbContext>()
//    .UseSqlServer(mcmdContext)
//    .Options;
//using (var context = new MyContactManagerDbContext(contextOptions2))
//{
//    context.Database.Migrate();
//}

builder.Services.AddDefaultIdentity<IdentityUser>(options => options.SignIn.RequireConfirmedAccount = true)
    .AddRoles<IdentityRole>()
    .AddEntityFrameworkStores<ApplicationDbContext>();
builder.Services.AddControllersWithViews();

builder.Services.AddScoped<IStatesRepository, StatesRepository>();
builder.Services.AddScoped<IStatesService, StatesService>();
builder.Services.AddScoped<IContactsRepository, ContactsRepository>();
builder.Services.AddScoped<IContactsService, ContactsService>();
builder.Services.AddScoped<IUserRolesService, UserRolesService>();
builder.Services.AddApplicationInsightsTelemetry(builder.Configuration["APPINSIGHTS_CONNECTIONSTRING"]);

//just key vault
/*
var keyVaultEndpoint = builder.Configuration["KeyVaultEndpoint"];
if (!string.IsNullOrWhiteSpace(keyVaultEndpoint))
{
    builder.Host.ConfigureAppConfiguration((hostingContext, config) =>
    {
        config.AddAzureKeyVault(new Uri(keyVaultEndpoint), new DefaultAzureCredential());
    });
} 
*/

// Use this section to add Azure App configuration and Key Vault integration
/*
builder.Host.ConfigureAppConfiguration((hostingContext, config) =>
{
    var settings = config.Build();
    var env = settings["Application:Environment"];
    if (env == null || !env.Trim().Equals("develop", StringComparison.OrdinalIgnoreCase))
    {
        var cred = new ManagedIdentityCredential();
        config.AddAzureAppConfiguration(options =>
                options.Connect(new Uri(settings["AzureAppConfigConnection"]), cred)
                            .ConfigureKeyVault(kv => { kv.SetCredential(cred); }));
    }
    else
    {
        var cred = new DefaultAzureCredential();
        config.AddAzureAppConfiguration(options =>
            options.Connect(settings["AzureAppConfigConnection"])
                   .ConfigureKeyVault(kv => kv.SetCredential(cred)));
    }
});
*/

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseMigrationsEndPoint();
}
else
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");
app.MapRazorPages();

app.Run();
