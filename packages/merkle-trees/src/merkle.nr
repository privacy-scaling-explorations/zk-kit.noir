use crate::{MembershipProver, Modifier, MT_Creator};
mod tests;
mod tree;

struct MerkleTree {
    hasher: fn([Field; 2]) -> Field,
    pub root: Field,
}

impl MT_Creator for MerkleTree {
    fn default(root: Field, hasher: fn([Field; 2]) -> Field) -> Self {
        Self { root, hasher }
    }
}

impl MembershipProver<Field, Field, Field> for MerkleTree {
    fn membership<let N: u32>(self, leaf: Field, indexes: Field, hash_path: [Field; N]) {
        let root = self.calculate_root(leaf, indexes, hash_path);
        assert(self.root == root);
    }
}

impl Modifier<Field, Field, Field> for MerkleTree {
    fn add<let N: u32>(&mut self, leaf: Field, indexes: Field, hash_path: [Field; N]) {
        let (old, new) = self.calculate_two_roots(leaf, indexes, hash_path);
        assert(old == self.root);
        self.root = new;
    }

    fn delete<let N: u32>(&mut self, leaf: Field, indexes: Field, hash_path: [Field; N]) {
        let (new, old) = self.calculate_two_roots(leaf, indexes, hash_path);
        assert(old == self.root);
        self.root = new;
    }

    fn update<let N: u32>(
        &mut self,
        leaf: Field,
        old_leaf: Field,
        indexes: Field,
        hash_path: [Field; N],
    ) {
        let index_bits: [u1; N] = indexes.to_le_bits();

        let mut old_parent: Field = old_leaf;
        let mut new_parent: Field = leaf;

        for i in 0..hash_path.len() {
            let sibling = hash_path[i];
            if sibling != 0 {
                if index_bits[i] == 0 {
                    new_parent = (self.hasher)([new_parent, sibling]);
                    old_parent = (self.hasher)([old_parent, sibling]);
                } else {
                    new_parent = (self.hasher)([sibling, new_parent]);
                    old_parent = (self.hasher)([sibling, old_parent]);
                }
            }
        }
        assert(old_parent == self.root);
        self.root = new_parent;
    }
}
