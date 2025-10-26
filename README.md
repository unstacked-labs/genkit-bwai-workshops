author: Firebase Team
summary: Learn how to build AI-powered applications with Firebase Genkit and TypeScript
id: firebase-genkit-typescript-codelab
categories: Firebase, AI, TypeScript
environments: Web
status: Published
feedback: https://github.com/firebase/genkit/issues

# Getting Started with Firebase Genkit and TypeScript

## Overview

Duration: 5

Firebase Genkit is a powerful framework for building AI-powered applications with TypeScript. This codelab will guide you through three essential patterns for working with Genkit: basic AI generation, prompt management with `.prompt` files, and building reusable flows.

**📚 Additional Resources:**

- [Official Genkit Documentation](https://genkit.dev/docs/)
- [Genkit GitHub Repository](https://github.com/firebase/genkit)
- [Firebase Genkit Discord Community](https://discord.gg/qXt5zzQKpc)

### What you'll learn

- How to set up Firebase Genkit in a TypeScript project
- How to use the `ai.generate` API for direct AI interactions
- How to create and manage prompts using `.prompt` files
- How to build and test Genkit flows
- How to use Firebase Studio for testing and debugging

### What you'll need

- [Node.js 20+](https://nodejs.org/en/download/) installed (includes npm)
- A text editor ([VS Code](https://code.visualstudio.com/) recommended)
- A Google AI API key - [Get API key here](https://aistudio.google.com/apikey)
- Basic knowledge of TypeScript/JavaScript

**📚 Additional Resources:**

- [Node.js Installation Guide](https://nodejs.org/en/learn/getting-started/how-to-install-nodejs)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)
- [VS Code Setup for TypeScript](https://code.visualstudio.com/docs/typescript/typescript-tutorial)
- [Google AI Studio Guide](https://ai.google.dev/aistudio/docs/get_api_key)

### What you'll build

By the end of this codelab, you'll have built three practical business examples:

1. A professional communication generator (emails, bug reports) using `ai.generate`
2. A project planning assistant using `.prompt` files
3. A complete content analysis flow for team communications and documentation

---

## Setting up your environment

Duration: 10

Before we start building, let's set up a new Genkit project.

### Initialize your project

First, create a new directory and initialize a Node.js project:

```bash
mkdir genkit-workshop
cd genkit-workshop
npm init -y
```

### Install Genkit packages

First, install the Genkit CLI globally:

```bash
npm install -g genkit-cli
```

Then, add the following packages to your project:

```bash
npm install genkit @genkit-ai/google-genai
npm install -D typescript tsx @types/node
```

### Configure TypeScript

Create a `tsconfig.json` file:

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

### Set up environment variables

Create a `.env` file in your project root:

```bash
# Get your API key from https://aistudio.google.com/apikey
GEMINI_API_KEY=your_google_ai_api_key_here
```

**Important:** Never commit your API keys to version control. Create a `.gitignore` file:

```gitignore
node_modules/
.env
dist/
*.log
```

### Install dotenv for environment variables

```bash
npm install dotenv
```

### Verify your setup

Let's make sure everything is working correctly:

```bash
# Check Node.js version (should be 18+)
node --version

# Check npm version
npm --version

# Verify TypeScript compilation works
npx tsc --version
```

If any command fails, please install the missing dependencies using the links provided above.

**📚 Additional Resources:**

- [npm Documentation](https://docs.npmjs.com/)
- [TypeScript Configuration Reference](https://www.typescriptlang.org/tsconfig)
- [Environment Variables Best Practices](https://nodejs.org/en/learn/command-line/how-to-read-environment-variables-from-nodejs)
- [dotenv Package Documentation](https://www.npmjs.com/package/dotenv)

---

## Example 1: Basic AI Generation with ai.generate

Duration: 10

Let's start with the simplest way to use Genkit: direct AI generation using the `ai.generate` API.

### Create the basic generator

Create `src/example1-basic.ts`:

```typescript
import { googleAI } from '@genkit-ai/google-genai';
import { genkit } from 'genkit';
import 'dotenv/config';

// Initialize Genkit with Google AI
const ai = genkit({
  plugins: [googleAI()],
  model: 'gemini-2.5-flash',
});

async function basicGeneration() {
  try {
    // Simple text generation
    const response = await ai.generate({
      prompt: 'Write a short welcome message for a new team member joining our development team.',
    });

    console.log('Generated message:');
    console.log(response.text());
  } catch (error) {
    console.error('Error generating content:', error);
  }
}

// Run the example
basicGeneration();
```

### Run your first example

Execute the basic generation example:

```bash
npx tsx src/example1-basic.ts
```

You should see a generated welcome message!

### Try different prompts

Let's try a few more simple examples. Update `src/example1-basic.ts`:

```typescript
import { googleAI } from '@genkit-ai/google-genai';
import { genkit } from 'genkit';
import 'dotenv/config';

// Initialize Genkit with Google AI
const ai = genkit({
  plugins: [googleAI()],
  model: 'gemini-2.5-flash',
});

async function basicGeneration() {
  try {
    // Example 1: Generate a welcome message
    console.log('=== Welcome Message ===');
    const welcomeResponse = await ai.generate({
      prompt: 'Write a short welcome message for a new team member joining our development team.',
    });
    console.log(welcomeResponse.text());

    // Example 2: Create a simple task list
    console.log('\n=== Task List ===');
    const taskResponse = await ai.generate({
      prompt: 'Create a simple 3-item todo list for setting up a new development environment.',
    });
    console.log(taskResponse.text());

    // Example 3: Write a brief explanation
    console.log('\n=== Explanation ===');
    const explanationResponse = await ai.generate({
      prompt: 'Explain what TypeScript is in 2-3 simple sentences.',
    });
    console.log(explanationResponse.text());
  } catch (error) {
    console.error('Error generating content:', error);
  }
}

// Run the example
basicGeneration();
```

### Test with Firebase Studio

Start Firebase Studio to test your generation interactively:

```bash
genkit start -- tsx --watch src/index.ts
```

This will open the Genkit Developer UI in your browser where you can test your AI generation with different prompts and see the results in real-time.

**📚 Additional Resources:**

- [Genkit Models Documentation](https://genkit.dev/docs/models)
- [Structured Output with Zod](https://zod.dev/)
- [Genkit Developer Tools](https://genkit.dev/docs/devtools)
- [Google AI Gemini Models](https://genkit.dev/docs/integrations/google-genai)

---

## Example 2: Working with Prompt Files

Duration: 15

Managing prompts in separate files makes them more maintainable and allows for better collaboration. Let's create a simple story generator using `.prompt` files.

### Create your first prompt file

Create a directory for prompts at your project root and add your first prompt file:

```bash
mkdir prompts
```

Create `prompts/story-generator.prompt`:

```
---
model: googleai/gemini-2.5-flash
input:
  schema:
    character: string
    setting: string
---

Write a short, fun story (2-3 paragraphs) about {{character}} in {{setting}}.
Keep it light-hearted and suitable for all ages.
```

### Create the prompt-based generator

Create `src/example2-prompts.ts`:

```typescript
import { googleAI } from '@genkit-ai/google-genai';
import { genkit } from 'genkit';
import 'dotenv/config';

// Initialize Genkit with Google AI
const ai = genkit({
  plugins: [googleAI()],
});

// Load the prompt from the file
const storyGeneratorPrompt = ai.prompt('story-generator');

async function generateStory() {
  try {
    console.log('=== Generating Story with Prompt File ===');

    const storyInput = {
      character: 'a friendly robot',
      setting: 'a magical library',
    };

    console.log('Story parameters:');
    console.log(`Character: ${storyInput.character}`);
    console.log(`Setting: ${storyInput.setting}`);

    const response = await storyGeneratorPrompt(storyInput);

    console.log('\n=== Generated Story ===');
    console.log(response.text());
  } catch (error) {
    console.error('Error generating story:', error);
  }
}

// Generate different stories
async function generateDifferentStories() {
  const stories = [
    { character: 'a curious cat', setting: 'a space station' },
    { character: 'a young wizard', setting: 'a bustling marketplace' },
    { character: 'a brave explorer', setting: 'an underwater city' },
  ];

  for (const story of stories) {
    console.log(`\n=== Story: ${story.character} in ${story.setting} ===`);
    const response = await storyGeneratorPrompt(story);
    console.log(response.text());
    console.log('\n' + '='.repeat(50));
  }
}

// Run examples
async function main() {
  await generateStory();
  await generateDifferentStories();
}

main();
```

### Create another simple prompt

Let's create another prompt for generating simple recipes. Create `prompts/recipe-generator.prompt`:

```
---
model: googleai/gemini-2.5-flash
input:
  schema:
    ingredient: string
    mealType: string
---

Create a simple recipe for {{mealType}} using {{ingredient}} as the main ingredient.
Keep it easy to follow with basic ingredients and simple steps.
```

### Test your prompts

Run the prompt-based example:

```bash
npx tsx src/example2-prompts.ts
```

You should see several different stories generated using your prompt file!

### View prompts in the Developer UI

With the Developer UI running (`genkit start -- tsx --watch src/index.ts`), you can see your prompts listed in the interface and test them with different inputs interactively.

**📚 Additional Resources:**

- [Dotprompt Documentation](https://genkit.dev/docs/dotprompt)
- [Handlebars Template Guide](https://handlebarsjs.com/guide/)
- [Prompt Engineering Best Practices](https://genkit.dev/docs/dotprompt#prompt-templates)
- [Schema Definition with Picoschema](https://genkit.dev/docs/dotprompt#picoschema)

---

## Example 3: Building Simple Genkit Flows

Duration: 15

Flows are reusable functions that can be called, tested, and monitored. They're perfect for building simple AI workflows.

### Create a basic greeting flow

Create `src/example3-flows.ts`:

```typescript
import { googleAI } from '@genkit-ai/google-genai';
import { genkit, z } from 'genkit';
import 'dotenv/config';

// Initialize Genkit with Google AI
const ai = genkit({
  plugins: [googleAI()],
  model: 'gemini-2.5-flash',
});

// Define a simple greeting flow
export const greetingFlow = ai.defineFlow(
  {
    name: 'greeting',
    inputSchema: z.object({
      name: z.string().describe("The person's name"),
      language: z.enum(['english', 'spanish', 'french']).describe('Language for greeting'),
    }),
    outputSchema: z.object({
      greeting: z.string().describe('The generated greeting'),
    }),
  },
  async ({ name, language }) => {
    // Generate the greeting
    const response = await ai.generate({
      prompt: `Create a friendly greeting for ${name} in ${language}. Keep it warm and welcoming.`,
    });

    return {
      greeting: response.text().trim(),
    };
  },
);

// Define a joke generator flow
export const jokeFlow = ai.defineFlow(
  {
    name: 'jokeGenerator',
    inputSchema: z.object({
      topic: z.string().describe('The topic for the joke'),
    }),
    outputSchema: z.object({
      joke: z.string().describe('The generated joke'),
    }),
  },
  async ({ topic }) => {
    // Generate a clean, family-friendly joke
    const response = await ai.generate({
      prompt: `Create a clean, family-friendly joke about ${topic}. Keep it short and funny.`,
    });

    return {
      joke: response.text().trim(),
    };
  },
);

// Example usage function
async function demonstrateFlows() {
  try {
    console.log('=== Testing Greeting Flow ===');

    const greetingResult = await greetingFlow({
      name: 'Alice',
      language: 'english',
    });

    console.log('Greeting Result:');
    console.log(greetingResult.greeting);

    console.log('\n=== Testing Joke Flow ===');

    const jokeResult = await jokeFlow({
      topic: 'programming',
    });

    console.log('Joke Result:');
    console.log(jokeResult.joke);

    console.log('\n=== Testing Multiple Greetings ===');
    const people = [
      { name: 'Bob', language: 'spanish' as const },
      { name: 'Claire', language: 'french' as const },
    ];

    for (const person of people) {
      const result = await greetingFlow(person);
      console.log(`${person.name} (${person.language}): ${result.greeting}`);
    }
  } catch (error) {
    console.error('Error running flows:', error);
  }
}

// Run the demonstration
demonstrateFlows();
```

````

### Create a package.json script

Add a script to your `package.json` to easily run the flows:

```json
{
  "scripts": {
    "example1": "tsx src/example1-basic.ts",
    "example2": "tsx src/example2-prompts.ts",
    "example3": "tsx src/example3-flows.ts",
    "studio": "genkit start"
  }
}
````

### Test your flows

Run the flows example:

```bash
npm run example3
```

### Test flows in the Developer UI

Start the Developer UI and navigate to the Flows section:

```bash
genkit start -- tsx --watch src/index.ts
```

In the Developer UI, you'll be able to:

- See all your defined flows
- Test them with custom inputs
- View execution traces and performance metrics
- Debug any issues step by step

**📚 Additional Resources:**

- [Creating Flows Documentation](https://genkit.dev/docs/flows)
- [Flow Debugging and Tracing](https://genkit.dev/docs/flows#debugging-flows)
- [Streaming Flows](https://genkit.dev/docs/flows#streaming-flows)
- [Flow Deployment Options](https://genkit.dev/docs/flows#deploying-flows)

---

## Testing and Debugging with Firebase Studio

Duration: 10

Firebase Studio provides a powerful interface for testing and debugging your Genkit applications.

### Key Features of Firebase Studio

1. **Flow Testing**: Interactive testing of your flows with custom inputs
2. **Prompt Management**: Visual editor for your prompts with real-time testing
3. **Model Comparison**: Test the same prompt with different models side by side
4. **Execution Traces**: Detailed view of each step in your flows
5. **Performance Monitoring**: Track response times and token usage

### Best Practices for Testing

1. **Start Simple**: Test basic functionality before adding complexity
2. **Use Diverse Inputs**: Test with various input types and edge cases
3. **Monitor Performance**: Watch token usage and response times
4. **Iterate on Prompts**: Use Studio to refine your prompts for better results
5. **Version Control**: Keep track of prompt changes and their performance

**📚 Additional Resources:**

- [Genkit Developer Tools Guide](https://genkit.dev/docs/devtools)
- [Local Observability](https://genkit.dev/docs/local-observability)
- [Testing Strategies](https://genkit.dev/docs/evaluation)
- [Performance Monitoring](https://genkit.dev/docs/observability/getting-started)

### Debugging Common Issues

#### API Key Problems

```bash
Error: Failed to authenticate with Google AI
```

- Check that your `GOOGLE_GENAI_API_KEY` is set correctly
- Verify the API key is valid and has proper permissions

#### Schema Validation Errors

```bash
Error: Output doesn't match expected schema
```

- Review your output schemas for accuracy
- Test with simpler schemas first
- Use Firebase Studio to see the raw model output

#### Rate Limiting

```bash
Error: Rate limit exceeded
```

- Implement retry logic with exponential backoff
- Consider using different models or reducing request frequency

**📚 Additional Resources:**

- [Error Types Documentation](https://genkit.dev/docs/error-types)
- [Troubleshooting Guide](https://genkit.dev/docs/observability/troubleshooting)
- [Google AI Rate Limits](https://ai.google.dev/pricing)
- [API Authentication Guide](https://ai.google.dev/aistudio/docs/get_api_key)

---

## Next Steps and Additional Resources

Duration: 5

Congratulations! You've learned the fundamentals of Firebase Genkit with TypeScript. Here's what you can explore next:

### Intermediate Topics

- **Custom Models**: Integrate other AI providers (OpenAI, Anthropic, local models)
- **Vector Databases**: Add semantic search capabilities with embeddings
- **Function Calling**: Enable AI to call your custom functions
- **Memory Management**: Implement conversation memory and context management

### Advanced Topics

- **Production Deployment**: Deploy your Genkit apps to Cloud Functions or Cloud Run
- **Monitoring and Analytics**: Set up comprehensive monitoring for your AI applications
- **Custom Plugins**: Build your own Genkit plugins
- **Multi-modal AI**: Work with images, audio, and video

### Useful Resources

1. **Official Documentation**: [Firebase Genkit Docs](https://firebase.google.com/docs/genkit)
2. **GitHub Repository**: [Genkit GitHub](https://github.com/firebase/genkit)
3. **Community**: [Firebase Discord](https://discord.gg/firebase)
4. **Examples**: [Genkit Samples](https://github.com/firebase/genkit/tree/main/samples)

### Sample Projects to Build

1. **AI Content Assistant**: Blog post generator with SEO optimization
2. **Code Review Bot**: Automated code analysis and suggestions
3. **Customer Service Chatbot**: Multi-turn conversations with context
4. **Document Processor**: Extract and analyze information from PDFs
5. **Language Learning App**: Personalized lessons and practice exercises

**📚 Additional Resources:**

- [Chat with PDF Tutorial](https://genkit.dev/docs/tutorials/chat-with-pdf)
- [YouTube Video Summarizer](https://genkit.dev/docs/tutorials/summarize-youtube-videos)
- [RAG Implementation Guide](https://genkit.dev/docs/rag)
- [Multi-Agent Systems](https://genkit.dev/docs/multi-agent)
- [Evaluation Framework](https://genkit.dev/docs/evaluation)

---

## Troubleshooting

Duration: 5

### Common Issues and Solutions

**Issue: "Module not found" errors**

```bash
npm install --save-dev @types/node
npm install dotenv
```

**Issue: TypeScript compilation errors**

```bash
npx tsc --noEmit  # Check for type errors
```

**Issue: "tsx command not found"**

```bash
npm install -g tsx  # Install tsx globally, or use npx tsx
```

**Issue: Firebase Studio not starting**

```bash
npx genkit start --port 4000  # Try different port
```

**Issue: API rate limits**

- Implement exponential backoff
- Use batch processing for multiple requests
- Consider upgrading your API plan

### Getting Help

- Check the [GitHub Issues](https://github.com/firebase/genkit/issues)
- Join the [Firebase Discord](https://discord.gg/firebase)
- Post questions on [Stack Overflow](https://stackoverflow.com/questions/tagged/firebase-genkit)

**📚 Additional Resources:**

- [Community Guidelines](https://github.com/firebase/genkit/blob/main/CONTRIBUTING.md)
- [API References](https://genkit.dev/docs/api-references)
- [Feedback and Feature Requests](https://genkit.dev/docs/feedback)
- [Security and Best Practices](https://genkit.dev/docs/deployment/authorization)

---

## Conclusion

Duration: 2

You've successfully built three different patterns for working with Firebase Genkit:

1. **Direct AI Generation**: Quick and simple for basic use cases
2. **Prompt Management**: Organized and maintainable for complex prompts
3. **Flows**: Powerful and reusable for complex AI workflows

These patterns form the foundation for building sophisticated AI-powered applications. Start with simple use cases and gradually build more complex workflows as you become comfortable with the framework.

**📚 Continue Your Journey:**

- [Advanced Genkit Patterns](https://genkit.dev/docs/)
- [Production Deployment](https://genkit.dev/docs/deployment/)
- [Community Examples](https://github.com/firebase/genkit/tree/main/samples)
- [Latest Updates and Releases](https://github.com/firebase/genkit/releases)

Happy building with Firebase Genkit! 🚀
