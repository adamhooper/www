#!/usr/bin/env python3

import re
import sqlite3
import unicodedata

BODY_NEEDS_SUMMARY_RE = re.compile(r'.*?</p>.*?</p>.*?</p>.*?</p>', re.S)
BODY_SUMMARY_RE = re.compile(r'(.*?</p>.*?</p>.*?</p>)', re.S)

def body_needs_summary(body):
    return BODY_SUMMARY_RE.match(body) is not None

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

def body_maybe_add_more_comment(body):
    if body_needs_summary(body):
        return BODY_SUMMARY_RE.sub('\\1\n<!--more-->', body)
    return body

def yaml_quote_string(s):
    return "'" + s.replace("'", "''") + "'"

def main():
    db = sqlite3.connect("../../production.sqlite3")
    cursor = db.cursor()
    for id, title, body, created_at, tags in cursor.execute("SELECT id, title, body, created_at, (SELECT GROUP_CONCAT(name) FROM tags WHERE id IN (SELECT tag_id FROM blog_posts_tags WHERE blog_post_id = blog_posts.id)) FROM blog_posts"):
        slug = str(id) + '-' + parameterize(title)
        # path = created_at[:10] + '-' + parameterize(title) + '.html'
        path = slug + '.html'
        content = '\n'.join([
            '---',
            'id: ' + str(id),
            'title: ' + yaml_quote_string(title),
            'slug: ' + slug,
            'date: ' + created_at.replace(' ', 'T') + 'Z',
            'tags: [' + tags + ']',
            '---',
            body_maybe_add_more_comment(body)
        ])
        with open(path, 'wt') as f:
            f.write(content)

    db.close()


if __name__ == '__main__':
    main()
