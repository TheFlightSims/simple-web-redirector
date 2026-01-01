# Contributing

## Environment requirements

### Git repo

To clone the repo, run, use this command

```bash
git clone https://github.com/TheFlightSims/simple-web-redirector.git
```

### Build with Visual Studio (only for Windows)

To contribute, you may need Visual Studio 2026. Required Visual Studio 2026 SDKs:

* ASP.NET and web development (with .NET 10.0 WebAssembly Build Tools)
* .NET 10.0 Runtime (LTS)

### SQL Server

It is recommended to use SQL Server 2022+ (version 16 and later) or the default SQL Server Express LocalDB. **DO NOT** use pre-release versions.

Try to run the script in `.sql/schema.sql` to restore the schema. Once done, edit the `appsettings.json` to add the SQL server connection. to debug the application or investigate for SQL queries.

> :warning:
>
> DO NOT commit the `./appsettings.json` with your environment configuration still leave in there.

## Build from source

You can open the `WebRedirector.sln` to open the project in Visual Studio
