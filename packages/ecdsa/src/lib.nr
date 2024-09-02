mod globals;
use dep::std;
use dep::std::ec::tecurve::affine::{Curve, Point};

// @@@@@@ Core ECDSA Implementation

/// Calculates an ECDSA signature for a given message using a private key and a random nonce.
/// # Arguments
/// * `message` - A 32-byte array representing the message to be signed.
/// * `random_nonce` - A `Field` element representing the random nonce used in the signature generation.
/// * `private_key` - A `Field` element representing the signer's private key.
/// # Returns
/// A tuple containing two `Field` elements (r, s) that represent the ECDSA signature.
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


/// Reduces a field element modulo the order of the curve to ensure it lies within the valid range.
/// # Arguments
/// * `x` - A `Field` element to be reduced.
/// # Returns
/// A `Field` element that represents `x` reduced modulo the order of the Baby JubJub curve.
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



/// Verifies an ECDSA signature against a given message hash.
/// # Arguments
/// * `signature` - A 64-byte array representing the signature to be verified.
/// * `message_hash` - A byte array representing the hash of the message that was signed.
/// # Returns
/// A boolean indicating whether the signature is valid (`true`) or not (`false`).
pub fn verify_signature(signature: (Field, Field), message: [u8; 32], public_key: Point) -> bool {
    let (r, s) = signature;
    
    let range_check = (r as i64 != 0) & (r as i64 < globals::BJJ_ORDER as i64) & 
                      (s as i64 != 0) & (s as i64 < globals::BJJ_ORDER as i64);
    
    if range_check {
        // Calculate the message hash
        let z = field_from_bytes(std::hash::sha256(message), true);
        
        // Calculate s_inv (modular inverse of s)
        let s_inv = mod_inv(s, globals::BJJ_ORDER);
        
        // Calculate u1 and u2
        let u1 = z * s_inv;
        let u2 = r * s_inv;
        
        // Calculate the point R = u1*G + u2*public_key
        let R1 = globals::BJJ.curve.mul(u1, globals::G);
        let R2 = globals::BJJ.curve.mul(u2, public_key);
        let R = R1.add(R2);
        
        // Check if R.x mod n == r
        let v = reduce_field(R.x);
        v as i64 == r as i64
    } else {
        false
    }
}


/// Computes the modular inverse of a field element with respect to a given modulus.
/// # Arguments
/// * `a` - A `Field` element for which the modular inverse is to be calculated.
/// * `m` - A `Field` element representing the modulus.
/// # Returns
/// The modular inverse of `a` modulo `m`.
pub fn mod_inv(a: Field, m: Field) -> Field {
    let mut t = 0;
    let mut new_t = 1;
    let mut r = m;
    let mut new_r = a;

    for _ in 0..254 {  // Assuming 254-bit field, adjust if necessary
        if new_r == 0 {
            assert(r as i64 > 1, "modular inverse does not exist");
            if t < 0 {
                t += m as u64;
            }
            result = t;
            break;
        }

        let quotient = r / new_r;

        let temp_t = new_t;
        new_t = t - quotient * new_t;
        t = temp_t;

        let temp_r = new_r;
        new_r = r - quotient * new_r;
        r = temp_r;
    }

    assert(false, "modular inverse calculation did not converge");
    0 // This line will never be reached due to the assert, but is needed for compilation
}



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


