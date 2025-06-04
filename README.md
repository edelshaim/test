# DOCX to Text Converter

This simple Python app converts one or more `.docx` files into cleaned
`.txt` files suitable for further AI processing.

## Setup

Install dependencies with `pip`:

```bash
pip install -r requirements.txt
```

## Usage

Run the script and pass one or multiple DOCX files. Optionally specify an
output directory with `-o`.

```bash
python docx_to_txt.py input1.docx input2.docx -o output_dir
```

Each converted file will be written with the same base name and a `.txt`
extension in the chosen output directory.
