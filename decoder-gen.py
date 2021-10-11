#!/usr/bin/python3
from SpecParser import parseSpec
from backend.systemVerilog.SVbackend import sv_backend


if __name__ == '__main__':
    spec = parseSpec()
    sv_backend(spec)