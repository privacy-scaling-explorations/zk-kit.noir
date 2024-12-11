import { UltraHonkBackend } from "@aztec/bb.js"
import { Noir } from "@noir-lang/noir_js"
import { ProofData } from "@noir-lang/types"
import { expect } from "chai"
import { randomBytes } from "crypto"
import { readFileSync } from "fs"
import { resolve } from "path"
import "mocha"

function generatePrivateKey(): Uint8Array {
    return randomBytes(32)
}

describe("ECDH Circuit Tests", function () {
    let noir: Noir
    let backend: UltraHonkBackend
    let correctProof: ProofData

    beforeEach(async () => {
        const circuitFile = readFileSync(resolve(__dirname, "../../../target/ecdh.json"), "utf-8")
        const circuit = JSON.parse(circuitFile)
        backend = new UltraHonkBackend(circuit.bytecode)
        noir = new Noir(circuit)
        const pk1 = generatePrivateKey()
        const pk2 = generatePrivateKey()

        // Convert Uint8Array to regular arrays
        const input = {
            private_key1: Array.from(pk1),
            private_key2: Array.from(pk2)
        }

        const { witness } = await noir.execute(input)

        correctProof = await backend.generateProof(witness)
    })

    it("Should generate valid proof for correct input", async function () {
        expect(correctProof.proof).to.be.instanceOf(Uint8Array)
    })

    it("Should verify valid proof for correct input", async function () {
        expect(correctProof).to.not.be.undefined // Ensure proof is generated
        const verification = await backend.verifyProof(correctProof)
        expect(verification).to.be.true
    })
})
