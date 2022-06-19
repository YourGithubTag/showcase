#!/usr/bin/env python3

import math
import struct
import sys

st = lambda n: 2**(n/12)
i16 = struct.Struct('<h')
i32 = struct.Struct('<l')

ms = 10_000 # Milliseconds
L = (330, 330*st(3), 330*st(6), 330*st(9))  # Edim7
R = (440, 440*st(4), 440*st(7), 440*st(11)) # Amaj7

def main():
  raw = b''.join(collect(sample(L), sample(R)))
  with open('wave.wav', 'wb') as f:
    for bs in wave(raw):
      f.write(bs)

def sample(fs):
  for t in range(ms*48):
    yield sum(math.sin(math.tau * t/48000 * f) for f in fs)

def collect(ls, rs):
  for l, r in zip(ls, rs):
    yield i16.pack(int(l*0x800))
    yield i16.pack(int(r*0x800))

def wave(raw):
    # WAVE header
    yield b'RIFF'
    yield i32.pack(len(raw)+36)
    yield b'WAVE'

    # WAVE format
    yield b'fmt '
    yield i32.pack(16)
    yield i16.pack(1)      # sample format
    yield i16.pack(2)      # channels
    yield i32.pack(48000)  # sample rate
    yield i32.pack(192000) # byte rate
    yield i16.pack(4)      # bytes per sample
    yield i16.pack(16)     # bits per channel

    # WAVE data
    yield b'data'
    yield i32.pack(len(raw))
    yield raw

if __name__ == '__main__':
  sys.exit(main())
