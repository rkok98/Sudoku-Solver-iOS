import Cocoa

let index = 43
//
// let x = index / width
// let y = index % width
//
// let res = x + y * width
//
// let a = ((x / 3) * 3) + (y / 3)

let boxwidth  = 3   /* Width of a small box */
let boxheight = 3   /* Height of a small box */

let hboxes    = 3   /* Boxes horizontally */
let vboxes    = 3   /* Boxes vertically */

let width  = boxwidth * hboxes
let height = boxheight * vboxes

let x = index / width
let y = index % width

