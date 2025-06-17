"""
Terminal UI for the Julia Trivia Game using Term.jl
(Rich interactive interface with colors, panels, and progress bars)
"""

using Term
using Term: Panel, ProgressBar

"""
    clear_screen()

Clear the terminal screen.
"""
function clear_screen()
    print("\033[2J\033[H")
end

"""
    create_header()

Create a beautiful header panel using Term.jl.
"""
function create_header()
    title = Panel(
        "🎯 JULIA TRIVIA GAME 🎯\nPowered by Open Trivia Database";
        title="Welcome",
        title_style="bold green",
        style="bright_blue",
        width=70,
        justify=:center
    )
    return title
end

"""
    display_menu()

Display the main menu with Term.jl styling.
"""
function display_menu()
    clear_screen()
    println(create_header())
    println()
    
    menu_content = """
📋 MAIN MENU

1. Start New Game
2. Settings  
3. Quit
"""
    
    menu_panel = Panel(
        menu_content;
        title="Options",
        title_style="bold magenta",
        style="white",
        width=50
    )
    
    println(menu_panel)
    print("Enter your choice (1-3): ")
end

"""
    display_settings(game::TriviaGame)

Display the settings menu with current configuration.
"""
function display_settings(game::TriviaGame)
    clear_screen()
    println(create_header())
    println()
    
    current_settings_content = """
⚙️ CURRENT SETTINGS

Questions: $(game.total_questions)
Difficulty: $(isempty(game.difficulty) ? "Any" : titlecase(game.difficulty))
Category: $(isempty(game.category) ? "Any" : game.category)
"""
    
    current_settings = Panel(
        current_settings_content;
        title="Configuration",
        title_style="bold blue",
        style="white",
        width=50
    )
    
    settings_menu_content = """
📝 SETTINGS MENU

1. Change number of questions
2. Change difficulty
3. Change category
4. Back to main menu
"""
    
    settings_menu = Panel(
        settings_menu_content;
        title="Options",
        title_style="bold cyan",
        style="white",
        width=50
    )
    
    println(current_settings)
    println()
    println(settings_menu)
    print("Enter your choice (1-4): ")
end

"""
    display_question(game::TriviaGame)

Display the current question with beautiful formatting.
"""
function display_question(game::TriviaGame)
    question = get_current_question(game)
    if question === nothing
        return
    end
    
    clear_screen()
    println(create_header())
    println()
    
    # Progress display
    progress_percent = round((game.current_question - 1) / game.total_questions * 100, digits=1)
    progress_content = """
Progress: $(game.current_question-1)/$(game.total_questions) ($progress_percent%)
"""
    
    progress_panel = Panel(
        progress_content;
        title="Progress",
        title_style="bold green",
        style="bright_green",
        width=60
    )
    
    # Score display
    score_content = """
Question: $(game.current_question) of $(game.total_questions)
Score: $(game.score)/$(game.current_question-1)
Percentage: $(game.current_question > 1 ? round(game.score/(game.current_question-1)*100, digits=1) : 0.0)%
"""
    
    score_panel = Panel(
        score_content;
        title="Stats",
        title_style="bold yellow",
        style="white",
        width=40
    )
    
    # Question details
    question_info_content = """
Category: $(question.category)
Difficulty: $(titlecase(question.difficulty))
Type: $(question.type == "boolean" ? "True/False" : "Multiple Choice")
"""
    
    question_info = Panel(
        question_info_content;
        title="Question Info",
        title_style="bold blue",
        style="white",
        width=50
    )
    
    println(progress_panel)
    println()
    
    # Display score and question info side by side
    println(score_panel, "  ", question_info)
    println()
    
    # Display question
    question_panel = Panel(
        "❓ $(question.question)";
        title="Trivia Question",
        title_style="bold red",
        style="bright_white",
        width=80
    )
    
    println(question_panel)
    println()
    
    # Display answers
    answers, correct_pos = get_shuffled_answers(question)
    
    answer_text = ""
    if question.type == "boolean"
        answer_text = "1. True\n2. False"
    else
        for (i, answer) in enumerate(answers)
            answer_text *= "$i. $answer\n"
        end
    end
    
    answers_panel = Panel(
        answer_text;
        title="Answer Options",
        title_style="bold green",
        style="white",
        width=80
    )
    
    println(answers_panel)
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
        feedback_content = "✅ CORRECT!\n\nWell done! You got it right!"
        feedback_panel = Panel(
            feedback_content;
            title="Result",
            title_style="bold green",
            style="bright_green",
            width=50
        )
    else
        feedback_content = "❌ INCORRECT\n\nThe correct answer was:\n$correct_answer"
        feedback_panel = Panel(
            feedback_content;
            title="Result",
            title_style="bold red",
            style="bright_red",
            width=60
        )
    end
    
    println(feedback_panel)
    println()
    print("Press Enter to continue...")
    readline()
