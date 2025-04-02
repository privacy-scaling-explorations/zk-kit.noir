use ecdh::{bjj::BJJ, ECDHTrait, Point};
use ecdh::{gpk::Grumpkin, ECDHSWTrait};
use ec::swcurve::affine::Point as swPoint;

global alice_sk: Field = 0x60c0102756aac2cf5d7277792a469bff83dfe3d3e7e50ad5a55383f3a89283e;
global bob_sk: Field = 0x86cdaad8886954a2eb20142fb98468d476a2d6c7b2c571af42cdc041b1a923c;

global grumpkin_alice_sk: Field = 0x12a4d37d71d32255c4e9b3d5f6c8c1b0e9a4c7d1b3e5f6c8a2d4e7f1b2c3d5e;
global grumpkin_bob_sk: Field = 0x2c8d3e7a1f5b9d2e6c4a8b1d3f5e7c9a2d4b6e8f1a3c5d7e9b2d4f6a8c3e1;

#[test]
fn test_pk() {
    let ecdh = BJJ::new(alice_sk);
    let expected_pk = Point::new(
        0x17d6ff45a37eee4ca071bb451c09b47184ed67492c6bac9279fb0a7d2d4ad1dc,
        0x02d3a6338eee1ae8a38b278ce6c13179889c780f5e0d7294b904b0fa52c7dc3e,
    );
    let pk = ecdh.derive_public_key();
    assert(pk == expected_pk);
}
#[test]
fn test_grumpkin_pk() {
    let ecdh = Grumpkin::new(grumpkin_alice_sk);
    
    let expected_pk = swPoint::new(
        0x159cf346346bebd155d7fc84f67bfb29cd9d26a920c4652823b1fc7b327490ca,
        0x2869bca8dd2c9d498c9ca4463c91f5f3e32cb40af3cfe3a7c5e8357436642b33,
    );
    
    let pk = ecdh.derive_public_key();

    assert(pk.x == expected_pk.x);
    assert(pk.y == expected_pk.y);
}

#[test]
fn test_shared_k() {
    let alice_ecdh = BJJ::new(alice_sk);
    let bob_ecdh = BJJ::new(bob_sk);

    let alice_pk: Point = alice_ecdh.derive_public_key();
    let bob_pk: Point = bob_ecdh.derive_public_key();

    let shared_key_with_bob = alice_ecdh.derive_shared_key(bob_pk);
    let shared_key_with_alice = bob_ecdh.derive_shared_key(alice_pk);

    assert(shared_key_with_bob == shared_key_with_alice);
}

#[test]
fn test_grumpkin_shared_k() {
    // Create ECDH instances for Alice and Bob
    let alice_ecdh = Grumpkin::new(grumpkin_alice_sk);
    let bob_ecdh = Grumpkin::new(grumpkin_bob_sk);

    // Derive public keys
    let alice_pk: swPoint = alice_ecdh.derive_public_key();
    let bob_pk: swPoint = bob_ecdh.derive_public_key();

    // Compute shared keys
    let shared_key_with_bob = alice_ecdh.derive_shared_key(bob_pk);
    let shared_key_with_alice = bob_ecdh.derive_shared_key(alice_pk);

    // Assert equality
    assert_eq(shared_key_with_bob, shared_key_with_alice);
}

