#!/bin/bash
mysql -uroot -p -h127.0.0.1 -P3306 -Dflashcards <<EOF
SELECT * FROM categories;
EOF
