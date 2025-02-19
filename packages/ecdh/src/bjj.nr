use crate::ECDHTrait;
use ec::consts::te::{baby_jubjub, BabyJubjub};
use ec::tecurve::affine::Point;

pub struct BJJ {
    pub private_key: Field,
    pub bjj: BabyJubjub,
}

impl ECDHTrait for BJJ {
    fn new(private_key: Field) -> Self {
        let bjj = baby_jubjub();
        Self { bjj, private_key }
    }

    fn derive_public_key(self) -> Point {
        self.bjj.curve.mul(self.private_key, self.bjj.base8)
    }

    fn derive_shared_key(self, public_key: Point) -> Field {
        let shared_key = self.bjj.curve.mul(self.private_key, public_key);
        shared_key.x
    }
}
