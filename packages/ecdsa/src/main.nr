mod lib;

fn main(private_key: [u8; 32], message: [u8; 32], random_nonce: [u8; 32]) {
    let private_key_field = lib::field_from_bytes(private_key, true);
    let random_nonce_field = lib::field_from_bytes(random_nonce, true);
    let public_key = lib::derive_public_key_optimized(private_key_field);
    let signature = lib::calculate_signature(message, random_nonce_field, private_key_field);
    // let is_valid = lib::verify_signature(signature, message, public_key);
    // assert(is_valid == true);
    let u: bool = false;
    assert(u != true);
}

