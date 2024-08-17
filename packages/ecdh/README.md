# ECDH Library using Baby JubJub Curve

This repository introduces a set of functions and utilities for elliptic curve cryptography using the Baby JubJub curve. The library provides essential operations for the Elliptic Curve Diffie-Hellman (ECDH) protocol, along with utility functions for key generation, field element conversion, and shared key computation.

## Features

- **Byte Array to Field Element Conversion:** Utility functions to convert byte arrays into field elements for use in elliptic curve operations.
- **Public Key Generation:** Generate public keys from private keys using the Baby JubJub curve, with both standard and optimized methods.
- **Shared Key Computation:** Compute shared keys for secure communication using the ECDH protocol.
- **Main Function:** A main function to generate ECDH shared keys, demonstrating the usage of the library.
- **Testing:** Comprehensive tests to verify the correctness of key derivation and field conversion functions.


## Compiling the Circuit

To compile the circuit, navigate one directory above the source code and run the following command:

```bash
nargo compile
```


## Running Tests

To run the tests for this library, use the following command:

```bash
yarn test
```

## Running Tests with Mocha

To run the tests using Mocha with TypeScript, use the following command:

```bash
npx mocha -r ts-node/register tests/ecdh.tests.ts
```