# TÀI LIỆU NGHIỆP VỤ FINAL
## HỆ THỐNG QUẢN LÝ PHÒNG KHÁM

## 1. Phạm vi hệ thống
* Một phòng khám ngoại trú, một cơ sở; không quản lý bệnh nhân nội trú, giường bệnh hoặc nhiều chi nhánh.
* Web dành cho **Admin**, **Receptionist** và **Doctor**; Mobile chủ yếu dành cho **Patient**.
* Web và Mobile sử dụng chung Backend/API và cùng một cơ sở dữ liệu.
* Phạm vi gồm tài khoản/phân quyền, danh mục, bác sĩ/lịch làm việc, lịch hẹn, tiếp nhận trực tiếp, khám và hồ sơ khám, kê đơn thuốc, chỉ định dịch vụ/kết quả, hóa đơn/thanh toán, thông báo, báo cáo và nhật ký.
* Hỗ trợ bệnh nhân đến trực tiếp không đặt lịch. Bệnh nhân có thể có hồ sơ `Patient` trước khi có tài khoản `User`.
* Không có chức năng đặt lịch giúp người thân/hồ sơ phụ thuộc; không tự động đổi giờ hoặc đẩy lịch của bệnh nhân khác khi có người hủy/không đến.
* Không tự thêm cơ chế phạt, khóa tài khoản do hủy nhiều lần, bảo hiểm, quản lý nội trú hoặc nhiều chi nhánh.

---

## 2. Vai trò và quyền chính

### 2.1 Tác nhân và chức năng chính

| Vai trò | Chức năng chính |
| :--- | :--- |
| **Admin** | Quản lý tài khoản và phân quyền; danh mục; hồ sơ bác sĩ; lịch làm việc; báo cáo; cấu hình và nhật ký hệ thống. |
| **Receptionist** | Tìm/tạo hồ sơ bệnh nhân; tạo lịch tại quầy; xác nhận lịch; check-in; tạo Visit cho người đến trực tiếp; hỗ trợ hủy/đổi lịch theo quy tắc. |
| **Doctor** | Xem lịch và bệnh nhân được phân công; bắt đầu/kết thúc lượt khám; lập MedicalRecord; kê đơn; chỉ định dịch vụ; xem/cập nhật kết quả theo quyền. |
| **Patient** | Đăng ký/đăng nhập; quản lý hồ sơ cá nhân; tìm bác sĩ và lịch trống; đặt/đổi/hủy lịch; phản hồi xác nhận; xem lịch sử khám/đơn thuốc; thanh toán online. |

---

### 2.2 Vai trò, chức năng, phạm vi dữ liệu và giới hạn quyền của từng tác nhân

| Tác nhân | Vai trò và mục đích | Chức năng được phép | Phạm vi dữ liệu được xem | Giới hạn quyền |
| :--- | :--- | :--- | :--- | :--- |
| **Admin** | Người quản trị trên Web. Quản lý tài khoản, danh mục, lịch làm việc và giám sát hệ thống qua báo cáo, cấu hình, nhật ký. | - Phân quyền tài khoản (AUTH-04); khóa/mở khóa tài khoản (AUTH-06).<br>- Quản lý Specialty, Room, Service, Medicine; hồ sơ Doctor, chuyên khoa, thông tin nghề nghiệp hiển thị, phí khám; giá dịch vụ (CAT-01..03).<br>- Tạo WorkSchedule, sinh TimeSlot và cấu hình capacity, khóa TimeSlot, thay đổi/đóng lịch làm việc (SCH-01..05).<br>- Xem báo cáo và xuất CSV/PDF nếu cần (REP-01..04); xem nhật ký AuditLog; cấu hình tham số nghiệp vụ (SYS-01, SYS-02). | Tài khoản, danh mục, hồ sơ Doctor, lịch làm việc/TimeSlot, báo cáo tổng hợp và AuditLog. Không xem chi tiết MedicalRecord; chỉ xem dữ liệu hóa đơn/thanh toán/hoàn tiền khi phục vụ quản trị tài chính. | Không thực hiện khám, kê đơn hoặc chỉ định dịch vụ. Có quyền khóa/mở khóa tài khoản; hủy hóa đơn và duyệt/ghi nhận hoàn tiền theo quy tắc tại Phụ lục A. |
| **Receptionist** | Nhân viên quầy trên Web. Tiếp nhận bệnh nhân, quản lý lịch hẹn tại quầy và thực hiện các bước thu phí theo UC-09. | - Tìm/tạo hồ sơ Patient và cập nhật thông tin hành chính/liên hệ theo yêu cầu của người bệnh.<br>- Tạo Appointment tại quầy; xác nhận PENDING → CONFIRMED; check-in CONFIRMED, ghi giờ check-in và cấp số thứ tự.<br>- Tạo Visit REGISTERED cho người đến trực tiếp; hỗ trợ đổi/hủy lịch, ghi người thực hiện và lý do.<br>- Lập/phát hành hóa đơn và ghi nhận thanh toán tiền mặt/chuyển khoản.<br>- Hỗ trợ đăng ký/hủy danh sách chờ tại quầy. | Thông tin hành chính/liên hệ của Patient, Appointment, Visit và các dữ liệu hóa đơn/thanh toán cần để tiếp nhận, thu phí. Không xem nội dung chi tiết MedicalRecord, chẩn đoán hoặc ghi chú lâm sàng. | Không khám, chẩn đoán, kê đơn hoặc chỉ định dịch vụ. Chỉ check-in Appointment CONFIRMED. Không tạo Appointment giả cho walk-in. Hủy hóa đơn/hoàn tiền phải do Admin phê duyệt; Receptionist không tự phê duyệt hoàn tiền. |
| **Doctor** | Bác sĩ trên Web. Thực hiện khám, lập hồ sơ khám, kê đơn và chỉ định dịch vụ. | - Xem lịch và bệnh nhân được phân công; mở hồ sơ Patient theo quyền (EXM-01).<br>- Bắt đầu/kết thúc lượt khám (EXM-02, EXM-08); lập MedicalRecord (EXM-03).<br>- Kê đơn thuốc (EXM-04); chỉ định dịch vụ (EXM-06); xem/cập nhật kết quả dịch vụ theo quyền (EXM-07).<br>- Xem lịch sử khám và đơn thuốc (UC-10); nhận thông báo khi cần thông báo bác sĩ (NTF-05). | Lịch và bệnh nhân được phân công; hồ sơ Patient, lịch sử khám, đơn thuốc theo quyền. Danh mục thuốc/dịch vụ dùng khi kê đơn và chỉ định. | Chỉ xem hồ sơ bệnh nhân thuộc lịch khám/Visit được phân công. Chỉnh sửa MedicalRecord sau khi hoàn tất chỉ do Doctor đã lập hồ sơ thực hiện, phải nêu lý do và ghi AuditLog. Không thực hiện quản trị tài khoản, xác nhận/check-in lịch hẹn, lập hóa đơn hoặc thu tiền. |
| **Patient** | Người bệnh, chủ yếu dùng Mobile. Tự đặt lịch, theo dõi lịch khám, xem lịch sử khám/đơn thuốc và thanh toán online. | - Đăng ký, đăng nhập; xem/sửa hồ sơ cá nhân gồm họ tên, ngày sinh, giới tính, địa chỉ, liên hệ, tiền sử dị ứng (AUTH-01, AUTH-05).<br>- Tìm bác sĩ/chuyên khoa, xem TimeSlot còn chỗ, đặt lịch với lý do khám (APT-01).<br>- Xem lịch, đổi/hủy lịch theo quy tắc thời hạn (APT-04, BR-02).<br>- Nhận nhắc lịch; phản hồi yêu cầu xác nhận đến khám YES/NO (NTF-01..04).<br>- Xem lịch sử khám/đơn thuốc (UC-10); thanh toán online qua cổng sandbox (BIL-04).<br>- Tham gia danh sách chờ: xác nhận hoặc từ chối lời mời OFFERED (UC-14, BR-19). | Hồ sơ cá nhân, Appointment, Visit, MedicalRecord, kết quả dịch vụ và Prescription của chính Patient; thông tin bác sĩ/chuyên khoa và TimeSlot còn chỗ để đặt lịch. | Không xem dữ liệu của Patient khác; không tự đổi/hủy online trong vòng dưới 2 giờ trước giờ hẹn; không khám, kê đơn hoặc chỉ định dịch vụ. |
| **SYSTEM** | Tác nhân hệ thống. Tác vụ tự động, không cần User; được ghi nhận là tác nhân SYSTEM trong AppointmentStatusHistory và AuditLog (APT-08, SYS-01, BR-20). | - Gửi nhắc lịch theo mốc cấu hình, mặc định 24 giờ và 2 giờ trước giờ hẹn.<br>- Gửi yêu cầu xác nhận trước 5 giờ đối với Appointment CONFIRMED; lưu từng lần gửi/phản hồi.<br>- Chuyển CONFIRMED sang NO_SHOW sau 30 phút kể từ scheduled_time nếu không check-in hợp lệ.<br>- Xử lý danh sách chờ theo thứ tự đăng ký và thời hạn cấu hình; cấp thông báo/phiếu lịch hẹn điện tử. | Appointment, WaitlistEntry, Notification và AppointmentConfirmationRequest phục vụ tác vụ tự động. | Không tự hủy Appointment do NO_RESPONSE; không chuyển PENDING sang NO_SHOW; không tự đổi giờ, đẩy lịch người khác hoặc tự tạo Appointment từ danh sách chờ khi Patient chưa xác nhận. |

