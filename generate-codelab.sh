#!/bin/bash

# Regenerate Firebase Genkit Codelabs
# This script converts the README files to codelabs using claat

echo "🔄 Regenerating Firebase Genkit Codelabs..."

# Check if claat is installed
if ! command -v claat &> /dev/null; then
    echo "❌ claat is not installed. Please install it first:"
    echo "   go install github.com/googlecodelabs/tools/claat@latest"
    exit 1
fi

# Create docs directory if it doesn't exist
mkdir -p docs

# Export the TypeScript codelab
echo "📝 Converting README.md to TypeScript codelab format..."
claat export -o docs README.md

if [ $? -eq 0 ]; then
    echo "✅ TypeScript codelab generated successfully!"
else
    echo "❌ Failed to generate TypeScript codelab"
    exit 1
fi

# Export the Go codelab
echo "📝 Converting README-go.md to Go codelab format..."
claat export -o docs README-go.md

if [ $? -eq 0 ]; then
    echo "✅ Go codelab generated successfully!"
else
    echo "❌ Failed to generate Go codelab"
    exit 1
fi

echo "📁 Output directory: docs/"
echo "   - TypeScript: docs/firebase-genkit-typescript-codelab/"
echo "   - Go: docs/firebase-genkit-go-codelab/"
echo "🌐 You can now serve the docs directory with:"
echo "   cd docs && python -m http.server 8000"
echo "   or"
echo "   cd docs && npx serve ."