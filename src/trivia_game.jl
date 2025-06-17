"""
Game logic for the Julia Trivia Game
"""

mutable struct TriviaGame
    questions::Vector{TriviaQuestion}
    current_question::Int
    score::Int
    total_questions::Int
    game_state::Symbol  # :menu, :playing, :game_over, :settings
    difficulty::String
    category::String
    
    function TriviaGame()
        new(TriviaQuestion[], 1, 0, 10, :menu, "", "")
    end
end

"""
    prepare_game!(game::TriviaGame)

Fetch questions and prepare the game for playing.
"""
function prepare_game!(game::TriviaGame)
    println("Fetching trivia questions...")
    game.questions = fetch_trivia_questions(game.total_questions, game.difficulty, game.category)
    
    if isempty(game.questions)
        @error "Failed to fetch questions. Please check your internet connection."
        return false
    end
    
    game.current_question = 1
    game.score = 0
    game.game_state = :playing
    return true
end

"""
    get_current_question(game::TriviaGame)

Get the current question or nothing if game is over.
"""
function get_current_question(game::TriviaGame)
    if game.current_question <= length(game.questions)
        return game.questions[game.current_question]
    end
    return nothing
end

"""
    get_shuffled_answers(question::TriviaQuestion)

Get all answers shuffled with the correct answer position.
"""
function get_shuffled_answers(question::TriviaQuestion)
    all_answers = vcat([question.correct_answer], question.incorrect_answers)
    
    # Simple shuffle using rand()
    n = length(all_answers)
    for i in n:-1:2
        j = rand(1:i)
        all_answers[i], all_answers[j] = all_answers[j], all_answers[i]
    end
    
    # Find the position of the correct answer
    correct_pos = findfirst(x -> x == question.correct_answer, all_answers)
    
    return all_answers, correct_pos
end

"""
    answer_question!(game::TriviaGame, answer_index::Int, correct_index::Int)

Process the player's answer and update the game state.
"""
function answer_question!(game::TriviaGame, answer_index::Int, correct_index::Int)
    is_correct = (answer_index == correct_index)
    
    if is_correct
        game.score += 1
    end
    
    game.current_question += 1
    
    # Check if game is over
    if game.current_question > length(game.questions)
        game.game_state = :game_over
    end
    
    return is_correct
end

"""
    get_game_stats(game::TriviaGame)

Get current game statistics.
"""
function get_game_stats(game::TriviaGame)
    return (
        score = game.score,
        total = game.total_questions,
        percentage = round(game.score / game.total_questions * 100, digits=1)
    )
end

"""
    reset_game!(game::TriviaGame)

Reset the game to initial state.
"""
function reset_game!(game::TriviaGame)
    game.questions = TriviaQuestion[]
    game.current_question = 1
    game.score = 0
    game.game_state = :menu
end
