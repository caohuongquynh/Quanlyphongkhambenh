

CREATE TYPE user_role AS ENUM ('ADMIN', 'RECEPTIONIST', 'DOCTOR', 'PATIENT');
CREATE TYPE active_status AS ENUM ('ACTIVE', 'LOCKED');
CREATE TYPE schedule_status AS ENUM ('ACTIVE', 'CLOSED');
CREATE TYPE slot_status AS ENUM ('OPEN', 'LOCKED');
CREATE TYPE appt_status AS ENUM ('PENDING', 'CONFIRMED', 'CHECKED_IN', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'NO_SHOW');
CREATE TYPE actor_type_enum AS ENUM ('USER', 'SYSTEM');
CREATE TYPE confirm_response AS ENUM ('YES', 'NO', 'NO_RESPONSE');
CREATE TYPE visit_status AS ENUM ('REGISTERED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED');
CREATE TYPE service_detail_status AS ENUM ('ORDERED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED');
CREATE TYPE doc_status AS ENUM ('NOT_ISSUED', 'ISSUED', 'CANCELLED');
CREATE TYPE pay_method AS ENUM ('CASH', 'BANK_TRANSFER', 'ONLINE');
CREATE TYPE txn_status AS ENUM ('PENDING', 'SUCCESS', 'FAILED');
CREATE TYPE waitlist_status AS ENUM ('WAITING', 'OFFERED', 'BOOKED', 'DECLINED', 'EXPIRED', 'CANCELLED');

-- =====================================================================
-- 1. TÀI KHOẢN & HỒ SƠ
-- =====================================================================

CREATE TABLE users (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email VARCHAR(255) NULL,
  phone VARCHAR(20) NULL,
  password_hash VARCHAR(255) NOT NULL,
  role user_role NOT NULL,
  status active_status NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_users_email UNIQUE (email),
  CONSTRAINT uq_users_phone UNIQUE (phone),
  CONSTRAINT chk_users_contact CHECK (email IS NOT NULL OR phone IS NOT NULL)
);

