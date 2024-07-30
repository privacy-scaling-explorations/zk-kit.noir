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

        for i in 0..siblings.1.len() {
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
}
