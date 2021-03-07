#!/bin/bash
MYSQL="mysql -uroot -p -h127.0.0.1 -P3306 -Dflashcards --skip-column-names"
categories=()
qCategoryIds="SELECT id FROM categories WHERE course_id = 1;"
while read -a row
do
	categories+=(${row[0]})
done < <(echo $qCategoryIds | $MYSQL)
echo "${categories[@]}"
