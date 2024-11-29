use std::hash::poseidon2::Poseidon2::hash;
use trees::sparse_merkle::SparseMerkleTree;

#[test]
fn test_verify_membership_proof() {
    let root = 0x1fb97f8fa4a6f05b16a3b8c9f76744de200a216e837a71f0c7c29ea927006b40;
    let smt = SparseMerkleTree::from(root, |h| hash(h, 3), |h| hash(h, 2));

    let key = 0x01;
    let value = 0x01;
    let entry = (key, value);
    let mut siblings: [Field; 256] = [0; 256];
    siblings[254] = 0x18ff110fac007ab061c17af9b831d12aabc3b0024fc240be77b0ed4823495531;
    siblings[255] = 0xaef80d5d5b3a2fe223a3e532befc46ce5f542ff516a917886e30c97f5f6b832;

    smt.membership(entry, entry.0, siblings);
}

#[test]
fn test_verify_non_membership_proof() {
    let root = 0x117a3c51b941cc245ed9139719b6a3d7cedee52056172adc6c0624c7ab0802bc;
    let smt = SparseMerkleTree::from(root, |h| hash(h, 3), |h| hash(h, 2));

    let key = 0x04;
    let value = 0x04;
    let entry = (key, value);
    let matching_entry = (0x02, 0x02);
    let mut siblings: [Field; 256] = [0; 256];
    siblings[255] = 0x172d81eba79a0df9c5cbe1d9ec427d730cd74c2bc4950389d5200a390377e4b1;

    smt.non_membership(entry, matching_entry, entry.0, siblings);
}

#[test]
fn test_add_first_element() {
    let mut smt = SparseMerkleTree::new(|h| hash(h, 3), |h| hash(h, 2));

    let key = 0x01;
    let value = 0x01;
    let entry = (key, value);
    let siblings: [Field; 256] = [0; 256];
    smt.add(entry, entry.0, siblings);

    assert(smt.root == 0x27c9467e3a466973f72dfe56bdeb362fe3158acf84bb79f59a55d722199b8a47);
}

#[test]
fn test_add_element_to_one_element_tree() {
    let root = 0x27c9467e3a466973f72dfe56bdeb362fe3158acf84bb79f59a55d722199b8a47;
    let mut smt = SparseMerkleTree::from(root, |h| hash(h, 3), |h| hash(h, 2));

    let key = 0x02;
    let value = 0x02;
    let entry = (key, value);
    let mut siblings: [Field; 256] = [0; 256];
    siblings[255] = 0x27c9467e3a466973f72dfe56bdeb362fe3158acf84bb79f59a55d722199b8a47;
    smt.add(entry, entry.0, siblings);
    assert(smt.root == 0x299535cfb103bbd9bb510df9347da1d2e0a8b0e457285f1dfd5780395059623d);
}

#[test]
fn test_add_element_to_existing_tree() {
    let root = 0x299535cfb103bbd9bb510df9347da1d2e0a8b0e457285f1dfd5780395059623d;
    let mut smt = SparseMerkleTree::from(root, |h| hash(h, 3), |h| hash(h, 2));

    let key = 0x03;
    let value = 0x03;
    let entry = (key, value);
    let mut siblings: [Field; 256] = [0; 256];
    siblings[254] = 0x27c9467e3a466973f72dfe56bdeb362fe3158acf84bb79f59a55d722199b8a47;
    siblings[255] = 0x1bfe300d0432b4e851095a255b5f6fb9df7d36a913a4cfd7cac46b4dc3327021;
    let big_tree_root = 0x117a3c51b941cc245ed9139719b6a3d7cedee52056172adc6c0624c7ab0802bc;

    smt.add(entry, entry.0, siblings);

    assert(smt.root == big_tree_root);
}

#[test]
fn test_delete() {
    let root = 0x117a3c51b941cc245ed9139719b6a3d7cedee52056172adc6c0624c7ab0802bc;
    let mut smt = SparseMerkleTree::from(root, |h| hash(h, 3), |h| hash(h, 2));

    let key = 0x03;
    let value = 0x03;
    let entry = (key, value);
    let mut siblings: [Field; 256] = [0; 256];
    siblings[254] = 0x27c9467e3a466973f72dfe56bdeb362fe3158acf84bb79f59a55d722199b8a47;
    siblings[255] = 0x1bfe300d0432b4e851095a255b5f6fb9df7d36a913a4cfd7cac46b4dc3327021;
    let small_tree_root = 0x299535cfb103bbd9bb510df9347da1d2e0a8b0e457285f1dfd5780395059623d;

    smt.delete(entry, entry.0, siblings);

    assert(smt.root == small_tree_root);
}

#[test]
fn test_update() {
    let root = 0x117a3c51b941cc245ed9139719b6a3d7cedee52056172adc6c0624c7ab0802bc;
    let mut smt = SparseMerkleTree::from(root, |h| hash(h, 3), |h| hash(h, 2));

    let key = 0x03;
    let old_value = 0x03;
    let new_value = 0x04;
    let old_entry = (key, old_value);
    let new_entry = (key, new_value);
    let mut siblings: [Field; 256] = [0; 256];
    siblings[254] = 0x27c9467e3a466973f72dfe56bdeb362fe3158acf84bb79f59a55d722199b8a47;
    siblings[255] = 0x1bfe300d0432b4e851095a255b5f6fb9df7d36a913a4cfd7cac46b4dc3327021;
    let big_tree_root = 0x1bc7c7ffbfbb8a474496aa06c2a8da387497f86e9109c98ea0f4802f849b69b8;

    smt.update(new_entry, old_entry, old_entry.0, siblings);

    assert(smt.root == big_tree_root);
}
