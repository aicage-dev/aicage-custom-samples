#!/usr/bin/env python3
import json
from pathlib import Path


def main() -> int:
    bases = sorted(path.name for path in Path("base-images").iterdir() if path.is_dir())
    matrix = [{"base": base} for base in bases]
    print(json.dumps({"include": matrix}, separators=(",", ":")))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
