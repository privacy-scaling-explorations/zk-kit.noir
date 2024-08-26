mod lib;

// ECDH Circuit
fn main(private_key1: [u8; 32], private_key2: [u8; 32]) {

    // Convert private keys to fields
    let private_key1_as_field = lib::field_from_bytes(private_key1, true);
    let private_key2_as_field = lib::field_from_bytes(private_key2, true);
    
    // Generate public keys from private keys
    let public_key1 = lib::derive_public_key_optimized(private_key1_as_field);
    let public_key2 = lib::derive_public_key_optimized(private_key2_as_field);
    
    // Generate Both ECDH Shared Keys - Scalar Multiply
    let shared_key1 = lib::derive_shared_key(private_key2_as_field, public_key1);
    let shared_key2 = lib::derive_shared_key(private_key1_as_field, public_key2);
    assert(shared_key1 == shared_key2);
}


// ########## Tests ##########

// Description: This test verifies the correctness of the optimized public key derivation function.
// It ensures that the `derive_public_key_optimized` function produces the same result as the 
// standard `derive_public_key` function for a given test input.

#[test]
fn test_derive_public_key() {
    let test_field_value = 0x3fbbccb240537392421955b07a0d65eded9e7637995bf2f9cfe29e19b580e4;
    let derived_public_key = lib::derive_public_key_optimized(test_field_value);
    let test_derived_public_key = lib::derive_public_key(test_field_value);
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
    let field_result = lib::field_from_bytes(bytes, true);
    assert_eq(field_result, 0);
}

