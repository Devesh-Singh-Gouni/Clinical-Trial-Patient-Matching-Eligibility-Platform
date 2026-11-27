CREATE TABLE "patients" (
  "patient_id" uuid PRIMARY KEY,
  "source_patient_id" varchar(100) UNIQUE,
  "first_name" varchar(100),
  "last_name" varchar(100),
  "birth_date" date NOT NULL,
  "death_date" date,
  "gender" varchar(20),
  "created_at" timestamp
);

CREATE TABLE "diseases" (
  "disease_id" uuid PRIMARY KEY,
  "disease_name" varchar(150) NOT NULL,
  "code_system" varchar(50),
  "disease_code" varchar(50),
  "description" text
);

CREATE TABLE "conditions" (
  "condition_id" uuid PRIMARY KEY,
  "patient_id" uuid NOT NULL,
  "disease_id" uuid NOT NULL,
  "start_date" date,
  "end_date" date
);

CREATE TABLE "observations" (
  "observation_id" uuid PRIMARY KEY,
  "patient_id" uuid NOT NULL,
  "code" varchar(50),
  "code_system" varchar(50),
  "description" varchar(200),
  "value_numeric" decimal(12,4),
  "value_text" text,
  "unit" varchar(50),
  "recorded_at" timestamp,
  "data_source" varchar(50)
);

CREATE TABLE "medications" (
  "medication_id" uuid PRIMARY KEY,
  "patient_id" uuid NOT NULL,
  "medication_code" varchar(50),
  "medication_name" varchar(200),
  "start_date" date,
  "end_date" date
);

CREATE TABLE "clinical_trials" (
  "trial_id" uuid PRIMARY KEY,
  "registry_id" varchar(50) UNIQUE,
  "title" text NOT NULL,
  "description" text,
  "phase" varchar(50),
  "status" varchar(50),
  "source_url" text,
  "raw_eligibility_text" text,
  "created_at" timestamp
);

CREATE TABLE "trial_conditions" (
  "trial_id" uuid NOT NULL,
  "disease_id" uuid NOT NULL,
  PRIMARY KEY ("trial_id", "disease_id")
);

CREATE TABLE "eligibility_criteria" (
  "criterion_id" uuid PRIMARY KEY,
  "trial_id" uuid NOT NULL,
  "criterion_type" varchar(20) NOT NULL,
  "field_type" varchar(30),
  "field_code" varchar(100),
  "operator" varchar(20),
  "value_numeric" decimal(12,4),
  "value_text" text,
  "unit" varchar(50),
  "lookback_days" integer,
  "description" text
);

CREATE TABLE "matching_runs" (
  "run_id" uuid PRIMARY KEY,
  "patient_id" uuid NOT NULL,
  "created_at" timestamp,
  "engine_version" varchar(30)
);

CREATE TABLE "matching_results" (
  "result_id" uuid PRIMARY KEY,
  "run_id" uuid NOT NULL,
  "trial_id" uuid NOT NULL,
  "status" varchar(30),
  "match_score" decimal(5,2),
  "evaluated_at" timestamp
);

CREATE TABLE "criterion_evaluations" (
  "evaluation_id" uuid PRIMARY KEY,
  "result_id" uuid NOT NULL,
  "criterion_id" uuid NOT NULL,
  "outcome" varchar(20),
  "actual_value" text,
  "explanation" text
);

CREATE UNIQUE INDEX ON "matching_results" ("run_id", "trial_id");

CREATE UNIQUE INDEX ON "criterion_evaluations" ("result_id", "criterion_id");

ALTER TABLE "conditions" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "conditions" ADD FOREIGN KEY ("disease_id") REFERENCES "diseases" ("disease_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "observations" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "medications" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "trial_conditions" ADD FOREIGN KEY ("trial_id") REFERENCES "clinical_trials" ("trial_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "trial_conditions" ADD FOREIGN KEY ("disease_id") REFERENCES "diseases" ("disease_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "eligibility_criteria" ADD FOREIGN KEY ("trial_id") REFERENCES "clinical_trials" ("trial_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "matching_runs" ADD FOREIGN KEY ("patient_id") REFERENCES "patients" ("patient_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "matching_results" ADD FOREIGN KEY ("run_id") REFERENCES "matching_runs" ("run_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "matching_results" ADD FOREIGN KEY ("trial_id") REFERENCES "clinical_trials" ("trial_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "criterion_evaluations" ADD FOREIGN KEY ("result_id") REFERENCES "matching_results" ("result_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "criterion_evaluations" ADD FOREIGN KEY ("criterion_id") REFERENCES "eligibility_criteria" ("criterion_id") DEFERRABLE INITIALLY IMMEDIATE;
