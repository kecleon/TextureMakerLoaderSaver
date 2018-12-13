# TextureMakerLoaderSaver
A modified TextureMaker (commonly referred to as the **draw tool**) for **Realm of the Mad God** that allows for PNG **saving** and **loading**, and more.

## Features:  
- Support for more sizes (24x24, 32x32, 48x48, 56x56, 64x64) in addition to the default 8x8, 16x8, and 16x16.
- Load has been replaced with a local file picker that loads PNGs into the canvas.
- Save has been replaced with a PNG file exporter.

## Planned:
- Loading from existing in game sprite content.

## Issues:
- Images must be non interlaced, and 8bcp RGBA, to appear correctly.

## Pictures:

Loading a Bulbasaur sprite:  
![Loading a Sprite](https://raw.githubusercontent.com/kecleon/TextureMakerLoaderSaver/master/Example%201.png)

Exporting the Bulbasaur sprite preview at 60% scaling:  
![Preview of Sprite](https://raw.githubusercontent.com/kecleon/TextureMakerLoaderSaver/master/Example%202.png)
