#!/usr/bin/env julia

# Quick test script to verify API connectivity
using Pkg
Pkg.activate(@__DIR__)

push!(LOAD_PATH, joinpath(@__DIR__, "src"))
using JuliaTrivia

println("Testing OpenTDB API connection...")

# Test fetching a few questions
questions = fetch_trivia_questions(5, "easy")

if !isempty(questions)
    println("✅ Successfully fetched $(length(questions)) questions!")
    println("\nSample question:")
    q = questions[1]
    println("Category: $(q.category)")
    println("Difficulty: $(q.difficulty)")
    println("Question: $(q.question)")
    println("Correct Answer: $(q.correct_answer)")
    println("Incorrect Answers: $(join(q.incorrect_answers, ", "))")
else
    println("❌ Failed to fetch questions. Check your internet connection.")
end

println("\nTest completed.")
