#!/usr/bin/env python

from __future__ import print_function

import sys
import json


LINE_DELIMITER = '-' * 80


def main(line_delimiter=LINE_DELIMITER):
    for line in sys.stdin:
        try:
            obj = json.loads(line)
        except ValueError as e:
            raise SystemExit(e)

        print(json.dumps(obj, sort_keys=True, indent=4, separators=(',', ': ')))
        print("\n" + line_delimiter + "\n")


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--delimiter', type=str, default=LINE_DELIMITER, help='Line to separate each output pretty-printed line.')
    args = parser.parse_args()
    main()
