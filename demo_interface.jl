#!/usr/bin/env julia

# Demo script to showcase the beautiful Term.jl interface
using Pkg
Pkg.activate(@__DIR__)

push!(LOAD_PATH, joinpath(@__DIR__, "src"))
using JuliaTrivia
using Term

clear_screen() = print("\033[2J\033[H")

# Create a demo showcase
function demo_interface()
    clear_screen()
    
    # Show the header
    header = Panel(
        "🎯 JULIA TRIVIA GAME 🎯\nPowered by Open Trivia Database";
        title="Welcome to the Enhanced Interface",
        title_style="bold green",
        style="bright_blue",
        width=70,
        justify=:center
    )
    
    println(header)
    println()
    
    # Show feature highlights
    features = Panel(
        """
✨ NEW FEATURES WITH TERM.JL ✨

🎨 Beautiful bordered panels with styled titles
📊 Visual progress tracking and statistics  
🌈 Rich text formatting and colors
🎮 Professional loading screens
📋 Enhanced error handling with visual feedback
⚙️ Organized settings and configuration displays
🏆 Stylized game over screens with performance ratings
        """;
        title="Enhanced Features",
        title_style="bold magenta",
        style="white",
        width=60
    )
    
    println(features)
    println()
    
    # Show sample question display
    sample = Panel(
        """
Sample Enhanced Question Display:
• Progress bar with percentage completion
• Score tracking in dedicated panels  
• Question info with category and difficulty
• Colored answer options
• Immediate visual feedback for answers
        """;
        title="Interface Improvements",
        title_style="bold cyan",
        style="bright_white",
        width=50
    )
    
    println(sample)
    println()
    
    # Call to action
    cta = Panel(
        "Ready to play? Run: julia main.jl";
        title="Get Started",
        title_style="bold yellow",
        style="bright_green",
        width=40,
        justify=:center
    )
    
    println(cta)
end

demo_interface()
