mod globals;
use dep::std;
use dep::std::ec::tecurve::affine::{Curve, Point};

// @@@@@@ Core ECDSA Implementation

pub fn calculate_signature(message: [u8; 32], random_nonce: Field, private_key: Field) -> (Field, Field) {
    let z = field_from_bytes(std::hash::sha256(message), true);
    let k = random_nonce;
    let point = globals::BJJ.curve.mul(k, globals::G);
    let r = reduce_field(point.x);
    let s = reduce_field(mod_inv(k, globals::BJJ_ORDER) * (z + r * private_key));
    if (r == 0) | (s == 0){
        assert(false);
    } 
    (r, s)
}



pub fn reduce_field(x: Field) -> Field {
    let order = globals::BJJ_ORDER;
    let mut result = x;
    for _ in 0..100 {  // Adjust this range as needed
        let difference = result - order;
        let is_negative = difference as i64 < 0;
        result = if is_negative { result } else { difference };
    }
    result
}



// Verify Signature

pub fn verify_signature(signature: [u8; 64], message_hash: [u8]){

}

// Mod Inverse 



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
pub fn derive_public_key_optimized(private_key: Field) -> Point{
    let X = globals::BJJ.curve.mul(private_key, globals::G);
    X
}


