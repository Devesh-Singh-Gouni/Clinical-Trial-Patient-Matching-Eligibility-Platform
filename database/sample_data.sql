-- 1. Insert sample patients

INSERT INTO patients (
    patient_id,
    source_patient_id,
    first_name,
    last_name,
    birth_date,
    gender,
    created_at
)
VALUES
(
    gen_random_uuid(),
    'TEST001',
    'Rahul',
    'Sharma',
    '1980-05-12',
    'M',
    CURRENT_TIMESTAMP
),
(
    gen_random_uuid(),
    'TEST002',
    'Priya',
    'Verma',
    '1995-03-15',
    'F',
    CURRENT_TIMESTAMP
);


-- 2. Insert patient diagnoses

-- Rahul: Type 2 Diabetes

INSERT INTO conditions (
    condition_id,
    patient_id,
    disease_id,
    start_date
)
SELECT
    gen_random_uuid(),
    p.patient_id,
    d.disease_id,
    '2018-01-10'::date
FROM patients p
CROSS JOIN diseases d
WHERE p.source_patient_id = 'TEST001'
AND d.disease_name = 'Type 2 Diabetes';


-- Rahul: Hypertension

INSERT INTO conditions (
    condition_id,
    patient_id,
    disease_id,
    start_date
)
SELECT
    gen_random_uuid(),
    p.patient_id,
    d.disease_id,
    '2020-07-15'::date
FROM patients p
CROSS JOIN diseases d
WHERE p.source_patient_id = 'TEST001'
AND d.disease_name = 'Hypertension';


-- Priya: Asthma

INSERT INTO conditions (
    condition_id,
    patient_id,
    disease_id,
    start_date
)
SELECT
    gen_random_uuid(),
    p.patient_id,
    d.disease_id,
    '2022-03-10'::date
FROM patients p
CROSS JOIN diseases d
WHERE p.source_patient_id = 'TEST002'
AND d.disease_name = 'Asthma';


-- 3. Insert medical observations

-- Rahul's medical observations

INSERT INTO observations (
    observation_id,
    patient_id,
    code,
    code_system,
    description,
    value_numeric,
    unit,
    recorded_at,
    data_source
)
SELECT
    gen_random_uuid(),
    p.patient_id,
    v.code,
    'LOINC',
    v.description,
    v.value_numeric,
    v.unit,
    CURRENT_TIMESTAMP,
    'manual_test'
FROM patients p
CROSS JOIN (
    VALUES
        ('4548-4', 'HbA1c', 8.2, '%'),
        ('39156-5', 'BMI', 29.5, 'kg/m2'),
        ('8480-6', 'Systolic BP', 150, 'mmHg'),
        ('8462-4', 'Diastolic BP', 95, 'mmHg')
) AS v(code, description, value_numeric, unit)
WHERE p.source_patient_id = 'TEST001';


-- Priya's medical observations

INSERT INTO observations (
    observation_id,
    patient_id,
    code,
    code_system,
    description,
    value_numeric,
    unit,
    recorded_at,
    data_source
)
SELECT
    gen_random_uuid(),
    patient_id,
    'FEV1_PERCENT',
    'LOCAL',
    'FEV1 Percent Predicted',
    65,
    '%',
    CURRENT_TIMESTAMP,
    'manual_test'
FROM patients
WHERE source_patient_id = 'TEST002';


-- 4. Insert medication records

-- Rahul's medication

INSERT INTO medications (
    medication_id,
    patient_id,
    medication_name,
    start_date
)
SELECT
    gen_random_uuid(),
    patient_id,
    'Metformin',
    '2018-02-01'::date
FROM patients
WHERE source_patient_id = 'TEST001';


-- Priya's medication

INSERT INTO medications (
    medication_id,
    patient_id,
    medication_name,
    start_date
)
SELECT
    gen_random_uuid(),
    patient_id,
    'Salbutamol',
    '2022-04-01'::date
FROM patients
WHERE source_patient_id = 'TEST002';