from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import subprocess
from pathlib import Path
from urllib.parse import quote


DECKTAPE_PARAMS = "handout=true&pdfSeparateFragments=false"
HASH_FILE = ".pdf_hashes.json"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Render revealjs handout PDFs from an already-rendered site tree."
    )
    parser.add_argument("--site-dir", type=Path, required=True)
    parser.add_argument("--base-url", required=True)
    parser.add_argument("--output-dir", type=Path)
    parser.add_argument("--glob", default="lectures/**/lecture_*.html")
    parser.add_argument("--size", default="1920x1400")
    parser.add_argument("--pause", type=int, default=250)
    parser.add_argument("--load-pause", type=int, default=500)
    return parser.parse_args()


def find_decktape() -> str:
    path = shutil.which("decktape")
    if path:
        return path
    for runner in ("bunx", "npx"):
        if shutil.which(runner):
            return runner
    raise FileNotFoundError(
        "decktape not found. Install with: npm install -g decktape"
    )


def build_url(base_url: str, relative_path: Path) -> str:
    relative_url = "/".join(quote(part) for part in relative_path.parts)
    return f"{base_url.rstrip('/')}/{relative_url}?{DECKTAPE_PARAMS}"


def file_hash(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_hashes(output_dir: Path) -> dict[str, str]:
    hash_path = output_dir / HASH_FILE
    if hash_path.exists():
        return json.loads(hash_path.read_text())
    return {}


def save_hashes(output_dir: Path, hashes: dict[str, str]) -> None:
    (output_dir / HASH_FILE).write_text(json.dumps(hashes, indent=2) + "\n")


def main() -> int:
    args = parse_args()
    site_dir = args.site_dir.resolve()
    output_dir = (args.output_dir or args.site_dir).resolve()

    if not site_dir.is_dir():
        raise FileNotFoundError(f"Site directory does not exist: {site_dir}")

    html_paths = sorted(path for path in site_dir.glob(args.glob) if path.is_file())
    if not html_paths:
        raise FileNotFoundError(
            f"No lecture HTML files matched {args.glob!r} under {site_dir}"
        )

    decktape = find_decktape()
    is_runner = decktape in ("bunx", "npx")

    old_hashes = load_hashes(output_dir)
    new_hashes: dict[str, str] = {}

    for html_path in html_paths:
        relative_html = html_path.relative_to(site_dir)
        pdf_path = output_dir / relative_html.with_suffix(".pdf")
        pdf_path.parent.mkdir(parents=True, exist_ok=True)

        key = str(relative_html)
        current_hash = file_hash(html_path)
        new_hashes[key] = current_hash

        if old_hashes.get(key) == current_hash and pdf_path.exists():
            print(f"Unchanged {relative_html}, skipping", flush=True)
            continue

        url = build_url(args.base_url, relative_html)
        print(
            f"Printing {relative_html} -> {pdf_path.relative_to(output_dir)}",
            flush=True,
        )

        cmd = []
        if is_runner:
            cmd = [decktape, "decktape"]
        else:
            cmd = [decktape]

        cmd += [
            "reveal",
            url,
            str(pdf_path),
            "--size", args.size,
            "--pause", str(args.pause),
            "--load-pause", str(args.load_pause),
            "--chrome-arg=--no-sandbox",
        ]

        result = subprocess.run(cmd, check=False)
        if result.returncode != 0:
            raise RuntimeError(
                f"decktape failed for {relative_html} (exit {result.returncode})"
            )

    save_hashes(output_dir, new_hashes)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
