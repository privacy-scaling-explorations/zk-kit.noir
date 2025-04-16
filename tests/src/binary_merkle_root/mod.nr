use binary_merkle_root::binary_merkle_root;
use std::hash::poseidon::bn254::hash_2 as poseidon2;

#[test]
fn test_one_level() {
    let identity_commitment =
        1280033553760815678764770846139155613435155939625621669696967390845036381755;
    // One level, depth = 1
    let merkle_proof_length = 1;
    let merkle_proof_indices = [1];
    let merkle_proof_siblings = [1];
    let root = 6691153974608186212136798648834496237771156483253230205533658046584008158327;
    let root_result = binary_merkle_root(
        poseidon2,
        identity_commitment,
        merkle_proof_length,
        merkle_proof_indices,
        merkle_proof_siblings,
    );

    assert(root_result == root);
}

#[test]
fn test_depth_less_than_max_depth() {
    let identity_commitment =
        1280033553760815678764770846139155613435155939625621669696967390845036381755;
    // depth = 2 which is < max depth = 5
    let merkle_proof_length = 2;
    let merkle_proof_indices = [1, 1, 0, 0, 0];
    let merkle_proof_siblings =
        [4, 3720616653028013822312861221679392249031832781774563366107458835261883914924, 0, 0, 0];
    let root = 10509779603326422522676562251845606046522679317041388765499233991324785125471;
    let root_result = binary_merkle_root(
        poseidon2,
        identity_commitment,
        merkle_proof_length,
        merkle_proof_indices,
        merkle_proof_siblings,
    );

    assert(root_result == root);
}

#[test]
fn test_depth_equals_max_depth() {
    let identity_commitment =
        1280033553760815678764770846139155613435155939625621669696967390845036381755;
    // depth = 2 which is = max depth = 2
    let merkle_proof_length = 2;
    let merkle_proof_indices = [1, 1];
    let merkle_proof_siblings =
        [4, 3720616653028013822312861221679392249031832781774563366107458835261883914924];
    let root = 10509779603326422522676562251845606046522679317041388765499233991324785125471;
    let root_result = binary_merkle_root(
        poseidon2,
        identity_commitment,
        merkle_proof_length,
        merkle_proof_indices,
        merkle_proof_siblings,
    );

    assert(root_result == root);
}

fn dummy_hasher(input: [Field; 2]) -> Field {
    input[0] + input[1]
}

#[test(should_fail)]
fn test_incorrect_hash_function() {
    let identity_commitment =
        1280033553760815678764770846139155613435155939625621669696967390845036381755;
    let merkle_proof_length = 2;
    let merkle_proof_indices = [1, 1, 0, 0, 0];
    let merkle_proof_siblings =
        [4, 3720616653028013822312861221679392249031832781774563366107458835261883914924, 0, 0, 0];
    let root = 10509779603326422522676562251845606046522679317041388765499233991324785125471;
    // Incorrect hasher function, it should be poseidon2 in this example since the root was generated using poseidon2
    let root_result = binary_merkle_root(
        dummy_hasher,
        identity_commitment,
        merkle_proof_length,
        merkle_proof_indices,
        merkle_proof_siblings,
    );

    assert(root_result == root);
}

#[test(should_fail)]
fn test_incorrect_commitment_value() {
    // This test is expected to fail because the identity_commitment value is incorrect, this was not the one used to generate the root expected
    let identity_commitment =
        1380033553760815678764770846139155613435155939625621669696967390845036381755;
    let merkle_proof_length = 2;
    let merkle_proof_indices = [1, 1, 0, 0, 0];
    let merkle_proof_siblings =
        [4, 3720616653028013822312861221679392249031832781774563366107458835261883914924, 0, 0, 0];
    let root = 10509779603326422522676562251845606046522679317041388765499233991324785125471;
    let root_result = binary_merkle_root(
        poseidon2,
        identity_commitment,
        merkle_proof_length,
        merkle_proof_indices,
        merkle_proof_siblings,
    );

    assert(root_result == root);
}

#[test(should_fail)]
fn test_incorrect_depth_value() {
    let identity_commitment =
        1280033553760815678764770846139155613435155939625621669696967390845036381755;
    // This test is expected to fail because the depth value is incorrect, this was not the one used to generate the root expected, it should be 2 instead
    let merkle_proof_length = 3;
    let merkle_proof_indices = [1, 1, 0, 0, 0];
    let merkle_proof_siblings =
        [4, 3720616653028013822312861221679392249031832781774563366107458835261883914924, 0, 0, 0];
    let root = 10509779603326422522676562251845606046522679317041388765499233991324785125471;
    let root_result = binary_merkle_root(
        poseidon2,
        identity_commitment,
        merkle_proof_length,
        merkle_proof_indices,
        merkle_proof_siblings,
    );

    assert(root_result == root);
}

#[test(should_fail)]
fn test_incorrect_proof_indices_values() {
    let identity_commitment =
        1280033553760815678764770846139155613435155939625621669696967390845036381755;
    let merkle_proof_length = 2;
    // This test is expected to fail because the proof indices values are incorrect, this was not the one used to generate the root expected, it should be [1, 1]
    let merkle_proof_indices = [1, 0];
    let merkle_proof_siblings =
        [4, 3720616653028013822312861221679392249031832781774563366107458835261883914924];
    let root = 10509779603326422522676562251845606046522679317041388765499233991324785125471;
    let root_result = binary_merkle_root(
        poseidon2,
        identity_commitment,
        merkle_proof_length,
        merkle_proof_indices,
        merkle_proof_siblings,
    );

    assert(root_result == root);
}

#[test(should_fail)]
fn test_incorrect_siblings_values() {
    let identity_commitment =
        1280033553760815678764770846139155613435155939625621669696967390845036381755;
    let merkle_proof_length = 2;
    let merkle_proof_indices = [1, 1, 0, 0, 0];
    // This test is expected to fail because the proof siblings values are incorrect, these were not the ones used to generate the root expected.
    let merkle_proof_siblings =
        [4, 3420616653028013822312861221679392249031832781774563366107458835261883914924, 0, 0, 0];
    let root = 10509779603326422522676562251845606046522679317041388765499233991324785125471;
    let root_result = binary_merkle_root(
        poseidon2,
        identity_commitment,
        merkle_proof_length,
        merkle_proof_indices,
        merkle_proof_siblings,
    );

    assert(root_result == root);
}
