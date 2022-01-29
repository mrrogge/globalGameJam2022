package com;

/**
    Defines different kinds of sprites. These can be either simple rects of one solid color, or a region of an image resource.
**/
enum SpriteKind {
    RECT(x:Int, y:Int, w:Int, h:Int, color:Int, alpha:Float);
    IMG(img:hxd.res.Image, x:Int, y:Int, w:Int, h:Int, dx:Int, dy:Int);
}