# `icon`

```
                                    icon(1)
NAME
    icon -- generate iOS and macOS app icons from an image 

SYNOPSIS
    icon.sh [-him] image lowresimage filename

OPTIONS
    -h, --help      Show this help document.
    -i, --ios       Generate iOS app icons.    
    -m, --macOS     Generate macOS app icons. 
```

## About 

This script is a wrapper around the image processing program `sips` found on macOS with the aim of simplifying the process of generating different app icon sizes for iOS and macOS applications. 

## Getting started

First, give executable permissions to the script:

```bash
$ chmod +x ./icon.sh
```

## Examples

To generate iOS icons:

```bash
$ ./icon.sh --ios <path to image>
```

To generate macOS icons:

```bash
$ ./icon.sh --macos <path to image>
```

There is also an option to specify a separate image for lower resolutions (sub 64 x 64 pixels) for macOS as per Apple's Human Interface guidelines:

```
$ ./icon.sh --macos <path to high res image> <path to low res image>
```

Optionally, the name of the resulting .iconset folder can also be specified at the end of each of the above commands. For example, to specify a name for the resulting iOS .iconset,

```
$ ./icon.sh --ios <path to image> <name of the resulting .iconset>
```

## Apple Icon Image format (ICNS)

Although the use of the ICNS image format has been discouraged since macOS 11, an .icns file can still be generated using the following command after generating an .iconset using the instructions above.

```
$ iconutil --convert icns <name of the generated iconset>.iconset
```
