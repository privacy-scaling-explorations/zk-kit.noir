import { BarretenbergBackend } from '@noir-lang/backend_barretenberg';
import { Noir } from '@noir-lang/noir_js';
import { ProofData } from '@noir-lang/types';
import { expect } from 'chai';
import { randomBytes } from 'crypto';
import { readFileSync } from 'fs';
import { resolve } from 'path';
import 'mocha';

function generatePrivateKey(): Uint8Array {
  return randomBytes(32);
}

describe('ECDH Circuit Tests', function() {
  let noir: Noir;
  let backend: BarretenbergBackend;
  let correctProof: ProofData;

  beforeEach(async () => {
    const circuitFile = readFileSync(resolve(__dirname, '../../../target/ecdh.json'), 'utf-8');
    const circuit = JSON.parse(circuitFile);
    backend = new BarretenbergBackend(circuit);
    noir = new Noir(circuit, backend);
    const pk1 = generatePrivateKey();
    const pk2 = generatePrivateKey();

    // Convert Uint8Array to regular arrays
    const input = {
      private_key1: Array.from(pk1),
      private_key2: Array.from(pk2),
    };

    correctProof = await noir.generateProof(input);
  });

  it('Should generate valid proof for correct input', async function() {
    this.timeout(25000); // Optional: Increase timeout if needed
    // Assert that correctProof is defined and has the expected structure
    expect(correctProof).to.not.be.undefined;
    expect(correctProof.proof).to.be.instanceOf(Uint8Array);
  });

  it('Should verify valid proof for correct input', async function() {
    this.timeout(25000); // Increase timeout if needed
    expect(correctProof).to.not.be.undefined; // Ensure proof is generated
    const verification = await noir.verifyProof(correctProof);
    expect(verification).to.be.true;
  });
});
