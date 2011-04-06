#!/usr/bin/env python

import libxml2
import libxslt
from PIL import Image

image_sizes = {}

def get_image_size(image_path):
    if image_path not in image_sizes:
        size = (0,0)
        try:
            im = Image.open(image_path)
            size = im.size
        except IOError:
            pass
        image_sizes[image_path] = size
    return image_sizes[image_path]


def get_image_width(ctx, image_path):
    size = get_image_size(str(image_path))
    return size[0]

def get_image_height(ctx, image_path):
    size = get_image_size(str(image_path))
    return size[1]

def process(infile, xslt, outfile):
    NS = 'http://adamhooper.com/xslt/extension'

    libxslt.registerExtModuleFunction('image-width', NS, get_image_width)
    libxslt.registerExtModuleFunction('image-height', NS, get_image_height)

    stylesheet = libxslt.parseStylesheetFile(xslt)

    doc = libxml2.parseFile(infile)

    result = stylesheet.applyStylesheet(doc, None)

    outfile.write(stylesheet.saveResultToString(result))

if __name__ == '__main__':
    process('mrp.fodt', 'barrick.xslt', open('index.html', 'w'))
