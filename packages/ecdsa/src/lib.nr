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
pub fn calculate_signature(
    message: [u8; 32],
    random_nonce: Field,
    private_key: Field,
) -> (u64, u64) {
    let z = field_from_bytes(std::hash::sha256(message), true);
    // Noir cannot generate a random number, needs to be inputted from Integration Tests
    let k = random_nonce;
    // Random Point
    let point = globals::BJJ.curve.mul(k, globals::G);
    let r = (point.x as u64) % (globals::BJJ_ORDER as u64);
    let s = ((mod_inv(k, globals::BJJ_ORDER) as u64) * ((z as u64) + r * (private_key as u64)))
        as u64
        % globals::BJJ_ORDER as u64;
    if (r == 0) | (s == 0) {
        assert(false);
    }
    (r, s)
}

/// Verifies an ECDSA signature against a given message hash.
/// # Arguments
/// * `signature` - A 64-byte array representing the signature to be verified.
/// * `message_hash` - A byte array representing the hash of the message that was signed.
/// # Returns
/// A boolean indicating whether the signature is valid (`true`) or not (`false`).
pub fn verify_signature(signature: (Field, Field), message: [u8; 32], public_key: Point) -> bool {}

/// Computes the modular inverse of a field element with respect to a given modulus.
/// # Arguments
/// * `a` - A `Field` element for which the modular inverse is to be calculated.
/// * `m` - A `Field` element representing the modulus.
/// # Returns
/// The modular inverse of `a` modulo `m`.
pub fn mod_inv(a: Field, m: Field) -> Field {
    let result = if m == 1 {
        1
    } else {
        let mut a = a;
        let mut m0: Field = m;
        let mut y: Field = 0;
        let mut x: Field = 1;
        let mut inverse_found: Field = 0;

        // We need to set a reasonable upper bound for the number of iterations
        // This should be log2(m) + 1, but we'll use a constant for simplicity
        // Adjust this value based on the maximum expected size of your modulus
        let max_iterations = 256;

        for i in 0..max_iterations {
            if (a as u32 > 1) & (inverse_found as u32 == 0) {
                // q is quotient
                let q: Field = a / m0;
                let mut t: Field = m0;

                // m0 is remainder now, process same as Euclid's algo
                m0 = (a as u32 % m0 as u32) as Field;
                a = t;
                t = y;

                // Update x and y
                y = x - q * y;
                x = t;
            } else {
                inverse_found = 1;
            }
        }

        // Make x positive
        if (x as i32) < 0 {
            x += m;
        }

        // Check if a and m are coprime
        if a != 1 {
            assert(false); // or use Noir's specific assertion/error handling
        }

        x
    };

    result
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
pub fn derive_public_key_optimized(private_key: Field) -> Point {
    let X = globals::BJJ.curve.mul(private_key, globals::G);
    X
}