---

### 2.3 Ma trận quyền hạn

| Chức năng / Dữ liệu | Admin | Receptionist | Doctor | Patient | Căn cứ / Giới hạn |
| :--- | :---: | :---: | :---: | :---: | :--- |
| **Quản lý tài khoản và phân quyền** | ✓ | — | — | — | AUTH-04; Admin quản trị vai trò |
| **Khóa/mở khóa tài khoản** | ✓ | — | — | — | AUTH-06 |
| **Đăng ký tài khoản** | — | — | — | ✓ | AUTH-01 (Tài khoản Patient) |
| **Đăng nhập/đăng xuất; đổi và khôi phục mật khẩu** | ✓ | ✓ | ✓ | ✓ | AUTH-02, AUTH-03 |
| **Xem/sửa thông tin cá nhân Patient** | Chỉ dữ liệu quản trị | ✓ | ✓ | ✓ | AUTH-05, APT-02, EXM-01 |
| **Quản lý Specialty, Room, Service, Medicine, giá/phí** | ✓ | Xem thu phí | Xem kê đơn | Xem đặt lịch | CAT-01..03; Medicine chỉ là danh mục |
| **Quản lý hồ sơ Doctor** | ✓ | Xem tiếp nhận | Xem hồ sơ mình | Xem tìm kiếm | CAT-02, APT-01 |
| **Tạo WorkSchedule, sinh TimeSlot, khóa/đóng lịch** | ✓ | Xem xử lý | Xem lịch mình | Xem slot trống | SCH-01..05 |
| **Xem lịch làm việc/lịch khám** | ✓ | ✓ | ✓ | ✓ | EXM-01, APT-01 |
| **Tạo Appointment** | — | ✓ | ✓ | ✓ | APT-01, APT-02, EXM-09 |
| **Xem lịch hẹn** | ✓ | ✓ | ✓ | ✓ | APT-04, EXM-01 |
| **Đổi/hủy lịch hẹn** | — | ✓ | — | ✓ | APT-04, BR-02, BR-21 (Patient ≥ 2h) |
| **Xác nhận lịch PENDING → CONFIRMED** | — | ✓ | — | — | APT-05 |
| **Check-in Appointment CONFIRMED** | — | ✓ | — | — | APT-05, BR-06 |
| **Tạo Visit cho người đến trực tiếp** | — | ✓ | — | — | APT-06 |
| **Phản hồi yêu cầu xác nhận đến khám YES/NO** | — | — | — | ✓ | NTF-03, NTF-04 |
| **Bắt đầu/kết thúc lượt khám** | — | — | ✓ | — | EXM-02, EXM-08 |
| **Lập MedicalRecord** | — | — | ✓ | — | EXM-03, BR-08 |
| **Sửa MedicalRecord sau hoàn tất** | — | — | ✓ | — | BR-08, SYS-01 (Doctor đã lập, ghi AuditLog) |
| **Kê đơn thuốc** | — | — | ✓ | Xem đơn mình | EXM-04, BR-11 |
| **Xem lịch sử khám và đơn thuốc** | — | — | ✓ | ✓ | UC-10; Giới hạn dữ liệu lâm sàng |
| **Chỉ định dịch vụ** | — | — | ✓ | — | EXM-06 |
| **Xem/cập nhật kết quả dịch vụ** | — | — | ✓ | Xem kết quả mình | EXM-07, UC-08 |
| **Cập nhật trạng thái/hủy chỉ định dịch vụ** | — | — | ✓ | — | EXM-06, BR-13 |
| **Lập và phát hành hóa đơn** | Giám sát | ✓ | — | Xem hóa đơn mình | BIL-01, BIL-02, UC-09 |
| **Ghi nhận thanh toán tiền mặt/chuyển khoản** | Giám sát | ✓ | — | — | BIL-03, UC-09 |
| **Thanh toán online** | — | — | — | ✓ | BIL-04 (Sandbox) |
| **Hủy hóa đơn; phê duyệt/ghi nhận hoàn tiền** | ✓ | Chỉ gửi yêu cầu | — | — | BIL-06, BIL-07 |
| **Danh sách chờ** | Giám sát | ✓ | — | ✓ | UC-14, BR-19 |
| **Nhận nhắc lịch và thông báo** | Giám sát | ✓ | ✓ | ✓ | NTF-01, NTF-05 |
| **Xem/xuất báo cáo, xem nhật ký, cấu hình** | ✓ | — | — | — | REP-01..04, SYS-01, SYS-02 |

---

## 3. Danh mục Use Case trong phạm vi

### 3.1 Danh sách Use Case

