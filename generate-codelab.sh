#!/bin/bash

# Regenerate Firebase Genkit TypeScript Codelab
# This script converts the README.md to a codelab using claat

echo "🔄 Regenerating Firebase Genkit TypeScript Codelab..."

# Check if claat is installed
if ! command -v claat &> /dev/null; then
    echo "❌ claat is not installed. Please install it first:"
    echo "   go install github.com/googlecodelabs/tools/claat@latest"
    exit 1
fi

# Create docs directory if it doesn't exist
mkdir -p docs

# Export the codelab
echo "📝 Converting README.md to codelab format..."
claat export -o docs README.md

if [ $? -eq 0 ]; then
    echo "✅ Codelab generated successfully!"
    echo "📁 Output directory: docs/firebase-genkit-typescript-codelab/"
    echo "🌐 You can now serve the docs directory with:"
    echo "   cd docs && python -m http.server 8000"
    echo "   or"
    echo "   cd docs && npx serve ."
else
    echo "❌ Failed to generate codelab"
    exit 1
fi