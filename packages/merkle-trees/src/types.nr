pub trait Calculator<T, K> {
    fn calculate_root<let N: u32>(self, entry: K, indexes: Field, hash_path: [T; N]) -> T;
    fn calculate_two_roots<let N: u32>(self, entry: K, indexes: Field, hash_path: [T; N]) -> (T, T);
}

pub trait SMT_Creator<T> {
    pub fn default(root: T, leaf_hasher: fn([T; 3]) -> T, hasher: fn([T; 2]) -> T) -> Self {}

    /**
     * Imports an existing Sparse Merkle Tree (SparseMerkleTree) instance.
     * @param hasher The hash function that is used to hash the nodes of the tree
     * @param root The root of the tree
     */
    pub fn from(root: T, leaf_hasher: fn([T; 3]) -> T, hasher: fn([T; 2]) -> T) -> Self {
        Self::default(root, leaf_hasher, hasher)
    }

    /**
     * Creates a new Sparse Merkle Tree (SparseMerkleTree) instance.
     * @param hasher The hash function that is used to hash the nodes of the tree
     */
    pub fn new(leaf_hasher: fn([T; 3]) -> T, hasher: fn([T; 2]) -> T) -> Self {
        Self::from(T::default(), leaf_hasher, hasher)
    }
}

pub trait MT_Creator<T> {
    pub fn default(root: T, hasher: fn([T; 2]) -> T) -> Self {
        Self { root, hasher }
    }

    /**
     * Imports an existing Sparse Merkle Tree (SparseMerkleTree) instance.
     * @param hasher The hash function that is used to hash the nodes of the tree
     * @param root The root of the tree
     */
    pub fn from(root: T, hasher: fn([T; 2]) -> T) -> Self {
        Self::default(root, hasher)
    }

    /**
     * Creates a new Sparse Merkle Tree (SparseMerkleTree) instance.
     * @param hasher The hash function that is used to hash the nodes of the tree
     */
    pub fn new(hasher: fn([T; 2]) -> T) -> Self {
        Self::from(T::default(), hasher)
    }
}

pub trait MembershipProver<T, K> {
    /**
     * Proves that a leaf is a member of the tree.
     * @param leaf The leaf to prove
     * @param path The hash path and indices
     */
    pub fn membership<let N: u32>(self, entry: K, indexes: Field, hash_path: [T; N]);
}

pub trait NonMembershipProver<T, K> {
    /**
     * Verifies a non-membership proof, ie it calculates the tree root
     * based on an entry and a matching_entry and all siblings and compares that calculated root
     * with the root that is passed to this function.
     * @param entry Contains key and value of an entry: (key, value)
     * @param matching_entry Contains (key, value) of a matching entry
     * @param siblings Contains array of siblings the matching_entry
     */
    pub fn non_membership(self, matching_entry: K, index: Field, siblings: [T; 256]);
}

pub trait Modifier<T, K> {
    /**
     * Proves the addition of a NEW entry to an existing tree. Based on the siblings first validates the correctness of
     * the old root. Then uses the new entry and the siblings to calculate the new tree root.
     * NOTE: this function doesn't validate if the key for the new entry already exists in the tree, ie
     * if the operation is actually an update. For this operation there is a separate function.
     * @param new_entry The new entry to prove addition
     * @param siblings The siblings (and indices for MT proofs)
     */
    pub fn add<let N: u32>(&mut self, new_entry: K, indexes: Field, hash_path: [T; N]);

    /**
     * Proves the deletion of an existing entry from a tree. Based on the siblings first does a membership proof
     * of that existing entry and then calculates the new root (without the entry).
     * @param entry Contains key and value of the to-be-deleted entry: (key, value)
     * @param siblings The siblings (and indices for MT proofs)
     */
    pub fn delete<let N: u32>(&mut self, entry: K, indexes: Field, hash_path: [T; N]);

    /**
     * Proves the update of the value of an existing entry in a tree. Based on the siblings first does a membership proof
     * first verifies the membership of the old entry. Then recalculates the new root.
     * @param new_value The new value to be added (instead of old_entry[1])
     * @param old_entry Contains key and value of the entry to be updated: (key, value)
     * @param siblings The siblings (and indices for MT proofs)
     */
    pub fn update<let N: u32>(
        &mut self,
        new_value: K,
        old_entry: K,
        index: Field,
        hash_path: [T; N],
    );
}
