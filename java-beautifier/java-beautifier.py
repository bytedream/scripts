#!/usr/bin/python3

import sys

if __name__ == '__main__':
    file = sys.argv[-1]

    lenght = 0
    content = []
    new_content = []

    for line in open(file, 'r'):
        line = line.strip()
        if line:
            if len(line) > lenght:
                lenght = len(line)
            content.append(line)

    lenght = lenght + 2

    for i, line in enumerate(content):
        if line and line[-1] in ('{', '}'):
            if len(line.strip()) == 1 and i != 0:
                new_content[-1] += ' ' * (lenght - len(new_content[-1]) - 1) + line[-1]
            else:
                new_content.append(line[:-1] + (' ' * (lenght - len(line))) + line[-1])
        else:
            new_content.append(line)

    sys.stdout.write('\n'.join(new_content))
