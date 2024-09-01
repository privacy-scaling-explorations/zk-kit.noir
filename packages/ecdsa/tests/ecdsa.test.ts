import { BarretenbergBackend } from '@noir-lang/backend_barretenberg'
import { Noir } from '@noir-lang/noir_js'
import { ProofData } from '@noir-lang/types'
import { expect } from 'chai'
import { randomBytes } from 'crypto'
import { readFileSync } from 'fs'
import { resolve } from 'path'
import 'mocha'

const BJJ_ORDER = BigInt("2736030358979909402780800718157159386076813972158567259200215660948447373041");


function generatePrivateKey(): Uint8Array {
  return randomBytes(32)
}

function generateRandomNonce(): Uint8Array {
  const randomBytes = new Uint8Array(32);
  crypto.getRandomValues(randomBytes);
  let nonceBigInt = BigInt("0x" + Array.from(randomBytes)
      .map(b => b.toString(16).padStart(2, "0"))
      .join(""));
  nonceBigInt = nonceBigInt % BJJ_ORDER;
  const resultArray = new Uint8Array(32);
  for (let i = 0; i < 32; i++) {
      resultArray[31 - i] = Number(nonceBigInt & BigInt(255));
      nonceBigInt = nonceBigInt >> BigInt(8);
  }

  return resultArray;
}

describe('ECDSA Circuit Tests', function() {
    let noir: Noir
    let backend: BarretenbergBackend
    let correctProof: ProofData
  
    beforeEach(async () => {
      const circuitFile = readFileSync(resolve(__dirname, '../../../target/ecdsa.json'), 'utf-8')
      const circuit = JSON.parse(circuitFile)
      backend = new BarretenbergBackend(circuit)
      noir = new Noir(circuit, backend)
      const pk1 = generatePrivateKey()
      const pk2 = generatePrivateKey()
  
      // Convert Uint8Array to regular arrays
      const input = {
        private_key1: Array.from(pk1),
        private_key2: Array.from(pk2),
      }
  
      correctProof = await noir.generateProof(input)
    })
  
    it('Should generate valid proof for correct input', async function() {
      expect(correctProof.proof).to.be.instanceOf(Uint8Array)
    })
  
    it('Should verify valid proof for correct input', async function() {
      expect(correctProof).to.not.be.undefined // Ensure proof is generated
      const verification = await noir.verifyProof(correctProof)
      expect(verification).to.be.true
    })
  })
  