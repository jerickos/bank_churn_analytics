SELECT COUNT(*)
FROM diabetes;

SELECT *
FROM diabetes
LIMIT 5;

CREATE TABLE patients (
	patient_id BIGINT PRIMARY KEY,
	race VARCHAR(30),
	gender VARCHAR(10),
	age INT,
	weight VARCHAR(10),
	admission_type VARCHAR(50),
	discharge_disposition VARCHAR(50),
	admission_source VARCHAR(50)
);

CREATE TABLE encounters (
	encounter_id BIGINT PRIMARY KEY,
	patient_id BIGINT REFERENCES patients(patient_id),
	readmitted BOOLEAN,
	time_in_hospital INT,
	num_lab_procedures INT,
	num_procedures INT,
	num_medications INT,
	number_outpatient INT,
	number_emergency INT,
	number_inpatient INT, 
	medical_specialty VARCHAR(50)
);


CREATE TABLE diagnoses (
	diag_id SERIAL PRIMARY KEY,
	encounter_id BIGINT REFERENCES encounters(encounter_id),
	diag_order SMALLINT,
	icd9_code VARCHAR(10),
	diag_group VARCHAR(50)
);

CREATE TABLE labs (
	lab_id SERIAL PRIMARY KEY,
	encounter_id BIGINT REFERENCES encounters(encounter_id),
	max_glu_serum SMALLINT,
	a1c_results SMALLINT
);

CREATE TABLE medications (
	med_id SERIAL PRIMARY KEY,
	encounter_id BIGINT REFERENCES encounters(encounter_id),
	drug_name VARCHAR(50),
	status SMALLINT
)

SELECT table_name FROM information_schema.tables WHERE table_schema='public';

SELECT column_name, data_type, character_maximum_length
FROM information_schema.columns
WHERE table_name = 'patients';

ALTER TABLE patients
ALTER COLUMN gender TYPE VARCHAR(50);


SELECT *
FROM diagnoses
LIMIT 5;

ALTER TABLE diagnoses
RENAME COLUMN icd9_code TO diag_category;

ALTER TABLE diagnoses
DROP COLUMN diag_group;


SELECT *
FROM diagnoses
LIMIT 5;

SELECT DISTINCT diag_group
FROM diagnoses;

SELECT *
FROM labs
LIMIT 5;


SELECT *
FROM medications
LIMIT 5;

--count and investigation drug prescruptions
SELECT drug_name, COUNT(*) AS total_prescriptions
FROM medications
WHERE status > 0 
GROUP BY drug_name
ORDER BY total_prescriptions DESC;

--medication adjustments
SELECT drug_name,
       SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END) AS increased,
       SUM(CASE WHEN status = 3 THEN 1 ELSE 0 END) AS decreased
FROM medications
GROUP BY drug_name;

--investigates if patients where prescirbe more than one drug
SELECT encounter_id, COUNT(*) AS num_drugs
FROM medications
WHERE status > 0
GROUP BY encounter_id
HAVING COUNT(*) > 1;


--investigate which drugs affect changes in A1C
SELECT l.a1c_results, m.drug_name, COUNT(*) as changes
FROM labs l
JOIN medications m on l.encounter_id = m.encounter_id
WHERE m.status in (2,3) --2up/3down
GROUP BY l.a1c_results, m.drug_name
ORDER BY changes DESC;


--avg glucose lever per medication
--status 0:NO, 1:steady, 2:up, 3:down
SELECT m.drug_name, m.status, AVG(l.max_glu_serum) AS avg_glu
FROM medications m
JOIN labs l on M.encounter_id = l.encounter_id
GROUP BY m.drug_name, m.status;

--drug perscribe for primary diagnoses
SELECT d.diag_category, m.drug_name, COUNT(*) AS prescriptions
FROM diagnoses d
JOIN medications m ON d.encounter_id = m.encounter_id
WHERE m.status > 0 and d.diag_order = 1
GROUP BY d.diag_category, m.drug_name
ORDER BY prescriptions DESC;

--identifying top secondary diagnoses
SELECT diag_category, COUNT(*) AS freq
FROM diagnoses 
WHERE diag_order = 2
GROUP BY diag_category
ORDER BY freq DESC;


--
SELECT d.diag_category, m.drug_name, COUNT(*) AS prescriptions
FROM diagnoses d
JOIN medications m ON d.encounter_id = m.encounter_id
WHERE diag_order = 2 AND m.status > 0
GROUP BY diag_category, m.drug_name
ORDER BY prescriptions DESC;

--how often primary and secondary diagnoses pairs occurs
SELECT d1.diag_category AS primary, d2.diag_category AS secondary, COUNT(*) AS freq
FROM diagnoses d1
JOIN diagnoses d2 ON d1.encounter_id = d2.encounter_id
WHERE d1.diag_order = 1 AND d2.diag_order = 2
GROUP BY d1.diag_category, d2.diag_category
ORDER BY freq DESC;

--age was a categorical value and was change to average in a set of 5
SELECT *
FROM patients
LIMIT 5;

--count the number of patients per age group and identify which group has the highest concentration
SELECT age, COUNT(*) AS num_patients
FROM patients
group by age
ORDER BY num_patients DESC;
SELECT age;

SELECT gender, COUNT(*) AS num_patients
FROM patients
GROUP BY gender;

--distrubution of patients per race
SELECT race, COUNT(*) AS num_patients
FROM patients
GROUP BY race 
ORDER BY num_patients DESC;

--distrubution of adission type of the hospital
SELECT admission_type, COUNT(*) AS freq
FROM patients
GROUP BY admission_type
ORDER BY freq DESC;

--discharge of patients
SELECT discharge_disposition, COUNT(*) as freq
FROM patients
GROUP BY discharge_disposition
ORDER BY freq DESC;

--readmission rate per age
SELECT p.age, 
		SUM(CASE WHEN e.readmitted = 'YES' THEN 1 ELSE 0 END) AS readmission,
		COUNT(*) AS total,
		ROUND(SUM(CASE WHEN e.readmitted = 'YES' THEN 1 ELSE 0 END) *100/ COUNT(*), 2) AS readmission_rate
FROM patients p 	
JOIN encounters e
ON p.patient_id = e.patient_id
GROUP BY p.age
ORDER BY readmission_rate DESC;

--readmission rate per race
SELECT p.race,
		SUM(CASE WHEN e.readmitted = 'YES' THEN 1 ELSE 0 END) AS readmission,
		COUNT(*) AS total,
		ROUND(SUM(CASE WHEN e.readmitted = 'YES' THEN 1 ELSE 0 END) *100/ COUNT(*), 2) AS readmission_rate
FROM patients p 	
JOIN encounters e
ON p.patient_id = e.patient_id
GROUP BY p.race
ORDER BY readmission_rate DESC;

SELECT *
FROM medications
LIMIT 5;

SELECT drug_name,
		SUM(CASE WHEN e.readmitted = 'YES' THEN 1 ELSE 0 END) AS readmission,
		COUNT(*) AS total,
		ROUND(SUM(CASE WHEN e.readmitted = 'YES' THEN 1 ELSE 0 END) *100/ COUNT(*), 2) AS readmission_rate
FROM medications m
JOIN enc