| Mã | Tên Use Case | Tác nhân chính | Phạm vi thao tác | Căn cứ |
| :--- | :--- | :--- | :--- | :--- |
| **UC-01** | **Đăng ký, đăng nhập và quản lý hồ sơ cá nhân** | | | |
| UC-01.1 | Đăng ký tài khoản | Patient | Đăng ký bằng email/SĐT và mật khẩu; kiểm tra trùng định danh. | AUTH-01, BR-10 |
| UC-01.2 | Đăng nhập hệ thống | All Roles | Xác thực người dùng; kiểm tra quyền ở Backend theo vai trò. | AUTH-02, AUTH-04 |
| UC-01.3 | Đăng xuất hệ thống | All Roles | Kết thúc phiên xác thực. | AUTH-02 |
| UC-01.4 | Đổi mật khẩu | All Roles | Thay đổi mật khẩu của tài khoản đang đăng nhập. | AUTH-03 |
| UC-01.5 | Khôi phục mật khẩu | All Roles | Khôi phục qua email/SĐT bằng OTP/link 1 lần; không gửi mật khẩu cũ. | AUTH-03 |
| UC-01.6 | Xem hồ sơ cá nhân | Patient | Xem họ tên, ngày sinh, giới tính, địa chỉ, liên hệ, tiền sử dị ứng. | AUTH-05 |
| UC-01.7 | Cập nhật hồ sơ cá nhân | Patient | Sửa các thông tin cá nhân phù hợp. | AUTH-05 |
| UC-01.8 | Khóa/Mở khóa tài khoản | Admin | Khóa/mở khóa tài khoản; không tự động khóa do hủy lịch. | AUTH-06 |
| UC-01.9 | Phân quyền tài khoản | Admin | Gán vai trò Admin, Receptionist, Doctor, Patient. | AUTH-04 |
| **UC-02** | **Tìm bác sĩ và xem lịch trống** | | | |
| UC-02.1 | Tìm bác sĩ | Patient | Tìm theo bác sĩ hoặc chuyên khoa; xem thông tin hiển thị. | APT-01, CAT-02 |
| UC-02.2 | Xem lịch trống | Patient | Xem TimeSlot còn chỗ (chưa đạt capacity). | APT-01, BR-01 |
| **UC-03** | **Đặt, đổi và hủy lịch khám** | | | |
| UC-03.1 | Đặt lịch khám online | Patient | Đặt Appointment kèm lý do; mặc định PENDING. | APT-01, APT-05, LN-01 |
| UC-03.2 | Đặt lịch khám tại quầy | Receptionist | Tạo Appointment cho Patient có sẵn hoặc tạo mới hồ sơ. | APT-02, LN-01 |
| UC-03.3 | Xem lịch hẹn | Patient | Xem các Appointment của chính mình. | APT-04 |
| UC-03.4 | Đổi lịch khám | Patient / Receptionist | Tạo Appointment mới; Appointment cũ → CANCELLED (RESCHEDULED). | APT-04, BR-02, BR-21 |
| UC-03.5 | Hủy lịch khám | Patient / Receptionist | Chuyển Appointment PENDING/CONFIRMED → CANCELLED; giữ lịch sử. | APT-04, BR-02, BR-06 |
| UC-03.6 | Cấp phiếu lịch hẹn điện tử | SYSTEM | Cấp thông tin xác nhận/phiếu lịch hẹn điện tử. | APT-07 |
| **UC-04** | **Xác nhận lịch, tiếp nhận tại quầy và check-in** | | | |
| UC-04.1 | Xác nhận lịch hẹn | Receptionist | Chuyển Appointment PENDING → CONFIRMED. | APT-05, LN-02 |
| UC-04.2 | Check-in lịch hẹn | Receptionist | Check-in Appointment CONFIRMED, ghi giờ, cấp STT theo ngày/bác sĩ. | APT-05, BR-07, LN-04 |
| UC-04.3 | Ghi nhận vắng mặt | SYSTEM | Tự động chuyển CONFIRMED không check-in quá giờ → NO_SHOW. | BR-05, LN-06 |
| **UC-05** | **Tiếp nhận người đến trực tiếp không có lịch hẹn** | | | |
| UC-05.1 | Tìm hồ sơ bệnh nhân | Receptionist | Tìm Patient theo thông tin hiện có trước khi tiếp nhận. | APT-02, APT-06 |
| UC-05.2 | Tạo hồ sơ bệnh nhân | Receptionist | Tạo hồ sơ Patient mới khi chưa có (chưa cần User). | APT-02, APT-06, BR-10 |
| UC-05.3 | Tạo lượt khám Walk-in | Receptionist | Chọn Doctor, tạo Visit REGISTERED (không Appointment), cấp STT. | APT-06, BR-07, LN-05 |
| **UC-06** | **Khám bệnh và lập hồ sơ khám** | | | |
| UC-06.1 | Xem lịch & hồ sơ bệnh nhân | Doctor | Xem lịch và bệnh nhân phân công; mở hồ sơ theo quyền. | EXM-01 |
| UC-06.2 | Bắt đầu lượt khám | Doctor | Visit/Appointment → IN_PROGRESS. | EXM-02, LN-08 |
| UC-06.3 | Lập hồ sơ khám | Doctor | Tạo MedicalRecord khi bắt đầu khám; ghi chẩn đoán, triệu chứng... | EXM-03, BR-08 |
| UC-06.4 | Kết thúc lượt khám | Doctor | Visit/Appointment → COMPLETED; chuyển phí sang lập hóa đơn. | EXM-08, LN-08 |
| UC-06.5 | Lập lịch tái khám | Doctor | Tạo Appointment mới cho cùng Patient. | EXM-09 |
| UC-06.6 | Sửa hồ sơ sau hoàn tất | Doctor đã lập | Chỉ Doctor lập hồ sơ được sửa; ghi lý do & AuditLog. | BR-08, SYS-01 |
| **UC-07** | **Kê đơn thuốc** | | | |
| UC-07.1 | Kê đơn thuốc | Doctor | Ghi Prescription/Detail (chọn từ Medicine). Không bán/quản lý kho. | EXM-04, BR-11 |
| **UC-08** | **Chỉ định dịch vụ và cập nhật kết quả** | | | |
| UC-08.1 | Chỉ định dịch vụ | Doctor | Tạo ServiceOrder và ServiceOrderDetail (ORDERED). | EXM-06, BR-13 |
| UC-08.2 | Cập nhật trạng thái chỉ định | Doctor | ORDERED → IN_PROGRESS → COMPLETED (hoặc CANCELLED có lý do). | EXM-06, BR-13 |
| UC-08.3 | Cập nhật kết quả dịch vụ | Doctor | Lưu ServiceResult cho dịch vụ cần kết quả (tối đa 1 result/detail). | EXM-07 |
| UC-08.4 | Xem kết quả dịch vụ | Doctor | Xem ServiceResult của chỉ định. | EXM-07 |
| **UC-09** | **Lập hóa đơn, thanh toán và hoàn tiền** | | | |
| UC-09.1 | Lập hóa đơn | Receptionist | Tạo Invoice từ VisitCharge & ServiceOrderDetail COMPLETED. | BIL-01, BIL-02, BR-14 |
| UC-09.2 | Phát hành hóa đơn | Receptionist | Invoice NOT_ISSUED → ISSUED sau khi Visit COMPLETED. | BIL-05, BR-15 |
| UC-09.3 | Ghi nhận thanh toán quầy | Receptionist | Ghi nhận Payment tiền mặt/chuyển khoản cho Invoice ISSUED. | BIL-03, BR-15 |
| UC-09.4 | Thanh toán online | Patient | Thanh toán qua cổng sandbox; xác minh kết quả từ cổng. | BIL-04 |
| UC-09.5 | Hủy hóa đơn | Admin | Hủy khi chưa thu tiền hoặc đã hoàn đủ tiền; ghi lý do & AuditLog. | BIL-05, BIL-07 |
| UC-09.6 | Hoàn tiền | Admin | Ghi Refund riêng; tổng Refund SUCCESS ≤ Payment SUCCESS. | BIL-06, BIL-07, BR-16 |
| **UC-10** | **Xem lịch sử khám và đơn thuốc** | | | |
| UC-10.1 | Xem lịch sử khám & đơn | Patient / Doctor | Xem các Visit, MedicalRecord và Prescription theo quyền. | UC-10 |
| **UC-11** | **Quản lý danh mục và hồ sơ bác sĩ** | | | |
| UC-11.1 | Quản lý chuyên khoa | Admin | Specialty; quản lý chuyên khoa của Doctor (Doctor N—N Specialty). | CAT-01, CAT-02 |
| UC-11.2 | Quản lý phòng khám | Admin | Room. | CAT-01 |
| UC-11.3 | Quản lý dịch vụ | Admin | Service và giá hiện hành. | CAT-01, CAT-03 |
| UC-11.4 | Quản lý danh mục thuốc | Admin | Medicine (chỉ là danh mục kê đơn; không kho/cấp phát). | CAT-01 |
| UC-11.5 | Quản lý hồ sơ bác sĩ | Admin | Hồ sơ Doctor, chuyên khoa, thông tin hiển thị, phí khám. | CAT-02 |
| UC-11.6 | Quản lý giá dịch vụ | Admin | Cập nhật giá; không làm thay đổi hóa đơn cũ đã lập. | CAT-03 |
| **UC-12** | **Quản lý lịch làm việc và TimeSlot** | | | |
| UC-12.1 | Tạo lịch làm việc | Admin | Tạo WorkSchedule theo Doctor, ngày/ca, Room; chống trùng. | SCH-01, SCH-03 |
| UC-12.2 | Sinh TimeSlot | Admin | Sinh TimeSlot theo thời lượng khám & capacity (mặc định 1). | SCH-02, BR-01 |
| UC-12.3 | Khóa TimeSlot | Admin | Khóa TimeSlot; không tự xóa/hủy Appointment đã có. | SCH-05 |
| UC-12.4 | Thay đổi/đóng lịch làm việc | Admin | Trích xuất Appointment bị ảnh hưởng để xử lý đổi/hủy. | SCH-04 |
| **UC-14** | **Quản lý danh sách chờ (Waitlist)** | | | |
| UC-14.1 | Đăng ký danh sách chờ | Patient | Tạo WaitlistEntry WAITING cho TimeSlot đã đầy. | UC-14, BR-19 |
| UC-14.2 | Gửi lời mời đặt lịch | SYSTEM | Gửi OFFERED cho WaitlistEntry WAITING theo FIFO khi có chỗ. | BR-19 |
| UC-14.3 | Phản hồi lời mời chờ | Patient | Xác nhận (→ Appointment & BOOKED) hoặc Từ chối/Quá hạn (DECLINED/EXPIRED). | BR-19 |
| **UC-15** | **Nhắc lịch và xác nhận đến khám** | | | |
| UC-15.1 | Gửi nhắc lịch | SYSTEM | Nhắc lịch tự động (mặc định trước 24h và 2h). | NTF-01 |
| UC-15.2 | Gửi yêu cầu xác nhận | SYSTEM | Gửi trước 5h đối với lịch CONFIRMED; lưu Request. | NTF-02, NTF-03 |
| UC-15.3 | Phản hồi xác nhận đến khám | Patient | Phản hồi YES/NO; NO_RESPONSE không tự hủy. | NTF-03, NTF-04 |
| UC-15.4 | Xem thông báo | Patient / Doctor | Trung tâm thông báo; trạng thái đã đọc/chưa đọc. | NTF-05 |
| **UC-16** | **Xem báo cáo thống kê & AuditLog** | | | |
| UC-16.1 | Xem báo cáo thống kê | Admin | Báo cáo lượt khám, doanh thu, tỷ lệ hủy/NO_SHOW, top thuốc. | REP-01..03 |
| UC-16.2 | Xuất báo cáo | Admin | Xuất CSV/PDF nếu cần. | REP-04 |
| UC-16.3 | Xem nhật ký thao tác | Admin | Xem AuditLog các thao tác nhạy cảm. | SYS-01 |
| UC-16.4 | Cấu hình tham số | Admin | Cấu hình tham số hệ thống (thời lượng, capacity, hạn hủy...). | SYS-02 |

