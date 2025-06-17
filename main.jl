#!/usr/bin/env julia

# Main entry point for the Julia Trivia Game
using Pkg
Pkg.activate(@__DIR__)

push!(LOAD_PATH, joinpath(@__DIR__, "src"))
using JuliaTrivia

# Run the trivia game
run_trivia_game()
