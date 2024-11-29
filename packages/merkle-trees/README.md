# Merkle Trees Library

This Noir library provides a Merkle Tree (MT) and a Sparse Merkle Tree (SMT) implementation.

A Sparse Merkle Tree is not too different from a Merkle Tree, but the index of each leaf is determined by its key value. This makes the SMT quite useful, for example, for nullifier trees, as it allows for easy non-membership proofs.

## Usage

To use these trees in your project, add the lib to its `Nargo.toml` file. For example:

```toml
[dependencies]
trees = { git = "https://github.com/privacy-scaling-explorations/zk-kit.noir", tag = "main", directory = "packages/merkle-trees" }
```

And import it in your file.

### Examples

A Merkle Tree:

```rust
use trees::merkle::MerkleTree;
use std::hash::poseidon2::Poseidon2::hash;


fn hasher(leaves: [Field; 2]) -> Field {
    hash(leaves, 2)
}

fn main(
    entry: Field,
    paths: [Field; 1])
{
    let mut mt = MerkleTree::new(hasher);

    // add at index 0
    mt.add(entry, 0, paths);
    mt.membership(entry, paths);
}
```

A Sparse Merkle Tree:

```rust
use trees::sparse_merkle::SparseMerkleTree;
use std::hash::poseidon2::Poseidon2::hash;

fn hasher(leaves: [Field; 2]) -> Field {
    hash(leaves, 2)
}

fn leaves_hasher(leaves: [Field; 3]) -> Field {
    hash(leaves, 3)
}

fn main(entry: (Field, Field), index: Field, siblings: [Field; 256]) {
    let mut tree2 = SparseMerkleTree::new(hasher, leaves_hasher);

    // proving non-membership at index
    tree2.non_membership(entry, index, [0; 256].as_slice());

    // proving that it was added
    tree2.add(entry, index, siblings);
}
```

## Tests

This repository provides tests using pedersen and poseidon2 hashes. To test them, `cd` into the folder and run `nargo test`.
