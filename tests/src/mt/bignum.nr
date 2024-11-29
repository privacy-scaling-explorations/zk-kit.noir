use bignum::BigNum;
use bignum::fields::bn254Fq::BN254_Fq_Params;
use std::hash::poseidon2::Poseidon2::hash;
use trees::merkle::MerkleTree;

type BN = BigNum<3, 254, BN254_Fq_Params>;

fn hasher(input: [BN; 2]) -> BN {
    let limbs: [Field; 6] =
        &[].append(input[0].get_limbs_slice()).append(input[1].get_limbs_slice()).as_array();
    let hash_field = hash(limbs, 6);
    BigNum::from_slice([hash_field, 0x00, 0x00])
}

#[test]
fn test_merkle_tree_add_bignum() {
    let old_root = BigNum::from_slice([
        0x21447efbbddb57d6fc5ad24d906388492e82c44e5160425258dd4ea995e3a06e,
        0x00,
        0x00,
    ]);
    let mut mt = MerkleTree::from(old_root, hasher);

    let leaf = BigNum::from_slice([
        0x2bc00d90b885b09d12764e764410f7f693f514f7f3ca14d916741ff3968b3079,
        0x00,
        0x00,
    ]);
    let paths = [BigNum::from_slice([
        0x21447efbbddb57d6fc5ad24d906388492e82c44e5160425258dd4ea995e3a06e,
        0x00,
        0x00,
    ])];

    mt.add(leaf, 0x01, paths);
}

#[test]
fn test_merkle_tree_add_really_bignum() {
    let old_root = BigNum::from_slice([
        0x2494b80a540ec0a0124a9dba7d5922e3250507677700e9eb680e30a279a72742,
        0x00,
        0x00,
    ]);
    let mut mt = MerkleTree::from(old_root, hasher);

    let leaf = BN::from_slice([
        0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000000,
        0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000000,
        0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000000,
    ]);

    let paths = [BigNum::from_slice([
        0x2494b80a540ec0a0124a9dba7d5922e3250507677700e9eb680e30a279a72742,
        0x00,
        0x00,
    ])];
    mt.add(leaf, 0x01, paths);
    assert(
        mt.root
            == BN::from_slice([
                0x1a9a6cfaea6bfb6f8dec45c5e333cf568d1f74a32acaca391e510a690b3767f9,
                0x00,
                0x00,
            ]),
    );
}
