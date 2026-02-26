"""
DoPE constants and helper functions (bit masks for controller status and keys).

These masks are transcribed conservatively from `Seriell-DLL-DOPE.pdf` (section
13 controller status). Field order/meaning should be verified against the
original manual. The file provides decoding helpers to map status words to
human-readable flags.
"""
from typing import Dict, List

# Controller status WORD bits (bit positions taken from manual's listing).
# The PDF lists bits 15..0 with names; we map bit 15 to the highest-order bit.
# NOTE: Confirm these bit names & order against the original manual before use.

# Bit masks (1 << bit_index). Using MSB=bit15 ... LSB=bit0
CTRL_FREE = 1 << 15
CTRL_STATE_POS = 1 << 14
CTRL_STATE_LOAD = 1 << 13
CTRL_STATE_EXT = 1 << 12
# bit11 reserved
CTRL_HALT = 1 << 10
CTRL_DOWN = 1 << 9
CTRL_UP = 1 << 8
CTRL_MOVE = 1 << 7  # cross-head not halted
CTRL_READY = 1 << 6
CTRL_INIT_E = 1 << 5
CTRL_SFTSET = 1 << 4
# bit3 reserved
# bit2 SYNCH_STATEMASTER/SLAVE - requires multi-bit interpretation
SYNCH_STATE_MASK = (1 << 3) | (1 << 2)
CTRL_E_ACTIVE = 1 << 1
# bit0 reserved or other

# Front-panel key masks (these are transmitted as WORDs in the data record).
# We don't know exact bit numbering for each key here; keep as placeholders.
KEY_UP = 1 << 0
KEY_DOWN = 1 << 1
KEY_HALT = 1 << 2
KEY_DIGIPOTI = 1 << 3


def decode_ctrl_status(word: int) -> List[str]:
    """Return list of human-readable flags set in controller status WORD."""
    flags = []
    if word & CTRL_FREE:
        flags.append("CTRL_FREE")
    if word & CTRL_STATE_POS:
        flags.append("CTRL_STATE_POS")
    if word & CTRL_STATE_LOAD:
        flags.append("CTRL_STATE_LOAD")
    if word & CTRL_STATE_EXT:
        flags.append("CTRL_STATE_EXT")
    if word & CTRL_HALT:
        flags.append("CTRL_HALT")
    if word & CTRL_DOWN:
        flags.append("CTRL_DOWN")
    if word & CTRL_UP:
        flags.append("CTRL_UP")
    if word & CTRL_MOVE:
        flags.append("CTRL_MOVE")
    if word & CTRL_READY:
        flags.append("CTRL_READY")
    if word & CTRL_INIT_E:
        flags.append("CTRL_INIT_E")
    if word & CTRL_SFTSET:
        flags.append("CTRL_SFTSET")
    # SYNCH_STATE handled specially
    synch = (word & SYNCH_STATE_MASK) >> 2
    if synch == 1:
        flags.append("SYNCH_MASTER")
    elif synch == 2:
        flags.append("SYNCH_SLAVE")
    if word & CTRL_E_ACTIVE:
        flags.append("CTRL_E_ACTIVE")
    return flags


def keys_from_word(word: int) -> List[str]:
    """Decode front-panel key WORD into list of active key names (best-effort)."""
    res = []
    if word & KEY_UP:
        res.append("UP")
    if word & KEY_DOWN:
        res.append("DOWN")
    if word & KEY_HALT:
        res.append("HALT")
    if word & KEY_DIGIPOTI:
        res.append("DIGIPOTI")
    return res


__all__ = [
    # masks
    "CTRL_FREE",
    "CTRL_STATE_POS",
    "CTRL_STATE_LOAD",
    "CTRL_STATE_EXT",
    "CTRL_HALT",
    "CTRL_DOWN",
    "CTRL_UP",
    "CTRL_MOVE",
    "CTRL_READY",
    "CTRL_INIT_E",
    "CTRL_SFTSET",
    "SYNCH_STATE_MASK",
    "CTRL_E_ACTIVE",
    # helpers
    "decode_ctrl_status",
    "keys_from_word",
]
"""
DoPE-related constants and bitmask helpers.

NOTE: Many bit positions below are inferred from the extracted PDF text
(`output/Seriell_DLL_DOPE_text.txt`) and are marked as provisional. You
must verify bit numbers against the official header or the original PDF
pages before using these masks for production control logic.
"""
from typing import Dict


def _bit(n: int) -> int:
    return 1 << n


# Controller status WORD 1 bitmasks (provisional - verify against manual)
# Mapping is assigned from bit15 down to bit0 based on PDF layout snippets.
CTRL_FREE = _bit(15)
CTRL_STATE_POS = _bit(14)
CTRL_STATE_LOAD = _bit(13)
CTRL_STATE_EXT = _bit(12)
CTRL_RESERVED_1 = _bit(11)
CTRL_HALT = _bit(10)
CTRL_DOWN = _bit(9)
CTRL_UP = _bit(8)
CTRL_MOVE = _bit(7)    # movement active (not halted)
CTRL_READY = _bit(6)
CTRL_INIT_E = _bit(5)
CTRL_SFTSET = _bit(4)
CTRL_RESERVED_2 = _bit(3)
SYNCH_STATE = _bit(2)  # master/slave indicator
CTRL_E_ACTIVE = _bit(1)
CTRL_UNKNOWN_0 = _bit(0)


_CTRL_FLAGS = [
    ("CTRL_FREE", CTRL_FREE),
    ("CTRL_STATE_POS", CTRL_STATE_POS),
    ("CTRL_STATE_LOAD", CTRL_STATE_LOAD),
    ("CTRL_STATE_EXT", CTRL_STATE_EXT),
    ("CTRL_HALT", CTRL_HALT),
    ("CTRL_DOWN", CTRL_DOWN),
    ("CTRL_UP", CTRL_UP),
    ("CTRL_MOVE", CTRL_MOVE),
    ("CTRL_READY", CTRL_READY),
    ("CTRL_INIT_E", CTRL_INIT_E),
    ("CTRL_SFTSET", CTRL_SFTSET),
    ("SYNCH_STATE", SYNCH_STATE),
    ("CTRL_E_ACTIVE", CTRL_E_ACTIVE),
]


def decode_ctrl_status(word: int) -> Dict[str, bool]:
    """Return a dict mapping known CTRL flags to booleans for a status WORD."""
    return {name: bool(word & mask) for name, mask in _CTRL_FLAGS}


__all__ = [
    "_bit",
    "CTRL_FREE",
    "CTRL_STATE_POS",
    "CTRL_STATE_LOAD",
    "CTRL_STATE_EXT",
    "CTRL_HALT",
    "CTRL_DOWN",
    "CTRL_UP",
    "CTRL_MOVE",
    "CTRL_READY",
    "CTRL_INIT_E",
    "CTRL_SFTSET",
    "SYNCH_STATE",
    "CTRL_E_ACTIVE",
    "decode_ctrl_status",
]
