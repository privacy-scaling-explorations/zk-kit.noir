import { execSync } from 'child_process'

const packageName = process.argv[2]
const version = process.argv[3]

if (!packageName || !version) {
  console.error('❌ Please provide a package name and version')
  process.exit(1)
}

try {
  execSync(`git tag ${packageName}-v${version}`, { stdio: 'inherit' })
  console.log(`✅ Created git tag: ${packageName}-v${version}`)
} catch (err) {
  console.error('❌ Failed to create git tag', err)
  process.exit(1)
}
