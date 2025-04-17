# Binary Merkle Root Library

This project contains the Binary Merkle Root Noir circuit. It's used to calculate the Merkle root of a binary tree (including the LeanIMT).

## Import the library

To import the library, add the lib to the `Nargo.toml` file. For example:

```toml
[dependencies]
binary_merkle_root = { git = "https://github.com/privacy-scaling-explorations/zk-kit.noir", tag = "main", directory = "packages/binary-merkle-root" }
```

You can find all released versions of the `binary-merkle-root` circuit at the following link: https://github.com/privacy-scaling-explorations/zk-kit.noir/releases?q=binary-merkle-root&expanded=true

## Usage

```nr
use binary_merkle_root::binary_merkle_root;
use std::hash::poseidon::bn254::hash_2 as poseidon2;

fn main(
    identity_commitment: Field,
    merkle_proof_length: u32, 
    merkle_proof_indices: [u1; MAX_DEPTH], 
    merkle_proof_siblings: [Field; MAX_DEPTH], 
) {

    // Calculate Merkle root.
    let merkle_root = binary_merkle_root(poseidon2, identity_commitment, merkle_proof_length, merkle_proof_indices, merkle_proof_siblings);
}
```
