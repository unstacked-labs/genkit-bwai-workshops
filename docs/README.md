# Firebase Genkit Codelabs

This directory contains interactive codelabs for learning Firebase Genkit with TypeScript.

## Available Codelabs

### [Getting Started with Firebase Genkit and TypeScript](firebase-genkit-typescript-codelab/)

Learn the fundamentals of building AI-powered applications with Firebase Genkit and TypeScript.

**What you'll learn:**

- Setting up Firebase Genkit in a TypeScript project
- Using the `ai.generate` API for direct AI interactions
- Managing prompts with `.prompt` files
- Building and testing Genkit flows
- Using Firebase Studio for testing and debugging

**Duration:** 45-60 minutes  
**Level:** Beginner  
**Prerequisites:** Basic TypeScript/JavaScript knowledge

## Running Locally

To run these codelabs locally:

1. Clone the repository
2. Navigate to the `docs` directory
3. Start a local server:
   ```bash
   python -m http.server 8000
   # or
   npx serve .
   ```
4. Open `http://localhost:8000` in your browser

## GitHub Pages

These codelabs are automatically published to GitHub Pages when changes are pushed to the main branch.

## Contributing

To update or add new codelabs:

1. Edit the source markdown files
2. Regenerate the codelab using `claat export -o docs README.md`
3. Commit and push your changes

## Resources

- [Firebase Genkit Documentation](https://genkit.dev)
- [Firebase Genkit GitHub](https://github.com/firebase/genkit)
- [Firebase Discord Community](https://discord.gg/firebase)
