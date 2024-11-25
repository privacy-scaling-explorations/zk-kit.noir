use crate::Calculator;
use crate::merkle::MerkleTree;

/*
 * Transforms the key into into a big endian array of bits so that when determining the position
 * of a tree entry starting from the root node, the first array element to look at is the last.
 * @param key The key of a tree entry
 * @returns The path that determines the position of a key in the tree
 */
pub fn key_to_path(key: Field) -> [u1] {
    key.to_be_bits()
}

impl Calculator<Field> for MerkleTree {
    fn calculate_root<let N: u32>(
        self,
        leaf: Field,
        indexes: Field,
        hash_path: [Field; N],
    ) -> Field {
        let index_bits: [u1; N] = indexes.to_le_bits();
        let mut node = leaf;
        for i in 0..hash_path.len() {
            let sibling = hash_path[i];
            if sibling != 0 {
                let mut left = sibling;
                let mut right = node;
                if index_bits[i] == 0 {
                    left = node;
                    right = sibling;
                }
                node = (self.hasher)([left, right]);
            }
        }
        node
    }

    /*
     * Calculates two roots for a given leaf entry based on the passed array of siblings: one root
     * for if the leaf entry was included in the tree and one for if the leaf entry was not included
     * in the tree. This is useful for efficiently proving the membership of leaf entries for a
     * tree while simultaneously modifying the tree.
     * @param entry The key and value of an entry [k, v]
     * @param siblings Contains the siblings from bottom to top
     * @returns Two root nodes: the first one doesn't include entry, the second does
     */
    fn calculate_two_roots<let N: u32>(
        self,
        leaf: Field,
        indexes: Field,
        hash_path: [Field; N],
    ) -> (Field, Field) {
        let index_bits: [u1; N] = indexes.to_be_bits();

        // root_with_leaf is a container for hashes to derive the root node for the tree that
        // includes the entry
        let mut root_with_leaf = leaf;
        // root_without_leaf is a container for hashes to derive the root node for the tree that
        // doesn't include the entry
        let mut root_without_leaf: Field = hash_path[0];

        // iterate over the levels of the tree from bottom to top
        for i in 0..hash_path.len() {
            let sibling = hash_path[i];
            // After the first sibling is found, the processes are started to calculate the two root nodes.
            // The calulcation of the root node that includes the entry is comparable to `calculate_root`.
            // To calc the root node that doesn't include entry, the first sibling is put into the container
            // and starting from each SUBSEQUENT iteration it is hashed with its sibling and the resulting hash
            // again stored in the container until the root is reached
            if sibling != 0 {
                if index_bits[i] == 0 {
                    root_with_leaf = (self.hasher)([root_with_leaf, sibling]);
                    if (root_without_leaf != sibling) {
                        root_without_leaf = (self.hasher)([root_without_leaf, sibling]);
                    }
                } else {
                    root_with_leaf = (self.hasher)([sibling, root_with_leaf]);
                    if (root_without_leaf != sibling) {
                        root_without_leaf = (self.hasher)([sibling, root_without_leaf]);
                    }
                }
            }
        }
        (root_without_leaf, root_with_leaf)
    }
}
