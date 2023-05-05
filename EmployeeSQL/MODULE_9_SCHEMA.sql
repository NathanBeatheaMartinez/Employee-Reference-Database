-- Create the different tables neccessary for analysis

-- Create 'titles' table

CREATE TABLE "titles" (
    "title_id" varchar(30)   NOT NULL,
    "title" varchar(50)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

-- Create 'employees' table

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title_id" varchar(50)   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar(50)   NOT NULL,
    "last_name" varchar(50)   NOT NULL,
    "sex" varchar   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);


-- Create 'departments' table

CREATE TABLE "departments" (
    "dept_no" varchar(50)   NOT NULL,
    "dept_name" varchar(50)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);


-- Create 'dept_manager' table

CREATE TABLE "dept_manager" (
    "dept_no" varchar(50)   NOT NULL,
    "emp_no" int   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "dept_no","emp_no"
     )
);


-- Create 'dept_emp' table

CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" varchar(50)   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);


-- Create 'dept_emp' table

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

-- ADD PRIMARY AND FOREIGN KEY CONSTRAINTS

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

-- Join the employees and salaries tables
-- List the employee number, last name, first name, sex, and salary of each employee

SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees as e
INNER JOIN salaries as s ON
s.emp_no=e.emp_no;

-- List the first name, last name, and hire date for the employees who were hired in 1986

SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date BETWEEN '01/01/1986' AND '12/31/1986'

-- List the manager of each department along with their department number, department name, employee number, last name, and first name

SELECT depm.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name
FROM ((employees as e
INNER JOIN dept_manager as depm ON
depm.emp_no=e.emp_no)
INNER JOIN departments as d ON
d.dept_no=depm.dept_no);

-- List the department number for each employee along with that employee’s employee number, last name, first name, and department name

SELECT depe.dept_no, e.emp_no, e.last_name, e.first_name, d.dept_name
FROM ((employees as e
INNER JOIN dept_emp as depe ON
depe.emp_no=e.emp_no)
INNER JOIN departments as d ON
d.dept_no=depe.dept_no);

-- List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B

SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%'

-- List each employee in the Sales department, including their employee number, last name, and first name
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM ((employees as e
INNER JOIN dept_emp as depe ON
depe.emp_no=e.emp_no)
INNER JOIN departments as d ON
d.dept_no=depe.dept_no)
WHERE depe.dept_no = 'd007';

-- List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM ((employees as e
INNER JOIN dept_emp as depe ON
depe.emp_no=e.emp_no)
INNER JOIN departments as d ON
d.dept_no=depe.dept_no)
WHERE depe.dept_no = 'd007'
OR depe.dept_no = 'd005';

-- List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name)

SELECT last_name, COUNT(last_name) 
FROM employees
GROUP BY last_name
ORDER BY COUNT(last_name) DESC


