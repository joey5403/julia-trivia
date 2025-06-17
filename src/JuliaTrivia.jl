module JuliaTrivia

include("api_client.jl")
include("trivia_game.jl")
include("ui.jl")

export run_trivia_game, fetch_trivia_questions

"""
    run_trivia_game()

Start the Julia Trivia Game with ncurses interface.
"""
function run_trivia_game()
    game = TriviaGame()
    run_game_loop(game)
end

end # module JuliaTrivia
