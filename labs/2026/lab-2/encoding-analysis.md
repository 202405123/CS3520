# Lab 2 - Encoding analysis (B-type and J-type)

## Branch (B-type): bge t0, t1, use_a  (ex1-larger-of-two)

Address 0x10, target use_a at 0x1c, so the offset is +12 bytes.
Encoding from Ripes: 0x0062d663
Binary: 0000 0000 0110 0010 1101 0110 0110 0011

| Field | Bits | Value | Meaning |
|---|---|---|---|
| imm[12] | 31 | 0 | sign bit of the offset |
| imm[10:5] | 30-25 | 000000 | upper offset bits |
| rs2 | 24-20 | 00110 | t1 (x6) |
| rs1 | 19-15 | 00101 | t0 (x5) |
| funct3 | 14-12 | 101 | bge |
| imm[4:1] | 11-8 | 0110 | lower offset bits |
| imm[11] | 7 | 0 | offset bit 11 |
| opcode | 6-0 | 1100011 | branch instructions |

Reassembling the immediate: imm[12|11|10:5|4:1] followed by an implicit 0 gives 0 0 000000 0110 0 = 12.

## Jump (J-type): jal ra, factorial  (ex4-factorial)

Address 0x08, target factorial at 0x34, so the offset is +44 bytes.
Encoding from Ripes: 0x02c000ef
Binary: 0000 0010 1100 0000 0000 0000 1110 1111

| Field | Bits | Value | Meaning |
|---|---|---|---|
| imm[20] | 31 | 0 | sign bit of the offset |
| imm[10:1] | 30-21 | 0000010110 | low offset bits |
| imm[11] | 20 | 0 | offset bit 11 |
| imm[19:12] | 19-12 | 00000000 | high offset bits |
| rd | 11-7 | 00001 | ra (x1), receives the return address |
| opcode | 6-0 | 1101111 | jal |

Reassembling the immediate: imm[20|19:12|11|10:1] followed by an implicit 0 gives 0 00000000 0 0000010110 0 = 44.

## Why the immediate is scattered

The register fields (rs1, rs2, rd) and the sign bit stay in the same bit positions in every instruction format, so the hardware can read registers and start sign extension before it knows which format it is decoding. The immediate bits are therefore placed around those fixed fields, which looks scrambled but keeps the decoder simple. The lowest offset bit is not stored because jump and branch targets are always even.