---

### 3.2 Đặc tả tóm tắt từng nhóm Use Case

#### UC-01 — Đăng ký, đăng nhập và quản lý hồ sơ cá nhân
* **Mục đích:** Cho phép Patient tạo tài khoản, đăng nhập, quản lý thông tin cá nhân; Admin phân quyền và khóa/mở khóa tài khoản.
* **Tác nhân:** Patient; Admin (UC-01.8, UC-01.9). Nội bộ đăng nhập qua UC-01.2.
* **Tiền điều kiện:** Định danh chưa trùng. Thao tác khác yêu cầu đăng nhập đúng vai trò (AUTH-02, AUTH-04).
* **Luồng chính:** 
  1. Patient đăng ký bằng Email/SĐT + Password → Hệ thống kiểm tra trùng.
  2. Đăng nhập → Tạo phiên xác thực → Kiểm tra quyền Backend cho mọi API.
  3. Patient cập nhật hồ sơ cá nhân / Đổi / Khôi phục mật khẩu.
  4. Admin thực hiện phân quyền hoặc khóa/mở khóa tài khoản.
* **Ngoại lệ:** Trùng thông tin định danh -> từ chối tạo; không có quyền -> Backend trả lỗi; hồ sơ Patient có sẵn trước -> chỉ liên kết sau khi xác minh (1 User - 1 Patient).

#### UC-02 — Tìm bác sĩ và xem lịch trống
* **Mục đích:** Giúp Patient tìm kiếm và chọn TimeSlot còn chỗ.
* **Tác nhân:** Patient.
* **Tiền điều kiện:** Đã có WorkSchedule và TimeSlot được khởi tạo.
* **Luồng chính:** Patient tìm theo bác sĩ/chuyên khoa → Hệ thống hiển thị thông tin & danh sách TimeSlot còn chỗ (chưa vượt capacity).

#### UC-03 — Đặt, đổi và hủy lịch khám
* **Mục đích:** Quản lý vòng đời Appointment và cấp phiếu hẹn.
* **Tác nhân:** Patient (Online), Receptionist (Tại quầy), SYSTEM (Cấp phiếu).
* **Tiền điều kiện:** Slot còn chỗ/hợp lệ; Đổi/Hủy Online phải thực hiện trước ít nhất 2 giờ.
* **Luồng chính:** Kiểm tra slot/capacity → Tạo Appointment PENDING → Hủy (CANCELLED) hoặc Đổi lịch (Tạo Appointment mới + Hủy Appointment cũ lý do RESCHEDULED).

