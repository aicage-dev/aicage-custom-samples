#!/usr/bin/env python3
import json
from pathlib import Path


def main() -> int:
    agents = sorted(path.name for path in Path("agents").iterdir() if path.is_dir())
    matrix = [{"agent": agent} for agent in agents]
    print(json.dumps({"include": matrix}, separators=(",", ":")))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
