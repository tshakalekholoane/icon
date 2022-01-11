#!/bin/sh
# Generates iOS and macOS app icons from an image.

if [[ -z $(which sips) ]];then
  printf "This script requires the sips program to run.\n"
  exit 1
fi

case $1 in
  "" | -h | --help)
    less << EOF
                                    icon(1)
NAME
    icon -- generate iOS and macOS app icons from an image 

SYNOPSIS
    icon.sh [-him] image lowresimage filename

OPTIONS
    -h, --help      Show this help document.
    -i, --ios       Generate iOS app icons.    
    -m, --macOS     Generate macOS app icons.    

EXAMPLES
    The following commands will create an .iconset folder in the directory that
    this script is run in.

    To generate iOS icons:

      ./icon.sh --ios <path to image>
    
    To generate macOS icons:

      ./icon.sh --macos <path to image>

    There is also an option to specify a separate image for lower resolutions 
    (sub 64 x 64 pixels) for macOS as per Apple's Human Interface guidelines:

      ./icon.sh --macos <path to high res image> <path to low res image>
    
    Optionally, the name of the resulting .iconset folder can also be specified
    at the end of each of the above commands. For example, to specify a name 
    for the resulting iOS .iconset,

      ./icon.sh --ios <path to image> <name of the resulting .iconset>

                                29th April 2021
EOF
    ;;
  -i | --ios | -m | --macos)
    if [[ -f $2 ]]; then
      height=$(sips --getProperty pixelHeight $2 | grep -oE '([0-9]+)$')
      width=$(sips --getProperty pixelWidth $2 | grep -oE '([0-9]+)$')
      if [[ $width != 1024 && $height != 1024 ]]; then
        printf "Dimensions of the image have to be 1024px by 1024px.\n"
        exit 1
      fi
      if [[ $(sips --getProperty hasAlpha $2 | grep -oE 'yes') != "yes" ]]; then
        printf "Requires image with an alpha channel.\n"
        exit 1
      fi
      if [[ $1 = "-m" || $1 = "--macos" ]]; then
        if [[ -f $3 ]]; then
          if [[ -z "$4" ]]; then
            name="untitled.iconset"
          else
            name=$4.iconset
          fi
          mkdir $name 2>/dev/null
          sips --resampleHeightWidth 16 16 $3 --out $name/icon_16x16.png >/dev/null
          sips --resampleHeightWidth 32 32 $3 --out $name/icon_16x16@2x.png >/dev/null
          sips --resampleHeightWidth 32 32 $3 --out $name/icon_32x32.png >/dev/null
          sips --resampleHeightWidth 64 64 $3 --out $name/icon_32x32@2x.png >/dev/null
        else 
          if [[ -z "$3" ]]; then
            name="untitled.iconset"
          else
            name=$3.iconset
          fi
          mkdir $name 2>/dev/null
          sips --resampleHeightWidth 16 16 $2 --out $name/icon_16x16.png >/dev/null
          sips --resampleHeightWidth 32 32 $2 --out $name/icon_16x16@2x.png >/dev/null
          sips --resampleHeightWidth 32 32 $2 --out $name/icon_32x32.png >/dev/null
          sips --resampleHeightWidth 64 64 $2 --out $name/icon_32x32@2x.png >/dev/null
        fi
        sips --resampleHeightWidth 128 128 $2 --out $name/icon_128x128.png >/dev/null
        sips --resampleHeightWidth 256 256 $2 --out $name/icon_128x128@2x.png >/dev/null
        sips --resampleHeightWidth 256 256 $2 --out $name/icon_256x256.png >/dev/null
        sips --resampleHeightWidth 512 512 $2 --out $name/icon_256x256@2x.png >/dev/null
        # sips --resampleHeightWidth 512 512 $2 --out $name/icon_512x512.png >/dev/null
        cp $2 $name/icon_512x512@2x.png
      else
        if [[ -f $3 ]]; then
          printf "Low resolution icons are not generated for iOS.\n"
          exit 1
        fi
        if [[ -z "$3" ]]; then
         name="untitled.iconset"
        else
         name=$3.iconset
        fi
        mkdir $name 2>/dev/null
        # iOS.
        sips --resampleHeightWidth 40 40 $2 --out $name/icon_20x20@2x.png >/dev/null
        sips --resampleHeightWidth 60 60 $2 --out $name/icon_20x20@3x.png >/dev/null
        sips --resampleHeightWidth 58 58 $2 --out $name/icon_29x29@2x.png >/dev/null
        sips --resampleHeightWidth 87 87 $2 --out $name/icon_29x29@3x.png >/dev/null
        sips --resampleHeightWidth 80 80 $2 --out $name/icon_40x40@2x.png >/dev/null
        sips --resampleHeightWidth 120 120 $2 --out $name/icon_40x40@3x.png >/dev/null
        # sips --resampleHeightWidth 120 120 $2 --out $name/icon_60x60@2x.png >/dev/null
        sips --resampleHeightWidth 180 180 $2 --out $name/icon_60x60@3x.png >/dev/null
        # iPadOS.
        sips --resampleHeightWidth 20 20 $2 --out $name/icon_20x20.png >/dev/null
        sips --resampleHeightWidth 29 29 $2 --out $name/icon_29x29.png >/dev/null
        sips --resampleHeightWidth 76 76 $2 --out $name/icon_76x76.png >/dev/null
        sips --resampleHeightWidth 152 152 $2 --out $name/icon_76x76@2x.png >/dev/null
        sips --resampleHeightWidth 167 167 $2 --out $name/icon_83.5x83.5@2x.png >/dev/null
        cp $2 $name/icon_1024x1024.png
      fi
    else
      printf "Image not found.\n"
    fi
    ;;
  *)
    printf "There is no $1 option. Use -h to see a list of available options.\n"
    ;;
esac
