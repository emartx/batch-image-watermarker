# Batch Image Watermarker

A small Bash script that uses ImageMagick to add a watermark to every `.jpg`,
`.jpeg`, `.png`, and `.webp` image directly inside `input/`. It saves the results
in `output/` using the original filenames and leaves the source images unchanged.

The watermark appears in the bottom-left corner, scaled to 20% of each image's
width. Its alpha is multiplied by 0.45, with horizontal and vertical margins of
4% and 2% of the image width, respectively.

## Prerequisites

- Bash.
- ImageMagick 7, with the `magick` command available on your `PATH`.
- A watermark image named `watermark.png` in the project root.
  Supply your own image; a PNG with a transparent background works well.

On macOS, install ImageMagick using [Homebrew](https://brew.sh/):

```sh
brew install imagemagick
```

For other platforms, follow the
[official ImageMagick installation instructions](https://imagemagick.org/script/download.php/).
Ensure you install version 7, since the script uses `magick`.

Check that it is installed:

```sh
magick -version
```

## Run

Run these commands from the project root:

```sh
mkdir -p input
```

Place your source images in `input/` and your watermark at
`watermark.png`, then run:

```sh
bash watermark.sh
```

The script creates `output/` automatically. Running it again overwrites output
files with matching names. It processes lowercase extensions only and does not
search subdirectories. Both `input/` and `output/` are ignored by Git.

## Customize

Edit `INPUT`, `OUTPUT`, and `WATERMARK` at the top of `watermark.sh` to change
the paths. Adjust `wm_width`, `margin_x`, `margin_y`, or the alpha multiplier
to change the watermark's size, spacing, or opacity.
