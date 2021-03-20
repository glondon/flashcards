#!/bin/bash
MYSQL="mysql -uroot -h127.0.0.1 -P3306 -Dflashcards --skip-column-names"
qCourses="SELECT id, course FROM courses;"
courses=()
echo -e "\nSELECT A COURSE ID TO STUDY\n"
echo "ID COURSE"
while IFS=$'\t' read -a row
do
	echo "${row[0]}  ${row[1]}"
	courses+=(${row[0]})
done < <(echo $qCourses | $MYSQL)

read -s courseId

if [[ ! "${courses[@]}" =~ "${courseId}" ]]; then
	echo "Invalid courseId"
	exit 1
fi
echo -e "\nSELECT A CATEGORY ID TO STUDY\n"
echo "ID CATEGORY"
categories=()
qCategoryIds="SELECT id, category FROM categories WHERE course_id = ${courseId};"
while IFS=$'\t' read -a row
do
	echo "${row[0]}  ${row[1]}"
	categories+=(${row[0]})
done < <(echo $qCategoryIds | $MYSQL)
read -s categoryId
if [[ ! "${categories[@]}" =~ "${categoryId}" ]]; then
	echo "Invalid categoryId"
	exit 1
fi
qCards="SELECT REPLACE(front, '\r\n\r\n', ' '), REPLACE(back, '\r\n\r\n', ' ') FROM cards WHERE category_id = ${categoryId} ORDER BY RAND()"
exec 3<&0
while IFS=$'\t' read -a row
do
	echo "${row[0]}"
	echo "---------------------------------"
	printf 'Press <enter> to continue..' >&2
	read keypress <&3
	echo "---------------------------------"
	echo "${row[1]}"
	echo "---------------------------------"
done < <(echo $qCards | $MYSQL)
exec 3<&-
echo -e "\nFINISHED"
