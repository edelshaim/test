#!/usr/bin/env python3
"""Convert DOCX files to cleaned text files."""

import argparse
import os
import re
from docx import Document


def clean_text(text: str) -> str:
    """Clean up whitespace in extracted text."""
    lines = [re.sub(r"\s+", " ", line.strip()) for line in text.splitlines()]
    lines = [line for line in lines if line]
    return "\n".join(lines)


def process_docx(path: str, output_dir: str) -> str:
    """Read a DOCX file, clean it, and write a .txt file.

    Args:
        path: Path to the .docx file.
        output_dir: Directory to place the output file.

    Returns:
        Path to the written .txt file.
    """
    document = Document(path)
    paragraphs = [para.text for para in document.paragraphs]
    raw_text = "\n".join(paragraphs)
    cleaned = clean_text(raw_text)

    base = os.path.splitext(os.path.basename(path))[0]
    output_path = os.path.join(output_dir, base + ".txt")
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(cleaned)
    return output_path


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Convert DOCX files to cleaned text files"
    )
    parser.add_argument("files", nargs="+", help="Input DOCX files")
    parser.add_argument(
        "-o",
        "--output",
        default=".",
        help="Output directory (default: current directory)",
    )
    args = parser.parse_args()

    os.makedirs(args.output, exist_ok=True)

    for file in args.files:
        path = process_docx(file, args.output)
        print(f"Wrote {path}")


if __name__ == "__main__":
    main()
