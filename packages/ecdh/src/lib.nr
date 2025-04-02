mod bjj;
use ec::tecurve::affine::Point ;

mod gpk;
use ec::swcurve::affine::Point as SWPoint;

pub trait ECDHTrait {
    fn new(private_key: Field) -> Self;
    fn derive_public_key(self) -> Point;
    fn derive_shared_key(self, public_key: Point) -> Field;
}

pub trait ECDHSWTrait {
    fn new(private_key: Field) -> Self;
    fn derive_public_key(self) -> SWPoint;
    fn derive_shared_key(self, public_key: SWPoint) -> Field;
}