end

"""
    display_game_over(game::TriviaGame)

Display the game over screen with final statistics.
"""
function display_game_over(game::TriviaGame)
    clear_screen()
    println(create_header())
    println()
    
    stats = get_game_stats(game)
    
    # Performance feedback
    performance_msg = ""
    trophy = ""
    
    if stats.percentage >= 90
        performance_msg = "Outstanding! You're a trivia master!"
        trophy = "🏆"
    elseif stats.percentage >= 70
        performance_msg = "Great job! You know your stuff!"
        trophy = "🥇"
    elseif stats.percentage >= 50
        performance_msg = "Good work! Keep learning!"
        trophy = "👍"
    else
        performance_msg = "Keep studying and try again!"
        trophy = "📚"
    end
    
    game_over_content = """
🎉 GAME OVER! 🎉

Final Score: $(stats.score)/$(stats.total) ($(stats.percentage)%)

$trophy $performance_msg
"""
    
    game_over_panel = Panel(
        game_over_content;
        title="Final Results",
        title_style="bold magenta",
        style="bright_white",
        width=60
    )
    
    menu_content = """
🎮 WHAT'S NEXT?

1. Play Again
2. Main Menu
3. Quit
"""
    
    menu_panel = Panel(
        menu_content;
        title="Options",
        title_style="bold cyan",
        style="white",
        width=40
    )
    
    println(game_over_panel)
    println()
    println(menu_panel)
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
                error_content = "❌ Invalid choice\n\nPlease enter a number between $(first(valid_range)) and $(last(valid_range))."
                error_panel = Panel(
                    error_content;
                    title="Error",
                    title_style="bold red",
                    style="bright_red",
                    width=50
                )
                println(error_panel)
            end
        catch
            error_content = "❌ Invalid input\n\nPlease enter a valid number."
            error_panel = Panel(
                error_content;
                title="Error",
                title_style="bold red",
                style="bright_red",
                width=40
            )
            println(error_panel)
        end
    end
end

"""
    show_loading_message(message::String)

Display a loading message with spinner effect.
"""
function show_loading_message(message::String)
    loading_panel = Panel(
        "🔄 Loading...\n\n$message";
        title="Please Wait",
        title_style="bold cyan",
        style="bright_blue",
        width=50
    )
    println(loading_panel)
end

