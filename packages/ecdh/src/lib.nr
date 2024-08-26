mod globals;
use dep::std::ec::tecurve::affine::{Curve, Point};

// @@@@@@ Core ECDH Implementation

/// Converts a byte array to a field element.
/// # Arguments
/// * `bytes` - A fixed-size array of 32 bytes.
/// * `big_endian` - A boolean indicating if the byte array is in big-endian format.
/// # Returns
/// A `Field` element representing the converted byte array.
pub fn field_from_bytes(bytes: [u8; 32], big_endian: bool) -> Field {
    let mut as_field: Field = 0;
    let mut offset: Field = 1;

    for i in 0..32 {
        let index = if big_endian { 31 - i } else { i };
        as_field += (bytes[index] as Field) * offset;
        offset *= 256;
    }

    as_field
}

/// Computes a public key from a private key using the Baby JubJub curve.
/// # Arguments
/// * `private_key` - The private key as a `Field` element.
/// # Returns
/// The corresponding `Point` on the Baby JubJub curve.
pub fn derive_public_key(private_key: Field) -> Point {
    let base_point = Point::new(
        5299619240641551281634865583518297030282874472190772894086521144482721001553,
        16950150798460657717958625567821834550301663161624707787222815936182638968203,
    );
    let baby_jubjub_curve = Curve::new(168700, 168696, base_point);
    baby_jubjub_curve.mul(private_key, base_point)
}

/// Optimized public key derivation using Baby JubJub curve.
/// # Arguments
/// * `private_key` - The private key as a `Field` element.
/// # Returns
/// The public key as a `Point` on the Baby JubJub curve.
pub fn derive_public_key_optimized(private_key: Field) -> Point {
    let X = globals::BJJ.curve.mul(private_key, globals::G);
    X
}

/// Computes a shared secret key using ECDH with the Baby JubJub curve.
/// # Arguments
/// * `private_key` - The private key as a `Field` element.
/// * `public_key` - The public key as a `Point` on the Baby JubJub curve.
/// # Returns
/// The shared secret key as a `Field` element.
pub fn derive_shared_key(private_key: Field, public_key: Point) -> Field {
    let shared_key = globals::BJJ.curve.mul(private_key, public_key);
    shared_key.x
}
