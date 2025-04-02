use crate::ECDHSWTrait;
use ec::swcurve::affine::{Curve, Point};

pub struct Grumpkin {
    pub private_key: Field,
    pub curve: Curve,
}

impl ECDHSWTrait for Grumpkin {
    fn new(private_key: Field) -> Self {
        let curve = create_grumpkin_curve();
        Self { curve, private_key }
    }

    fn derive_public_key(self) -> Point {
        // Use the stored curve instance
        self.curve.mul(self.private_key, self.curve.gen)
    }

    fn derive_shared_key(self, public_key: Point) -> Field {
        // Use the stored curve instance
        let shared_point = self.curve.mul(self.private_key,public_key);
        
        // Return x-coordinate as the shared secret
        shared_point.x
    }
}


fn create_grumpkin_curve() -> Curve {
    // Let Noir handle the field arithmetic
    let a = 0;
    let b = -17; 
    
    let gen_x = 1;
    let gen_y = 0x2cf135e7506a45d632d270d45f1181294833fc48d823f272c;
    
    let generator = Point::new(gen_x, gen_y);
    Curve::new(a, b, generator)
}