#### UC-04 — Xác nhận lịch, tiếp nhận tại quầy và check-in
* **Mục đích:** Xác nhận lịch PENDING, Check-in cho bệnh nhân đến quầy và xử lý vắng mặt.
* **Tác nhân:** Receptionist, SYSTEM.
* **Luồng chính:** PENDING → CONFIRMED → CHECKED_IN (Ghi `check_in_at`, cấp STT theo ngày/bác sĩ). Nửa tiếng sau giờ hẹn không check-in → SYSTEM chuyển NO_SHOW.

#### UC-05 — Tiếp nhận người đến trực tiếp không có lịch hẹn (Walk-in)
* **Mục đích:** Tiếp nhận bệnh nhân vãng lai.
* **Tác nhân:** Receptionist.
* **Luồng chính:** Tìm/Tạo mới hồ sơ Patient → Chọn Doctor → Tạo Visit REGISTERED (không tạo Appointment giả) → Cấp STT duy nhất theo ngày & Bác sĩ.

#### UC-06 — Khám bệnh và lập hồ sơ khám
* **Mục đích:** Bác sĩ thực hiện quy trình khám bệnh lâm sàng.
* **Tác nhân:** Doctor.
* **Luồng chính:** Bắt đầu khám (Visit/Appointment → IN_PROGRESS) → Tạo MedicalRecord → Kê đơn/Chỉ định dịch vụ → Kết thúc khám (Visit/Appointment → COMPLETED) → Chuyển các khoản phí hợp lệ sang hóa đơn.

#### UC-07 — Kê đơn thuốc
* **Mục đích:** Ghi đơn thuốc trong lượt khám.
* **Tác nhân:** Doctor.
* **Luồng chính:** Chọn thuốc từ danh mục `Medicine` → Nhập liều dùng, cách dùng, số lượng → Lưu `Prescription` và `PrescriptionDetail`. *(Không quản lý kho, không cấp phát hay thu tiền thuốc)*.

#### UC-08 — Chỉ định dịch vụ và cập nhật kết quả
* **Mục đích:** Chỉ định CLS/Dịch vụ, theo dõi tiến trình và trả kết quả.
* **Tác nhân:** Doctor.
* **Luồng chính:** Tạo `ServiceOrder`/`Detail` (ORDERED → IN_PROGRESS → COMPLETED) → Nhập `ServiceResult` (nếu dịch vụ yêu cầu).

#### UC-09 — Lập hóa đơn, thanh toán và hoàn tiền
* **Mục đích:** Thu phí khám và dịch vụ, quản lý chứng từ tài chính.
* **Tác nhân:** Receptionist (Lập/Phát hành/Thu tiền quầy), Patient (Thanh toán Sandbox), Admin (Hủy/Hoàn tiền).
* **Luồng chính:** Tạo Invoice từ VisitCharge & ServiceOrderDetail COMPLETED → Phát hành ISSUED → Ghi nhận Payment → Tạo Refund riêng nếu cần hoàn tiền.

#### UC-10 — Xem lịch sử khám và đơn thuốc
* **Mục đích:** Tra cứu lịch sử khám bệnh.
* **Tác nhân:** Patient (xem của mình), Doctor (xem bệnh nhân phân công).

#### UC-11 — Quản lý danh mục và hồ sơ bác sĩ
* **Mục đích:** Cấu hình danh mục hệ thống và bác sĩ.
* **Tác nhân:** Admin.

#### UC-12 — Quản lý lịch làm việc và TimeSlot
* **Mục đích:** Xây dựng thời gian biểu khám bệnh cho bác sĩ.
* **Tác nhân:** Admin.
* **Luồng chính:** Tạo WorkSchedule (chống trùng phòng/bác sĩ) → Sinh TimeSlot → Khóa/Mở slot hoặc xử lý lịch ảnh hưởng khi đóng ca.

#### UC-14 — Quản lý danh sách chờ (Waitlist)
* **Mục đích:** Cho phép đăng ký chờ khi khung giờ đã đầy chỗ.
* **Tác nhân:** Patient, SYSTEM, Receptionist.
* **Luồng chính:** Đăng ký (WAITING) → Hủy slot trống → SYSTEM gửi thông báo (OFFERED) theo FIFO → Patient xác nhận trong thời hạn → Chuyển BOOKED & Tạo Appointment.

#### UC-15 — Nhận nhắc lịch và phản hồi xác nhận đến khám
* **Mục đích:** Gửi thông báo tự động và thu thập xác nhận của bệnh nhân.
* **Tác nhân:** SYSTEM, Patient.

#### UC-16 — Xem báo cáo thống kê và nhật ký thao tác
* **Mục đích:** Báo cáo quản trị tài chính, vận hành và AuditLog.
* **Tác nhân:** Admin.

---

### 3.3 Phạm vi thao tác CRUD theo nhóm dữ liệu

| Dữ liệu | Tạo (Create) | Xem (Read) | Cập nhật (Update) | Xóa / Ngừng sử dụng (Delete) | Căn cứ |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **User** | Patient tự đăng ký; Admin tạo nội bộ. | Bản thân; Admin quản lý. | Đổi/khôi phục mật khẩu; Admin sửa vai trò, khóa. | Không xóa cứng; Admin khóa tài khoản. | AUTH-01..06 |
| **Patient** | Receptionist (khi walk-in); Patient tự đăng ký. | Bản thân; Doctor phân công; Receptionist. | Bản thân; Receptionist cập nhật hành chính. | Không xóa cứng nếu có lịch sử khám/lịch hẹn. | AUTH-05, APT-02 |
| **Danh mục (Specialty, Room, Service, Medicine)** | Admin | Tất cả vai trò (theo phạm vi công việc). | Admin | Ngừng hoạt động (IsActive=false); Không xóa cứng. | CAT-01 |
| **Doctor & Phí khám** | Admin | Tất cả vai trò | Admin | Ngừng nhận lịch; Giữ lịch sử giao dịch. | CAT-02 |
| **Giá dịch vụ** | Admin | Tất cả vai trò | Admin (Không đổi ngược giá trên Invoice cũ). | Không xóa giá đã giao dịch; Thêm giá mới. | CAT-03 |
| **WorkSchedule / TimeSlot** | Admin | Tất cả vai trò | Admin khóa/điều chỉnh. | Không xóa âm thầm lịch hẹn đã đặt. | SCH-01..05 |
| **Appointment** | Patient; Receptionist; Doctor (Tái khám); SYSTEM (Waitlist). | Patient (mình); Receptionist; Doctor; Admin. | Chuyển trạng thái theo BR-06. Không sửa giờ hẹn. | Không xóa cứng; Hủy = CANCELLED. | APT-01..08, BR-06 |
| **Visit** | Receptionist (Walk-in hoặc Check-in). | Doctor; Receptionist; Patient (lịch sử). | Doctor cập nhật trạng thái khám. | Receptionist chỉ hủy Visit REGISTERED tạo nhầm. | APT-06, EXM-02 |
| **MedicalRecord** | Doctor | Doctor phụ trách; Patient (mình). | Doctor đã lập (nếu xong phải có AuditLog). | Không xóa cứng dữ liệu y tế. | EXM-03, BR-08 |
| **Prescription / Detail** | Doctor (Visit IN_PROGRESS). | Doctor phụ trách; Patient (mình). | Doctor (Visit IN_PROGRESS); Hoàn tất chỉ đính chính. | Không xóa cứng. | EXM-04, BR-11 |
| **ServiceOrder / Detail** | Doctor | Doctor; Receptionist (thu tiền); Patient. | Doctor cập nhật trạng thái hoặc Hủy (có lý do). | Không xóa cứng. | EXM-06, BR-13 |
| **ServiceResult** | Doctor | Doctor; Patient. | Doctor phụ trách (ghi AuditLog nếu sửa). | Không xóa cứng. | EXM-07 |
| **Invoice / Detail** | Receptionist | Patient; Receptionist; Admin. | Receptionist phát hành; Admin hủy (có lý do). | Admin hủy; Không xóa cứng. | BIL-01..07 |
| **Payment** | Receptionist (Tiền mặt/CK); Patient (Online). | Patient; Receptionist; Admin. | Cập nhật PENDING → SUCCESS/FAILED. | Không xóa Payment gốc. | BIL-03, BIL-04 |
| **Refund** | Admin | Admin; Patient; Receptionist. | PENDING → SUCCESS/FAILED. | Không xóa Refund. | BIL-06, BR-16 |
| **WaitlistEntry** | Patient; Receptionist. | Patient; Receptionist; SYSTEM. | WAITING → OFFERED → BOOKED/DECLINED/EXPIRED. | Patient có thể hủy khi WAITING. | UC-14, BR-19 |
| **AuditLog / StatusHistory** | Tự động (System/User action). | Admin | Append-only (Không chỉnh sửa). | Không xóa cứng. | SYS-01, BR-20 |

