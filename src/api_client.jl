using HTTP, JSON3, StructTypes

"""
API client for OpenTDB (Open Trivia Database)
"""

struct TriviaQuestion
    category::String
    type::String
    difficulty::String
    question::String
    correct_answer::String
    incorrect_answers::Vector{String}
end

StructTypes.StructType(::Type{TriviaQuestion}) = StructTypes.Struct()

struct TriviaResponse
    response_code::Int
    results::Vector{TriviaQuestion}
end

StructTypes.StructType(::Type{TriviaResponse}) = StructTypes.Struct()

"""
    fetch_trivia_questions(amount=10, difficulty="", category="", type="")

Fetch trivia questions from OpenTDB API.

# Arguments
- `amount::Int`: Number of questions to retrieve (1-50)
- `difficulty::String`: Difficulty level ("easy", "medium", "hard", or "" for any)
- `category::String`: Category ID or "" for any
- `type::String`: Question type ("multiple", "boolean", or "" for any)
"""
function fetch_trivia_questions(amount::Int=10, difficulty::String="", category::String="", type::String="")
    base_url = "https://opentdb.com/api.php"
    params = ["amount=$amount"]
    
    if !isempty(difficulty)
        push!(params, "difficulty=$difficulty")
    end
    
    if !isempty(category)
        push!(params, "category=$category")
    end
    
    if !isempty(type)
        push!(params, "type=$type")
    end
    
    url = base_url * "?" * join(params, "&")
    
    try
        response = HTTP.get(url)
        if response.status == 200
            # Decode HTML entities in the response
            json_str = String(response.body)
            json_str = decode_html_entities(json_str)
            
            trivia_data = JSON3.read(json_str, TriviaResponse)
            return trivia_data.results
        else
            @error "Failed to fetch trivia questions. HTTP status: $(response.status)"
            return TriviaQuestion[]
        end
    catch e
        @error "Error fetching trivia questions: $e"
        return TriviaQuestion[]
    end
end

"""
    decode_html_entities(text::String)

Decode common HTML entities in text.
"""
function decode_html_entities(text::String)
    replacements = [
        "&quot;" => "\"",
        "&#039;" => "'",
        "&amp;" => "&",
        "&lt;" => "<",
        "&gt;" => ">",
        "&lsquo;" => "'",
        "&rsquo;" => "'",
        "&ldquo;" => "\"",
        "&rdquo;" => "\"",
        "&mdash;" => "—",
        "&ndash;" => "–",
        "&hellip;" => "…"
    ]
    
    result = text
    for (entity, replacement) in replacements
        result = replace(result, entity => replacement)
    end
    
    return result
end

"""
    get_categories()

Fetch available trivia categories from OpenTDB API.
"""
function get_categories()
    url = "https://opentdb.com/api_category.php"
    
    try
        response = HTTP.get(url)
        if response.status == 200
            data = JSON3.read(response.body)
            return data.trivia_categories
        else
            @warn "Failed to fetch categories. Using default categories."
            return []
        end
    catch e
        @warn "Error fetching categories: $e. Using default categories."
        return []
    end
end
