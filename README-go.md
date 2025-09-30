author: Firebase Team
summary: Learn how to build AI-powered applications with Firebase Genkit and Go
id: firebase-genkit-go-codelab
categories: Firebase, AI, Go
environments: Web
status: Published
feedback: https://github.com/firebase/genkit/issues

# Getting Started with Firebase Genkit and Go

<!-- View this as an interactive codelab: [Firebase Genkit Go Codelab](docs/firebase-genkit-go-codelab/) -->

## Overview

Duration: 5

Firebase Genkit is a powerful framework for building AI-powered applications with Go. This codelab will guide you through three essential patterns for working with Genkit: basic AI generation, structured data generation, and building reusable flows.

### What you'll learn

- How to set up Firebase Genkit in a Go project
- How to use the `genkit.Generate` API for direct AI interactions
- How to create structured data with Go structs and JSON schemas
- How to build and test Genkit flows
- How to use Firebase Studio for testing and debugging

### What you'll need

- [Go 1.24+](https://go.dev/doc/install) installed
- A text editor ([VS Code](https://code.visualstudio.com/) recommended)
- A Google AI API key - [Get API key here](https://aistudio.google.com/apikey)
- Basic knowledge of Go programming

### What you'll build

By the end of this codelab, you'll have built three simple examples:

1. **Basic AI Generation**: Simple text generation using `genkit.Generate`
2. **Structured Data Generation**: Using Go structs for type-safe AI responses
3. **Flow-based Services**: Simple reusable flows with HTTP endpoints

---

## Setting up your environment

Duration: 10

Before we start building, let's set up a new Genkit Go project.

### Initialize your project

First, create a new directory and initialize a Go module:

```bash
mkdir genkit-go-workshop
cd genkit-go-workshop
go mod init example/genkit-go-workshop
```

### Install Genkit CLI

First, install the Genkit CLI globally:

```bash
curl -sL cli.genkit.dev | bash
```

### Install Genkit Go package

Add the Genkit package for Go:

```bash
go get github.com/firebase/genkit/go
```

### Set up environment variables

Create a `.env` file in your project root:

```bash
# Get your API key from https://aistudio.google.com/apikey
GEMINI_API_KEY=your_google_ai_api_key_here
```

**Important:** Never commit your API keys to version control. Create a `.gitignore` file:

```gitignore
.env
*.log
```

### Verify your setup

Let's make sure everything is working correctly:

```bash
# Check Go version (should be 1.24+)
go version

# Verify the Genkit package is installed
go list -m github.com/firebase/genkit/go
```

If any command fails, please install the missing dependencies using the links provided above.

---

## Example 1: Basic AI Generation with genkit.Generate

Duration: 10

Let's start with the simplest way to use Genkit: direct AI generation using the `genkit.Generate` API.

### Create the basic generator

Create `example1/main.go`:

```go
package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/firebase/genkit/go/ai"
	"github.com/firebase/genkit/go/genkit"
	"github.com/firebase/genkit/go/plugins/googlegenai"
)

func main() {
	ctx := context.Background()

	// Load environment variables
	apiKey := os.Getenv("GEMINI_API_KEY")
	if apiKey == "" {
		log.Fatal("GEMINI_API_KEY environment variable is required")
	}

	// Initialize Genkit with Google AI plugin
	g := genkit.Init(ctx,
		genkit.WithPlugins(&googlegenai.GoogleAI{}),
		genkit.WithDefaultModel("googleai/gemini-2.5-flash"),
	)

	// Simple text generation
	response, err := genkit.Generate(ctx, g,
		ai.WithPrompt("Write a short welcome message for a new team member joining our development team."),
	)
	if err != nil {
		log.Fatalf("Error generating content: %v", err)
	}

	fmt.Println("Generated message:")
	fmt.Println(response.Text())
}
```

### Run your first example

Execute the basic generation example:

```bash
# Set your API key
export GEMINI_API_KEY=your_actual_api_key_here

cd example1
go run main.go
```

You should see a generated welcome message!

### Try different prompts

Let's try a few more simple examples. Update `example1/main.go`:

```go
package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/firebase/genkit/go/ai"
	"github.com/firebase/genkit/go/genkit"
	"github.com/firebase/genkit/go/plugins/googlegenai"
)

func main() {
	ctx := context.Background()

	// Load environment variables
	apiKey := os.Getenv("GEMINI_API_KEY")
	if apiKey == "" {
		log.Fatal("GEMINI_API_KEY environment variable is required")
	}

	// Initialize Genkit with Google AI plugin
	g := genkit.Init(ctx,
		genkit.WithPlugins(&googlegenai.GoogleAI{}),
		genkit.WithDefaultModel("googleai/gemini-2.5-flash"),
	)

	// Example 1: Generate a welcome message
	fmt.Println("=== Welcome Message ===")
	response1, err := genkit.Generate(ctx, g,
		ai.WithPrompt("Write a short welcome message for a new team member joining our development team."),
	)
	if err != nil {
		log.Printf("Error generating welcome message: %v", err)
	} else {
		fmt.Println(response1.Text())
	}

	// Example 2: Create a simple task list
	fmt.Println("\n=== Task List ===")
	response2, err := genkit.Generate(ctx, g,
		ai.WithPrompt("Create a simple 3-item todo list for setting up a new development environment."),
	)
	if err != nil {
		log.Printf("Error generating task list: %v", err)
	} else {
		fmt.Println(response2.Text())
	}

	// Example 3: Write a brief explanation
	fmt.Println("\n=== Explanation ===")
	response3, err := genkit.Generate(ctx, g,
		ai.WithPrompt("Explain what Go programming language is in 2-3 simple sentences."),
	)
	if err != nil {
		log.Printf("Error generating explanation: %v", err)
	} else {
		fmt.Println(response3.Text())
	}
}
```

### Test with Firebase Studio

Start Firebase Studio to test your generation interactively:

```bash
genkit start -- go run example1/main.go
```

This will open the Genkit Developer UI in your browser where you can test your AI generation with different prompts and see the results in real-time.

---

## Example 2: Structured Data Generation

Duration: 15

Go's type system makes it perfect for generating structured data with AI. Let's create a story generator using Go structs for type-safe responses.

### Create structured data types

Create `example2/main.go`:

```go
package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"

	"github.com/firebase/genkit/go/ai"
	"github.com/firebase/genkit/go/genkit"
	"github.com/firebase/genkit/go/plugins/googlegenai"
)

// Story represents a generated story with structured data
type Story struct {
	Title      string   `json:"title" jsonschema:"description=The title of the story"`
	Characters []string `json:"characters" jsonschema:"description=Main characters in the story"`
	Setting    string   `json:"setting" jsonschema:"description=Where the story takes place"`
	Plot       string   `json:"plot" jsonschema:"description=The main plot of the story"`
	Mood       string   `json:"mood" jsonschema:"description=The overall mood (happy, adventurous, mysterious, etc.)"`
}

// StoryInput represents the input parameters for story generation
type StoryInput struct {
	Character string `json:"character" jsonschema:"description=Main character for the story"`
	Setting   string `json:"setting" jsonschema:"description=Setting where the story takes place"`
}

func main() {
	ctx := context.Background()

	// Load environment variables
	apiKey := os.Getenv("GEMINI_API_KEY")
	if apiKey == "" {
		log.Fatal("GEMINI_API_KEY environment variable is required")
	}

	// Initialize Genkit with Google AI plugin
	g := genkit.Init(ctx,
		genkit.WithPlugins(&googlegenai.GoogleAI{}),
		genkit.WithDefaultModel("googleai/gemini-2.5-flash"),
	)

	// Generate a structured story
	fmt.Println("=== Generating Structured Story ===")

	input := StoryInput{
		Character: "a friendly robot",
		Setting:   "a magical library",
	}

	fmt.Printf("Character: %s\n", input.Character)
	fmt.Printf("Setting: %s\n", input.Setting)

	prompt := fmt.Sprintf(`Create a short, fun story about %s in %s.
		Make it light-hearted and suitable for all ages.
		Return the response as structured data with title, characters, setting, plot, and mood.`,
		input.Character, input.Setting)

	// Generate structured data using Go structs
	story, _, err := genkit.GenerateData[Story](ctx, g,
		ai.WithPrompt(prompt),
	)
	if err != nil {
		log.Fatalf("Error generating story: %v", err)
	}

	// Print the structured story
	fmt.Println("\n=== Generated Story ===")
	storyJSON, _ := json.MarshalIndent(story, "", "  ")
	fmt.Println(string(storyJSON))

	// Generate different stories
	fmt.Println("\n=== Generating Different Stories ===")

	stories := []StoryInput{
		{Character: "a curious cat", Setting: "a space station"},
		{Character: "a young wizard", Setting: "a bustling marketplace"},
		{Character: "a brave explorer", Setting: "an underwater city"},
	}

	for i, storyInput := range stories {
		fmt.Printf("\n--- Story %d: %s in %s ---\n", i+1, storyInput.Character, storyInput.Setting)

		prompt := fmt.Sprintf(`Create a short, fun story about %s in %s.
			Make it light-hearted and suitable for all ages.
			Return the response as structured data with title, characters, setting, plot, and mood.`,
			storyInput.Character, storyInput.Setting)

		story, _, err := genkit.GenerateData[Story](ctx, g,
			ai.WithPrompt(prompt),
		)
		if err != nil {
			log.Printf("Error generating story %d: %v", i+1, err)
			continue
		}

		fmt.Printf("Title: %s\n", story.Title)
		fmt.Printf("Plot: %s\n", story.Plot)
		fmt.Printf("Mood: %s\n", story.Mood)
	}
}
```

### Test your structured generation

Run the structured generation example:

```bash
cd example2
go run main.go
```

You should see several different stories generated with structured JSON data!

### Create another structured type

Let's create another example for generating simple recipes. Add this to a new file `example2/recipe.go`:

```go
package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"

	"github.com/firebase/genkit/go/ai"
	"github.com/firebase/genkit/go/genkit"
	"github.com/firebase/genkit/go/plugins/googlegenai"
)

// Recipe represents a structured recipe
type Recipe struct {
	Name         string   `json:"name" jsonschema:"description=Name of the recipe"`
	Ingredients  []string `json:"ingredients" jsonschema:"description=List of ingredients"`
	Instructions []string `json:"instructions" jsonschema:"description=Step-by-step cooking instructions"`
	PrepTime     string   `json:"prepTime" jsonschema:"description=Preparation time"`
	Difficulty   string   `json:"difficulty" jsonschema:"description=Difficulty level (easy, medium, hard)"`
}

// RecipeInput represents input for recipe generation
type RecipeInput struct {
	Ingredient string `json:"ingredient" jsonschema:"description=Main ingredient"`
	MealType   string `json:"mealType" jsonschema:"description=Type of meal (breakfast, lunch, dinner, snack)"`
}

func generateRecipe() {
	ctx := context.Background()

	// Load environment variables
	apiKey := os.Getenv("GEMINI_API_KEY")
	if apiKey == "" {
		log.Fatal("GEMINI_API_KEY environment variable is required")
	}

	// Initialize Genkit
	g := genkit.Init(ctx,
		genkit.WithPlugins(&googlegenai.GoogleAI{}),
		genkit.WithDefaultModel("googleai/gemini-2.5-flash"),
	)

	input := RecipeInput{
		Ingredient: "avocado",
		MealType:   "breakfast",
	}

	prompt := fmt.Sprintf(`Create a simple recipe for %s using %s as the main ingredient.
		Keep it easy to follow with basic ingredients and simple steps.
		Return as structured data with name, ingredients, instructions, prep time, and difficulty.`,
		input.MealType, input.Ingredient)

	recipe, _, err := genkit.GenerateData[Recipe](ctx, g,
		ai.WithPrompt(prompt),
	)
	if err != nil {
		log.Fatalf("Error generating recipe: %v", err)
	}

	fmt.Println("=== Generated Recipe ===")
	recipeJSON, _ := json.MarshalIndent(recipe, "", "  ")
	fmt.Println(string(recipeJSON))
}
```

---

## Example 3: Building Simple Genkit Flows

Duration: 15

Flows are reusable functions that can be called, tested, and monitored. They're perfect for building simple AI workflows that can be served as HTTP endpoints.

### Create a basic greeting flow

Create `example3/main.go`:

```go
package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/firebase/genkit/go/ai"
	"github.com/firebase/genkit/go/genkit"
	"github.com/firebase/genkit/go/plugins/googlegenai"
	"github.com/firebase/genkit/go/plugins/server"
)

// GreetingInput represents input for greeting generation
type GreetingInput struct {
	Name     string `json:"name" jsonschema:"description=The person's name"`
	Language string `json:"language" jsonschema:"description=Language for greeting (english, spanish, french)"`
}

// GreetingOutput represents the generated greeting
type GreetingOutput struct {
	Greeting string `json:"greeting" jsonschema:"description=The generated greeting"`
}

// JokeInput represents input for joke generation
type JokeInput struct {
	Topic string `json:"topic" jsonschema:"description=The topic for the joke"`
}

// JokeOutput represents the generated joke
type JokeOutput struct {
	Joke string `json:"joke" jsonschema:"description=The generated joke"`
}

func main() {
	ctx := context.Background()

	// Load environment variables
	apiKey := os.Getenv("GEMINI_API_KEY")
	if apiKey == "" {
		log.Fatal("GEMINI_API_KEY environment variable is required")
	}

	// Initialize Genkit with Google AI plugin
	g := genkit.Init(ctx,
		genkit.WithPlugins(&googlegenai.GoogleAI{}),
		genkit.WithDefaultModel("googleai/gemini-2.5-flash"),
	)

	// Define a greeting flow
	greetingFlow := genkit.DefineFlow(g, "greeting", func(ctx context.Context, input *GreetingInput) (*GreetingOutput, error) {
		prompt := fmt.Sprintf("Create a friendly greeting for %s in %s. Keep it warm and welcoming.", input.Name, input.Language)

		response, err := genkit.Generate(ctx, g,
			ai.WithPrompt(prompt),
		)
		if err != nil {
			return nil, fmt.Errorf("failed to generate greeting: %w", err)
		}

		return &GreetingOutput{
			Greeting: response.Text(),
		}, nil
	})

	// Define a joke generator flow
	jokeFlow := genkit.DefineFlow(g, "jokeGenerator", func(ctx context.Context, input *JokeInput) (*JokeOutput, error) {
		prompt := fmt.Sprintf("Create a clean, family-friendly joke about %s. Keep it short and funny.", input.Topic)

		response, err := genkit.Generate(ctx, g,
			ai.WithPrompt(prompt),
		)
		if err != nil {
			return nil, fmt.Errorf("failed to generate joke: %w", err)
		}

		return &JokeOutput{
			Joke: response.Text(),
		}, nil
	})

	// Test the flows locally
	fmt.Println("=== Testing Greeting Flow ===")
	greetingResult, err := greetingFlow.Run(ctx, &GreetingInput{
		Name:     "Alice",
		Language: "english",
	})
	if err != nil {
		log.Printf("Error running greeting flow: %v", err)
	} else {
		fmt.Printf("Greeting Result: %s\n", greetingResult.Greeting)
	}

	fmt.Println("\n=== Testing Joke Flow ===")
	jokeResult, err := jokeFlow.Run(ctx, &JokeInput{
		Topic: "programming",
	})
	if err != nil {
		log.Printf("Error running joke flow: %v", err)
	} else {
		fmt.Printf("Joke Result: %s\n", jokeResult.Joke)
	}

	// Test multiple greetings
	fmt.Println("\n=== Testing Multiple Greetings ===")
	people := []GreetingInput{
		{Name: "Bob", Language: "spanish"},
		{Name: "Claire", Language: "french"},
	}

	for _, person := range people {
		result, err := greetingFlow.Run(ctx, &person)
		if err != nil {
			log.Printf("Error greeting %s: %v", person.Name, err)
			continue
		}
		fmt.Printf("%s (%s): %s\n", person.Name, person.Language, result.Greeting)
	}

	// Set up HTTP server to serve the flows
	mux := http.NewServeMux()
	mux.HandleFunc("POST /greeting", genkit.Handler(greetingFlow))
	mux.HandleFunc("POST /jokeGenerator", genkit.Handler(jokeFlow))

	// Print sample usage
	fmt.Println("\n=== Server Starting ===")
	fmt.Println("Starting server on http://localhost:3400")
	fmt.Println("Flows available at:")
	fmt.Println("  POST http://localhost:3400/greeting")
	fmt.Println("  POST http://localhost:3400/jokeGenerator")
	fmt.Println("\nSample curl commands:")
	fmt.Println(`  curl -X POST "http://localhost:3400/greeting" \`)
	fmt.Println(`    -H "Content-Type: application/json" \`)
	fmt.Println(`    -d '{"data": {"name": "Alice", "language": "english"}}'`)
	fmt.Println()
	fmt.Println(`  curl -X POST "http://localhost:3400/jokeGenerator" \`)
	fmt.Println(`    -H "Content-Type: application/json" \`)
	fmt.Println(`    -d '{"data": {"topic": "programming"}}'`)

	// Start the server
	log.Fatal(server.Start(ctx, "127.0.0.1:3400", mux))
}
```

### Test your flows

Run the flows example:

```bash
cd example3
go run main.go
```

### Test flows via HTTP

With the server running, you can test your flows using curl in a new terminal:

```bash
# Test greeting flow
curl -X POST "http://localhost:3400/greeting" \
  -H "Content-Type: application/json" \
  -d '{"data": {"name": "Alice", "language": "english"}}'

# Test joke flow
curl -X POST "http://localhost:3400/jokeGenerator" \
  -H "Content-Type: application/json" \
  -d '{"data": {"topic": "programming"}}'
```

### Test flows in the Developer UI

Start the Developer UI and navigate to the Flows section:

```bash
genkit start -- go run example3/main.go
```

In the Developer UI, you'll be able to:

- See all your defined flows
- Test them with custom inputs
- View execution traces and performance metrics
- Debug any issues step by step

---

## Testing and Debugging with Firebase Studio

Duration: 10

Firebase Studio provides a powerful interface for testing and debugging your Genkit applications.

### Key Features of Firebase Studio

1. **Flow Testing**: Interactive testing of your flows with custom inputs
2. **Structured Output**: Visual display of your Go struct responses
3. **Model Comparison**: Test the same prompt with different models side by side
4. **Execution Traces**: Detailed view of each step in your flows
5. **Performance Monitoring**: Track response times and token usage

### Best Practices for Testing

1. **Start Simple**: Test basic functionality before adding complexity
2. **Use Diverse Inputs**: Test with various input types and edge cases
3. **Monitor Performance**: Watch token usage and response times
4. **Iterate on Prompts**: Use Studio to refine your prompts for better results
5. **Version Control**: Keep track of prompt changes and their performance

### Debugging Common Issues

#### API Key Problems

```bash
Error: GEMINI_API_KEY environment variable is required
```

- Check that your `GEMINI_API_KEY` is set correctly
- Verify the API key is valid and has proper permissions

#### JSON Schema Errors

```bash
Error: failed to generate structured data
```

- Review your Go struct tags for accuracy
- Ensure your `jsonschema` tags provide clear descriptions
- Test with simpler structs first

#### HTTP Server Issues

```bash
Error: address already in use
```

- Change the port in your `server.Start()` call
- Kill any existing processes using the port

---

## Next Steps

Congratulations! You've learned the fundamentals of Firebase Genkit with Go. Here's what you can explore next:

### Continue Learning

- **Custom Models**: Integrate other AI providers (OpenAI, Anthropic, local models)
- **Vector Databases**: Add semantic search capabilities with embeddings
- **Tool Calling**: Enable AI to call your custom functions
- **Production Deployment**: Deploy your Genkit apps to Cloud Functions or Cloud Run

### Resources

- [Official Genkit Documentation](https://genkit.dev/docs/)
- [Genkit GitHub Repository](https://github.com/firebase/genkit)
- [Firebase Discord Community](https://discord.gg/firebase)

---

## Troubleshooting

### Common Issues and Solutions

#### "Go module not found" errors

```bash
go mod tidy
go get github.com/firebase/genkit/go
```

#### Go compilation errors

```bash
go build .  # Check for compilation errors
```

#### "genkit command not found"

```bash
curl -sL cli.genkit.dev | bash  # Install genkit CLI
```

#### Firebase Studio not starting

```bash
genkit start --port 4000 -- go run main.go  # Try different port
```

#### API rate limits

- Implement exponential backoff
- Use batch processing for multiple requests
- Consider upgrading your API plan

### Getting Help

- Check the [GitHub Issues](https://github.com/firebase/genkit/issues)
- Join the [Firebase Discord](https://discord.gg/firebase)
- Post questions on [Stack Overflow](https://stackoverflow.com/questions/tagged/firebase-genkit)

---

## Conclusion

You've successfully built three different patterns for working with Firebase Genkit in Go:

1. **Direct AI Generation**: Quick and simple for basic use cases
2. **Structured Data**: Type-safe responses using Go structs
3. **Flows**: Powerful and reusable for complex AI workflows

These patterns form the foundation for building sophisticated AI-powered applications. Start with simple use cases and gradually build more complex workflows as you become comfortable with the framework.

Happy building with Firebase Genkit and Go! 🚀