---

### 3.4 Mô tả luồng nghiệp vụ chi tiết

#### LN-01 — Đặt lịch khám (UC-03.1, UC-03.2)
* **Tác nhân:** Patient / Receptionist.
* **Luồng chính:** Tìm bác sĩ/chuyên khoa → Chọn TimeSlot còn chỗ → Nhập lý do → System kiểm tra trùng lịch & Capacity → Tạo `Appointment` (PENDING) → Cấp phiếu hẹn điện tử.
* **Trạng thái:** `(Chưa có)` → `PENDING`.

#### LN-02 — Xác nhận lịch, nhắc lịch và xác nhận đến khám (UC-04.1, UC-15)
* **Tác nhân:** Receptionist, SYSTEM, Patient.
* **Luồng chính:** 
  1. Receptionist xác nhận: `PENDING` → `CONFIRMED`.
  2. SYSTEM gửi nhắc lịch (Trước 24h & 2h).
  3. SYSTEM gửi yêu cầu xác nhận riêng trước 5h → Lưu `AppointmentConfirmationRequest`.
  4. Patient phản hồi YES (giữ `CONFIRMED`) / NO (yêu cầu hủy) / NO_RESPONSE (không tự hủy).

#### LN-03 — Đổi lịch và hủy lịch (UC-03.4, UC-03.5)
* **Tác nhân:** Patient (Online ≥ 2h), Receptionist (Hỗ trợ tại quầy/điện thoại).
* **Luồng chính:**
  * **Hủy lịch:** Kiểm tra hạn 2h → Chuyển `CANCELLED` (ghi lý do) → Giải phóng Capacity slot.
  * **Đổi lịch:** Kiểm tra Slot mới hợp lệ → Tạo Appointment mới (PENDING) → Chuyển Appointment cũ sang `CANCELLED` với lý do `RESCHEDULED`.
* **Trạng thái:** `PENDING/CONFIRMED` → `CANCELLED`.

#### LN-04 — Tiếp nhận và check-in lịch hẹn (UC-04.2)
* **Tác nhân:** Receptionist.
* **Luồng chính:** Bệnh nhân đến quầy → Kiểm tra Appointment trạng thái `CONFIRMED` → Ghi nhận `check_in_at` → Cấp STT trong ngày theo Bác sĩ → Chuyển trạng thái `CONFIRMED` → `CHECKED_IN`.

#### LN-05 — Tiếp nhận người đến trực tiếp không có lịch hẹn (UC-05)
* **Tác nhân:** Receptionist.
* **Luồng chính:** Tra cứu Patient (Tạo mới nếu chưa có) → Chọn Doctor tiếp nhận → Tạo `Visit` trạng thái `REGISTERED` (không qua Appointment) → Cấp STT trong ngày theo Bác sĩ.

#### LN-06 — Lịch hẹn không được xác nhận hoặc bệnh nhân không đến (UC-04.3)
* **Tác nhân:** SYSTEM.
* **Luồng chính:** Tác vụ quét định kỳ các Appointment `CONFIRMED` quá giờ hẹn + 30 phút chờ mà chưa check-in → Chuyển sang `NO_SHOW` (Tác nhân ghi nhận: SYSTEM).

#### LN-07 — Danh sách chờ khi TimeSlot đã đầy (UC-14)
* **Tác nhân:** Patient, SYSTEM.
* **Luồng chính:** TimeSlot hết chỗ → Patient đăng ký Waitlist (`WAITING`) → Có slot trống → SYSTEM gửi lời mời `OFFERED` cho người đứng đầu FIFO → Patient chấp nhận trong thời gian quy định → Tạo Appointment mới & Chuyển WaitlistEntry sang `BOOKED`.

#### LN-08 — Khám bệnh, hồ sơ khám, kê đơn và chỉ định dịch vụ (UC-06, UC-07, UC-08)
* **Tác nhân:** Doctor.
* **Luồng chính:** 
  1. Bắt đầu khám: `Visit` / `Appointment` → `IN_PROGRESS` (Ghi `started_at`).
  2. Tạo `MedicalRecord` → Ghi chẩn đoán, triệu chứng.
  3. Kê đơn (`Prescription` / `Detail`) & Chỉ định CLS (`ServiceOrder` / `Detail`).
  4. Kết thúc khám: `Visit` / `Appointment` → `COMPLETED` (Ghi `completed_at`) → Đẩy các khoản phí hợp lệ sang phân hệ Billing.

#### LN-09 — Lập hóa đơn và ghi nhận thanh toán (UC-09.1 đến UC-09.4)
* **Tác nhân:** Receptionist, Patient, Cổng Sandbox.
* **Luồng chính:** Gom khoản phí `VisitCharge` + `ServiceOrderDetail` (COMPLETED) → Lập `Invoice` (`NOT_ISSUED`) → Phát hành `ISSUED` → Thu tiền (Tạo `Payment` PENDING/SUCCESS/FAILED) → Cập nhật trạng thái thanh toán Invoice (`UNPAID` / `PARTIALLY_PAID` / `PAID`).

#### LN-10 — Hủy hóa đơn và hoàn tiền (UC-09.5, UC-09.6)
* **Tác nhân:** Admin.
* **Luồng chính:** 
  * **Hủy hóa đơn:** Chỉ thực hiện khi chưa thu tiền hoặc đã hoàn đủ 100% tiền mặt/CK → Invoice → `CANCELLED` (Ghi AuditLog).
  * **Hoàn tiền:** Tạo bản ghi `Refund` riêng → Kiểm tra Tổng tiền Refund SUCCESS ≤ Số tiền Payment SUCCESS còn lại.

