
#!/usr/bin/env python3

import sys
from pathlib import Path

try:
    import tomllib
except ImportError:
    import tomli as tomllib

snippet_file = Path.home() / ".config/pet/snippet.toml"

with snippet_file.open("rb") as f:
    snippets = tomllib.load(f)["snippets"]

selected = sys.argv[1]

for snippet in snippets:
    description = snippet["description"]

    if selected.startswith(f"[{description}]"):
        print(snippet["command"])
        break

