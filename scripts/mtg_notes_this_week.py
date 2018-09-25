#! /usr/bin/env python

import os
import argparse
from datetime import datetime, timedelta

MTG_DIR = '/Users/jasonventresca/Dropbox/moat_notes/mtg/standup'


def get_monday(dt=None):
    dt = dt or datetime.now()
    return dt - timedelta(days=(
        dt.weekday() - 1
    ))


def test():
    for n in range(7):
        today = datetime.now() + timedelta(days=n)
        monday = get_monday(today)
        print('today = {}\nmonday = {}\n'.format(today.date(), monday.date()))


def touch(fname, times=None):
    with open(fname, 'a'):
        os.utime(fname, times)


def main():
    monday = get_monday().date()
    return '{mtg_dir}/{monday}.txt'.format(
        mtg_dir=MTG_DIR,
        monday=monday,
    )


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-t', '--test', action='store_true', help='run the tests'
    )
    args = parser.parse_args()

    if args.test:
        test()
    else:
        fname = main()
        touch(fname)
        print(fname)