#### LN-11 — Thay đổi/đóng lịch làm việc và khóa TimeSlot (UC-12)
* **Tác nhân:** Admin.
* **Luồng chính:** Tạo WorkSchedule (chống trùng Doctor/Room) → Sinh TimeSlot → Khóa/Đóng lịch → Trích xuất danh sách Appointment bị ảnh hưởng để hủy/đổi lịch có thông báo.

---

## 4. Yêu cầu chức năng (Detail Rules)

* **AUTH — Tài khoản & Phân quyền:**
  * `AUTH-01`: Patient đăng ký bằng email/SĐT + password; kiểm tra trùng lặp.
  * `AUTH-02`: Đăng nhập/Đăng xuất; bảo vệ session/token.
  * `AUTH-03`: Đổi mật khẩu & Khôi phục mật khẩu an toàn.
  * `AUTH-04`: Phân quyền Admin, Receptionist, Doctor, Patient ở Backend.
  * `AUTH-05`: Patient quản lý thông tin cá nhân và tiền sử dị ứng.
  * `AUTH-06`: Admin khóa/mở khóa tài khoản User. Liên kết User-Patient phải qua xác minh.
* **CAT — Danh mục:**
  * `CAT-01`: Quản lý Chuyên khoa, Phòng khám, Dịch vụ và Thuốc.
  * `CAT-02`: Quản lý hồ sơ Bác sĩ, giá khám, chuyên khoa phụ trách.
  * `CAT-03`: Quản lý bảng giá dịch vụ (không ảnh hưởng hóa đơn cũ).
* **SCH — Lịch làm việc:**
  * `SCH-01`: Khởi tạo WorkSchedule theo Bác sĩ, Ngày/Ca, Phòng.
  * `SCH-02`: Sinh TimeSlot tự động, capacity mặc định = 1.
  * `SCH-03`: Chống trùng lịch công tác của Bác sĩ hoặc Phòng khám.
  * `SCH-04`: Xử lý truyền vết khi điều chỉnh/đóng ca làm việc.
  * `SCH-05`: Khóa TimeSlot (không tự động xóa Appointment sẵn có).
* **APT — Lịch hẹn & Tiếp nhận:**
  * `APT-01`: Tìm kiếm bác sĩ và đặt lịch online kèm lý do.
  * `APT-02`: Receptionist đặt lịch tại quầy.
  * `APT-03`: Khóa giao dịch đồng thời (Concurrency control) chống overbooking.
  * `APT-04`: Đổi/hủy lịch hẹn (Lưu vết quan hệ cũ-mới khi đổi lịch).
  * `APT-05`: Quy trình trạng thái: PENDING → CONFIRMED → CHECKED_IN.
  * `APT-06`: Tiếp nhận Walk-in (Cấp STT riêng biệt theo Bác sĩ/Ngày).
  * `APT-07`: Cấp phiếu hẹn điện tử.
  * `APT-08`: Ghi nhật ký trạng thái `AppointmentStatusHistory`.
* **EXM — Khám & Lâm sàng:**
  * `EXM-01`: Doctor tra cứu danh sách khám.
  * `EXM-02`: Chuyển trạng thái bắt đầu khám (`IN_PROGRESS`).
  * `EXM-03`: Lập `MedicalRecord` (Triệu chứng, chẩn đoán, hướng xử trí).
  * `EXM-04`: Kê đơn thuốc (`Prescription`).
  * `EXM-06`: Chỉ định dịch vụ cận lâm sàng.
  * `EXM-07`: Cập nhật kết quả CLS (`ServiceResult`).
  * `EXM-08`: Kết thúc lượt khám (`COMPLETED`).
  * `EXM-09`: Đặt lịch tái khám.
* **BIL — Hóa đơn & Thanh toán:**
  * `BIL-01`: Lập Invoice từ `VisitCharge` và `ServiceOrderDetail` COMPLETED.
  * `BIL-02`: Chi tiết hóa đơn (`InvoiceDetail`) chỉ tham chiếu 1 nguồn phí duy nhất.
  * `BIL-03`: Thu tiền quầy (Tiền mặt/Chuyển khoản).
  * `BIL-04`: Thanh toán Online Sandbox (Idempotency control chống thu trùng).
  * `BIL-05`: Tách biệt Trạng thái chứng từ và Trạng thái thanh toán.
  * `BIL-06`: Quản lý hoàn tiền bằng bảng `Refund` riêng.
  * `BIL-07`: Hủy hóa đơn/Hoàn tiền bắt buộc lưu AuditLog.
* **NTF — Thông báo:**
  * `NTF-01`: Gửi nhắc lịch tự động (24h, 2h).
  * `NTF-02`: Gửi yêu cầu xác nhận đến khám (Trước 5h).
  * `NTF-03`: Lưu nhật ký `AppointmentConfirmationRequest`.
  * `NTF-04`: Xử lý phản hồi xác nhận YES/NO/NO_RESPONSE.
  * `NTF-05`: Trung tâm thông báo In-app/SMS/Email.
* **REP/SYS — Báo cáo & Hệ thống:**
  * `REP-01..04`: Báo cáo lượt khám, doanh thu, NO_SHOW, top thuốc; xuất file CSV/PDF.
  * `SYS-01`: Ghi nhận `AuditLog` cho các hành động nhạy cảm.
  * `SYS-02`: Quản lý tham số cấu hình toàn hệ thống.

---

## 5. Quy tắc nghiệp vụ bắt buộc (Business Rules)

| Mã | Chủ đề | Nội dung quy tắc |
| :--- | :--- | :--- |
| **BR-01** | Sức chứa | Số Appointment hiệu lực trong 1 TimeSlot ≤ Capacity (Mặc định = 1). Kiểm soát bằng Transaction ở Backend. |
| **BR-02** | Hạn Đổi/Hủy | Patient chỉ được tự đổi/hủy Online trước **ít nhất 2 giờ**. Dưới 2h phải liên hệ Receptionist. |
| **BR-03** | Không điều phối | Hủy/NO_SHOW không tự động đẩy giờ hoặc đổi `scheduled_time` của người khác. |
| **BR-04** | Giải phóng Slot | Hủy hợp lệ trước giờ hẹn giải phóng capacity slot. Slot quá giờ không mở lại cho đặt online. |
| **BR-05** | NO_SHOW | Qua `scheduled_time` + 30 phút không Check-in → Tự động chuyển `NO_SHOW` (Tác nhân: SYSTEM). |
| **BR-06** | Trạng thái Lịch | Luồng: `PENDING` → `CONFIRMED` → `CHECKED_IN` → `IN_PROGRESS` → `COMPLETED`. Hủy = `CANCELLED`. |
| **BR-07** | Quản lý Visit | 1 Appointment ↔ 0..1 Visit. Walk-in không tạo Appointment giả. STT duy nhất theo Ngày + Doctor. |
| **BR-08** | MedicalRecord | 1 Visit có tối đa 1 Hồ sơ khám. Đã COMPLETED muốn sửa phải ghi lý do & AuditLog. |
| **BR-09** | Thời gian | `scheduled_time` là cố định. Lưu vết thực tế riêng: `check_in_at`, `started_at`, `completed_at`. |
| **BR-10** | Patient/User | Quan hệ 1 User - 1 Patient. Patient có thể tồn tại độc lập khi chưa đăng ký tài khoản App. |
| **BR-11** | Đơn thuốc | Thuốc kê trong `PrescriptionDetail`. Phòng khám không bán, không xuất kho, không thu tiền thuốc. |
| **BR-13** | Dịch vụ CLS | Chi tiết dịch vụ chỉ tính phí khi trạng thái = `COMPLETED`. `CANCELLED` không tính phí. |
| **BR-14** | Nguồn phí | `InvoiceDetail` tham chiếu **đúng 1 trong 2 nguồn**: `VisitCharge` HOẶC `ServiceOrderDetail`. |
| **BR-15** | Invoice/Payment | Chỉ Invoice `ISSUED` mới được thu tiền. Không xóa bản ghi `Payment` gốc khi thanh toán thất bại. |
| **BR-16** | Hoàn tiền | `Refund` lưu bản ghi riêng. Tổng Refund SUCCESS ≤ Tổng Payment SUCCESS khả dụng. |
| **BR-17** | Chứng từ | Trạng thái chứng từ (ISSUED/CANCELLED) độc lập với trạng thái thanh toán (PAID/REFUNDED). |
| **BR-18** | Yêu cầu 5h | Xác nhận trước 5h không thay thế nhắc lịch 24h/2h. `NO_RESPONSE` không tự động hủy lịch. |
| **BR-19** | Waitlist | WaitlistEntry ≠ Appointment. Chỉ tạo Appointment khi bệnh nhân xác nhận OFFERED còn thời hạn. |
| **BR-20** | Lưu vết lịch sử | Dữ liệu giao dịch/y tế/lịch sử không xóa cứng (No hard delete). System action ghi tác nhân `SYSTEM`. |
| **BR-21** | Đổi lịch | Đổi lịch = Tạo Appointment mới + Chuyển Appointment cũ sang `CANCELLED` (lý do: `RESCHEDULED`). |

