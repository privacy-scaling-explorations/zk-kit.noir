<p align="center">
    <h1 align="center">
        🧰 ZK-Kit (Noir)
    </h1>
    <p align="center">A monorepo of reusable Noir circuits.</p>
</p>

<p align="center">
    <a href="https://github.com/privacy-scaling-explorations" target="_blank">
        <img src="https://img.shields.io/badge/project-PSE-blue.svg?style=flat-square">
    </a>
    <a href="https://github.com/privacy-scaling-explorations/zk-kit.noir/blob/main/LICENSE">
        <img alt="Github license" src="https://img.shields.io/github/license/privacy-scaling-explorations/zk-kit.noir.svg?style=flat-square">
    </a>
    <a href="https://github.com/privacy-scaling-explorations/zk-kit.noir/actions?query=workflow%3Atests">
        <img alt="GitHub Workflow test" src="https://img.shields.io/github/actions/workflow/status/privacy-scaling-explorations/zk-kit.noir/tests.yml?branch=main&label=test&style=flat-square&logo=github">
    </a>
    <a href="https://prettier.io/">
        <img alt="Code style prettier" src="https://img.shields.io/badge/code%20style-prettier-f8bc45?style=flat-square&logo=prettier">
    </a>
    <a href="http://commitizen.github.io/cz-cli/">
        <img alt="Commitizen friendly" src="https://img.shields.io/badge/commitizen-friendly-586D76?style=flat-square">
    </a>
</p>

<div align="center">
    <h4>
        <a href="/CONTRIBUTING.md">
            👥 Contributing
        </a>
        <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>
        <a href="/CODE_OF_CONDUCT.md">
            🤝 Code of conduct
        </a>
        <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>
        <a href="https://github.com/privacy-scaling-explorations/zk-kit.noir/issues/new/choose">
            🔎 Issues
        </a>
        <span>&nbsp;&nbsp;|&nbsp;&nbsp;</span>
        <a href="https://appliedzkp.org/discord">
            🗣️ Chat &amp; Support
        </a>
    </h4>
</div>

| ZK-Kit is a set of libraries (algorithms or utility functions) that can be reused in different projects and zero-knowledge protocols, making it easier for developers to access user-friendly, tested, and documented code for common tasks. ZK-Kit provides a repository for each language. This repository only contains Noir circuits. |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

> [!IMPORTANT]  
> Installation of [Nargo](https://noir-lang.org/getting_started/nargo_installation) required for circuit tests.

## 📦 Packages

-   [merkle-trees](https://github.com/privacy-scaling-explorations/zk-kit.noir/tree/main/packages/merkle-trees)

## 👥 Ways to contribute

-   🔧 Work on [open issues](https://github.com/privacy-scaling-explorations/zk-kit.noir/contribute)
-   📦 Suggest new [circuits](https://github.com/privacy-scaling-explorations/zk-kit.noir/issues/new?assignees=&labels=feature+%3Arocket%3A&template=---circuit.md&title=)
-   🐛 Create a report if you find any [bugs](https://github.com/privacy-scaling-explorations/zk-kit.noir/issues/new?assignees=&labels=bug+%F0%9F%90%9B&template=---bug.md&title=) in the code

> [!NOTE]  
> Need inspiration? Check this list of circuits from the Atzec team: https://aztecnetwork.notion.site/f06968995c124de1be359459775ca2cb?v=613d3cb893dd46899a5bd3793b01e63b.

## 🛠 Install

Clone this repository:

```bash
git clone https://github.com/privacy-scaling-explorations/zk-kit.noir.git
```

and install the dependencies:

```bash
cd zk-kit.noir && yarn
```

## 📜 Usage

### Conventional commits

Semaphore uses [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/). A [command line utility](https://github.com/commitizen/cz-cli) to commit using the correct syntax can be used by running:

```bash
git commit
```

### Testing

Test the code with:

```bash
yarn test
```
