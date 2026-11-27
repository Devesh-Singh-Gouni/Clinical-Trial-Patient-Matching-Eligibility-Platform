-- Query 1: Find patients and their diseases

SELECT
    p.first_name,
    p.last_name,
    d.disease_name,
    c.start_date
FROM patients p
INNER JOIN conditions c
    ON p.patient_id = c.patient_id
INNER JOIN diseases d
    ON c.disease_id = d.disease_id;


-- Query 2: Retrieve patient medical observations

SELECT
    p.first_name,
    p.last_name,
    o.description,
    o.value_numeric,
    o.unit
FROM patients p
INNER JOIN observations o
    ON p.patient_id = o.patient_id;


-- Query 3: Find all patients with Diabetes

SELECT DISTINCT
    p.patient_id,
    p.first_name,
    p.last_name,
    d.disease_name
FROM patients p
INNER JOIN conditions c
    ON p.patient_id = c.patient_id
INNER JOIN diseases d
    ON c.disease_id = d.disease_id
WHERE d.disease_name = 'Type 2 Diabetes';


-- Query 4: Retrieve patient medications

SELECT
    p.first_name,
    p.last_name,
    m.medication_name,
    m.start_date
FROM patients p
INNER JOIN medications m
    ON p.patient_id = m.patient_id;


-- Query 5: Count patients for each disease

SELECT
    d.disease_name,
    COUNT(DISTINCT c.patient_id) AS total_patients
FROM diseases d
LEFT JOIN conditions c
    ON d.disease_id = c.disease_id
GROUP BY d.disease_id, d.disease_name
ORDER BY total_patients DESC;


-- Query 6: Perform basic clinical trial screening

SELECT DISTINCT
    p.first_name,
    p.last_name,
    EXTRACT(YEAR FROM AGE(p.birth_date)) AS age,
    d.disease_name,
    o.value_numeric AS hba1c
FROM patients p
INNER JOIN conditions c
    ON p.patient_id = c.patient_id
INNER JOIN diseases d
    ON c.disease_id = d.disease_id
INNER JOIN observations o
    ON p.patient_id = o.patient_id
WHERE d.disease_name = 'Type 2 Diabetes'
AND o.code = '4548-4'
AND o.unit = '%'
AND o.value_numeric BETWEEN 7 AND 10
AND EXTRACT(YEAR FROM AGE(p.birth_date))
    BETWEEN 18 AND 75;


-- Query 7: Verify total record counts

SELECT 'patients' AS table_name,
       COUNT(*) AS total_records FROM patients
UNION ALL
SELECT 'diseases', COUNT(*) FROM diseases
UNION ALL
SELECT 'conditions', COUNT(*) FROM conditions
UNION ALL
SELECT 'observations', COUNT(*) FROM observations
UNION ALL
SELECT 'medications', COUNT(*) FROM medications;