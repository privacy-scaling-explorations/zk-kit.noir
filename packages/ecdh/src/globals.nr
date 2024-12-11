// Globals Edward Curves supported Baby JubJub
use ec::consts::te::{baby_jubjub, BabyJubjub};
use ec::tecurve::affine::Point;

global BJJ: BabyJubjub = baby_jubjub();
global G: Point = BJJ.base8;
