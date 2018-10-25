#!/usr/bin/env python
import argparse


parser = argparse.ArgumentParser()
parser.add_argument('who', nargs='?', default='World')
args = parser.parse_args()
print(f'Hello, {args.who}!')
