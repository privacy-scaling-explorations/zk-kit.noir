use dep::std::ec::tecurve::affine::{Curve, Point};
use dep::std::ec::consts::te::{baby_jubjub};


// @@@@@@ Core ECDH Implementation

// Globals Edward Curves supported Baby JubJub
global bjj = baby_jubjub();
global G = bjj.base8;

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


fn derive_public_key(private_key: Field) -> Point {
    let base_point = Point::new(
        5299619240641551281634865583518297030282874472190772894086521144482721001553,
        16950150798460657717958625567821834550301663161624707787222815936182638968203,
    );
    let baby_jubjub_curve = Curve::new(168700, 168696, base_point);
    baby_jubjub_curve.mul(private_key, base_point)
}

/// Generates a public key from a private key using the Baby JubJub curve.
/// An Optimized Version of the Baby JubJub Curve
/// # Arguments
/// * `private_key` - A field element representing the private key.
/// * `base_point` - A point on the Baby JubJub curve used as the base point.
/// # Returns
/// A `Point` on the Baby JubJub curve representing the public key.
fn derive_public_key_optimized(private_key: Field) -> Point {
    let X = bjj.curve.mul(private_key, G);
    X 
}

fn derive_shared_key(private_key: Field, public_key: Point) -> Field {
    let shared_key = bjj.curve.mul(private_key, public_key);
    shared_key.x
}

// ECDH Circuit
fn generate_shared(private_key1: [u8; 32], private_key2: [u8; 32]) {

    // Convert private keys to fields
    let private_key1_as_field = field_from_bytes(private_key1, true);
    let private_key2_as_field = field_from_bytes(private_key2, true);
    
    // Generate public keys from private keys
    let public_key1 = derive_public_key_optimized(private_key1_as_field);
    let public_key2 = derive_public_key_optimized(private_key2_as_field);
    
    // Generate Both ECDH Shared Keys - Scalar Multiply
    let shared_key1 = derive_shared_key(private_key2_as_field, public_key1);
    let shared_key2 = derive_shared_key(private_key1_as_field, public_key2);
    assert(shared_key1 == shared_key2);
}


// ########## Tests ##########

// Description: This test verifies the correctness of the optimized public key derivation function.
// It ensures that the `derive_public_key_optimized` function produces the same result as the 
// standard `derive_public_key` function for a given test input.

#[test]
fn test_derive_public_key() {
    let test_field_value = 0x3fbbccb240537392421955b07a0d65eded9e7637995bf2f9cfe29e19b580e4;
    let derived_public_key = derive_public_key_optimized(test_field_value);
    let test_derived_public_key = derive_public_key(test_field_value);
    assert(derived_public_key.x == test_derived_public_key.x);
    assert(derived_public_key.y == test_derived_public_key.y);
}

/// Test that the `field_from_bytes` function correctly converts a 32-byte array of zeroes to a field element with a value of `0`.
///
/// This test ensures that:
/// - The input is a 32-byte array initialized with zeroes.
/// - The `field_from_bytes` function is called with the input and a boolean flag set to `true`.
/// - The output is asserted to be `0`, verifying that the conversion is correct.
#[test]
// Define the test function for `field_from_bytes`
fn field_from_bytes_correct() {
    let bytes: [u8; 32] = [0; 32];
    let field_result = field_from_bytes(bytes, true);
    assert_eq(field_result, 0);
}
