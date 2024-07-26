use dep::std::ec::tecurve::affine::{Curve, Point};

pub fn field_from_bytes(bytes: [u8; 32], big_endian: bool) -> Field {
    let mut as_field: Field = 0;
    let mut offset = 1;
    for i in 0..32 {
        let index = if big_endian { 31 - i } else { i };
        as_field += (bytes[index] as Field) * offset;
        offset *= 256;
    }

    as_field
}
/// Generates a public key from a private key using the Baby JubJub curve.
/// # Arguments
/// * `private_key` - A field element representing the private key.
/// * `base_point` - A point on the Baby JubJub curve used as the base point.
/// # Returns
/// A `Point` on the Baby JubJub curve representing the public key.
fn generate_public_key(private_key: Field, base_point: Point) -> Point {
    let baby_jubjub_curve = Curve::new(168700, 168696, base_point);
    baby_jubjub_curve.mul(private_key, base_point)
}

// ECDH Circuit
fn main(private_key1: [u8; 32], private_key2: [u8; 32]) {
    let base_point = Point::new(
        5299619240641551281634865583518297030282874472190772894086521144482721001553,
        16950150798460657717958625567821834550301663161624707787222815936182638968203,
    );
    let private_key3 = field_from_bytes(private_key1, true);
    let private_key4 = field_from_bytes(private_key2, true);
    let public_key1 = generate_public_key(private_key3, base_point);
    let public_key2 = generate_public_key(private_key4, base_point);
    // Generate Both ECDH Shared Keys - Scalar Multiply
    let shared_key1 = generate_public_key(private_key4, public_key1);
    let shared_key2 = generate_public_key(private_key3, public_key2);
    assert(shared_key1 == shared_key2);
}

// Add Individual Function Tests Here