CREATE TABLE patients (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT NULL,
  full_name VARCHAR(150) NOT NULL,
  date_of_birth DATE NULL,
  gender VARCHAR(20) NULL,
  address VARCHAR(255) NULL,
  phone VARCHAR(20) NULL,
  email VARCHAR(255) NULL,
  allergy_history TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_patients_user UNIQUE (user_id),
  CONSTRAINT fk_patients_user FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE INDEX idx_patients_phone ON patients (phone);
CREATE INDEX idx_patients_email ON patients (email);
CREATE INDEX idx_patients_name ON patients (full_name);

-- =====================================================================
-- 2. DANH MỤC & BÁC SĨ
-- =====================================================================

CREATE TABLE specialties (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_specialties_name UNIQUE (name)
);

CREATE TABLE doctors (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT NULL,
  full_name VARCHAR(150) NOT NULL,
  professional_info TEXT NULL,
  consultation_fee DECIMAL(12,2) NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_doctors_user UNIQUE (user_id),
  CONSTRAINT fk_doctors_user FOREIGN KEY (user_id) REFERENCES users (id),
  CONSTRAINT chk_doctors_fee CHECK (consultation_fee >= 0)
);

CREATE TABLE doctor_specialties (
  doctor_id BIGINT NOT NULL,
  specialty_id BIGINT NOT NULL,
  PRIMARY KEY (doctor_id, specialty_id),
  CONSTRAINT fk_ds_doctor FOREIGN KEY (doctor_id) REFERENCES doctors (id),
  CONSTRAINT fk_ds_specialty FOREIGN KEY (specialty_id) REFERENCES specialties (id)
);

CREATE INDEX idx_ds_specialty ON doctor_specialties (specialty_id);

CREATE TABLE rooms (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_rooms_name UNIQUE (name)
);

CREATE TABLE services (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  price DECIMAL(12,2) NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_services_name UNIQUE (name),
  CONSTRAINT chk_services_price CHECK (price >= 0)
);

CREATE TABLE medicines (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT uq_medicines_name UNIQUE (name)
);

-- =====================================================================
-- 3. LỊCH LÀM VIỆC & TIMESLOT
-- =====================================================================

CREATE TABLE work_schedules (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  doctor_id BIGINT NOT NULL,
  room_id BIGINT NOT NULL,
  work_date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  status schedule_status NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_ws_doctor FOREIGN KEY (doctor_id) REFERENCES doctors (id),
  CONSTRAINT fk_ws_room FOREIGN KEY (room_id) REFERENCES rooms (id),
  CONSTRAINT chk_ws_time CHECK (end_time > start_time)
);

CREATE INDEX idx_ws_doctor_date ON work_schedules (doctor_id, work_date);
CREATE INDEX idx_ws_room_date ON work_schedules (room_id, work_date);

CREATE TABLE time_slots (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  work_schedule_id BIGINT NOT NULL,
  start_time TIMESTAMP NOT NULL,
  end_time TIMESTAMP NOT NULL,
  capacity INT NOT NULL DEFAULT 1,
  status slot_status NOT NULL DEFAULT 'OPEN',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_ts_schedule_start UNIQUE (work_schedule_id, start_time),
  CONSTRAINT fk_ts_schedule FOREIGN KEY (work_schedule_id) REFERENCES work_schedules (id),
  CONSTRAINT chk_ts_time CHECK (end_time > start_time),
  CONSTRAINT chk_ts_capacity CHECK (capacity >= 1)
);

CREATE INDEX idx_ts_start ON time_slots (start_time);

-- =====================================================================
-- 4. LỊCH HẸN
-- =====================================================================

CREATE TABLE appointments (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  appointment_code VARCHAR(30) NOT NULL,
  patient_id BIGINT NOT NULL,
  time_slot_id BIGINT NOT NULL,
  scheduled_time TIMESTAMP NOT NULL,
  reason VARCHAR(500) NOT NULL,
  status appt_status NOT NULL DEFAULT 'PENDING',
  check_in_at TIMESTAMP NULL,
  cancel_reason VARCHAR(255) NULL,
  rescheduled_from_id BIGINT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_appt_code UNIQUE (appointment_code),
  CONSTRAINT uq_appt_rescheduled_from UNIQUE (rescheduled_from_id),
  CONSTRAINT fk_appt_patient FOREIGN KEY (patient_id) REFERENCES patients (id),
  CONSTRAINT fk_appt_slot FOREIGN KEY (time_slot_id) REFERENCES time_slots (id),
  CONSTRAINT fk_appt_prev FOREIGN KEY (rescheduled_from_id) REFERENCES appointments (id),
  CONSTRAINT chk_appt_cancel CHECK (status <> 'CANCELLED' OR cancel_reason IS NOT NULL),
  CONSTRAINT chk_appt_checkin CHECK ((status IN ('CHECKED_IN','IN_PROGRESS','COMPLETED')) = (check_in_at IS NOT NULL))
);

CREATE INDEX idx_appt_patient ON appointments (patient_id, scheduled_time);
CREATE INDEX idx_appt_slot_status ON appointments (time_slot_id, status);
CREATE INDEX idx_appt_status_time ON appointments (status, scheduled_time);

CREATE TABLE appointment_status_histories (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  appointment_id BIGINT NOT NULL,
  from_status appt_status NULL,
  to_status appt_status NOT NULL,
  changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  actor_type actor_type_enum NOT NULL,
  actor_user_id BIGINT NULL,
  reason VARCHAR(255) NULL,
  CONSTRAINT fk_ash_appt FOREIGN KEY (appointment_id) REFERENCES appointments (id),
  CONSTRAINT fk_ash_user FOREIGN KEY (actor_user_id) REFERENCES users (id),
  CONSTRAINT chk_ash_actor CHECK (
    (actor_type = 'SYSTEM' AND actor_user_id IS NULL) OR
    (actor_type = 'USER' AND actor_user_id IS NOT NULL)
  )
);

CREATE INDEX idx_ash_appt ON appointment_status_histories (appointment_id, changed_at);

CREATE TABLE appointment_confirmation_requests (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  appointment_id BIGINT NOT NULL,
  sent_at TIMESTAMP NOT NULL,
  channel VARCHAR(30) NOT NULL,
  response confirm_response NULL,
  responded_at TIMESTAMP NULL,
  processing_status VARCHAR(30) NOT NULL,
  CONSTRAINT fk_acr_appt FOREIGN KEY (appointment_id) REFERENCES appointments (id)
);

CREATE INDEX idx_acr_appt ON appointment_confirmation_requests (appointment_id);

-- =====================================================================
-- 5. LƯỢT KHÁM, HỒ SƠ KHÁM, ĐƠN THUỐC, DỊCH VỤ
-- =====================================================================

CREATE TABLE visits (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  patient_id BIGINT NOT NULL,
  doctor_id BIGINT NOT NULL,
  appointment_id BIGINT NULL,
  visit_date DATE NOT NULL,
  queue_number INT NOT NULL,
  status visit_status NOT NULL DEFAULT 'REGISTERED',
  cancel_reason VARCHAR(255) NULL,
  started_at TIMESTAMP NULL,
  completed_at TIMESTAMP NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_visit_appointment UNIQUE (appointment_id),
  CONSTRAINT uq_visit_queue UNIQUE (doctor_id, visit_date, queue_number),
  CONSTRAINT fk_visit_patient FOREIGN KEY (patient_id) REFERENCES patients (id),
  CONSTRAINT fk_visit_doctor FOREIGN KEY (doctor_id) REFERENCES doctors (id),
  CONSTRAINT fk_visit_appt FOREIGN KEY (appointment_id) REFERENCES appointments (id),
  CONSTRAINT chk_visit_queue CHECK (queue_number >= 1),
  CONSTRAINT chk_visit_cancel CHECK (status <> 'CANCELLED' OR cancel_reason IS NOT NULL)
);

CREATE INDEX idx_visit_patient ON visits (patient_id, visit_date);

CREATE TABLE visit_charges (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  visit_id BIGINT NOT NULL,
  description VARCHAR(255) NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_vc_visit FOREIGN KEY (visit_id) REFERENCES visits (id),
  CONSTRAINT chk_vc_amount CHECK (amount >= 0)
);

CREATE INDEX idx_vc_visit ON visit_charges (visit_id);

CREATE TABLE medical_records (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  visit_id BIGINT NOT NULL,
  symptoms TEXT NULL,
  examination_info TEXT NULL,
  diagnosis TEXT NULL,
  treatment_plan TEXT NULL,
  notes TEXT NULL,
  follow_up_date DATE NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_mr_visit UNIQUE (visit_id),
  CONSTRAINT fk_mr_visit FOREIGN KEY (visit_id) REFERENCES visits (id)
);

CREATE TABLE prescriptions (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  medical_record_id BIGINT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_presc_mr FOREIGN KEY (medical_record_id) REFERENCES medical_records (id)
);

CREATE INDEX idx_presc_mr ON prescriptions (medical_record_id);

CREATE TABLE prescription_details (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  prescription_id BIGINT NOT NULL,
  medicine_id BIGINT NOT NULL,
  dosage VARCHAR(255) NOT NULL,
  usage_instruction VARCHAR(255) NOT NULL,
  quantity INT NOT NULL,
  instructions TEXT NULL,
  CONSTRAINT fk_pd_presc FOREIGN KEY (prescription_id) REFERENCES prescriptions (id),
  CONSTRAINT fk_pd_medicine FOREIGN KEY (medicine_id) REFERENCES medicines (id),
  CONSTRAINT chk_pd_qty CHECK (quantity > 0)
);

CREATE INDEX idx_pd_presc ON prescription_details (prescription_id);
CREATE INDEX idx_pd_medicine ON prescription_details (medicine_id);

CREATE TABLE service_orders (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  medical_record_id BIGINT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_so_mr FOREIGN KEY (medical_record_id) REFERENCES medical_records (id)
);

CREATE INDEX idx_so_mr ON service_orders (medical_record_id);

CREATE TABLE service_order_details (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  service_order_id BIGINT NOT NULL,
  service_id BIGINT NOT NULL,
  status service_detail_status NOT NULL DEFAULT 'ORDERED',
  unit_price DECIMAL(12,2) NOT NULL,
  cancel_reason VARCHAR(255) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_sod_order FOREIGN KEY (service_order_id) REFERENCES service_orders (id),
  CONSTRAINT fk_sod_service FOREIGN KEY (service_id) REFERENCES services (id),
  CONSTRAINT chk_sod_price CHECK (unit_price >= 0),
  CONSTRAINT chk_sod_cancel CHECK (status <> 'CANCELLED' OR cancel_reason IS NOT NULL)
);

CREATE INDEX idx_sod_order ON service_order_details (service_order_id);
CREATE INDEX idx_sod_service ON service_order_details (service_id);

CREATE TABLE service_results (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  service_order_detail_id BIGINT NOT NULL,
  result_content TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_sr_detail UNIQUE (service_order_detail_id),
  CONSTRAINT fk_sr_detail FOREIGN KEY (service_order_detail_id) REFERENCES service_order_details (id)
);

-- =====================================================================
-- 6. HÓA ĐƠN, THANH TOÁN, HOÀN TIỀN
-- =====================================================================

CREATE TABLE invoices (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  invoice_code VARCHAR(30) NOT NULL,
  visit_id BIGINT NOT NULL,
  document_status doc_status NOT NULL DEFAULT 'NOT_ISSUED',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_inv_code UNIQUE (invoice_code),
  CONSTRAINT uq_inv_visit UNIQUE (visit_id),
  CONSTRAINT fk_inv_visit FOREIGN KEY (visit_id) REFERENCES visits (id)
);

CREATE TABLE invoice_details (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  invoice_id BIGINT NOT NULL,
  visit_charge_id BIGINT NULL,
  service_order_detail_id BIGINT NULL,
  description VARCHAR(255) NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  unit_price DECIMAL(12,2) NOT NULL,
  line_amount DECIMAL(14,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
  CONSTRAINT uq_invd_visit_charge UNIQUE (visit_charge_id),
  CONSTRAINT uq_invd_service_detail UNIQUE (service_order_detail_id),
  CONSTRAINT fk_invd_invoice FOREIGN KEY (invoice_id) REFERENCES invoices (id),
  CONSTRAINT fk_invd_vc FOREIGN KEY (visit_charge_id) REFERENCES visit_charges (id),
  CONSTRAINT fk_invd_sod FOREIGN KEY (service_order_detail_id) REFERENCES service_order_details (id),
  CONSTRAINT chk_invd_one_source CHECK ((visit_charge_id IS NULL) <> (service_order_detail_id IS NULL)),
  CONSTRAINT chk_invd_qty CHECK (quantity > 0),
  CONSTRAINT chk_invd_price CHECK (unit_price >= 0)
);

CREATE INDEX idx_invd_invoice ON invoice_details (invoice_id);

CREATE TABLE payments (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  reference_code VARCHAR(64) NOT NULL,
  invoice_id BIGINT NOT NULL,
  amount DECIMAL(14,2) NOT NULL,
  method pay_method NOT NULL,
  transaction_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status txn_status NOT NULL DEFAULT 'PENDING',
  CONSTRAINT uq_pay_ref UNIQUE (reference_code),
  CONSTRAINT fk_pay_invoice FOREIGN KEY (invoice_id) REFERENCES invoices (id),
  CONSTRAINT chk_pay_amount CHECK (amount > 0)
);

CREATE INDEX idx_pay_invoice ON payments (invoice_id, status);

CREATE TABLE refunds (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  payment_id BIGINT NOT NULL,
  amount DECIMAL(14,2) NOT NULL,
  reason VARCHAR(255) NOT NULL,
  refund_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status txn_status NOT NULL DEFAULT 'PENDING',
  processed_by_user_id BIGINT NOT NULL,
  CONSTRAINT fk_ref_payment FOREIGN KEY (payment_id) REFERENCES payments (id),
  CONSTRAINT fk_ref_user FOREIGN KEY (processed_by_user_id) REFERENCES users (id),
  CONSTRAINT chk_ref_amount CHECK (amount > 0)
);

CREATE INDEX idx_ref_payment ON refunds (payment_id, status);

-- =====================================================================
-- 7. DANH SÁCH CHỜ, THÔNG BÁO, NHẬT KÝ, CẤU HÌNH
-- =====================================================================

CREATE TABLE waitlist_entries (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  patient_id BIGINT NOT NULL,
  time_slot_id BIGINT NOT NULL,
  status waitlist_status NOT NULL DEFAULT 'WAITING',
  registered_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  offered_at TIMESTAMP NULL,
  appointment_id BIGINT NULL,
  cancelled_by_user_id BIGINT NULL,
  CONSTRAINT uq_wl_patient_slot UNIQUE (patient_id, time_slot_id),
  CONSTRAINT uq_wl_appointment UNIQUE (appointment_id),
  CONSTRAINT fk_wl_patient FOREIGN KEY (patient_id) REFERENCES patients (id),
  CONSTRAINT fk_wl_slot FOREIGN KEY (time_slot_id) REFERENCES time_slots (id),
  CONSTRAINT fk_wl_appt FOREIGN KEY (appointment_id) REFERENCES appointments (id),
  CONSTRAINT fk_wl_cancel_user FOREIGN KEY (cancelled_by_user_id) REFERENCES users (id),
  CONSTRAINT chk_wl_booked CHECK ((status = 'BOOKED') = (appointment_id IS NOT NULL))
);

CREATE INDEX idx_wl_queue ON waitlist_entries (time_slot_id, status, registered_at);

CREATE TABLE notifications (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id BIGINT NULL,
  patient_id BIGINT NULL,
  type VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  read_at TIMESTAMP NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_ntf_user FOREIGN KEY (user_id) REFERENCES users (id),
  CONSTRAINT fk_ntf_patient FOREIGN KEY (patient_id) REFERENCES patients (id),
  CONSTRAINT chk_ntf_target CHECK (user_id IS NOT NULL OR patient_id IS NOT NULL)
);

CREATE INDEX idx_ntf_user ON notifications (user_id, is_read);
CREATE INDEX idx_ntf_patient ON notifications (patient_id, is_read);

CREATE TABLE audit_logs (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  actor_type actor_type_enum NOT NULL,
  actor_user_id BIGINT NULL,
  action VARCHAR(100) NOT NULL,
  entity_type VARCHAR(100) NULL,
  entity_id BIGINT NULL,
  reason VARCHAR(500) NULL,
  details JSONB NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_audit_user FOREIGN KEY (actor_user_id) REFERENCES users (id),
  CONSTRAINT chk_audit_actor CHECK (
    (actor_type = 'SYSTEM' AND actor_user_id IS NULL) OR
    (actor_type = 'USER' AND actor_user_id IS NOT NULL)
  )
);

CREATE INDEX idx_audit_time ON audit_logs (created_at);
CREATE INDEX idx_audit_entity ON audit_logs (entity_type, entity_id);
CREATE INDEX idx_audit_actor ON audit_logs (actor_user_id);

CREATE TABLE system_configs (
  config_key VARCHAR(100) PRIMARY KEY,
  config_value VARCHAR(255) NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================================
-- 8. VIEW TRẠNG THÁI THANH TOÁN
-- =====================================================================

CREATE VIEW v_invoice_summary AS
SELECT i.id AS invoice_id, i.invoice_code, i.visit_id, i.document_status,
       COALESCE(d.total_amount, 0) AS total_amount,
       COALESCE(p.paid_amount, 0) AS paid_amount,
       COALESCE(r.refunded_amount, 0) AS refunded_amount,
       CASE
         WHEN COALESCE(p.paid_amount, 0) = 0 THEN 'UNPAID'
         WHEN COALESCE(r.refunded_amount, 0) >= p.paid_amount THEN 'REFUNDED'
         WHEN COALESCE(r.refunded_amount, 0) > 0 THEN 'PARTIALLY_REFUNDED'
         WHEN p.paid_amount >= COALESCE(d.total_amount, 0) THEN 'PAID'
         ELSE 'PARTIALLY_PAID'
       END AS payment_status
FROM invoices i
LEFT JOIN (SELECT invoice_id, SUM(line_amount) AS total_amount FROM invoice_details GROUP BY invoice_id) d ON d.invoice_id = i.id
LEFT JOIN (SELECT invoice_id, SUM(amount) AS paid_amount FROM payments WHERE status = 'SUCCESS' GROUP BY invoice_id) p ON p.invoice_id = i.id
LEFT JOIN (SELECT pay.invoice_id, SUM(rf.amount) AS refunded_amount FROM refunds rf JOIN payments pay ON pay.id = rf.payment_id WHERE rf.status = 'SUCCESS' GROUP BY pay.invoice_id) r ON r.invoice_id = i.id;

-- =====================================================================
-- 9. FUNCTIONS & TRIGGERS (PL/pgSQL)
-- =====================================================================

-- ---- SCH-03: WorkSchedule Overlap ----
CREATE OR REPLACE FUNCTION fn_check_schedule_overlap() RETURNS TRIGGER AS $$
DECLARE
  v_cnt INT := 0;
BEGIN
  IF NEW.status = 'ACTIVE' THEN
    PERFORM id FROM doctors WHERE id = NEW.doctor_id FOR UPDATE;
    PERFORM id FROM rooms WHERE id = NEW.room_id FOR UPDATE;

    SELECT COUNT(*) INTO v_cnt FROM work_schedules
     WHERE status = 'ACTIVE' AND work_date = NEW.work_date
       AND (doctor_id = NEW.doctor_id OR room_id = NEW.room_id)
       AND start_time < NEW.end_time AND end_time > NEW.start_time
       AND (TG_OP = 'INSERT' OR id <> NEW.id);

    IF v_cnt > 0 THEN
      RAISE EXCEPTION 'WorkSchedule overlaps with same doctor or same room';
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_ws_bi_bu
BEFORE INSERT OR UPDATE ON work_schedules
FOR EACH ROW EXECUTE FUNCTION fn_check_schedule_overlap();

-- ---- BR-01, APT-03: Capacity & Appointment Validation ----
CREATE OR REPLACE FUNCTION fn_appt_bi() RETURNS TRIGGER AS $$
DECLARE
  v_capacity INT;
  v_slot_status slot_status;
  v_start TIMESTAMP;
  v_end TIMESTAMP;
  v_used INT := 0;
  v_overlap INT := 0;
BEGIN
  SELECT capacity, status, start_time, end_time
    INTO v_capacity, v_slot_status, v_start, v_end
    FROM time_slots WHERE id = NEW.time_slot_id FOR UPDATE;

  IF v_slot_status <> 'OPEN' THEN
    RAISE EXCEPTION 'TimeSlot is locked';
  END IF;

  IF NEW.scheduled_time <> v_start THEN
    RAISE EXCEPTION 'scheduled_time must equal TimeSlot start_time';
  END IF;

  IF NEW.status IN ('PENDING','CONFIRMED','CHECKED_IN','IN_PROGRESS','COMPLETED') THEN
    SELECT COUNT(*) INTO v_used FROM appointments
     WHERE time_slot_id = NEW.time_slot_id
       AND status IN ('PENDING','CONFIRMED','CHECKED_IN','IN_PROGRESS','COMPLETED');
    IF v_used >= v_capacity THEN
      RAISE EXCEPTION 'TimeSlot is full (capacity exceeded)';
    END IF;

    SELECT COUNT(*) INTO v_overlap
      FROM appointments a JOIN time_slots t ON t.id = a.time_slot_id
     WHERE a.patient_id = NEW.patient_id
       AND a.status IN ('PENDING','CONFIRMED','CHECKED_IN','IN_PROGRESS','COMPLETED')
       AND t.start_time < v_end AND t.end_time > v_start;
    IF v_overlap > 0 THEN
      RAISE EXCEPTION 'Patient already has an overlapping appointment';
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_appt_bi
BEFORE INSERT ON appointments
FOR EACH ROW EXECUTE FUNCTION fn_appt_bi();

-- ---- BR-06, BR-09: Immutable Appointment fields ----
CREATE OR REPLACE FUNCTION fn_appt_bu() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.patient_id <> OLD.patient_id OR NEW.time_slot_id <> OLD.time_slot_id
     OR NEW.scheduled_time <> OLD.scheduled_time THEN
    RAISE EXCEPTION 'Appointment patient/slot/scheduled_time are immutable';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_appt_bu
BEFORE UPDATE ON appointments
FOR EACH ROW EXECUTE FUNCTION fn_appt_bu();

-- ---- BR-07: Visit Validation ----
CREATE OR REPLACE FUNCTION fn_visit_bi() RETURNS TRIGGER AS $$
DECLARE
  v_status appt_status;
  v_patient BIGINT;
BEGIN
  IF NEW.appointment_id IS NOT NULL THEN
    SELECT status, patient_id INTO v_status, v_patient FROM appointments WHERE id = NEW.appointment_id;
    IF v_status IN ('PENDING','CANCELLED','NO_SHOW') THEN
      RAISE EXCEPTION 'Appointment status does not allow creating a Visit';
    END IF;
    IF v_patient <> NEW.patient_id THEN
      RAISE EXCEPTION 'Visit patient must match Appointment patient';
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_visit_bi
BEFORE INSERT ON visits
FOR EACH ROW EXECUTE FUNCTION fn_visit_bi();

-- ---- BR-14, BIL-01: Invoice Details Validation ----
CREATE OR REPLACE FUNCTION fn_assert_invoice_editable(p_invoice_id BIGINT) RETURNS VOID AS $$
DECLARE
  v_doc doc_status;
BEGIN
  SELECT document_status INTO v_doc FROM invoices WHERE id = p_invoice_id FOR UPDATE;
  IF v_doc <> 'NOT_ISSUED' THEN
    RAISE EXCEPTION 'Invoice content cannot change after it is issued';
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_invd_bi() RETURNS TRIGGER AS $$
DECLARE
  v_visit BIGINT;
  v_src_visit BIGINT;
  v_src_status service_detail_status;
BEGIN
  PERFORM fn_assert_invoice_editable(NEW.invoice_id);
  SELECT visit_id INTO v_visit FROM invoices WHERE id = NEW.invoice_id;

  IF NEW.visit_charge_id IS NOT NULL THEN
    SELECT visit_id INTO v_src_visit FROM visit_charges WHERE id = NEW.visit_charge_id;
  ELSIF NEW.service_order_detail_id IS NOT NULL THEN
    SELECT mr.visit_id, d.status INTO v_src_visit, v_src_status
      FROM service_order_details d
      JOIN service_orders so ON so.id = d.service_order_id
      JOIN medical_records mr ON mr.id = so.medical_record_id
     WHERE d.id = NEW.service_order_detail_id;
    IF v_src_status <> 'COMPLETED' THEN
      RAISE EXCEPTION 'Only COMPLETED service can be invoiced';
    END IF;
  END IF;

  IF v_src_visit <> v_visit THEN
    RAISE EXCEPTION 'Fee source does not belong to the Invoice visit';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_invd_bi
BEFORE INSERT ON invoice_details
FOR EACH ROW EXECUTE FUNCTION fn_invd_bi();

CREATE OR REPLACE FUNCTION fn_invd_bu_bd() RETURNS TRIGGER AS $$
BEGIN
  PERFORM fn_assert_invoice_editable(OLD.invoice_id);
  IF TG_OP = 'DELETE' THEN RETURN OLD; END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_invd_bu
BEFORE UPDATE ON invoice_details
FOR EACH ROW EXECUTE FUNCTION fn_invd_bu_bd();

CREATE TRIGGER trg_invd_bd
BEFORE DELETE ON invoice_details
FOR EACH ROW EXECUTE FUNCTION fn_invd_bu_bd();

-- ---- Invoice Update Validation ----
CREATE OR REPLACE FUNCTION fn_inv_bu() RETURNS TRIGGER AS $$
DECLARE
  v_paid DECIMAL(14,2) := 0;
  v_refunded DECIMAL(14,2) := 0;
BEGIN
  IF NEW.visit_id <> OLD.visit_id THEN
    RAISE EXCEPTION 'Invoice visit is immutable';
  END IF;

  IF NEW.document_status <> OLD.document_status THEN
    IF NOT ((OLD.document_status = 'NOT_ISSUED' AND NEW.document_status = 'ISSUED')
         OR (OLD.document_status = 'ISSUED' AND NEW.document_status = 'CANCELLED')) THEN
      RAISE EXCEPTION 'Invalid Invoice document status transition';
    END IF;

    IF NEW.document_status = 'ISSUED' AND (SELECT COUNT(*) FROM invoice_details WHERE invoice_id = OLD.id) = 0 THEN
      RAISE EXCEPTION 'Cannot issue an Invoice without details';
    END IF;

    IF NEW.document_status = 'CANCELLED' THEN
      SELECT COALESCE(SUM(amount), 0) INTO v_paid FROM payments WHERE invoice_id = OLD.id AND status = 'SUCCESS';
      SELECT COALESCE(SUM(rf.amount), 0) INTO v_refunded FROM refunds rf JOIN payments p ON p.id = rf.payment_id WHERE p.invoice_id = OLD.id AND rf.status = 'SUCCESS';
      IF v_paid > v_refunded THEN
        RAISE EXCEPTION 'Refund all collected money before cancelling the Invoice';
      END IF;
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_inv_bu
BEFORE UPDATE ON invoices
FOR EACH ROW EXECUTE FUNCTION fn_inv_bu();

-- ---- Payment Validation ----
CREATE OR REPLACE FUNCTION fn_check_payment(p_payment_id BIGINT, p_invoice_id BIGINT, p_amount DECIMAL(14,2), p_status txn_status) RETURNS VOID AS $$
DECLARE
  v_doc doc_status;
  v_total DECIMAL(14,2) := 0;
  v_paid DECIMAL(14,2) := 0;
BEGIN
  SELECT document_status INTO v_doc FROM invoices WHERE id = p_invoice_id FOR UPDATE;
  IF v_doc <> 'ISSUED' THEN
    RAISE EXCEPTION 'Payment is allowed only for ISSUED invoices';
  END IF;

  SELECT COALESCE(SUM(line_amount), 0) INTO v_total FROM invoice_details WHERE invoice_id = p_invoice_id;
  IF v_total <= 0 THEN
    RAISE EXCEPTION 'Invoice has no amount due';
  END IF;

  IF p_status = 'SUCCESS' THEN
    SELECT COALESCE(SUM(amount), 0) INTO v_paid FROM payments
     WHERE invoice_id = p_invoice_id AND status = 'SUCCESS'
       AND (p_payment_id IS NULL OR id <> p_payment_id);
    IF v_paid + p_amount > v_total THEN
      RAISE EXCEPTION 'Payment exceeds the remaining balance';
    END IF;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_pay_bi() RETURNS TRIGGER AS $$
BEGIN
  PERFORM fn_check_payment(NULL, NEW.invoice_id, NEW.amount, NEW.status);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_pay_bi
BEFORE INSERT ON payments
FOR EACH ROW EXECUTE FUNCTION fn_pay_bi();

CREATE OR REPLACE FUNCTION fn_pay_bu() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.invoice_id <> OLD.invoice_id OR NEW.amount <> OLD.amount THEN
    RAISE EXCEPTION 'Payment invoice/amount are immutable';
  END IF;
  IF OLD.status <> 'PENDING' AND NEW.status <> OLD.status THEN
    RAISE EXCEPTION 'Final Payment status cannot be changed';
  END IF;
  IF NEW.status = 'SUCCESS' AND OLD.status <> 'SUCCESS' THEN
    PERFORM fn_check_payment(OLD.id, OLD.invoice_id, OLD.amount, 'SUCCESS');
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_pay_bu
BEFORE UPDATE ON payments
FOR EACH ROW EXECUTE FUNCTION fn_pay_bu();

-- ---- Refund Validation ----
CREATE OR REPLACE FUNCTION fn_check_refund(p_refund_id BIGINT, p_payment_id BIGINT, p_amount DECIMAL(14,2), p_status txn_status) RETURNS VOID AS $$
DECLARE
  v_pay_amount DECIMAL(14,2);
  v_pay_status txn_status;
  v_refunded DECIMAL(14,2) := 0;
BEGIN
  SELECT amount, status INTO v_pay_amount, v_pay_status FROM payments WHERE id = p_payment_id FOR UPDATE;
  IF v_pay_status <> 'SUCCESS' THEN
    RAISE EXCEPTION 'Only SUCCESS payments can be refunded';
  END IF;

  IF p_amount > v_pay_amount THEN
    RAISE EXCEPTION 'Refund exceeds the payment amount';
  END IF;

  IF p_status = 'SUCCESS' THEN
    SELECT COALESCE(SUM(amount), 0) INTO v_refunded FROM refunds
     WHERE payment_id = p_payment_id AND status = 'SUCCESS'
       AND (p_refund_id IS NULL OR id <> p_refund_id);
    IF v_refunded + p_amount > v_pay_amount THEN
      RAISE EXCEPTION 'Total successful refunds exceed the refundable amount';
    END IF;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_ref_bi() RETURNS TRIGGER AS $$
BEGIN
  PERFORM fn_check_refund(NULL, NEW.payment_id, NEW.amount, NEW.status);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_ref_bi
BEFORE INSERT ON refunds
FOR EACH ROW EXECUTE FUNCTION fn_ref_bi();

CREATE OR REPLACE FUNCTION fn_ref_bu() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.payment_id <> OLD.payment_id OR NEW.amount <> OLD.amount THEN
    RAISE EXCEPTION 'Refund payment/amount are immutable';
  END IF;
  IF OLD.status <> 'PENDING' AND NEW.status <> OLD.status THEN
    RAISE EXCEPTION 'Final Refund status cannot be changed';
  END IF;
  IF NEW.status = 'SUCCESS' AND OLD.status <> 'SUCCESS' THEN
    PERFORM fn_check_refund(OLD.id, OLD.payment_id, OLD.amount, 'SUCCESS');
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_ref_bu
BEFORE UPDATE ON refunds
FOR EACH ROW EXECUTE FUNCTION fn_ref_bu();

CREATE OR REPLACE FUNCTION fn_prevent_modification() RETURNS TRIGGER AS $$
BEGIN
  RAISE EXCEPTION '% is append-only / immutable', TG_TABLE_NAME;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_ash_bu_bd BEFORE UPDATE OR DELETE ON appointment_status_histories FOR EACH ROW EXECUTE FUNCTION fn_prevent_modification();
CREATE TRIGGER trg_audit_bu_bd BEFORE UPDATE OR DELETE ON audit_logs FOR EACH ROW EXECUTE FUNCTION fn_prevent_modification();
CREATE TRIGGER trg_pay_bd BEFORE DELETE ON payments FOR EACH ROW EXECUTE FUNCTION fn_prevent_modification();
CREATE TRIGGER trg_ref_bd BEFORE DELETE ON refunds FOR EACH ROW EXECUTE FUNCTION fn_prevent_modification();