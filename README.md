# agrep 🔎

```
     _                          _     
    / \   _ __ ___  __ _  ___  | |_ ___
   / _ \ | '__/ _ \/ _` |/ _ \ | __/ _ \
  / ___ \| | |  __/ (_| |  __/ | ||  __/
 /_/   \_\_|  \___|\__, |\___|  \__\___|
                   |___/                
```

[![Build](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://github.com/yourusername/agrep/actions)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Haskell](https://img.shields.io/badge/language-haskell-5e5086.svg)](https://www.haskell.org/)

> A lightweight, educational implementation of `grep`, written in pure **Haskell**.

---

## ✨ Features

- 🔍 Search for lines matching a regex pattern
- 📂 Read input from files or standard input
- 🧹 Clean, functional Haskell design
- ⚡ Minimal and fast for small-medium files

---

## 📋 Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [Project Structure](#project-structure)
- [Goals](#goals)
- [Contributing](#contributing)
- [License](#license)

---

## ⚙️ Installation

You can build **agrep** with [`stack`](https://docs.haskellstack.org/) or [`cabal`](https://www.haskell.org/cabal/).

### Using Stack

```bash
git clone https://github.com/Turtel216/agrep.git
cd agrep
stack build
```

### Using Cabal

```bash
git clone https://github.com/Turtel216/agrep.git
cd agrep
cabal build
```

---

## 🖥️ Usage

```bash
agrep PATTERN [FILE...]
```

- `PATTERN`: The regex pattern to search for.
- `FILE`: One or more files to search. Defaults to stdin if omitted.

---

## 🔥 Examples

Search for the word `hello` in a file:

```bash
agrep "hello" example.txt
```

Search across multiple `.hs` files:

```bash
agrep "main" *.hs
```

Pipe input and search:

```bash
cat file.txt | agrep "pattern"
```

---

## 📁 Project Structure

```bash
agrep/
├── app/         # Haskell source files 
├── src/         # Haskell library files 
├── test/        # Test files
├── README.md    # This file
└── LICENSE      # Project license
```

---

## 🎯 Goals

- Simple and educational for Haskell learners
- Extensible for future features:
  - [ ] Case-insensitive search (`-i`)
  - [ ] Recursive directory traversal (`-r`)
  - [ ] Colored output for matches
  - [ ] Fuzzy/approximate matching

---

## 🤝 Contributing

Contributions are warmly welcome! Feel free to:

- Open an [issue](https://github.com/Turtel216/agrep/issues)
- Submit a [pull request](https://github.com/Turtel216/agrep/pulls)

Let's build something fun together! 🚀

---

## 📝 License

Licensed under the [MIT License](LICENSE).
