"""
Terminal UI for the Julia Trivia Game using basic terminal I/O
(ncurses-like interface using ANSI escape codes)
"""

"""
    clear_screen()

Clear the terminal screen.
"""
function clear_screen()
    print("\033[2J\033[H")
end

"""
    print_centered(text::String, width::Int=80)

Print text centered on the screen.
"""
function print_centered(text::String, width::Int=80)
    padding = max(0, (width - length(text)) ÷ 2)
    println(" "^padding * text)
end

"""
    print_header()

Print the game header.
"""
function print_header()
    clear_screen()
    println("="^80)
    print_centered("🎯 JULIA TRIVIA GAME 🎯", 80)
    print_centered("Powered by Open Trivia Database", 80)
    println("="^80)
    println()
end

"""
    display_menu()

Display the main menu.
"""
function display_menu()
    print_header()
    println("📋 MAIN MENU")
    println()
    println("1. Start New Game")
    println("2. Settings")
    println("3. Quit")
    println()
    print("Enter your choice (1-3): ")
end

"""
    display_settings(game::TriviaGame)

Display the settings menu.
"""
function display_settings(game::TriviaGame)
    print_header()
    println("⚙️  SETTINGS")
    println()
    println("Current Settings:")
    println("  Questions: $(game.total_questions)")
    println("  Difficulty: $(isempty(game.difficulty) ? "Any" : game.difficulty)")
    println("  Category: $(isempty(game.category) ? "Any" : game.category)")
    println()
    println("1. Change number of questions")
    println("2. Change difficulty")
    println("3. Change category")
    println("4. Back to main menu")
    println()
    print("Enter your choice (1-4): ")
end

"""
    display_question(game::TriviaGame)

Display the current question.
"""
function display_question(game::TriviaGame)
    question = get_current_question(game)
    if question === nothing
        return
    end
    
    print_header()
    println("🎲 Question $(game.current_question) of $(game.total_questions)")
    println("📊 Score: $(game.score)/$(game.current_question-1)")
    println()
    
    # Display category and difficulty
    println("Category: $(question.category)")
    println("Difficulty: $(uppercasefirst(question.difficulty))")
    println("Type: $(question.type == "boolean" ? "True/False" : "Multiple Choice")")
    println()
    
    # Display question
    println("❓ $(question.question)")
    println()
    
    # Display answers
    answers, correct_pos = get_shuffled_answers(question)
    
    if question.type == "boolean"
        println("1. True")
        println("2. False")
    else
        for (i, answer) in enumerate(answers)
            println("$i. $answer")
        end
    end
    
    println()
    print("Enter your answer (1-$(length(answers))): ")
    
    return correct_pos
end

"""
    display_answer_feedback(is_correct::Bool, correct_answer::String)

Display feedback after answering a question.
"""
function display_answer_feedback(is_correct::Bool, correct_answer::String)
    println()
    if is_correct
        println("✅ Correct! Well done!")
    else
        println("❌ Incorrect. The correct answer was: $correct_answer")
    end
    println()
    print("Press Enter to continue...")
    readline()
end

"""
    display_game_over(game::TriviaGame)

Display the game over screen.
"""
function display_game_over(game::TriviaGame)
    print_header()
    stats = get_game_stats(game)
    
    println("🎉 GAME OVER! 🎉")
    println()
    println("Final Score: $(stats.score)/$(stats.total) ($(stats.percentage)%)")
    println()
    
    # Performance feedback
    if stats.percentage >= 90
        println("🏆 Outstanding! You're a trivia master!")
    elseif stats.percentage >= 70
        println("🥇 Great job! You know your stuff!")
    elseif stats.percentage >= 50
        println("👍 Good work! Keep learning!")
    else
        println("📚 Keep studying and try again!")
    end
    
    println()
    println("1. Play Again")
    println("2. Main Menu")
    println("3. Quit")
    println()
    print("Enter your choice (1-3): ")
end

"""
    get_user_input(prompt::String, valid_range::UnitRange{Int})

Get valid user input within a specified range.
"""
function get_user_input(prompt::String, valid_range::UnitRange{Int})
    while true
        try
            print(prompt)
            input = readline()
            choice = parse(Int, strip(input))
            if choice in valid_range
                return choice
            else
                println("Invalid choice. Please enter a number between $(first(valid_range)) and $(last(valid_range)).")
            end
        catch
            println("Invalid input. Please enter a number.")
        end
    end
end

"""
    run_game_loop(game::TriviaGame)

Main game loop.
"""
function run_game_loop(game::TriviaGame)
    while true
        if game.game_state == :menu
            display_menu()
            choice = get_user_input("", 1:3)
            
            if choice == 1
                if prepare_game!(game)
                    # Game successfully prepared, will start in next iteration
                else
                    println("Failed to start game. Press Enter to continue...")
                    readline()
                end
            elseif choice == 2
                game.game_state = :settings
            elseif choice == 3
                println("Thanks for playing! Goodbye! 👋")
                break
            end
            
        elseif game.game_state == :settings
            display_settings(game)
            choice = get_user_input("", 1:4)
            
            if choice == 1
                print("Enter number of questions (1-50): ")
                try
                    num = parse(Int, strip(readline()))
                    if 1 <= num <= 50
                        game.total_questions = num
                        println("Questions set to $num")
                    else
                        println("Invalid number. Please enter between 1 and 50.")
                    end
                catch
                    println("Invalid input.")
                end
                print("Press Enter to continue...")
                readline()
                
            elseif choice == 2
                println("Difficulty options:")
                println("1. Any")
                println("2. Easy")
                println("3. Medium") 
                println("4. Hard")
                diff_choice = get_user_input("Enter difficulty choice (1-4): ", 1:4)
                difficulties = ["", "easy", "medium", "hard"]
                game.difficulty = difficulties[diff_choice]
                println("Difficulty set to $(isempty(game.difficulty) ? "Any" : game.difficulty)")
                print("Press Enter to continue...")
                readline()
                
            elseif choice == 3
                println("Category feature coming soon! Currently using 'Any' category.")
                print("Press Enter to continue...")
                readline()
                
            elseif choice == 4
                game.game_state = :menu
            end
            
        elseif game.game_state == :playing
            correct_pos = display_question(game)
            if correct_pos !== nothing
                question = get_current_question(game)
                answers, _ = get_shuffled_answers(question)
                
                choice = get_user_input("", 1:length(answers))
                is_correct = answer_question!(game, choice, correct_pos)
                display_answer_feedback(is_correct, question.correct_answer)
            end
            
        elseif game.game_state == :game_over
            display_game_over(game)
            choice = get_user_input("", 1:3)
            
            if choice == 1
                reset_game!(game)
                if prepare_game!(game)
                    # Game will continue in playing state
                end
            elseif choice == 2
                reset_game!(game)
            elseif choice == 3
                println("Thanks for playing! Goodbye! 👋")
                break
            end
        end
    end
end
