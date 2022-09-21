#!/usr/bin/env python3

import re
import sqlite3
import unicodedata

def asciify(s):
    # 'K' - compatibility (U+2160 ROMAN NUMERAL ONE => U+0049 1)
    # 'D' - decompose (U+00C7 LATIN CAPITAL LETTER C WITH CEDILLA => U+0043 C + U+0327 COMBINING CEDILLA)
    normalized = unicodedata.normalize('NFKD', s)
    return ''.join([c for c in normalized if ord(c) < 0xf0])

def parameterize(s):
    ret = re.sub('[^a-zA-Z0-9\-_]+', '-', asciify(s).lower())
    if ret[0] == '-':
        ret = ret[1:]
    # throw IndexError on empty string
    if ret[-1] == '-':
        ret = ret[:-1]
    return ret.lower()

def yaml_quote_string(s):
    return "'" + s.replace("'", "''") + "'"

def main():
    db = sqlite3.connect("../../production.sqlite3")
    cursor = db.cursor()
    for id, title, body, created_at in cursor.execute("SELECT id, title, body, created_at FROM eng_articles"):
        slug = str(id) + '-' + parameterize(title)
        # path = created_at[:10] + '-' + parameterize(title) + '.html'
        path = 'articles/' + slug + '.textile'
        content = '\n'.join([
            '---',
            'id: ' + str(id),
            'title: ' + yaml_quote_string(title),
            'slug: ' + slug,
            'date: ' + created_at.replace(' ', 'T') + 'Z',
            '---',
            body
        ])
        with open(path, 'wt') as f:
            f.write(content)

    db.close()


if __name__ == '__main__':
    main()
