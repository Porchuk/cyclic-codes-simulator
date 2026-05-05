# cyclic-codes-simulator

A desktop application for simulation of polynomial and cyclic error-correcting codes.  
The system allows encoding, decoding, and error correction using classical information theory algorithms.

---

## Stack

**Language / Platform** — Object Pascal (Delphi), VCL  
**Algorithms** — Shannon-Fano, Huffman, Hamming (7,4), Cyclic Codes  

---

## Features

- Text encoding using Shannon-Fano algorithm  
- Text encoding using Huffman algorithm  
- Decoding of binary encoded messages  
- Generation of cyclic codes  
- Detection and correction of single-bit errors (Hamming (7,4))  
- Polynomial-based encoding and syndrome calculation  
- Visualization of encoding results in tables  
- Interactive GUI for input/output data  

---

## Description

The application implements core concepts of information theory and coding.  
It provides tools to simulate:

- efficient data compression (Shannon-Fano, Huffman)
- error detection and correction using cyclic codes
- polynomial representation of codewords
- syndrome-based error localization

The program is designed as an educational tool for studying coding theory and demonstrates how different algorithms affect data transmission reliability.

---

## Use Cases

- Encode text into binary representation  
- Decode binary message back to original text  
- Generate cyclic code for given input sequence  
- Detect and locate transmission errors  
- Correct single-bit errors in received data  

---

## Author

- Ivan Porchuk  
- Chernivtsi National University  

---

## Notes

This project was developed as a course work for the subject related to information theory and coding.
Merge Shannon-Fano feature
