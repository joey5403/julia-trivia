<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Julia Trivia Game - Copilot Instructions

This is a Julia project for a terminal-based trivia game that uses the OpenTDB (Open Trivia Database) API.

## Project Structure
- `src/JuliaTrivia.jl` - Main module
- `src/api_client.jl` - HTTP client for OpenTDB API
- `src/trivia_game.jl` - Game logic and state management
- `src/ui.jl` - Terminal user interface using ANSI escape codes
- `main.jl` - Entry point script

## Key Dependencies
- HTTP.jl - For API requests
- JSON3.jl - For JSON parsing
- StructTypes.jl - For struct serialization

## Coding Guidelines
- Follow Julia naming conventions (snake_case for functions, PascalCase for types)
- Use docstrings for all public functions
- Prefer immutable structs where possible
- Handle HTTP and JSON parsing errors gracefully
- Use ANSI escape codes for terminal formatting instead of external ncurses libraries
- Keep the interface simple and accessible

## API Integration
- The OpenTDB API is free and doesn't require authentication
- HTML entities in responses need to be decoded
- API has rate limiting, so implement appropriate error handling
- Support different question categories, difficulties, and types