---

## 6. Mô hình trạng thái thống nhất

| Đối tượng | Trạng thái & Luồng chuyển đổi | Ghi chú |
| :--- | :--- | :--- |
| **Appointment** | `PENDING` → `CONFIRMED` → `CHECKED_IN` → `IN_PROGRESS` → `COMPLETED`<br>• `PENDING/CONFIRMED` → `CANCELLED`<br>• `CONFIRMED` → `NO_SHOW` | Đổi lịch: Lịch cũ `CANCELLED` (RESCHEDULED), tạo lịch mới `PENDING`. Không có trạng thái `RESCHEDULED`. |
| **Visit** | `REGISTERED` → `IN_PROGRESS` → `COMPLETED`<br>• `REGISTERED` → `CANCELLED` (chỉ khi tạo nhầm tại quầy) | Khởi tạo khi Walk-in hoặc khi Check-in Appointment. |
| **ServiceOrderDetail** | `ORDERED` → `IN_PROGRESS` → `COMPLETED`<br>• Hoặc → `CANCELLED` | Chỉ `COMPLETED` mới đủ điều kiện tính tiền vào Invoice. |
| **Payment** | `PENDING` → `SUCCESS` / `FAILED` | Mỗi lần thử thanh toán là 1 bản ghi Payment. Không xóa Payment lỗi. |
| **Refund** | `PENDING` → `SUCCESS` / `FAILED` | Bản ghi hoàn tiền độc lập. |
| **Invoice (Chứng từ)** | `NOT_ISSUED` → `ISSUED` → `CANCELLED` | `NOT_ISSUED`: Hóa đơn nháp chưa thu tiền. `ISSUED`: Đã phát hành, cho phép thu tiền. |
| **Invoice (Thanh toán)**| `UNPAID` → `PARTIALLY_PAID` → `PAID` → `PARTIALLY_REFUNDED` → `REFUNDED` | Trạng thái tổng hợp dựa trên Payment và Refund. |
| **WaitlistEntry** | `WAITING` → `OFFERED` → `BOOKED` / `DECLINED` / `EXPIRED` / `CANCELLED` | `BOOKED`: Đã tạo Appointment thành công. |

---

## 7. Thực thể dữ liệu đề xuất (Cho ERD)

1. **User:** Tài khoản đăng nhập, password hash, role, status.
2. **Patient:** Hồ sơ bệnh nhân (Họ tên, SĐT, Ngày sinh, Địa chỉ, Tiền sử dị ứng, UserId fk).
3. **Doctor:** Hồ sơ bác sĩ (Họ tên, Học vị, Phí khám, UserId fk).
4. **Specialty:** Danh mục chuyên khoa.
5. **DoctorSpecialty:** Bảng n-n giữa Doctor và Specialty.
6. **Room:** Danh mục phòng khám.
7. **WorkSchedule:** Lịch làm việc của bác sĩ (DoctorId, RoomId, Ngày, Ca).
8. **TimeSlot:** Khung giờ chi tiết (ScheduleId, GioBatDau, GioKetThuc, Capacity, Status).
9. **Appointment:** Lịch hẹn (PatientId, TimeSlotId, ScheduledTime, Lý do, Status, RescheduledFromId fk).
10. **AppointmentStatusHistory:** Lịch sử đổi trạng thái lịch hẹn.
11. **AppointmentConfirmationRequest:** Nhật ký gửi yêu cầu xác nhận 5h.
12. **Visit:** Lượt khám thực tế (PatientId, DoctorId, AppointmentId fk, STT, CheckInAt, Status).
13. **VisitCharge:** Khoản phí khám phát sinh từ Visit.
14. **MedicalRecord:** Hồ sơ khám bệnh (VisitId, Triệu chứng, Chẩn đoán, Lời khuyên, Ngày tái khám).
15. **Medicine:** Danh mục thuốc.
16. **Prescription:** Đơn thuốc (MedicalRecordId).
17. **PrescriptionDetail:** Chi tiết đơn thuốc (MedicineId, SoLuong, LieuDung, CachDung).
18. **Service:** Danh mục dịch vụ/CLS và giá hiện hành.
19. **ServiceOrder:** Đơn chỉ định dịch vụ (MedicalRecordId).
20. **ServiceOrderDetail:** Chi tiết dịch vụ chỉ định (ServiceId, DongGia, Status).
21. **ServiceResult:** Kết quả cận lâm sàng (OrderDetailId fk, Kết quả, HÌnh ảnh/File).
22. **Invoice:** Hóa đơn (VisitId, MaHoaDon, TrangThaiChungTu, TrangThaiThanhToan).
23. **InvoiceDetail:** Chi tiết hóa đơn (InvoiceId, VisitChargeId fk, ServiceOrderDetailId fk, SoLuong, DonGia, ThanhTien).
24. **Payment:** Giao dịch thanh toán (InvoiceId, PhuongThuc, SoTien, MaGiaoDich, Status).
25. **Refund:** Giao dịch hoàn tiền (PaymentId, SoTien, LyDo, Status).
26. **WaitlistEntry:** Đăng ký danh sách chờ (PatientId, TimeSlotId, Status).
27. **Notification:** Thông báo in-app/system (UserId fk, PatientId fk, Nội dung, IsRead).
28. **AuditLog:** Nhật ký thao tác hệ thống (UserId, Action, Detail, IP, Time).
29. **SystemConfig:** Tham số cấu hình hệ thống (Key, Value).

