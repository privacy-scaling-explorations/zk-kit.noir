ecdh.tests.ts

import { randomBytes } from 'crypto';
import { readFileSync } from 'fs';
import { resolve } from 'path';
import { BarretenbergBackend } from '@noir-lang/backend_barretenberg';
import { compile } from '@noir-lang/noir_wasm';
import { Noir } from '@noir-lang/noir_js';
import { ProofData } from '@noir-lang/types';
import { expect } from 'chai';


function generatePrivateKey(): Uint8Array {
    return randomBytes(32);
}
  
describe("ECDH Circuit Tests", function() {
    let correctProof: ProofData;
    it('Should generate valid proof for correct input', async () => {
        const circuitFile = readFileSync(resolve('../target/ecdh.json'), 'utf-8');
        const circuit = JSON.parse(circuitFile);
        const backend = new BarretenbergBackend(circuit);
        const noir = new Noir(circuit);
        let pk1 = generatePrivateKey();
        let pk2 = generatePrivateKey();
        const input = { private_key1: pk1, private_key2: pk2};
        // Generate proof
        correctProof = await noir.generateProof(input);
        expect(correctProof.proof).to.be.true;
    });
    
    it('Should verify valid proof for correct input', async () => {
        const verification = await noir.verifyProof(correctProof);
        expect(verification).to.be.true;
    });
  
});


