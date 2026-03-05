#!/bin/bash

HTML_FILE="portkey.html"

if [ ! -f "$HTML_FILE" ]; then
    echo "Error: $HTML_FILE not found."
    echo "Please save the HTML of the Portkey models page to a file named '$HTML_FILE' in this directory."
    exit 1
fi

# Use a highly reliable inline Python script to parse the model and provider blocks
python3 -c "
import re, sys
try:
    with open('$HTML_FILE', 'r') as f:
        html = f.read()

    # Split by the aria-label to process each model card individually
    blocks = html.split('aria-label=\"View details for ')
    for block in blocks[1:]:
        model_match = re.search(r'^([^\"]+)\"', block)
        provider_match = re.search(r'By\s+([^<]+)</div>', block)
        if model_match and provider_match:
            provider = provider_match.group(1).strip()
            model = model_match.group(1).strip()
            print(f'{provider} {model}')
except Exception as e:
    print(f'Error parsing HTML: {e}', file=sys.stderr)
    sys.exit(1)
"
