import { BarretenbergBackend } from '@noir-lang/backend_barretenberg'
import { Noir } from '@noir-lang/noir_js'
import { compile } from '@noir-lang/noir_wasm'
import { ProofData } from '@noir-lang/types'
import { expect } from 'chai'
import { randomBytes } from 'crypto'
import { readFileSync } from 'fs'
import { resolve } from 'path'
import 'mocha'
import circuit_ecdh from '../../ecdh/target/ecdh.json'

// RUN: npx mocha -r ts-node/register tests/ecdh.tests.ts
// This will not run with yarn tests

function generatePrivateKey(): Uint8Array {
  return randomBytes(32)
}

describe('ECDH Circuit Tests', function() {
  let noir: Noir
  let backend: BarretenbergBackend
  let correctProof: ProofData
  beforeEach(async () => {
    const circuitFile = readFileSync(resolve(__dirname, '../target/ecdh.json'), 'utf-8')
    const circuit = JSON.parse(circuitFile)
    backend = new BarretenbergBackend(circuit)
    noir = new Noir(circuit, backend)
  })
  it('Should generate valid proof for correct input', async function() {
    this.timeout(20000) // Optional: Increase timeout if needed

    let pk1 = generatePrivateKey()
    let pk2 = generatePrivateKey()

    // Convert Uint8Array to regular arrays
    const input = {
      private_key1: Array.from(pk1),
      private_key2: Array.from(pk2),
    }

    // Generate proof
    let correctProof
    try {
      correctProof = await noir.generateProof(input)
      console.log('Proof generated:', correctProof)
    } catch (error) {
      console.error('Error generating proof:', error)
      throw error // Ensure errors are not swallowed
    }

    // Assert that correctProof is defined and has the expected structure
    expect(correctProof).to.not.be.undefined
    expect(correctProof.proof instanceof Uint8Array).to.be.true
  })
})

// describe("ECDH Circuit Tests", function() {
//     let noir: Noir;
//     let correctProof: ProofData;
//     beforeEach(async () => {
//         const circuitFile = readFileSync(resolve('../target/ecdh.json'), 'utf-8');
//         const circuit = JSON.parse(circuitFile);
//         const backend = new BarretenbergBackend(circuit);
//         noir = new Noir(circuit, backend);
//     });
//     it('Should generate valid proof for correct input', async () => {

//         let pk1 = generatePrivateKey();
//         let pk2 = generatePrivateKey();
//         const input = {
//             private_key1: Array.from(pk1),
//             private_key2: Array.from(pk2)
//         };

//         // Generate proof
//         correctProof = await noir.generateProof(input);
//         expect(correctProof.proof).to.be.true;
//     });

//     it('Should verify valid proof for correct input', async () => {
//         const verification = await noir.verifyProof(correctProof);
//         expect(verification).to.be.true;
//     });

// });
