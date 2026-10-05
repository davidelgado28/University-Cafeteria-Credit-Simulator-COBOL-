# University Cafeteria Credit Simulator (COBOL)

An educational COBOL program designed to demonstrate structured programming concepts, interactive menu loops, condition handling, and in-memory table manipulation using ANSI COBOL / GnuCOBOL.

## Project Overview

This project simulates a console-based cafeteria credit terminal (*Refeitório Universitário*) for academic purposes. It provides students with a practical example of how classic COBOL applications handle user authentication, in-memory arrays, input validation, and formatted currency displays without relying on database engines or file systems.

---

## Key Educational Concepts Demonstrated

- **Classic 4-Division Architecture:** Clear layout of `IDENTIFICATION`, `ENVIRONMENT`, `DATA`, and `PROCEDURE` divisions.
- **In-Memory Tables (`OCCURS` & `REDEFINES`):** Defining static data structures and reinterpreting memory layouts to query mock records.
- **Level 88 Condition Names:** Expressive flag management (`AUTENTICADO`, `OPCAO-CONSULTAR`, `SISTEMA-ENCERRADO`) instead of magic numbers.
- **Structured Control Flow:** Clean loop control using `PERFORM UNTIL` and decision trees using `EVALUATE` without `GO TO` statements.
- **Numeric Formatting & Localization:** Using `DECIMAL-POINT IS COMMA` and edit masks (`ZZZ.ZZ9,99`) for zero-suppression and locale-specific currency output.

---

## Features

1. **Authentication Flow:** Validates a 9-digit Student ID and 4-digit Security Token against pre-loaded memory records.
2. **Interactive Menu:**
   - **Option 1 (Balance Query):** Displays current credits formatted as currency (e.g., `R$ 150,00`).
   - **Option 2 (Debit Credits):** Deducts a specified amount after checking for sufficient balance.
   - **Option 3 (Recharge Credits):** Adds funds to the student's cafeteria balance.
   - **Option 4 (Logout):** Ends the current student session and returns to the login screen.

---

## Pre-loaded Test Accounts

| Student Name | ID (9 digits) | Token (4 digits) | Initial Balance |
| :--- | :--- | :--- | :--- |
| **Maria Silva** | `123456789` | `1234` | R$ 150,00 |
| **Joao Souza** | `987654321` | `4321` | R$ 50,50 |
| **Ana Oliveira** | `456789123` | `9999` | R$ 300,25 |

---

## Getting Started

### Prerequisites

You need a COBOL compiler installed on your system. **GnuCOBOL** (formerly OpenCOBOL) is recommended.

#### Installation

- **Linux (Ubuntu/Debian):**
  ```bash
  sudo apt update
  sudo apt install gnucobol
  ```
- **macOS (via Homebrew):**
  ```bash
  brew install gnucobol
  ```
- **Windows:** Download GnuCOBOL via MinGW or use Windows Subsystem for Linux (WSL).

---

### Compilation & Execution

1. **Clone or save the repository:**
   Save the source code as `refeitorio.cob`.

2. **Compile the source code:**
   ```bash
   cobc -x -o refeitorio refeitorio.cob
   ```
   * `-x` generates an executable binary.
   * `-o refeitorio` specifies the output filename.

3. **Run the executable:**
   - **Linux / macOS:**
     ```bash
     ./refeitorio
     ```
   - **Windows:**
     ```cmd
     refeitorio.exe
     ```

---

## Example Output

```text
========================================
  REFEITORIO UNIVERSITARIO - LOGIN
========================================
Informe o ID do Aluno (9 digitos): 123456789
Informe o Token de Acesso (4 digitos): 1234

>>> Bem-vindo(a), MARIA SILVA      !

----------------------------------------
          MENU DE OPCOES
----------------------------------------
1 - Consultar Credito Atual
2 - Debito de Credito (Uso RU)
3 - Recarga de Credito
4 - Finalizar Sessao (Sair)
Escolha uma opcao: 1

----------------------------------------
Aluno: MARIA SILVA      
Saldo Atual: R$     150,00
----------------------------------------
```
