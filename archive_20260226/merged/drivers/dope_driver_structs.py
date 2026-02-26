"""
ctypes structure definitions for DoPE (initial draft).

This file contains preliminary ctypes.Structure definitions for the
DoPE default measuring data record and a starter DoPESetup struct.

THESE DEFINITIONS ARE AUTOMATICALLY GENERATED FROM `Seriell-DLL-DOPE.pdf` AND
MUST BE VERIFIED AGAINST THE ORIGINAL DOCUMENT (FIELD ORDER, TYPES, _pack_)
before using them to parse binary data from the DLL.

See `output/structures_extract.txt` for the snippets used to create these.
"""
from ctypes import Structure, c_ulong, c_double, c_uint16, c_uint32, c_ubyte, c_int16, c_uint8


class DoPEData(Structure):
    _pack_ = 1  # Delphi 'packed' records typically use 1-byte alignment
    _fields_ = [
        ("Cycles", c_uint32),     # unsigned long
        ("Time", c_double),       # double
        ("Position", c_double),   # double X-Head position
        ("Load", c_double),       # double Load
        ("Extension", c_double),  # double Extension
        ("SensorD", c_double),    # double DigiPoti / Sensor D
        # Typical measuring channels (Sensor4..Sensor15). The manual
        # documents Sensor4..Sensor15 as configurable channels. Map them to a
        # fixed-size array of 12 doubles (Sensor4..Sensor15).
        ("Sensor", c_double * 12),  # Sensor[0] == Sensor4, ... Sensor[11] == Sensor15

        # Front panel key WORDs (three WORDs): active/new/gone
        ("KeyActive", c_uint16),
        ("KeyNew", c_uint16),
        ("KeyGone", c_uint16),

        # Controller/Status WORDs. The manual defines multiple controller status
        # words (see section 13.3). Use an array to preserve layout; later we
        # will map individual bits to named constants.
        ("CtrlStatus", c_uint16 * 4),

        # System state and output channel counts
        ("SysStateN", c_uint16),
        ("OutChanN", c_uint16),

        # Historically there were McOption1..11 fields; newer versions rename
        # or remove some of these. Reserve space for a couple of doubles to
        # keep alignment close to the original record size.
        ("McOption", c_double * 2),

        # Reserved words/bytes for future extension / unknown fields. Keeping
        # reserved arrays helps avoid misalignment when the exact manual order
        # is not fully transcribed yet.
        ("_reserved_w", c_uint16 * 8),
        ("_reserved_d", c_double * 4),
        # End of initial draft fields. The real record contains more items
        # (bit masks, more status words, and possible expansion fields).
    ]


class DoPESetup(Structure):
    _pack_ = 1
    _fields_ = [
        # Minimal placeholder for setup structure. Exact layout must be
        # transcribed from the manual and verified before use.
        ("SetupNo", c_uint16),
        ("UserScale", c_double),
        ("Reserved", c_ubyte * 4),
    ]


__all__ = ["DoPEData", "DoPESetup"]
