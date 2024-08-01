use crate::incremental_merkle::IncrementalMerkle;
use crate::DynamicCalculator;

/*
 * Transforms the key into into a big endian array of bits so that when determining the position
 * of a tree entry starting from the root node, the first array element to look at is the last.
 * @param key The key of a tree entry
 * @returns The path that determines the position of a key in the tree
 */
pub fn key_to_path(key: Field, length: u32) -> [u1] {
    key.to_be_bits(length)
}

impl DynamicCalculator<Field> for IncrementalMerkle {
    fn calculate_root_dynamic(
        self,
        max_depth: u32,
        leaf: Field,
        siblings: (Field, [Field]),
    ) -> Field {
        let index_bits = siblings.0.to_le_bits(max_depth);
        let mut node = leaf;
        for i in 0..max_depth {
            let sibling = siblings.1[i];
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

    fn calculate_two_roots_dynamic(
        self,
        max_depth: u32,
        leaf: Field,
        siblings: (Field, [Field]),
    ) -> (Field, Field) {
        let index_bits = siblings.0.to_le_bits(max_depth);

        let mut root_with_leaf = leaf;
        let mut root_without_leaf = Field::zero(); // Assuming Field::zero() creates a zero value.

        for i in 0..siblings.1.len() {
            let sibling = siblings.1[i];

            if sibling != Field::zero() {
                // Handle root_without_leaf at the last sibling index
                if i == siblings.1.len() - 1 {
                    root_without_leaf = sibling;
                }

                if index_bits[i] == 0 {
                    root_with_leaf = (self.hasher)([root_with_leaf, sibling]);

                    if root_without_leaf != sibling {
                        root_without_leaf = (self.hasher)([root_without_leaf, sibling]);
                    }
                } else {
                    root_with_leaf = (self.hasher)([sibling, root_with_leaf]);

                    if root_without_leaf != sibling {
                        root_without_leaf = (self.hasher)([sibling, root_without_leaf]);
                    }
                }
            }
        }

        (root_without_leaf, root_with_leaf)
    }
}
