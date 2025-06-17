# Julia Trivia Game 🎯

A terminal-based trivia game written in Julia that fetches questions from the [Open Trivia Database](https://opentdb.com/) API.

## Features

- 🎮 Interactive terminal interface with ANSI colors
- 🌐 Real-time question fetching from OpenTDB API
- ⚙️ Customizable settings (number of questions, difficulty)
- 📊 Score tracking and performance feedback
- 🎲 Multiple choice and true/false questions
- 🏆 Grade-based performance evaluation

## Requirements

- Julia 1.6 or higher
- Internet connection (for fetching trivia questions)

## Installation

1. Clone or download this repository
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   julia --project=. -e 'using Pkg; Pkg.instantiate()'
   ```

## Usage

### Quick Start
```bash
julia main.jl
```

### Using the Module
```julia
julia --project=.
using JuliaTrivia
run_trivia_game()
```

## Game Controls

- **Main Menu**: Choose from Start Game, Settings, or Quit
- **Settings**: Customize number of questions (1-50) and difficulty level
- **Gameplay**: Enter the number corresponding to your answer choice
- **Navigation**: Follow on-screen prompts

## Difficulty Levels

- **Any**: Mixed difficulty questions
- **Easy**: Simple questions suitable for everyone
- **Medium**: Moderate difficulty
- **Hard**: Challenging questions for trivia experts

## Score Grading

- 90-100%: 🏆 Outstanding! You're a trivia master!
- 70-89%: 🥇 Great job! You know your stuff!
- 50-69%: 👍 Good work! Keep learning!
- Below 50%: 📚 Keep studying and try again!

## Project Structure

```
julia-trivia/
├── Project.toml          # Julia project configuration
├── main.jl              # Entry point script
├── src/
│   ├── JuliaTrivia.jl   # Main module
│   ├── api_client.jl    # OpenTDB API client
│   ├── trivia_game.jl   # Game logic and state
│   └── ui.jl            # Terminal user interface
└── README.md            # This file
```

## Dependencies

- **HTTP.jl**: For making API requests to OpenTDB
- **JSON3.jl**: For parsing JSON responses
- **StructTypes.jl**: For struct serialization

## API Information

This game uses the [Open Trivia Database](https://opentdb.com/) which provides:
- Free trivia questions
- No API key required
- Multiple categories and difficulties
- Both multiple choice and true/false questions

## Development

To modify or extend the game:

1. **Adding new features**: The modular structure makes it easy to add new functionality
2. **UI improvements**: Modify `src/ui.jl` for interface changes
3. **API enhancements**: Extend `src/api_client.jl` for additional OpenTDB features
4. **Game logic**: Update `src/trivia_game.jl` for gameplay modifications

## Troubleshooting

### Common Issues

1. **"Failed to fetch questions"**: Check your internet connection
2. **Package errors**: Run `julia --project=. -e 'using Pkg; Pkg.instantiate()'`
3. **Terminal display issues**: Ensure your terminal supports ANSI escape codes

### Running in Development Mode

```bash
# Activate the project environment
julia --project=.

# In Julia REPL:
julia> using Pkg; Pkg.activate(".")
julia> using JuliaTrivia
julia> run_trivia_game()
```

## Contributing

Feel free to contribute by:
- Adding new question categories
- Improving the terminal interface
- Adding more game modes
- Enhancing error handling

## License

This project is open source. The trivia questions are provided by OpenTDB under CC BY-SA 4.0 license.

---

Enjoy testing your knowledge with Julia Trivia Game! 🎉
