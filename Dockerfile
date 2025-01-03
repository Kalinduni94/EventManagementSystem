# Use the official .NET 8.0 SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory in the container
WORKDIR /src

# Copy the project file and restore dependencies
COPY ["EventManagement/EventManagement.csproj", "EventManagement/"]
RUN dotnet restore "EventManagement/EventManagement.csproj"

# Copy the rest of the application and build
COPY . .
WORKDIR "/src/EventManagement"
RUN dotnet build "EventManagement.csproj" -c Release -o /app/build

# Publish the application
RUN dotnet publish "EventManagement.csproj" -c Release -o /app/publish

# Use the official .NET 8.0 ASP.NET runtime image for the final container
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

# Expose the port the application runs on
EXPOSE 80

# Define the entry point for the container
ENTRYPOINT ["dotnet", "EventManagement.dll"]
