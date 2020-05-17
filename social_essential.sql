-- Find the names of all students who are friends with someone named Gabriel.

SELECT NAME
FROM highschooler AS hs
    JOIN friend AS f
    ON hs.id = f.id1
WHERE  f.id2 IN (SELECT id
FROM highschooler
WHERE  NAME = "gabriel")


-- For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.

SELECT h1.name, h1.grade, h2.name, h2.grade
FROM Likes
    JOIN Highschooler as h1 ON Likes.ID1 = h1.ID
    JOIN Highschooler as h2 ON Likes.ID2 = h2.ID
WHERE h1.grade - h2.grade > 1

-- For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.

SELECT hs1.name, hs1.grade, hs2.name, hs2.grade
FROM Likes as l
    JOIN Likes as l1 ON l.ID1 = l1.ID2 and l.ID2 = l1.ID1
    JOIN Highschooler as hs1 ON l.ID1 = hs1.ID
    JOIN Highschooler as hs2 ON l.ID2 = hs2.ID
WHERE hs1.name < hs2.name

-- Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.

SELECT name, grade
FROM Highschooler as h
    LEFT JOIN Likes as l1 ON h.ID = l1.ID1
    LEFT JOIN Likes as l2 ON h.ID = l2.ID2
WHERE l1.ID1 IS NULL AND l1.ID2 is NULL AND l2.ID1 IS NULL AND l2.ID2 is NULL
ORDER BY grade,name

-- For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.

SELECT hs1.name, hs1.grade, hs2.name, hs2.grade
from Likes as l
    JOIN Highschooler as hs1 ON l.ID1 = hs1.ID
    JOIN Highschooler as hs2 on l.ID2 = hs2.ID
WHERE ID2 NOT IN ( SELECT ID1
from Likes )

-- Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.

SELECT name, grade
FROM Highschooler H1
WHERE ID NOT IN (
  SELECT ID1
FROM Friend, Highschooler H2
WHERE H1.ID = Friend.ID1 AND H2.ID = Friend.ID2 AND H1.grade <> H2.grade
)
ORDER BY grade, name;

-- For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.

SELECT hs1.NAME,
    hs1.grade,
    hs2.NAME,
    hs2.grade,
    hs3.NAME,
    hs3.grade
FROM highschooler hs1,
    highschooler hs2,
    highschooler hs3,
    likes l,
    friend f1,
    friend f2
WHERE  ( hs1.id = L.id1
    AND hs2.id = L.id2 )
    AND hs2.id NOT IN (SELECT friend.id2
    FROM friend
    WHERE  friend.id1 = hs1.id)
    AND ( hs1.id = f1.id1
    AND hs3.id = f1.id2 )
    AND ( hs2.id = f2.id1
    AND hs3.id = f2.id2 )


-- Find the difference between the number of students in the school and the number of different first names.

SELECT total_students.count - distinct_names.count
FROM (SELECT Count(DISTINCT id) AS count
    FROM highschooler) AS total_students,
    (SELECT Count(DISTINCT NAME) AS count
    FROM highschooler) AS distinct_names

-- Find the name and grade of all students who are liked by more than one other student.

SELECT NAME,
    grade
FROM highschooler
WHERE  id IN (SELECT l.id2
FROM likes AS l
GROUP  BY l.id2
HAVING Count(l.id2) > 1)