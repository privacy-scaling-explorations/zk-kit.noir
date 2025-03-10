# Merkle Trees Library

This Noir library provides a Merkle Tree (MT) and a Sparse Merkle Tree (SMT) implementation.

A Sparse Merkle Tree is not too different from a Merkle Tree, but the index of each leaf is determined by its key value. This makes the SMT quite useful, for example, for nullifier trees, as it allows for easy non-membership proofs.

These implementations follow the ones in [zk-kit](https://github.com/privacy-scaling-explorations/zk-kit). However, for the Merkle Tree, it is advised to use the [LeanIMT](https://github.com/privacy-scaling-explorations/zk-kit/tree/main/packages/lean-imt) for better compatibility and efficiency.

You can use these libraries side-by-side for execution and proving.

## Usage

To use these trees in your project, add the lib to its `Nargo.toml` file. For example:

```toml
[dependencies]
trees = { git = "https://github.com/privacy-scaling-explorations/zk-kit.noir", tag = "main", directory = "packages/merkle-trees" }
```

And import it in your file.

## Merkle Tree

At this moment, library suppors only trees with arity 2, meaning two children per node. It provides methods to create, add, delete and update leaves, as well as proving membership in the tree.

Since every node is the hash of its children, you need to define a hasher of type `fn [T; 2] -> T`.

You can use any type you want for the leaves as long as they implement both the [Default](https://noir-lang.org/docs/noir/standard_library/traits#stddefault) and the [Eq](https://noir-lang.org/docs/noir/standard_library/traits#stdcmpeq) traits. Check out the tests for an example using Noir Bignums.

### Examples

A Merkle Tree:

```rust
use trees::merkle::MerkleTree;
use std::hash::poseidon2::Poseidon2::hash;

fn hasher(leaves: [Field; 2]) -> Field {
    hash(leaves, 2)
}

fn main(entry: Field, paths: [Field; 0]) {
    let mut mt = MerkleTree::new(hasher);

    // add at index 0
    mt.add(entry, 0, paths);

    // prove it is in the tree (kinda redundant isn't it?)
    mt.membership(entry, 0, paths);
}
```

## Sparse Merkle Tree

The Sparse Merkle Tree introduces some overhead but it's quite convenient, since the index of a leaf is determined by its hash. This makes it very useful to prove that a leaf is _not_ on the tree (since it cannot be found at its index). For this reason, it has a predefined depth of 254 accounting for 32-byte leaves.

Similarly to the Merkle Tree, you need to provide a hasher, but also a leaf hasher. This is because the leaves are hashed with a default value to mark that they're leaves and not nodes.

You can use any type you want for the leaves as long as they implement both the [Default](https://noir-lang.org/docs/noir/standard_library/traits#stddefault) and the [Eq](https://noir-lang.org/docs/noir/standard_library/traits#stdcmpeq) traits. Check out the tests for an example using Noir Bignums.

> [!IMPORTANT]
> The Default trait is needed because the leaf nodes are hashed with a "leaf marker". If you're following the [zk-kit JS implementation](https://github.com/privacy-scaling-explorations/zk-kit) you will find that the marker [defaults to 1](https://github.com/privacy-scaling-explorations/zk-kit/blob/54f175d06af2fe556367675f68e241b56bc4293b/packages/smt/src/smt.ts#L64C14-L64C23) and not 0.

### Example

A Sparse Merkle Tree:

```rust
use std::hash::poseidon2::Poseidon2::hash;
use trees::sparse_merkle::SparseMerkleTree;

fn hasher(leaves: [Field; 2]) -> Field {
    hash(leaves, 2)
}

fn leaf_hasher(leaves: [Field; 3]) -> Field {
    hash(leaves, 3)
}

fn main(entry: (Field, Field), index: Field, siblings: [Field; 254]) {
    let mut tree2 = SparseMerkleTree::new(leaf_hasher, hasher);

    // proving non-membership at index
    tree2.non_membership(entry, entry, index, [0; 254]);

    // proving that it was added
    tree2.add(entry, index, siblings);

    // proving that it is in the tree (kinda redundant isn't it?)
    tree2.membership(entry, index, siblings);
}
```

## Tests

This repository provides tests using pedersen and poseidon2 hashes. To test them, `cd` into the folder and run `nargo test`.