"""
    run_game_loop(game::TriviaGame)

Main game loop with enhanced Term.jl interface.
"""
function run_game_loop(game::TriviaGame)
    while true
        if game.game_state == :menu
            display_menu()
            choice = get_user_input("", 1:3)
            
            if choice == 1
                clear_screen()
                show_loading_message("Fetching trivia questions from OpenTDB...")
                if prepare_game!(game)
                    # Game successfully prepared, will start in next iteration
                else
                    error_content = "❌ Failed to start game\n\nPlease check your internet connection."
                    error_panel = Panel(
                        error_content;
                        title="Error",
                        title_style="bold red",
                        style="bright_red",
                        width=50
                    )
                    println(error_panel)
                    print("Press Enter to continue...")
                    readline()
                end
            elseif choice == 2
                game.game_state = :settings
            elseif choice == 3
                goodbye_content = "Thanks for playing!\n\nGoodbye! 👋"
                goodbye_panel = Panel(
                    goodbye_content;
                    title="Farewell",
                    title_style="bold blue",
                    style="bright_magenta",
                    width=40
                )
                println(goodbye_panel)
                break
            end
            
        elseif game.game_state == :settings
            display_settings(game)
            choice = get_user_input("", 1:4)
            
            if choice == 1
                clear_screen()
                questions_content = "📊 Number of Questions\n\nEnter number of questions (1-50):"
                questions_panel = Panel(
                    questions_content;
                    title="Settings",
                    title_style="bold green",
                    style="white",
                    width=50
                )
                println(questions_panel)
                print("Questions: ")
                try
                    num = parse(Int, strip(readline()))
                    if 1 <= num <= 50
                        game.total_questions = num
                        success_content = "✅ Success\n\nQuestions set to $num"
                        success_panel = Panel(
                            success_content;
                            title="Updated",
                            title_style="bold green",
                            style="bright_green",
                            width=40
                        )
                        println(success_panel)
                    else
                        error_content = "❌ Invalid number\n\nPlease enter between 1 and 50."
                        error_panel = Panel(
                            error_content;
                            title="Error",
                            title_style="bold red",
                            style="bright_red",
                            width=40
                        )
                        println(error_panel)
                    end
                catch
                    error_content = "❌ Invalid input\n\nPlease enter a valid number."
                    error_panel = Panel(
                        error_content;
                        title="Error",
                        title_style="bold red",
                        style="bright_red",
                        width=40
                    )
                    println(error_panel)
                end
                print("Press Enter to continue...")
                readline()
                
            elseif choice == 2
                clear_screen()
                difficulty_content = """
🎯 Difficulty Level

1. Any
2. Easy
3. Medium
4. Hard
"""
                difficulty_panel = Panel(
                    difficulty_content;
                    title="Choose Difficulty",
                    title_style="bold magenta",
                    style="white",
                    width=40
                )
                println(difficulty_panel)
                diff_choice = get_user_input("Enter difficulty choice (1-4): ", 1:4)
                difficulties = ["", "easy", "medium", "hard"]
                difficulty_names = ["Any", "Easy", "Medium", "Hard"]
                game.difficulty = difficulties[diff_choice]
                
                success_content = "✅ Success\n\nDifficulty set to $(difficulty_names[diff_choice])"
                success_panel = Panel(
                    success_content;
                    title="Updated",
                    title_style="bold green",
                    style="bright_green",
                    width=40
                )
                println(success_panel)
                print("Press Enter to continue...")
                readline()
                
            elseif choice == 3
                info_content = """
🚧 Coming Soon

Category selection feature is under development!
Currently using 'Any' category.
"""
                info_panel = Panel(
                    info_content;
                    title="Feature Info",
                    title_style="bold blue",
                    style="bright_blue",
                    width=50
                )
                println(info_panel)
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
                clear_screen()
                show_loading_message("Fetching new trivia questions...")
                if prepare_game!(game)
                    # Game will continue in playing state
                else
                    error_content = "❌ Failed to start new game\n\nPlease check your internet connection."
                    error_panel = Panel(
                        error_content;
                        title="Error",
                        title_style="bold red",
                        style="bright_red",
                        width=50
                    )
                    println(error_panel)
                    print("Press Enter to continue...")
                    readline()
                    reset_game!(game)
                end
            elseif choice == 2
                reset_game!(game)
            elseif choice == 3
                goodbye_content = "Thanks for playing!\n\nGoodbye! 👋"
                goodbye_panel = Panel(
                    goodbye_content;
                    title="Farewell",
                    title_style="bold blue",
                    style="bright_magenta",
                    width=40
                )
                println(goodbye_panel)
                break
            end
        end
    end
end
