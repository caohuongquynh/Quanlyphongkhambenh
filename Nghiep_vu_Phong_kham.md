
HỆ THỐNG QUẢN LÝ PHÒNG KHÁM
1. Phạm vi hệ thống
•	Một phòng khám ngoại trú, một cơ sở; không quản lý bệnh nhân nội trú, giường bệnh hoặc nhiều chi nhánh.
•	Web dành cho Admin, Receptionist và Doctor; Mobile chủ yếu dành cho Patient.
•	Web và Mobile sử dụng chung Backend/API và cùng một cơ sở dữ liệu.
•	Phạm vi gồm tài khoản/phân quyền, danh mục, bác sĩ/lịch làm việc, lịch hẹn, tiếp nhận trực tiếp, khám và hồ sơ khám, kê đơn thuốc, chỉ định dịch vụ/kết quả, hóa đơn/thanh toán, thông báo, báo cáo và nhật ký.
•	Hỗ trợ bệnh nhân đến trực tiếp không đặt lịch. Bệnh nhân có thể có hồ sơ Patient trước khi có tài khoản User.
•	Không có chức năng đặt lịch giúp người thân/hồ sơ phụ thuộc; không tự động đổi giờ hoặc đẩy lịch của bệnh nhân khác khi có người hủy/không đến.
•	Không tự thêm cơ chế phạt, khóa tài khoản do hủy nhiều lần, bảo hiểm, quản lý nội trú hoặc nhiều chi nhánh.
2. Vai trò và quyền chính
Mục này giữ nguyên bốn vai trò đã chốt (Admin, Receptionist, Doctor, Patient) và tác nhân tự động SYSTEM. Để đủ căn cứ sang Bước 2, các quyền và quy tắc vận hành trước đây còn bỏ ngỏ đã được chốt theo phạm vi đồ án tại Phụ lục A; không bổ sung vai trò mới và không mở rộng phạm vi kê đơn thuốc thành quản lý kho/cấp phát/bán thuốc.
2.1 Tác nhân và chức năng chính (nội dung gốc, giữ nguyên)
Vai trò	Chức năng chính
Admin	Quản lý tài khoản và phân quyền; danh mục; hồ sơ bác sĩ; lịch làm việc; báo cáo; cấu hình và nhật ký hệ thống.
Receptionist	Tìm/tạo hồ sơ bệnh nhân; tạo lịch tại quầy; xác nhận lịch; check-in; tạo Visit cho người đến trực tiếp; hỗ trợ hủy/đổi lịch theo quy tắc.
Doctor	Xem lịch và bệnh nhân được phân công; bắt đầu/kết thúc lượt khám; lập MedicalRecord; kê đơn; chỉ định dịch vụ; xem/cập nhật kết quả theo quyền.
Patient	Đăng ký/đăng nhập; quản lý hồ sơ cá nhân; tìm bác sĩ và lịch trống; đặt/đổi/hủy lịch; phản hồi xác nhận; xem lịch sử khám/đơn thuốc; thanh toán online.

2.2 Vai trò, chức năng, phạm vi dữ liệu và giới hạn quyền của từng tác nhân
Tác nhân	Vai trò và mục đích	Chức năng được phép (theo tài liệu gốc)	Phạm vi dữ liệu được xem	Giới hạn quyền (có căn cứ trong tài liệu gốc)
Admin	Người quản trị trên Web.
Quản lý tài khoản, danh mục, lịch làm việc và giám sát hệ thống qua báo cáo, cấu hình, nhật ký.	- Phân quyền tài khoản (AUTH-04); khóa/mở khóa tài khoản (AUTH-06).
- Quản lý Specialty, Room, Service, Medicine; hồ sơ Doctor, chuyên khoa, thông tin nghề nghiệp hiển thị, phí khám; giá dịch vụ (CAT-01..03).
- Tạo WorkSchedule, sinh TimeSlot và cấu hình capacity, khóa TimeSlot, thay đổi/đóng lịch làm việc (SCH-01..05).
- Xem báo cáo và xuất CSV/PDF nếu cần (REP-01..04); xem nhật ký AuditLog; cấu hình tham số nghiệp vụ (SYS-01, SYS-02).	Tài khoản, danh mục, hồ sơ Doctor, lịch làm việc/TimeSlot, báo cáo tổng hợp và AuditLog. Không xem chi tiết MedicalRecord; chỉ xem dữ liệu hóa đơn/thanh toán/hoàn tiền khi phục vụ quản trị tài chính.	Không thực hiện khám, kê đơn hoặc chỉ định dịch vụ. Có quyền khóa/mở khóa tài khoản; hủy hóa đơn và duyệt/ghi nhận hoàn tiền theo quy tắc tại Phụ lục A.
Receptionist	Nhân viên quầy trên Web.
Tiếp nhận bệnh nhân, quản lý lịch hẹn tại quầy và thực hiện các bước thu phí theo UC-09.	- Tìm/tạo hồ sơ Patient và cập nhật thông tin hành chính/liên hệ theo yêu cầu của người bệnh.
- Tạo Appointment tại quầy; xác nhận PENDING → CONFIRMED; check-in CONFIRMED, ghi giờ check-in và cấp số thứ tự.
- Tạo Visit REGISTERED cho người đến trực tiếp; hỗ trợ đổi/hủy lịch, ghi người thực hiện và lý do.
- Lập/phát hành hóa đơn và ghi nhận thanh toán tiền mặt/chuyển khoản.
- Hỗ trợ đăng ký/hủy danh sách chờ tại quầy.	Thông tin hành chính/liên hệ của Patient, Appointment, Visit và các dữ liệu hóa đơn/thanh toán cần để tiếp nhận, thu phí. Không xem nội dung chi tiết MedicalRecord, chẩn đoán hoặc ghi chú lâm sàng.	Không khám, chẩn đoán, kê đơn hoặc chỉ định dịch vụ. Chỉ check-in Appointment CONFIRMED. Không tạo Appointment giả cho walk-in. Hủy hóa đơn/hoàn tiền phải do Admin phê duyệt; Receptionist không tự phê duyệt hoàn tiền.
Doctor	Bác sĩ trên Web.
Thực hiện khám, lập hồ sơ khám, kê đơn và chỉ định dịch vụ.	- Xem lịch và bệnh nhân được phân công; mở hồ sơ Patient theo quyền (EXM-01).
- Bắt đầu/kết thúc lượt khám (EXM-02, EXM-08); lập MedicalRecord (EXM-03).
- Kê đơn thuốc (EXM-04); chỉ định dịch vụ (EXM-06); xem/cập nhật kết quả dịch vụ theo quyền (EXM-07).
- Xem lịch sử khám và đơn thuốc (UC-10); nhận thông báo khi cần thông báo bác sĩ (NTF-05).	Lịch và bệnh nhân được phân công; hồ sơ Patient, lịch sử khám, đơn thuốc theo quyền.
Danh mục thuốc/dịch vụ dùng khi kê đơn và chỉ định.	Chỉ xem hồ sơ bệnh nhân thuộc lịch khám/Visit được phân công. Chỉnh sửa MedicalRecord sau khi hoàn tất chỉ do Doctor đã lập hồ sơ thực hiện, phải nêu lý do và ghi AuditLog. Không thực hiện quản trị tài khoản, xác nhận/check-in lịch hẹn, lập hóa đơn hoặc thu tiền.
Patient	Người bệnh, chủ yếu dùng Mobile.
Tự đặt lịch, theo dõi lịch khám, xem lịch sử khám/đơn thuốc và thanh toán online.	- Đăng ký, đăng nhập; xem/sửa hồ sơ cá nhân gồm họ tên, ngày sinh, giới tính, địa chỉ, liên hệ, tiền sử dị ứng (AUTH-01, AUTH-05).
- Tìm bác sĩ/chuyên khoa, xem TimeSlot còn chỗ, đặt lịch với lý do khám (APT-01).
- Xem lịch, đổi/hủy lịch theo quy tắc thời hạn (APT-04, BR-02).
- Nhận nhắc lịch; phản hồi yêu cầu xác nhận đến khám YES/NO (NTF-01..04).
- Xem lịch sử khám/đơn thuốc (UC-10); thanh toán online qua cổng sandbox (BIL-04).
- Tham gia danh sách chờ: xác nhận hoặc từ chối lời mời OFFERED (UC-14, BR-19).	Hồ sơ cá nhân, Appointment, Visit, MedicalRecord, kết quả dịch vụ và Prescription của chính Patient; thông tin bác sĩ/chuyên khoa và TimeSlot còn chỗ để đặt lịch.	Không xem dữ liệu của Patient khác; không tự đổi/hủy online trong vòng dưới 2 giờ trước giờ hẹn; không khám, kê đơn hoặc chỉ định dịch vụ.
SYSTEM (tác nhân hệ thống)	Tác vụ tự động, không cần User; được ghi nhận là tác nhân SYSTEM trong AppointmentStatusHistory và AuditLog (APT-08, SYS-01, BR-20).	- Gửi nhắc lịch theo mốc cấu hình, mặc định 24 giờ và 2 giờ trước giờ hẹn.
- Gửi yêu cầu xác nhận trước 5 giờ đối với Appointment CONFIRMED; lưu từng lần gửi/phản hồi.
- Chuyển CONFIRMED sang NO_SHOW sau 30 phút kể từ scheduled_time nếu không check-in hợp lệ.
- Xử lý danh sách chờ theo thứ tự đăng ký và thời hạn cấu hình; cấp thông báo/phiếu lịch hẹn điện tử.	Appointment, WaitlistEntry, Notification và AppointmentConfirmationRequest phục vụ tác vụ tự động.	Không tự hủy Appointment do NO_RESPONSE; không chuyển PENDING sang NO_SHOW; không tự đổi giờ, đẩy lịch người khác hoặc tự tạo Appointment từ danh sách chờ khi Patient chưa xác nhận.

2.3 Ma trận quyền hạn
Chức năng / dữ liệu	Admin	Receptionist	Doctor	Patient	Căn cứ / giới hạn
Quản lý tài khoản và phân quyền	✓	—	—	—	AUTH-04; Admin quản trị vai trò
Khóa/mở khóa tài khoản	✓	—	—	—	AUTH-06
Đăng ký tài khoản	—	—	—	✓ (tài khoản Patient)	AUTH-01
Đăng nhập/đăng xuất; đổi và khôi phục mật khẩu	✓ (tài khoản của mình/quản trị)	✓ (tài khoản của mình)	✓ (tài khoản của mình)	✓ (tài khoản của mình)	AUTH-02, AUTH-03
Xem/sửa thông tin cá nhân Patient	Chỉ dữ liệu hành chính cần quản trị	✓ (tìm/tạo; cập nhật hành chính/liên hệ theo yêu cầu)	✓ (xem Patient được phân công)	✓ (hồ sơ của mình)	AUTH-05, APT-02, EXM-01
Quản lý Specialty, Room, Service, Medicine, giá dịch vụ/phí khám	✓	Xem thông tin cần cho tiếp nhận/thu phí	Xem danh mục để khám, kê đơn, chỉ định	Xem thông tin công khai cần đặt lịch	CAT-01..03; Medicine chỉ là danh mục kê đơn
Quản lý hồ sơ Doctor	✓	Xem thông tin phục vụ lịch/tiếp nhận	Xem hồ sơ của mình và chuyên khoa liên quan	Xem thông tin hiển thị khi tìm bác sĩ	CAT-02, APT-01
Tạo WorkSchedule, sinh TimeSlot, khóa/đóng lịch	✓	Xem lịch và xử lý lịch hẹn bị ảnh hưởng theo phân công	Xem lịch của mình	Xem TimeSlot còn chỗ	SCH-01..05
Xem lịch làm việc/lịch khám	✓	✓ (lịch toàn phòng khám phục vụ tiếp nhận)	✓ (lịch và bệnh nhân được phân công)	✓ (lịch của mình và slot còn chỗ)	EXM-01, APT-01
Tạo Appointment	—	✓ (tại quầy)	✓ (lập lịch tái khám cho Patient đang khám)	✓ (online, cho chính mình)	APT-01, APT-02, EXM-09
Xem lịch hẹn	✓ (phục vụ quản trị)	✓ (toàn phòng khám phục vụ tiếp nhận)	✓ (Appointment được phân công)	✓ (của mình)	APT-04, EXM-01
Đổi/hủy lịch hẹn	—	✓ (ghi người thực hiện và lý do)	—	✓ (online khi còn ít nhất 2 giờ)	APT-04, BR-02, BR-21
Xác nhận lịch PENDING → CONFIRMED	—	✓	—	—	APT-05
Check-in Appointment CONFIRMED	—	✓	—	—	APT-05, BR-06
Tạo Visit cho người đến trực tiếp	—	✓	—	—	APT-06
Phản hồi yêu cầu xác nhận đến khám YES/NO	—	—	—	✓	NTF-03, NTF-04
Bắt đầu/kết thúc lượt khám	—	—	✓	—	EXM-02, EXM-08
Lập MedicalRecord	—	—	✓	—	EXM-03, BR-08
Sửa MedicalRecord sau hoàn tất	Không sửa nội dung lâm sàng	—	✓ (Doctor lập hồ sơ; nêu lý do, AuditLog)	—	BR-08, SYS-01
Kê đơn thuốc	—	—	✓	Xem đơn của mình	EXM-04, BR-11
Xem lịch sử khám và đơn thuốc	Chỉ báo cáo tổng hợp, không xem chi tiết lâm sàng	Không xem chi tiết lâm sàng	✓ (bệnh nhân được phân công)	✓ (của mình)	UC-10; giới hạn dữ liệu theo vai trò
Chỉ định dịch vụ	—	—	✓	—	EXM-06
Xem/cập nhật kết quả dịch vụ	—	—	✓ (Visit được phân công)	Xem kết quả thuộc hồ sơ của mình	EXM-07, UC-08
Cập nhật trạng thái/hủy chỉ định dịch vụ	—	—	✓ (trong Visit chưa hoàn tất; hủy phải có lý do)	—	EXM-06, BR-13
Lập và phát hành hóa đơn	Giám sát báo cáo tài chính	✓	—	Xem hóa đơn của mình	BIL-01, BIL-02, UC-09
Ghi nhận thanh toán tiền mặt/chuyển khoản	Giám sát báo cáo tài chính	✓ (Invoice ISSUED)	—	—	BIL-03, UC-09
Thanh toán online	—	—	—	✓ (hóa đơn của mình)	BIL-04
Hủy hóa đơn; phê duyệt/ghi nhận hoàn tiền	✓ (Admin thực hiện và ghi lý do/AuditLog)	Tạo yêu cầu, không tự phê duyệt	—	—	BIL-06, BIL-07; Phụ lục A
Danh sách chờ	Giám sát khi cần	✓ (hỗ trợ tại quầy)	—	✓ (đăng ký/hủy chờ của mình; xác nhận/từ chối OFFERED)	UC-14, BR-19
Nhận nhắc lịch và thông báo	Giám sát hệ thống	Nhận thông báo phục vụ tiếp nhận	✓ (thông báo liên quan lịch/bệnh nhân được phân công)	✓ (thông báo của mình)	NTF-01, NTF-05
Xem báo cáo, xuất báo cáo, xem nhật ký, cấu hình tham số	✓	—	—	—	REP-01..04, SYS-01, SYS-02
3. Danh mục Use Case trong phạm vi
3.1 Danh sách Use Case
Mã	Tên Use Case (Động từ + Danh từ)	Tác nhân chính	Phạm vi thao tác	Căn cứ
UC-01 — Đăng ký, đăng nhập và quản lý hồ sơ cá nhân
UC-01.1	Đăng ký tài khoản	Patient	Đăng ký bằng email hoặc số điện thoại và mật khẩu; kiểm tra trùng thông tin định danh theo chính sách.	AUTH-01, BR-10
UC-01.2	Đăng nhập hệ thống	Patient; Admin, Receptionist, Doctor	Xác thực người dùng; kiểm tra quyền ở Backend theo vai trò.	AUTH-02, AUTH-04
UC-01.3	Đăng xuất hệ thống	Patient; Admin, Receptionist, Doctor	Kết thúc phiên xác thực.	AUTH-02
UC-01.4	Đổi mật khẩu	Patient; Admin, Receptionist, Doctor	Thay đổi mật khẩu của tài khoản đang đăng nhập.	AUTH-03
UC-01.5	Khôi phục mật khẩu	Patient; Admin, Receptionist, Doctor	Khôi phục qua email/số điện thoại đã đăng ký bằng mã hoặc liên kết dùng một lần; không gửi lại mật khẩu cũ.	AUTH-03
UC-01.6	Xem hồ sơ cá nhân	Patient	Xem họ tên, ngày sinh, giới tính, địa chỉ, thông tin liên hệ, tiền sử dị ứng.	AUTH-05
UC-01.7	Cập nhật hồ sơ cá nhân	Patient	Sửa các thông tin cá nhân phù hợp nêu ở UC-01.6.	AUTH-05
UC-01.8	Khóa/Mở khóa tài khoản	Admin	Khóa hoặc mở khóa tài khoản; không có khóa tự động do hủy nhiều lần. (Use Case con làm rõ AUTH-06, vốn chưa có Use Case tương ứng.)	AUTH-06, mục 1
UC-01.9	Phân quyền tài khoản	Admin	Gán vai trò Admin, Receptionist, Doctor, Patient. (Use Case con làm rõ AUTH-04 và vai trò Admin.)	AUTH-04, mục 2
UC-02 — Tìm bác sĩ và xem lịch trống
UC-02.1	Tìm bác sĩ	Patient	Tìm theo bác sĩ hoặc chuyên khoa; xem thông tin nghề nghiệp hiển thị.	APT-01, CAT-02
UC-02.2	Xem lịch trống	Patient	Xem TimeSlot còn chỗ (số Appointment còn hiệu lực chưa đạt capacity).	APT-01, BR-01
UC-03 — Đặt, đổi và hủy lịch khám
UC-03.1	Đặt lịch khám online	Patient	Đặt Appointment kèm lý do khám; Appointment mới ở trạng thái PENDING.	APT-01, APT-05, LN-01
UC-03.2	Đặt lịch khám tại quầy	Receptionist	Tạo Appointment cho Patient đã có hồ sơ hoặc sau khi tạo hồ sơ mới.	APT-02, LN-01
UC-03.3	Xem lịch hẹn	Patient	Xem các Appointment của mình.	APT-04
UC-03.4	Đổi lịch khám	Patient; Receptionist (hỗ trợ)	Tạo Appointment mới; Appointment cũ chuyển CANCELLED với lý do RESCHEDULED.	APT-04, BR-02, BR-21, LN-03
UC-03.5	Hủy lịch khám	Patient; Receptionist (hỗ trợ)	Chuyển Appointment PENDING/CONFIRMED sang CANCELLED; giữ lịch sử.	APT-04, BR-02, BR-06, LN-03
UC-03.6	Cấp phiếu lịch hẹn điện tử	SYSTEM	Cấp thông tin xác nhận/phiếu lịch hẹn điện tử; QR là tùy chọn giao diện.	APT-07
UC-04 — Xác nhận lịch, tiếp nhận tại quầy và check-in
UC-04.1	Xác nhận lịch hẹn	Receptionist	Chuyển Appointment PENDING → CONFIRMED.	APT-05, LN-02
UC-04.2	Check-in lịch hẹn	Receptionist	Check-in Appointment CONFIRMED, ghi thời điểm check-in, cấp số thứ tự trong ngày theo bác sĩ.	APT-05, BR-07, LN-04
UC-04.3	Ghi nhận vắng mặt (NO_SHOW)	SYSTEM	Tự động chuyển Appointment CONFIRMED không check-in sang NO_SHOW. (Use Case con làm rõ BR-05, vốn chưa có Use Case tương ứng.)	BR-05, LN-06
UC-05 — Tiếp nhận người đến trực tiếp không có lịch hẹn
UC-05.1	Tìm hồ sơ bệnh nhân	Receptionist	Tìm Patient theo thông tin hiện có trước khi tiếp nhận hoặc đặt lịch.	APT-02, APT-06
UC-05.2	Tạo hồ sơ bệnh nhân	Receptionist	Tạo hồ sơ Patient mới khi chưa có; Patient có thể chưa có User.	APT-02, APT-06, BR-10
UC-05.3	Tạo lượt khám cho người đến trực tiếp	Receptionist	Chọn Doctor tiếp nhận, tạo Visit REGISTERED không có Appointment, cấp số thứ tự theo ngày và Doctor.	APT-06, BR-07, LN-05
UC-06 — Khám bệnh và lập hồ sơ khám
UC-06.1	Xem lịch khám và hồ sơ bệnh nhân	Doctor	Xem lịch và bệnh nhân được phân công; mở hồ sơ Patient theo quyền.	EXM-01
UC-06.2	Bắt đầu lượt khám	Doctor	Visit REGISTERED → IN_PROGRESS; nếu có Appointment: CHECKED_IN → IN_PROGRESS.	EXM-02, LN-08
UC-06.3	Lập hồ sơ khám	Doctor	Tạo MedicalRecord khi bắt đầu khám; ghi triệu chứng, thông tin khám, chẩn đoán, hướng xử trí/điều trị, ghi chú, ngày tái khám nếu có.	EXM-03, BR-08
UC-06.4	Kết thúc lượt khám	Doctor	Visit IN_PROGRESS → COMPLETED; Appointment IN_PROGRESS → COMPLETED; chuyển các khoản phí hợp lệ sang quy trình lập hóa đơn.	EXM-08, LN-08
UC-06.5	Lập lịch tái khám	Doctor	Tạo Appointment mới cho cùng Patient; không sửa giờ hẹn cũ.	EXM-09
UC-06.6	Chỉnh sửa hồ sơ khám sau hoàn tất	Doctor đã lập hồ sơ	Chỉ Doctor đã lập hồ sơ được chỉnh sửa sau hoàn tất; phải nêu lý do và ghi AuditLog.	BR-08, SYS-01
UC-07 — Kê đơn thuốc
UC-07.1	Kê đơn thuốc	Doctor	Ghi Prescription/PrescriptionDetail gồm thuốc (chọn từ danh mục Medicine), liều dùng, cách dùng, số lượng, hướng dẫn cần thiết. Phòng khám không bán thuốc, không quản lý kho, không cấp phát thuốc.	EXM-04, BR-11, mục 10
UC-08 — Chỉ định dịch vụ và cập nhật kết quả
UC-08.1	Chỉ định dịch vụ	Doctor	Tạo ServiceOrder và ServiceOrderDetail (trạng thái ORDERED).	EXM-06, BR-13
UC-08.2	Cập nhật trạng thái chỉ định dịch vụ	Doctor phụ trách Visit	ORDERED → IN_PROGRESS → COMPLETED; có thể chuyển CANCELLED khi Visit chưa hoàn tất, phải nhập lý do; không xóa bản ghi.	EXM-06, BR-13
UC-08.3	Cập nhật kết quả dịch vụ	Doctor (theo quyền)	Lưu ServiceResult cho dịch vụ cần kết quả; tối đa một ServiceResult cho mỗi ServiceOrderDetail.	EXM-07
UC-08.4	Xem kết quả dịch vụ	Doctor (theo quyền)	Xem ServiceResult của chỉ định.	EXM-07, mục 2
UC-09 — Lập hóa đơn, thanh toán và hoàn tiền theo quyền
UC-09.1	Lập hóa đơn	Receptionist	Tạo Invoice và InvoiceDetail từ VisitCharge và ServiceOrderDetail đủ điều kiện; tối đa một Invoice chính cho mỗi Visit; không tính tiền thuốc.	BIL-01, BIL-02, BR-14, LN-09
UC-09.2	Phát hành hóa đơn	Receptionist	Invoice NOT_ISSUED → ISSUED sau khi Visit COMPLETED và các khoản phí đủ điều kiện đã được xác định.	BIL-05, BR-15, LN-09
UC-09.3	Ghi nhận thanh toán tại quầy	Receptionist	Ghi nhận Payment tiền mặt/chuyển khoản cho Invoice ISSUED.	BIL-03, BR-15, LN-09
UC-09.4	Thanh toán hóa đơn online	Patient	Thanh toán qua cổng sandbox; chỉ xác nhận thu sau khi xác minh kết quả từ cổng; kết quả lặp không ghi thu trùng.	BIL-04, LN-09
UC-09.5	Hủy hóa đơn	Admin	Chỉ hủy khi chưa có Payment SUCCESS hoặc sau khi toàn bộ khoản đã thu thành công được hoàn thành công; bắt buộc lý do và AuditLog.	BIL-05, BIL-07, BR-17, LN-10
UC-09.6	Hoàn tiền	Admin	Ghi Refund riêng; tổng Refund SUCCESS không vượt số tiền Payment SUCCESS còn có thể hoàn; ghi lý do và AuditLog.	BIL-06, BIL-07, BR-16, LN-10
UC-10 — Xem lịch sử khám và đơn thuốc
UC-10.1	Xem lịch sử khám và đơn thuốc	Patient (của mình); Doctor (theo quyền)	Xem các Visit, MedicalRecord và Prescription đã có.	UC-10, mục 2
UC-11 — Quản lý danh mục và hồ sơ bác sĩ
UC-11.1	Quản lý danh mục chuyên khoa	Admin	Specialty; quản lý chuyên khoa của Doctor (Doctor N—N Specialty).	CAT-01, CAT-02
UC-11.2	Quản lý danh mục phòng khám	Admin	Room.	CAT-01
UC-11.3	Quản lý danh mục dịch vụ	Admin	Service và giá hiện hành.	CAT-01, CAT-03
UC-11.4	Quản lý danh mục thuốc	Admin	Medicine: danh mục chỉ để Doctor chọn khi kê đơn; không có tồn kho, nhập/xuất, cấp phát.	CAT-01, mục 10
UC-11.5	Quản lý hồ sơ bác sĩ	Admin	Hồ sơ Doctor, chuyên khoa, thông tin nghề nghiệp hiển thị, phí khám.	CAT-02
UC-11.6	Quản lý giá dịch vụ	Admin	Cập nhật giá theo chính sách; thay đổi giá không làm thay đổi hóa đơn đã lập.	CAT-03
UC-12 — Quản lý lịch làm việc và TimeSlot
UC-12.1	Tạo lịch làm việc	Admin	Tạo WorkSchedule theo bác sĩ, ngày/ca và Room; ngăn chồng lấn cùng Doctor hoặc cùng Room.	SCH-01, SCH-03
UC-12.2	Sinh TimeSlot	Admin	Sinh TimeSlot theo thời lượng khám và sức chứa; capacity mặc định 1.	SCH-02, BR-01
UC-12.3	Khóa TimeSlot	Admin	Khóa TimeSlot; không tự xóa/hủy/chuyển Appointment đã có.	SCH-05, LN-11
UC-12.4	Thay đổi hoặc đóng lịch làm việc	Admin	Xác định Appointment bị ảnh hưởng và xử lý theo nghiệp vụ đổi/hủy; ghi người thực hiện, thời điểm, lý do.	SCH-04, LN-11
UC-14 — Quản lý danh sách chờ khi TimeSlot đã đầy
UC-14.1	Đăng ký danh sách chờ	Patient	Tạo WaitlistEntry WAITING cho TimeSlot đã đầy; mỗi Patient chỉ có một entry cho cùng một TimeSlot.	UC-14, BR-19, LN-07
UC-14.2	Gửi lời mời đặt lịch từ danh sách chờ	SYSTEM	Khi có chỗ trống, gửi OFFERED cho WaitlistEntry WAITING đứng trước theo thứ tự đăng ký.	BR-19, LN-07
UC-14.3	Phản hồi lời mời danh sách chờ	Patient	Xác nhận (tạo Appointment, WaitlistEntry → BOOKED) hoặc từ chối (DECLINED); quá hạn → EXPIRED.	BR-19, LN-07
UC-15 — Nhận nhắc lịch và phản hồi xác nhận đến khám
UC-15.1	Gửi nhắc lịch	SYSTEM	Nhắc lịch thông thường theo mốc cấu hình, mặc định 24 giờ và 2 giờ trước giờ hẹn.	NTF-01
UC-15.2	Gửi yêu cầu xác nhận đến khám	SYSTEM	Gửi trước 5 giờ; lưu AppointmentConfirmationRequest.	NTF-02, NTF-03, LN-02
UC-15.3	Phản hồi yêu cầu xác nhận đến khám	Patient	Phản hồi YES/NO; NO_RESPONSE không tự hủy.	NTF-03, NTF-04, LN-02
UC-15.4	Xem thông báo	Patient; Doctor	Xem thông báo lịch xác nhận/đổi/hủy, hồ sơ khám/đơn thuốc mới, thông báo bác sĩ; trạng thái đã đọc/chưa đọc.	NTF-05
UC-16 — Xem báo cáo thống kê và nhật ký thao tác
UC-16.1	Xem báo cáo thống kê	Admin	Báo cáo lượt khám, doanh thu (phí khám, phí dịch vụ; thực thu; hoàn tiền), tỷ lệ hủy/NO_SHOW, thuốc được kê đơn nhiều nhất.	REP-01..03
UC-16.2	Xuất báo cáo	Admin	Xuất CSV/PDF nếu cần cho đồ án; không phát sinh thực thể nghiệp vụ riêng.	REP-04
UC-16.3	Xem nhật ký thao tác	Admin	Xem AuditLog các thao tác nhạy cảm.	SYS-01
UC-16.4	Cấu hình tham số nghiệp vụ	Admin	Thời lượng khám, sức chứa, hạn đổi/hủy, thời gian nhắc lịch, thời gian chờ trước NO_SHOW.	SYS-02


3.2 Đặc tả tóm tắt từng nhóm Use Case
UC-01 — Đăng ký, đăng nhập và quản lý hồ sơ cá nhân
Mục đích	Cho phép Patient tạo tài khoản, đăng nhập, quản lý thông tin cá nhân; Admin phân quyền và khóa/mở khóa tài khoản.
Tác nhân	Patient; Admin (UC-01.8, UC-01.9). Các vai trò nội bộ đăng nhập theo UC-01.2.
Tiền điều kiện	Đăng ký: thông tin định danh chưa trùng theo chính sách. Các thao tác còn lại: người dùng đã đăng nhập và có vai trò phù hợp (AUTH-02, AUTH-04).
Luồng chính (tóm tắt)	1. Patient đăng ký bằng email hoặc số điện thoại và mật khẩu; hệ thống kiểm tra trùng thông tin định danh.
2. Đăng nhập; phiên xác thực được bảo vệ; mọi thao tác kiểm tra quyền ở Backend.
3. Patient xem/sửa thông tin cá nhân; đổi hoặc khôi phục mật khẩu.
4. Admin phân quyền, khóa/mở khóa tài khoản.
Luồng thay thế / ngoại lệ	- Thông tin định danh bị trùng: không tạo tài khoản; email và số điện thoại được chuẩn hóa trước khi so trùng; mỗi thông tin nếu được cung cấp phải duy nhất; cần có ít nhất email hoặc số điện thoại.
- Hồ sơ Patient đã tồn tại trước tài khoản: chỉ liên kết sau khi xác minh; một User liên kết tối đa một Patient (AUTH-06, BR-10).
- Không có quyền: Backend từ chối (AUTH-04); Backend trả mã lỗi và thông báo ngắn gọn, không tiết lộ dữ liệu nhạy cảm.
- Cơ chế khôi phục mật khẩu chi tiết và Admin khóa/mở khóa thủ công; khóa tài khoản không xóa dữ liệu và thao tác được ghi AuditLog.
Kết quả sau khi thực hiện	Tài khoản User được tạo/liên kết; thông tin cá nhân được cập nhật; trạng thái tài khoản thay đổi khi Admin khóa/mở khóa.

UC-02 — Tìm bác sĩ và xem lịch trống
Mục đích	Giúp Patient chọn TimeSlot còn chỗ trước khi đặt lịch.
Tác nhân	Patient.
Tiền điều kiện	Đã có WorkSchedule và TimeSlot do Admin tạo (UC-12).
Luồng chính (tóm tắt)	1. Patient tìm theo bác sĩ hoặc chuyên khoa.
2. Hệ thống hiển thị thông tin nghề nghiệp hiển thị của Doctor và các TimeSlot còn chỗ.
Luồng thay thế / ngoại lệ	- Không có TimeSlot còn chỗ: Patient có thể dùng danh sách chờ (UC-14).
- TimeSlot bị khóa hoặc đã qua giờ khám không còn hợp lệ để đặt (SCH-05, BR-04).
- cho phép lọc theo bác sĩ, chuyên khoa, ngày và TimeSlot còn chỗ; mặc định sắp xếp thời gian tăng dần.
Kết quả sau khi thực hiện	Patient chọn được TimeSlot để đặt lịch (UC-03.1).

UC-03 — Đặt, đổi và hủy lịch khám
Mục đích	Đặt, xem, đổi, hủy Appointment; cấp phiếu lịch hẹn điện tử.
Tác nhân	Patient (online); Receptionist (đặt tại quầy, hỗ trợ đổi/hủy); SYSTEM (cấp phiếu).
Tiền điều kiện	Đặt lịch: TimeSlot còn chỗ và còn hợp lệ; Patient có hồ sơ (Receptionist có thể tạo mới). Đổi/hủy: Appointment ở PENDING hoặc CONFIRMED; Patient tự đổi/hủy online khi còn ít nhất 2 giờ trước scheduled_time (BR-02, BR-06).
Luồng chính (tóm tắt)	Xem LN-01 (đặt lịch) và LN-03 (đổi/hủy lịch).
Tóm tắt: kiểm tra slot và capacity → tạo Appointment PENDING; hủy → CANCELLED; đổi lịch → tạo Appointment mới và hủy lịch cũ với lý do RESCHEDULED.
Luồng thay thế / ngoại lệ	- Slot đầy, slot không hợp lệ, đặt đồng thời, đặt trùng lịch, đổi/hủy dưới 2 giờ: xem LN-01, LN-03.
- Không đặt giúp người thân/hồ sơ phụ thuộc (mục 1).
Kết quả sau khi thực hiện	Appointment PENDING mới; hoặc Appointment CANCELLED (giữ lịch sử); hoặc cặp Appointment mới và Appointment cũ CANCELLED (RESCHEDULED) truy vết được. Mọi chuyển trạng thái được ghi AppointmentStatusHistory.

UC-04 — Xác nhận lịch, tiếp nhận tại quầy và check-in
Mục đích	Receptionist xác nhận lịch và check-in; hệ thống ghi nhận vắng mặt.
Tác nhân	Receptionist; SYSTEM (UC-04.3).
Tiền điều kiện	Xác nhận: Appointment PENDING. Check-in: Appointment CONFIRMED (APT-05).
Luồng chính (tóm tắt)	Xem LN-02 (xác nhận), LN-04 (check-in), LN-06 (NO_SHOW).
Tóm tắt: PENDING → CONFIRMED; CONFIRMED → CHECKED_IN kèm check_in_at và số thứ tự; CONFIRMED không check-in sau 30 phút → NO_SHOW.
Luồng thay thế / ngoại lệ	- Appointment PENDING không được check-in, kể cả khi đã quá giờ; không được mở lại để booking online (APT-05).
- Appointment CANCELLED/NO_SHOW không tạo Visit khám đã thực hiện (BR-07).
- giữ PENDING để bảo toàn lịch sử; không check-in, không chuyển NO_SHOW và không mở lại để đặt online. Slot đã qua giờ không còn được đặt.
Kết quả sau khi thực hiện	Appointment CONFIRMED, CHECKED_IN (có check_in_at và số thứ tự) hoặc NO_SHOW; AppointmentStatusHistory ghi tác nhân thực hiện (SYSTEM với tác vụ tự động).

UC-05 — Tiếp nhận người đến trực tiếp không có lịch hẹn
Mục đích	Tiếp nhận bệnh nhân đến khám không đặt lịch.
Tác nhân	Receptionist.
Tiền điều kiện	Người bệnh đến trực tiếp; đã chọn được Doctor tiếp nhận.
Luồng chính (tóm tắt)	Xem LN-05.
Tóm tắt: tìm Patient (chưa có thì tạo) → chọn Doctor → tạo Visit REGISTERED → cấp số thứ tự theo ngày và Doctor.
Luồng thay thế / ngoại lệ	- Không tạo Appointment giả cho Walk-in (APT-06).
- Số thứ tự phải duy nhất theo ngày và Doctor, không trùng khi tiếp nhận đồng thời (APT-06, BR-07).
- chỉ Receptionist được hủy Visit REGISTERED tạo nhầm/chưa bắt đầu, phải nhập lý do; Visit đã IN_PROGRESS hoặc COMPLETED không được hủy theo luồng thông thường.
Kết quả sau khi thực hiện	Visit REGISTERED không có Appointment, có số thứ tự.

UC-06 — Khám bệnh và lập hồ sơ khám
Mục đích	Doctor khám, lập MedicalRecord và kết thúc lượt khám.
Tác nhân khởi tạo	Doctor; UC-06.5: Doctor lập lịch tái khám; UC-06.6: Doctor đã lập hồ sơ được chỉnh sửa sau hoàn tất, kèm lý do và AuditLog.
Tiền điều kiện	Visit ở REGISTERED; nếu gắn Appointment thì Appointment ở CHECKED_IN (EXM-02).
Luồng chính (tóm tắt)	Xem LN-08.
Tóm tắt: bắt đầu khám → tạo MedicalRecord → ghi nội dung khám → kê đơn/chỉ định dịch vụ nếu cần → kết thúc khám → chuyển khoản phí hợp lệ sang lập hóa đơn.
Luồng thay thế / ngoại lệ	- Visit không ở REGISTERED thì không bắt đầu khám (EXM-02).
- Sửa MedicalRecord sau hoàn tất cần quyền và AuditLog (BR-08).
- Visit vẫn có thể COMPLETED; dịch vụ chưa COMPLETED không được đưa vào hóa đơn và tiếp tục theo dõi ở ServiceOrderDetail.
Kết quả sau khi thực hiện	Visit COMPLETED; Appointment COMPLETED (nếu có); MedicalRecord hoàn chỉnh; mốc started_at, completed_at được ghi (BR-09).

UC-07 — Kê đơn thuốc
Mục đích	Ghi đơn thuốc của bác sĩ cho lượt khám.
Tác nhân	Doctor.
Tiền điều kiện	MedicalRecord của Visit đã được tạo (Prescription thuộc MedicalRecord).
Luồng chính (tóm tắt)	1. Doctor chọn thuốc từ danh mục Medicine.
2. Nhập liều dùng, cách dùng, số lượng, hướng dẫn cần thiết.
3. Hệ thống lưu Prescription và PrescriptionDetail.
Luồng thay thế / ngoại lệ	- Doctor được chỉnh sửa đơn trong khi Visit IN_PROGRESS; sau khi Visit COMPLETED, đơn đã chốt không được sửa/xóa trực tiếp. Nếu cần đính chính, tạo ghi nhận bổ sung có lý do và AuditLog; không kê đơn mới trên Visit đã hoàn tất.
- Ngoài phạm vi: bán thuốc, tồn kho, nhập/xuất, cấp phát, lô thuốc, cảnh báo hạn dùng; tiền thuốc không đưa vào hóa đơn (mục 10, BR-14).
Kết quả sau khi thực hiện	Đơn thuốc được lưu trong hồ sơ khám; Patient xem được trong lịch sử khám/đơn thuốc (UC-10).

UC-08 — Chỉ định dịch vụ và cập nhật kết quả
Mục đích	Doctor chỉ định dịch vụ; theo dõi trạng thái và lưu kết quả.
Tác nhân	Doctor; Doctor phụ trách Visit cập nhật trạng thái ServiceOrderDetail và hủy khi Visit chưa COMPLETED, kèm lý do.
Tiền điều kiện	MedicalRecord của Visit đã được tạo (ServiceOrder thuộc MedicalRecord).
Luồng chính (tóm tắt)	Xem LN-08.
Tóm tắt: tạo ServiceOrder/ServiceOrderDetail (ORDERED) → IN_PROGRESS → COMPLETED; lưu ServiceResult nếu dịch vụ cần kết quả.
Luồng thay thế / ngoại lệ	- Doctor phụ trách Visit được hủy ServiceOrderDetail khi Visit chưa COMPLETED, phải nhập lý do; không xóa bản ghi.
- Mỗi ServiceOrderDetail có tối đa một ServiceResult; trạng thái thực hiện và kết quả là hai thông tin khác nhau (EXM-07).
Kết quả sau khi thực hiện	ServiceOrderDetail ở trạng thái tương ứng; chỉ ServiceOrderDetail COMPLETED mặc định đủ điều kiện đưa vào hóa đơn.

UC-09 — Lập hóa đơn, thanh toán và hoàn tiền theo quyền
Mục đích	Lập hóa đơn từ khoản phí hợp lệ, ghi nhận thanh toán và hoàn tiền.
Tác nhân	Receptionist; Patient (thanh toán online); Admin thực hiện hủy hóa đơn/hoàn tiền; Receptionist chỉ lập hóa đơn và ghi nhận thanh toán tại quầy.
Tiền điều kiện	Visit có khoản phí hợp lệ (VisitCharge hoặc ServiceOrderDetail COMPLETED); Visit chưa có Invoice chính; chỉ Invoice ISSUED mới được ghi nhận Payment.
Luồng chính (tóm tắt)	Xem LN-09 (lập hóa đơn, thanh toán) và LN-10 (hủy hóa đơn, hoàn tiền).
Tóm tắt: tạo Invoice → phát hành → ghi nhận Payment → tính trạng thái thanh toán; hoàn tiền bằng Refund riêng.
Luồng thay thế / ngoại lệ	- Invoice NOT_ISSUED/CANCELLED không được tạo Payment; Payment PENDING/FAILED không tính là đã thu; kết quả cổng thanh toán lặp không ghi thu trùng.
- Tổng Refund thành công không vượt số tiền đã thanh toán thành công còn có thể hoàn (BR-16).
- Không có quyền: Backend từ chối (AUTH-04).
Kết quả sau khi thực hiện	Invoice/Payment/Refund được ghi nhận, không xóa lịch sử; hủy hóa đơn và hoàn tiền có AuditLog.

UC-10 — Xem lịch sử khám và đơn thuốc
Mục đích	Xem các lượt khám, hồ sơ khám và đơn thuốc đã có.
Tác nhân	Patient; Doctor.
Tiền điều kiện	Người dùng đã đăng nhập; Doctor xem theo quyền.
Luồng chính (tóm tắt)	1. Người dùng chọn xem lịch sử khám.
2. Hệ thống hiển thị Visit, MedicalRecord, Prescription trong phạm vi được phép.
Luồng thay thế / ngoại lệ	- Patient chỉ xem hồ sơ khám/đơn thuốc/kết quả của chính mình; Doctor chỉ xem bệnh nhân được phân công; Receptionist không xem nội dung lâm sàng; Admin chỉ xem báo cáo tổng hợp.
- Không có quyền: Backend từ chối.
Kết quả sau khi thực hiện	Người dùng xem được lịch sử trong phạm vi quyền; không thay đổi dữ liệu.

UC-11 — Quản lý danh mục và hồ sơ bác sĩ
Mục đích	Duy trì dữ liệu danh mục và hồ sơ Doctor làm cơ sở đặt lịch, khám và thu phí.
Tác nhân	Admin.
Tiền điều kiện	Admin đã đăng nhập.
Luồng chính (tóm tắt)	1. Admin tạo/xem/cập nhật Specialty, Room, Service, Medicine, hồ sơ Doctor, giá dịch vụ.
2. Hệ thống lưu thay đổi; thay đổi giá không làm đổi hóa đơn đã lập.
Luồng thay thế / ngoại lệ	- Admin được ngừng hoạt động danh mục khi không còn được dùng để tạo giao dịch mới; không xóa cứng nếu đã được tham chiếu.
- Medicine chỉ là danh mục để kê đơn.
Kết quả sau khi thực hiện	Danh mục/hồ sơ Doctor được cập nhật.

UC-12 — Quản lý lịch làm việc và TimeSlot
Mục đích	Thiết lập lịch làm việc, sinh TimeSlot, khóa TimeSlot và xử lý khi thay đổi/đóng lịch.
Tác nhân	Admin.
Tiền điều kiện	Có hồ sơ Doctor và Room.
Luồng chính (tóm tắt)	Xem LN-11.
Tóm tắt: tạo WorkSchedule không chồng lấn → sinh TimeSlot → khóa TimeSlot khi cần → xử lý Appointment bị ảnh hưởng khi thay đổi/đóng lịch.
Luồng thay thế / ngoại lệ	- Lịch chồng lấn cùng Doctor hoặc cùng Room bị ngăn (SCH-03).
- Không xóa âm thầm Appointment; khóa slot không tự hủy hoặc tự chuyển Appointment (SCH-04, SCH-05).
Kết quả sau khi thực hiện	WorkSchedule và TimeSlot được tạo/khóa/đóng; mọi thay đổi ảnh hưởng Appointment có ghi người thực hiện, thời điểm, lý do.

UC-14 — Quản lý danh sách chờ khi TimeSlot đã đầy
Mục đích	Cho Patient chờ chỗ trống của TimeSlot đã đầy mà không tạo Appointment khi chưa xác nhận.
Tác nhân	Patient; SYSTEM; Receptionist (hỗ trợ Patient tại quầy; chỉ SYSTEM gửi lời mời và tự xử lý hết hạn).
Tiền điều kiện	TimeSlot đã đầy; có WaitlistEntry WAITING.
Luồng chính (tóm tắt)	Xem LN-07.
Tóm tắt: đăng ký chờ (WAITING) → khi có chỗ, gửi OFFERED cho người đứng trước → Patient xác nhận trong thời hạn và slot còn hợp lệ → tạo Appointment, WaitlistEntry BOOKED.
Luồng thay thế / ngoại lệ	- Từ chối → DECLINED; hết thời hạn → EXPIRED; tiếp tục người kế tiếp.
- Không tự tạo Appointment khi chưa xác nhận; không đẩy lịch của Patient đang có Appointment (BR-19).
Kết quả sau khi thực hiện	WaitlistEntry ở trạng thái cuối tương ứng; Appointment mới chỉ có khi BOOKED.

UC-15 — Nhận nhắc lịch và phản hồi xác nhận đến khám
Mục đích	Nhắc lịch và thu phản hồi có đến khám của Patient.
Tác nhân	Patient; SYSTEM.
Tiền điều kiện	Appointment còn hiệu lực trước giờ hẹn; Patient chưa có User vẫn nhận qua kênh liên lạc phù hợp (NTF-05, BR-10).
Luồng chính (tóm tắt)	Xem LN-02.
Tóm tắt: nhắc lịch (mặc định 24 giờ, 2 giờ) → yêu cầu xác nhận trước 5 giờ → Patient phản hồi YES/NO/NO_RESPONSE.
Luồng thay thế / ngoại lệ	- NO: yêu cầu xác nhận hủy, chỉ hủy online nếu còn ít nhất 2 giờ.
- NO_RESPONSE: không tự hủy.
- Thông báo gửi lặp không tạo hai lần chuyển trạng thái (mục 12).
Kết quả sau khi thực hiện	AppointmentConfirmationRequest lưu thời điểm gửi, kênh, phản hồi, thời điểm phản hồi, trạng thái xử lý; Notification có trạng thái đọc.

UC-16 — Xem báo cáo thống kê và nhật ký thao tác
Mục đích	Giám sát hoạt động phòng khám qua báo cáo, nhật ký và cấu hình.
Tác nhân	Admin.
Tiền điều kiện	Admin đã đăng nhập.
Luồng chính (tóm tắt)	1. Admin chọn báo cáo lượt khám, doanh thu, tỷ lệ hủy/NO_SHOW, thuốc được kê nhiều nhất; hoặc nhật ký AuditLog.
2. Hệ thống hiển thị; Admin có thể xuất CSV/PDF nếu cần.
3. Admin cấu hình tham số nghiệp vụ (SYS-02).
Luồng thay thế / ngoại lệ	- Doanh thu phân biệt tổng phí ghi nhận trên Invoice, tiền thực thu từ Payment SUCCESS, tiền hoàn từ Refund SUCCESS; Payment PENDING/FAILED không tính là đã thu (REP-02).

Kết quả sau khi thực hiện	Báo cáo/nhật ký được hiển thị hoặc xuất; tham số cấu hình được cập nhật.

3.3 Phạm vi thao tác tạo, xem, cập nhật, xóa theo nhóm dữ liệu
Dữ liệu	Tạo	Xem	Cập nhật	Xóa / ngừng sử dụng	Căn cứ
User (tài khoản)	Patient tự đăng ký; Admin tạo tài khoản nội bộ	Người dùng xem tài khoản của mình; Admin quản lý tài khoản	Người dùng đổi/khôi phục mật khẩu; Admin cập nhật vai trò, khóa/mở khóa	Không xóa cứng nếu có lịch sử; Admin khóa tài khoản	AUTH-01..06
Patient (hồ sơ)	Receptionist tạo khi chưa có; có thể tồn tại chưa có User	Patient xem hồ sơ mình; Doctor xem Patient được phân công; Receptionist xem dữ liệu hành chính cần tiếp nhận	Patient sửa hồ sơ mình; Receptionist cập nhật hành chính/liên hệ theo yêu cầu; Doctor không sửa thông tin hành chính	Không xóa cứng nếu có lịch sử y tế/lịch hẹn	AUTH-05, APT-02, APT-06
Specialty, Room, Service, Medicine	Admin	Admin; Doctor xem danh mục cần dùng; Receptionist xem thông tin phục vụ công việc; Patient xem thông tin công khai liên quan	Admin	Admin ngừng hoạt động khi không còn dùng; không xóa cứng nếu đã được tham chiếu. Medicine chỉ phục vụ kê đơn	CAT-01
Doctor (hồ sơ, phí khám)	Admin	Admin; Doctor xem hồ sơ mình; Patient xem thông tin công khai; Receptionist xem thông tin phục vụ lịch	Admin	Ngừng hoạt động khi không còn nhận lịch; giữ lịch sử Appointment/Visit	CAT-02
Giá dịch vụ	Admin	Admin; Receptionist; Doctor; Patient xem giá hiện hành được phép công khai	Admin; không thay đổi ngược giá đã lưu trên InvoiceDetail	Không xóa giá đã được giao dịch tham chiếu; dùng giá hiện hành mới	CAT-03
WorkSchedule / TimeSlot	Admin sinh từ WorkSchedule	Admin; Receptionist; Doctor xem lịch được phân công; Patient xem slot còn chỗ	Admin khóa/điều chỉnh; khi ảnh hưởng lịch hẹn phải xử lý từng Appointment và thông báo	Không xóa lịch hẹn âm thầm; slot quá giờ/đã khóa không nhận booking mới	SCH-01..05
Appointment	Patient; Receptionist; Doctor lập tái khám; hệ thống tạo sau khi Patient nhận lời mời danh sách chờ	Patient xem lịch của mình; Receptionist xem phục vụ tiếp nhận; Doctor xem lịch được phân công; Admin xem phục vụ quản trị	Chỉ chuyển trạng thái theo BR-06; không sửa scheduled_time. Đổi lịch tạo Appointment mới	Hủy = CANCELLED, không xóa; đổi lịch giữ Appointment cũ và liên kết lịch mới	APT-01..08, BR-06, BR-21
Visit	Receptionist tạo khi walk-in hoặc check-in Appointment CONFIRMED	Doctor phụ trách; Receptionist xem phục vụ tiếp nhận; Patient xem lịch sử của mình	Doctor cập nhật trạng thái khám; Receptionist chỉ hủy Visit REGISTERED tạo nhầm/chưa bắt đầu, có lý do	Không xóa cứng; Visit IN_PROGRESS/COMPLETED không hủy theo luồng thông thường	APT-06, EXM-02, EXM-08
MedicalRecord	Doctor khi bắt đầu khám	Doctor phụ trách; Patient xem hồ sơ của mình	Doctor; sau hoàn tất chỉ Doctor đã lập hồ sơ được sửa có lý do và AuditLog	Không xóa cứng dữ liệu y tế	EXM-03, BR-08, SYS-01
Prescription / PrescriptionDetail	Doctor trong Visit IN_PROGRESS	Doctor phụ trách; Patient xem đơn thuốc của mình	Doctor được chỉnh sửa khi Visit IN_PROGRESS; sau Visit COMPLETED chỉ ghi đính chính có lý do/AuditLog	Không xóa cứng; không sửa trực tiếp đơn đã chốt sau hoàn tất	EXM-04, BR-11
ServiceOrder / ServiceOrderDetail	Doctor	Doctor phụ trách Visit; Receptionist xem khoản đủ điều kiện thu phí; Patient xem dịch vụ của mình	Doctor cập nhật trạng thái; hủy khi Visit chưa COMPLETED và ghi lý do	Không xóa cứng; CANCELLED không tự động tính phí	EXM-06, BR-13
ServiceResult	Doctor khi dịch vụ cần kết quả	Doctor phụ trách; Patient xem kết quả thuộc hồ sơ mình	Doctor phụ trách theo quyền; mọi chỉnh sửa sau hoàn tất có AuditLog	Không xóa cứng nếu đã được ghi nhận; đính chính có truy vết	EXM-07
Invoice / InvoiceDetail	Receptionist tạo từ khoản phí hợp lệ; tối đa một Invoice chính mỗi Visit	Patient xem hóa đơn của mình; Receptionist xem để thu phí; Admin xem để quản trị tài chính	Receptionist phát hành; nội dung sau phát hành không sửa trực tiếp; điều chỉnh qua quy trình được ghi vết	Admin hủy có lý do/AuditLog; nếu đã thu tiền thì phải hoàn đủ trước; không xóa cứng	BIL-01, BIL-02, BIL-07
Payment	Receptionist ghi tiền mặt/chuyển khoản; Patient tạo thanh toán online qua cổng sandbox	Patient xem thanh toán của mình; Receptionist/Admin xem phục vụ thu và đối soát	Trạng thái PENDING/SUCCESS/FAILED theo xác minh; không chỉnh tay SUCCESS của cổng online khi chưa đối soát	Không xóa Payment gốc; mỗi lần thử là một Payment riêng	BIL-03, BIL-04, BR-15
Refund	Admin tạo/ghi nhận theo yêu cầu hợp lệ	Admin; Patient xem hoàn tiền của mình; Receptionist xem trạng thái cần hỗ trợ	PENDING/SUCCESS/FAILED; chỉ SUCCESS tính là tiền hoàn	Không xóa Refund; tổng hoàn SUCCESS không vượt tiền đã thu SUCCESS còn có thể hoàn	BIL-06, BR-16
WaitlistEntry	Patient đăng ký cho chính mình; Receptionist hỗ trợ tại quầy	Patient xem entry của mình; Receptionist xem để hỗ trợ; SYSTEM xử lý theo thứ tự	WAITING → OFFERED → BOOKED/DECLINED/EXPIRED; Patient xác nhận mới tạo Appointment	Patient có thể hủy khi WAITING/OFFERED; không xóa cứng; mỗi Patient một entry mỗi TimeSlot	UC-14, BR-19
AppointmentConfirmationRequest	SYSTEM	Patient xem/phản hồi yêu cầu của mình; Receptionist xem phục vụ hỗ trợ; Admin xem khi kiểm tra hệ thống	SYSTEM ghi gửi; Patient phản hồi YES/NO/NO_RESPONSE; lưu thời điểm và trạng thái xử lý	Không xóa lịch sử yêu cầu/phản hồi	NTF-02..04
Notification	SYSTEM	Patient/Doctor xem thông báo thuộc mình; Receptionist xem thông báo phục vụ công việc	Cập nhật trạng thái đã đọc/chưa đọc	Không xóa lịch sử thông báo nghiệp vụ quan trọng	NTF-05
AppointmentStatusHistory, AuditLog	Tạo tự động khi đổi trạng thái/thao tác nhạy cảm; SYSTEM là tác nhân cho tác vụ tự động	Admin xem nhật ký; người dùng chỉ xem trạng thái/lịch sử được phép	Không sửa trực tiếp lịch sử; AuditLog append-only	Không xóa cứng	APT-08, SYS-01, BR-20
SystemConfig	Admin khai báo/cập nhật các tham số nghiệp vụ cần thiết.	Admin.	Admin cập nhật giá trị tham số; thay đổi phải được ghi nhận theo chính sách AuditLog.	Không xóa tham số đang được hệ thống sử dụng; chỉ ngừng sử dụng sau khi không còn phụ thuộc.	SYS-02; các khóa cấu hình đã chốt
					

Ghi chú: “quản lý” gồm tạo/xem/cập nhật. Dữ liệu có lịch sử y tế, tài chính hoặc lịch hẹn không bị xóa cứng; danh mục không còn sử dụng được chuyển sang ngừng hoạt động nếu đã được tham chiếu. Các thay đổi nhạy cảm phải ghi AuditLog.
3.4 Mô tả luồng nghiệp vụ bằng văn bản
Các luồng dưới đây mô tả bằng văn bản nghiệp vụ đã chốt, gồm tác nhân, điều kiện, luồng chính, ngoại lệ, trạng thái và kết quả. Appointment được tính vào capacity khi ở một trong các trạng thái PENDING, CONFIRMED, CHECKED_IN, IN_PROGRESS hoặc COMPLETED; CANCELLED và NO_SHOW không chiếm capacity. Slot đã qua giờ khám không được mở lại cho đặt lịch online.
LN-01 — Đặt lịch khám (UC-03.1, UC-03.2)
Tác nhân khởi tạo	Patient (đặt online trên Mobile) hoặc Receptionist (đặt tại quầy).
Điều kiện bắt đầu	- Có TimeSlot còn chỗ, chưa bị khóa, chưa qua giờ khám (BR-01, BR-04, SCH-05).
- Patient đã có hồ sơ; Receptionist có thể tạo hồ sơ Patient mới (APT-02).
Luồng chính	1. Người đặt tìm bác sĩ/chuyên khoa và xem TimeSlot còn chỗ (APT-01); Receptionist tìm hoặc tạo hồ sơ Patient rồi chọn TimeSlot (APT-02).
2. Nhập lý do khám (APT-01).
3. Hệ thống kiểm tra Patient không đặt trùng lịch không hợp lệ và số Appointment còn hiệu lực trong TimeSlot chưa vượt capacity (mặc định 1); việc kiểm tra bảo đảm ở Backend/CSDL trong giao dịch đồng thời (APT-03, BR-01).
4. Hệ thống tạo Appointment ở trạng thái PENDING (APT-05).
5. Hệ thống cấp thông tin xác nhận/phiếu lịch hẹn điện tử (APT-07).
6. Appointment chờ Receptionist xác nhận (LN-02).
Rẽ nhánh và ngoại lệ	Rẽ nhánh và ngoại lệ
Trạng thái trước → sau	Appointment: (chưa có) → PENDING.
Kết quả và ghi nhận	Appointment PENDING gắn Patient và TimeSlot; scheduled_time là giờ hẹn ban đầu (BR-09). hệ thống gửi thông báo xác nhận đã tiếp nhận yêu cầu đặt lịch và trạng thái PENDING qua kênh liên hệ đã đăng ký.

LN-02 — Xác nhận lịch, nhắc lịch và xác nhận đến khám (UC-04.1, UC-15)
Tác nhân khởi tạo	Receptionist (xác nhận lịch); SYSTEM (nhắc lịch, gửi yêu cầu xác nhận đến khám); Patient (phản hồi).
Điều kiện bắt đầu	- Xác nhận lịch: Appointment ở PENDING (APT-05).
- Yêu cầu xác nhận đến khám: gửi trước giờ hẹn 5 giờ (NTF-02); chỉ gửi nếu Appointment vẫn CONFIRMED và chưa qua giờ hẹn (YES giữ Appointment ở CONFIRMED).
Luồng chính	1. Receptionist xác nhận Appointment PENDING → CONFIRMED; ghi AppointmentStatusHistory (người thực hiện, thời điểm); Patient nhận thông báo lịch được xác nhận (APT-05, APT-08, NTF-05).
2. SYSTEM gửi nhắc lịch thông thường theo mốc cấu hình, mặc định 24 giờ và 2 giờ trước giờ hẹn (NTF-01).
3. SYSTEM gửi yêu cầu xác nhận có đến khám trước 5 giờ — thông báo riêng, không thay thế nhắc lịch; lưu AppointmentConfirmationRequest (Appointment, thời điểm gửi, kênh, phản hồi, thời điểm phản hồi, trạng thái xử lý) (NTF-02, NTF-03, BR-18).
4. Patient phản hồi YES, NO hoặc không phản hồi (NO_RESPONSE). Patient chưa có User vẫn nhận qua kênh liên lạc phù hợp theo thông tin liên hệ (NTF-05, BR-10).
Rẽ nhánh và ngoại lệ	- YES: Appointment giữ ở CONFIRMED (NTF-04).
- NO: hệ thống yêu cầu Patient xác nhận hủy. Nếu còn ít nhất 2 giờ trước giờ hẹn → hủy online theo LN-03. Nếu dưới 2 giờ → không hủy online; Patient liên hệ Receptionist theo BR-02 (NTF-04, BR-18).
- NO_RESPONSE: không tự hủy (NTF-04, BR-18); nếu Appointment CONFIRMED vẫn không check-in thì xử lý theo LN-06.
- Appointment không được Receptionist xác nhận (còn PENDING): không được check-in; nếu đã quá giờ thì không được check-in và không được mở lại để booking online (APT-05, BR-06). không tự hủy hoặc tự chuyển trạng thái; giữ PENDING trong lịch sử, không cho check-in và không cho đặt lại slot đã qua giờ.
- Thông báo/phản hồi lặp được xử lý idempotent, không tạo chuyển trạng thái hoặc ghi nhận thanh toán trùng.
- Không có quyền xác nhận lịch: Backend từ chối (AUTH-04).
Trạng thái trước → sau	Appointment: PENDING → CONFIRMED (bước 1); CONFIRMED giữ nguyên (YES, NO_RESPONSE) hoặc → CANCELLED (NO hợp lệ, qua LN-03).
Kết quả và ghi nhận	AppointmentStatusHistory ghi mọi chuyển trạng thái; AppointmentConfirmationRequest lưu từng lần gửi và phản hồi.

LN-03 — Đổi lịch và hủy lịch (UC-03.4, UC-03.5)
Tác nhân khởi tạo	Patient (tự đổi/hủy online) hoặc Receptionist (hỗ trợ).
Điều kiện bắt đầu	- Appointment ở PENDING hoặc CONFIRMED (BR-06).
- Patient tự thao tác online: còn ít nhất 2 giờ trước scheduled_time (BR-02).
Luồng chính	A. Hủy lịch
1. Người dùng chọn Appointment cần hủy; hệ thống kiểm tra thời hạn (BR-02).
2. Appointment chuyển CANCELLED, ghi lý do và AppointmentStatusHistory; không xóa Appointment (APT-04, BR-20).
3. Nếu hủy hợp lệ trước giờ hẹn và TimeSlot không bị khóa, còn hợp lệ để đặt thì sức chứa có thể được giải phóng (BR-04).
4. Patient nhận thông báo lịch bị hủy (NTF-05).
B. Đổi lịch
1. Người dùng chọn Appointment cần đổi và TimeSlot mới.
2. Hệ thống kiểm tra TimeSlot mới còn hợp lệ (còn chỗ theo BR-01, không bị khóa, chưa qua giờ) (BR-21).
3. Tạo Appointment mới.
4. Appointment cũ chuyển CANCELLED với lý do RESCHEDULED; giữ lịch sử và truy vết được quan hệ lịch cũ — lịch mới; không sửa Appointment cũ thành lịch mới (APT-04, BR-21, BR-09).
5. Patient nhận thông báo lịch được đổi (NTF-05).
Rẽ nhánh và ngoại lệ	- Còn dưới 2 giờ: Patient không tự đổi/hủy online mà phải liên hệ Receptionist; thao tác của Receptionist phải ghi người thực hiện và lý do (BR-02). không áp dụng hạn 2 giờ cho Receptionist; Receptionist có thể hỗ trợ đổi/hủy theo yêu cầu và phải ghi người thực hiện, lý do.
- TimeSlot mới không còn hợp lệ: không thực hiện đổi lịch (bước kiểm tra của BR-21); Appointment cũ không bị hủy.
- Appointment đã CHECKED_IN trở đi: không thuộc chuyển trạng thái hủy hợp lệ (BR-06).
- Hủy hoặc đổi không tự đẩy bệnh nhân khác lên và không đổi scheduled_time của họ (BR-03). Khi có chỗ trống, SYSTEM gửi OFFERED theo FIFO; Patient xác nhận trong thời hạn cấu hình mới tạo Appointment.
- Không phạt, không khóa tài khoản, không giới hạn số lần hủy (mục 1, mục 10); không đặt giới hạn số lần đổi lịch; mỗi lần đổi phải tạo Appointment mới và lưu lịch sử.
- bắt buộc thực hiện tạo Appointment mới và hủy Appointment cũ trong cùng một giao dịch; nếu tạo lịch mới thất bại thì lịch cũ vẫn còn hiệu lực.
- Người dùng không có quyền: Backend từ chối (AUTH-04).
Trạng thái trước → sau	Hủy: PENDING/CONFIRMED → CANCELLED.
Đổi lịch: Appointment cũ → CANCELLED (RESCHEDULED); Appointment mới: (chưa có) → PENDING (áp dụng APT-05).
Kết quả và ghi nhận	AppointmentStatusHistory ghi tác nhân, thời điểm, lý do; Appointment mới tham chiếu Appointment cũ để truy vết.

LN-04 — Tiếp nhận và check-in lịch hẹn (UC-04.2)
Tác nhân khởi tạo	Receptionist.
Điều kiện bắt đầu	Appointment ở CONFIRMED (APT-05, BR-06).
Luồng chính	1. Receptionist tìm Appointment của bệnh nhân đến khám.
2. Hệ thống kiểm tra Appointment ở CONFIRMED.
3. Ghi thời điểm check-in (check_in_at) (APT-05, BR-09).
4. Cấp số thứ tự trong ngày theo bác sĩ; số phải duy nhất theo ngày và Doctor, không trùng khi tiếp nhận đồng thời (APT-05, BR-07).
5. Appointment chuyển CONFIRMED → CHECKED_IN; ghi AppointmentStatusHistory.
Rẽ nhánh và ngoại lệ	- Appointment PENDING: không check-in; nếu đã quá giờ, không check-in và không mở lại để booking online (APT-05, BR-06).
- Appointment CANCELLED hoặc NO_SHOW: không tạo Visit khám đã thực hiện (BR-07).
- Check-in sớm hơn giờ hẹn: scheduled_time không đổi khi khám sớm (BR-09); không đặt ngưỡng giờ check-in sớm cố định; chỉ check-in khi Appointment CONFIRMED và người bệnh đã đến thực tế.
- Visit được tạo bởi Receptionist tại thời điểm check-in; check_in_at và thời điểm tạo Visit được lưu riêng. Số thứ tự duy nhất theo ngày và Doctor, cấp tránh trùng khi đồng thời.
- Không có quyền check-in: Backend từ chối (AUTH-04).
Trạng thái trước → sau	Appointment: CONFIRMED → CHECKED_IN.
Kết quả và ghi nhận	Có check_in_at và số thứ tự; sẵn sàng để Doctor bắt đầu khám (LN-08).

LN-05 — Tiếp nhận người đến trực tiếp không có lịch hẹn (UC-05)
Tác nhân khởi tạo	Receptionist.
Điều kiện bắt đầu	Người bệnh đến phòng khám trực tiếp, không có Appointment.
Luồng chính	1. Receptionist tìm Patient; nếu chưa có hồ sơ thì tạo hồ sơ Patient mới (APT-06).
2. Chọn Doctor tiếp nhận.
3. Tạo Visit ở trạng thái REGISTERED, không cần Appointment (APT-06, BR-07).
4. Cấp số thứ tự theo ngày và Doctor; số phải duy nhất và tránh trùng khi nhiều lượt tiếp nhận đồng thời (APT-06, BR-07).
Rẽ nhánh và ngoại lệ	- Không tạo Appointment giả cho Walk-in (APT-06).
- chỉ Receptionist được hủy Visit REGISTERED tạo nhầm/chưa bắt đầu, phải nhập lý do; Visit đã IN_PROGRESS hoặc COMPLETED không được hủy theo luồng thông thường.
- Receptionist chọn Doctor đang làm việc/được phân công tại phòng khám; nếu không có Doctor phù hợp thì chưa tạo Visit và thông báo người bệnh chờ hướng dẫn.
- Không có quyền: Backend từ chối (AUTH-04).
Trạng thái trước → sau	Visit: (chưa có) → REGISTERED.
Kết quả và ghi nhận	Visit walk-in có thể có MedicalRecord, Prescription, ServiceOrder, VisitCharge và Invoice mà không cần Appointment (mục 12).

LN-06 — Lịch hẹn không được xác nhận hoặc bệnh nhân không đến (UC-04.3)
Tác nhân khởi tạo	SYSTEM (tác vụ tự động).
Điều kiện bắt đầu	Appointment ở CONFIRMED, đã quá scheduled_time cộng thời gian chờ (mặc định 30 phút, cấu hình theo SYS-02), không có check-in hợp lệ (BR-05).
Luồng chính	1. Tác vụ hệ thống kiểm tra các Appointment CONFIRMED quá thời gian chờ.
2. Kiểm tra Appointment vẫn CONFIRMED và không có check-in hợp lệ.
3. Chuyển Appointment sang NO_SHOW.
4. Ghi AppointmentStatusHistory với tác nhân SYSTEM (BR-05, BR-20; SYS-01).
Rẽ nhánh và ngoại lệ	- Appointment đã CHECKED_IN hoặc không còn ở CONFIRMED: không chuyển NO_SHOW (BR-05).
- Appointment PENDING quá giờ: không chuyển NO_SHOW (NO_SHOW chỉ từ CONFIRMED – BR-06); không được check-in và không được mở lại booking online (APT-05); giữ PENDING để bảo toàn lịch sử; không check-in, không chuyển NO_SHOW và không mở lại slot đã qua giờ.
- NO_SHOW không tự khôi phục (BR-05); không tạo Visit khám đã thực hiện (BR-07).
- NO_SHOW không tự đẩy bệnh nhân khác lên và không đổi giờ của họ (BR-03); Appointment quá giờ không mở lại cho booking online (BR-04).
- SYSTEM gửi thông báo NO_SHOW và ghi lịch sử trạng thái; không tự khôi phục Appointment.
Trạng thái trước → sau	Appointment: CONFIRMED → NO_SHOW.
Kết quả và ghi nhận	Lịch sử ghi tác nhân SYSTEM; số liệu NO_SHOW được dùng trong báo cáo tỷ lệ hủy/NO_SHOW (REP-03).

LN-07 — Danh sách chờ khi TimeSlot đã đầy (UC-14)
Tác nhân khởi tạo	Patient (đăng ký chờ, phản hồi lời mời); SYSTEM (gửi lời mời, xử lý hết hạn); Receptionist (hỗ trợ Patient tại quầy; chỉ SYSTEM gửi lời mời và tự xử lý hết hạn).
Điều kiện bắt đầu	TimeSlot đã đầy; Patient có WaitlistEntry ở WAITING.
Luồng chính	1. Patient đăng ký chờ cho TimeSlot đã đầy; tạo WaitlistEntry WAITING (không phải Appointment).
2. Khi TimeSlot có chỗ trống (ví dụ do hủy hợp lệ – BR-04) và cần xử lý danh sách chờ, hệ thống ưu tiên các WaitlistEntry WAITING theo thứ tự đăng ký và gửi OFFERED cho người đứng trước.
3. Patient xác nhận trong thời hạn; hệ thống kiểm tra TimeSlot vẫn còn chỗ và còn hợp lệ.
4. Hệ thống tạo Appointment (áp dụng APT-05: Appointment mới ở PENDING) và chuyển WaitlistEntry sang BOOKED.
Rẽ nhánh và ngoại lệ	- Patient từ chối: WaitlistEntry → DECLINED; hệ thống tiếp tục người kế tiếp (BR-19).
- Hết thời hạn: WaitlistEntry → EXPIRED; tiếp tục người kế tiếp (BR-19). theo tham số bắt buộc WAITLIST_OFFER_EXPIRY_MINUTES do Admin cấu hình; không hard-code giá trị mặc định.
- Patient xác nhận nhưng TimeSlot không còn chỗ hoặc không còn hợp lệ: không tạo Appointment (BR-19); chuyển về WAITING nếu vẫn muốn chờ và slot chưa quá giờ; nếu slot không còn hợp lệ thì EXPIRED.
- Patient chưa xác nhận: không tự tạo Appointment; không đẩy lịch của Patient khác đang có Appointment (BR-19, BR-03).
- Patient được hủy yêu cầu của mình khi WAITING/OFFERED; Receptionist có thể hỗ trợ hủy tại quầy và ghi tác nhân.
- mỗi Patient chỉ có một WaitlistEntry cho cùng một TimeSlot; được đăng ký chờ ở các TimeSlot khác nhau.
Trạng thái trước → sau	WaitlistEntry: WAITING → OFFERED → BOOKED, hoặc → DECLINED / EXPIRED. Appointment: (chưa có) → PENDING khi BOOKED.
Kết quả và ghi nhận	BOOKED liên kết đến Appointment đã tạo (mục 8).

LN-08 — Khám bệnh, hồ sơ khám, kê đơn và chỉ định dịch vụ (UC-06, UC-07, UC-08)
Tác nhân khởi tạo	Doctor.
Điều kiện bắt đầu	Visit ở REGISTERED (đã check-in hoặc đã tiếp nhận trực tiếp); nếu Visit gắn Appointment thì Appointment ở CHECKED_IN (EXM-02).
Luồng chính	1. Doctor xem lịch khám và mở hồ sơ Patient theo quyền (EXM-01).
2. Bắt đầu khám: Visit REGISTERED → IN_PROGRESS; nếu có Appointment: CHECKED_IN → IN_PROGRESS; ghi started_at (EXM-02, BR-09).
3. Tạo MedicalRecord khi bắt đầu khám; mỗi Visit có tối đa một MedicalRecord (EXM-03, BR-08).
4. Ghi triệu chứng, thông tin khám, chẩn đoán, hướng xử trí/điều trị, ghi chú, ngày tái khám nếu có (EXM-03).
5. Kê đơn nếu cần: chọn thuốc từ danh mục, ghi liều dùng, cách dùng, số lượng, hướng dẫn; lưu Prescription và PrescriptionDetail (EXM-04, BR-11). Chỉ ghi đơn, không bán, không cấp phát, không tính tiền thuốc.
6. Chỉ định dịch vụ nếu cần: tạo ServiceOrder và ServiceOrderDetail ở ORDERED → IN_PROGRESS → COMPLETED; lưu ServiceResult riêng cho dịch vụ cần kết quả, tối đa một cho mỗi chi tiết (EXM-06, EXM-07, BR-13).
7. Kết thúc khám: Visit IN_PROGRESS → COMPLETED; Appointment IN_PROGRESS → COMPLETED nếu có; MedicalRecord hoàn chỉnh; ghi completed_at; các khoản phí hợp lệ chuyển sang quy trình lập hóa đơn (EXM-03, EXM-08, BR-09).
8. Nếu có ngày tái khám: lập lịch bằng một Appointment mới cho cùng Patient (EXM-09).
Rẽ nhánh và ngoại lệ	- Visit không ở REGISTERED: không bắt đầu khám (EXM-02); Backend trả thông báo ngắn gọn rằng trạng thái hiện tại không cho phép thao tác.
- Appointment CANCELLED/NO_SHOW: không tạo Visit khám đã thực hiện (BR-07).
- Dịch vụ ORDERED/IN_PROGRESS không mặc nhiên tính phí; CANCELLED không tự động tính phí (BIL-02, BR-13). Visit vẫn có thể COMPLETED; dịch vụ chưa COMPLETED không được đưa vào hóa đơn và tiếp tục theo dõi ở ServiceOrderDetail.
- Sửa MedicalRecord sau hoàn tất: phải có quyền và ghi AuditLog (BR-08, SYS-01); Doctor đã lập hồ sơ; nêu lý do chỉnh sửa và ghi AuditLog.
- Hủy chỉ định dịch vụ: CANCELLED theo quyền; Doctor phụ trách Visit; chỉ hủy khi Visit chưa COMPLETED và phải ghi lý do.
- Doctor chỉ chỉnh sửa đơn khi Visit IN_PROGRESS; sau khi Visit COMPLETED không sửa/xóa trực tiếp, mọi đính chính phải có lý do và AuditLog; không kê đơn mới trên Visit đã hoàn tất.
- Receptionist chỉ hủy Visit REGISTERED tạo nhầm/chưa bắt đầu, phải nhập lý do; Visit IN_PROGRESS/COMPLETED không hủy theo luồng thông thường.
- Doctor không có quyền với hồ sơ/thao tác: Backend từ chối (AUTH-04).
Trạng thái trước → sau	Visit: REGISTERED → IN_PROGRESS → COMPLETED.
Appointment (nếu có): CHECKED_IN → IN_PROGRESS → COMPLETED.
ServiceOrderDetail: ORDERED → IN_PROGRESS → COMPLETED (hoặc CANCELLED theo quyền).
Kết quả và ghi nhận	MedicalRecord, Prescription, ServiceOrder và ServiceResult được lưu; các chuyển trạng thái Appointment ghi AppointmentStatusHistory; Patient nhận thông báo khi có hồ sơ khám/đơn thuốc mới (NTF-05).

LN-09 — Lập hóa đơn và ghi nhận thanh toán (UC-09.1 đến UC-09.4)
Tác nhân khởi tạo	Receptionist (lập hóa đơn, ghi nhận thanh toán tại quầy – theo UC-09; Receptionist lập/phát hành hóa đơn và ghi nhận thanh toán tại quầy; Admin xử lý hủy hóa đơn/hoàn tiền); Patient (thanh toán online); cổng thanh toán sandbox trả kết quả.
Điều kiện bắt đầu	- Visit có khoản phí hợp lệ: VisitCharge hoặc ServiceOrderDetail COMPLETED (BIL-02).
- Visit chưa có Invoice chính (tối đa một Invoice chính cho mỗi Visit).
Luồng chính	1. Tạo Invoice từ các khoản phí hợp lệ của Visit; mỗi InvoiceDetail ghi mô tả, số lượng, đơn giá, thành tiền và đúng một nguồn phí (VisitCharge hoặc ServiceOrderDetail); giá tại thời điểm lập lưu trên InvoiceDetail (BIL-01, BIL-02, BR-14, mục 9). Không có dòng phí thuốc.
2. Invoice ở NOT_ISSUED (nội bộ) → phát hành → ISSUED; Receptionist phát hành sau khi Visit COMPLETED và các khoản phí đủ điều kiện đã được xác định.
3. Ghi nhận thanh toán — chỉ khi Invoice ISSUED và đã có số tiền phải thu (BIL-01, BIL-03, BR-15). Mỗi lần thanh toán là một Payment riêng, có mã tham chiếu, số tiền, phương thức, thời điểm, trạng thái.
   3a. Tiền mặt/chuyển khoản: Receptionist ghi nhận Payment.
   3b. Online: Patient thanh toán qua cổng sandbox; Payment PENDING; hệ thống xác minh kết quả từ cổng rồi mới xác nhận thu (SUCCESS) hoặc FAILED (BIL-04).
4. Trạng thái thanh toán của Invoice (UNPAID, PARTIALLY_PAID, PAID) độc lập với trạng thái chứng từ; nếu lưu thì phải cập nhật nhất quán với Payment/Refund (BIL-05, BR-17, mục 6).
Rẽ nhánh và ngoại lệ	- Invoice NOT_ISSUED hoặc CANCELLED: không được tạo Payment (BIL-05, BR-15).
- Thanh toán thất bại (FAILED): không tính là đã thu; Invoice có thể được thanh toán bằng Payment mới vì mỗi lần là một Payment riêng; Payment gốc không bị xóa (BIL-03, mục 12). không đặt giới hạn số lần thử; mỗi lần là Payment riêng, Payment FAILED được giữ lịch sử.
- Thanh toán chưa hoàn tất (PENDING): không tính là đã thu (BR-15). không tự chuyển PENDING thành SUCCESS; hệ thống đối soát trạng thái với cổng thanh toán. Nếu không xác minh được, giữ PENDING để kiểm tra và không tính là đã thu.
- Nhận kết quả thanh toán online lặp: không ghi nhận thu trùng (BIL-04, mục 12).
- Thanh toán một phần: Invoice thanh toán nhiều lần; trạng thái PARTIALLY_PAID khi chưa đủ (mục 12, BIL-05). Backend từ chối giao dịch vượt số dư còn phải thu; không ghi nhận tiền thu vượt hóa đơn.
- Không có quyền: Backend từ chối (AUTH-04).
Trạng thái trước → sau	Invoice (chứng từ): (chưa có) → NOT_ISSUED → ISSUED. Invoice (thanh toán): UNPAID → PARTIALLY_PAID / PAID. Payment: PENDING → SUCCESS / FAILED.
Kết quả và ghi nhận	Chỉ Payment SUCCESS được tính vào tiền thu (BR-15, REP-02). Doanh thu chỉ gồm phí khám và phí dịch vụ; không có doanh thu bán thuốc.

LN-10 — Hủy hóa đơn và hoàn tiền (UC-09.5, UC-09.6)
Tác nhân khởi tạo	Vai trò có quyền (BIL-07, UC-09 theo ma trận phân quyền tại Phụ lục A); Admin.
Điều kiện bắt đầu	- Hủy hóa đơn: có Invoice cần hủy; Invoice chưa có Payment SUCCESS, hoặc đã hoàn tất hoàn lại toàn bộ khoản đã thu thành công; mọi trường hợp hủy phải ghi lý do và AuditLog.
- Hoàn tiền: có Payment SUCCESS và còn số tiền có thể hoàn (BR-16).
Luồng chính	A. Hủy hóa đơn
1. Người có quyền hủy Invoice → CANCELLED (BIL-05).
2. Ghi AuditLog; lịch sử Payment được giữ nguyên (BIL-07, BR-17).
B. Hoàn tiền
1. Người có quyền lập Refund riêng gồm số tiền, lý do, thời điểm, trạng thái, người xử lý (BIL-06).
2. Hệ thống kiểm tra tổng Refund thành công không vượt số tiền đã thanh toán thành công còn có thể hoàn (BR-16).
3. Refund SUCCESS được tính là tiền hoàn; Payment gốc không bị xóa hay thay bằng trạng thái đơn thuần (BIL-06, BR-16).
4. Trạng thái thanh toán của Invoice phản ánh hoàn một phần/hoàn toàn (PARTIALLY_REFUNDED, REFUNDED) nhất quán với Payment/Refund (BIL-05, mục 6).
5. Ghi AuditLog (BIL-07, SYS-01).
Rẽ nhánh và ngoại lệ	- Hoàn vượt giới hạn BR-16: không được thực hiện.
- Refund PENDING/FAILED: không tính là tiền hoàn (mục 6, REP-02).
- Một Payment có thể được hoàn một phần nhiều lần, miễn tổng Refund SUCCESS không vượt giới hạn (mục 12).
- Hóa đơn đã thanh toán không được xử lý như hóa đơn chưa thu tiền (BIL-07). chỉ hủy sau khi toàn bộ số tiền đã thu thành công được hoàn thành công; nếu chưa hoàn đủ thì không cho hủy Invoice.
- ghi Refund riêng; với thanh toán online, thực hiện qua chức năng hoàn tiền sandbox nếu được hỗ trợ, còn thời gian xử lý phụ thuộc kết quả cổng; không tự ghi SUCCESS trước khi xác minh.
- Người dùng không có quyền: Backend từ chối (AUTH-04).
Trạng thái trước → sau	Invoice (chứng từ): ISSUED → CANCELLED. Refund: PENDING → SUCCESS / FAILED. Invoice (thanh toán): PAID → PARTIALLY_REFUNDED / REFUNDED.
Kết quả và ghi nhận	Mọi thao tác hủy hóa đơn và hoàn tiền truy vết được qua AuditLog; Payment và Refund không bị xóa cứng (BR-20).

LN-11 — Thay đổi/đóng lịch làm việc và khóa TimeSlot (UC-12)
Tác nhân khởi tạo	Admin.
Điều kiện bắt đầu	Có hồ sơ Doctor và Room; với thay đổi/đóng lịch: WorkSchedule đã tồn tại.
Luồng chính	1. Tạo WorkSchedule theo bác sĩ, ngày/ca và Room; hệ thống ngăn lịch chồng lấn của cùng Doctor hoặc cùng Room (SCH-01, SCH-03).
2. Sinh TimeSlot theo thời lượng khám và sức chứa; capacity mặc định 1 (SCH-02).
3. Khi thay đổi hoặc đóng lịch đã có Appointment: xác định các Appointment bị ảnh hưởng, xử lý theo nghiệp vụ đổi/hủy đã có (LN-03), ghi người thực hiện, thời điểm, lý do (SCH-04).
4. Khi khóa TimeSlot: TimeSlot không còn nhận đặt mới; Appointment đã tồn tại không tự bị xóa, hủy hoặc chuyển slot (SCH-05).
Rẽ nhánh và ngoại lệ	- Lịch chồng lấn: bị ngăn (SCH-03).
- Không xóa lịch hẹn âm thầm (SCH-04).
- capacity lớn hơn 1 chỉ khi Admin cấu hình và chính sách phòng khám cho phép (SCH-02, BR-01).
- Admin quyết định thay đổi/đóng lịch; Receptionist xử lý từng Appointment bị ảnh hưởng theo nghiệp vụ đổi/hủy và thông báo cho Patient. Không tự chuyển lịch sang slot khác.
Trạng thái trước → sau	WorkSchedule/TimeSlot: được tạo → có thể bị khóa/đóng. Appointment bị ảnh hưởng: theo LN-03.
Kết quả và ghi nhận	Ghi nhận người thực hiện, thời điểm, lý do cho thay đổi ảnh hưởng Appointment.

4. Yêu cầu chức năng
AUTH — Tài khoản và phân quyền
•	AUTH-01: Patient đăng ký bằng email hoặc số điện thoại và mật khẩu; thông tin định danh phải được kiểm tra trùng theo chính sách.
•	AUTH-02: Đăng nhập/đăng xuất; phiên xác thực được bảo vệ. Cơ chế JWT/refresh token là lựa chọn kỹ thuật ở thiết kế phần mềm, không phải quy tắc nghiệp vụ bắt buộc.
•	AUTH-03: Đổi mật khẩu và khôi phục mật khẩu.
•	AUTH-04: Phân quyền Admin, Receptionist, Doctor, Patient; mọi thao tác kiểm tra quyền ở Backend.
•	AUTH-05: Patient xem/sửa thông tin cá nhân phù hợp, gồm họ tên, ngày sinh, giới tính, địa chỉ, thông tin liên hệ và tiền sử dị ứng.
•	AUTH-06: Admin khóa/mở khóa tài khoản. Hồ sơ Patient có thể tồn tại trước tài khoản User; liên kết sau đăng ký chỉ thực hiện sau khi xác minh.
CAT — Danh mục
•	CAT-01: Quản lý Specialty, Room, Service và Medicine.
•	CAT-02: Quản lý hồ sơ Doctor, chuyên khoa, thông tin nghề nghiệp hiển thị và phí khám.
•	CAT-03: Quản lý giá dịch vụ theo chính sách của phòng khám; thay đổi giá không được làm thay đổi ngược các hóa đơn đã lập.
SCH — Lịch làm việc
•	SCH-01: Tạo WorkSchedule theo bác sĩ, ngày/ca và Room.
•	SCH-02: Sinh TimeSlot theo thời lượng khám và sức chứa cấu hình; capacity mặc định của TimeSlot là 1, chỉ lớn hơn 1 khi Admin cấu hình và chính sách phòng khám cho phép.
•	SCH-03: Ngăn lịch làm việc chồng lấn của cùng Doctor hoặc cùng Room.
•	SCH-04: Khi thay đổi/đóng lịch đã có Appointment, không xóa lịch hẹn âm thầm; phải xác định các Appointment bị ảnh hưởng, xử lý theo nghiệp vụ đổi/hủy đã có và ghi nhận người thực hiện, thời điểm, lý do.
•	SCH-05: Cho phép khóa TimeSlot; khóa slot không tự xóa hay tự hủy Appointment đã tồn tại và không tự chuyển Appointment sang slot khác.
APT — Lịch hẹn và tiếp nhận
•	APT-01: Patient tìm bác sĩ/chuyên khoa, xem TimeSlot còn chỗ và đặt Appointment với lý do khám.
•	APT-02: Receptionist có thể tạo Appointment tại quầy cho Patient đã có hồ sơ hoặc tạo hồ sơ Patient mới.
•	APT-03: Ngăn một Patient đặt trùng lịch không hợp lệ và ngăn số Appointment còn hiệu lực vượt sức chứa (capacity) của TimeSlot, mặc định bằng 1, kể cả khi nhiều yêu cầu đến đồng thời.
•	APT-04: Patient xem lịch, đổi/hủy theo quy tắc thời hạn; hủy giữ lại lịch sử. Khi đổi lịch: kiểm tra slot mới còn hợp lệ, tạo Appointment mới, Appointment cũ chuyển CANCELLED với lý do RESCHEDULED, giữ lịch sử và truy vết được quan hệ lịch cũ – lịch mới; không sửa Appointment cũ thành lịch mới.
•	APT-05: Appointment mới được tạo ở trạng thái PENDING; Receptionist xác nhận lịch để chuyển PENDING → CONFIRMED. Receptionist chỉ check-in Appointment ở trạng thái CONFIRMED, ghi thời điểm check-in và cấp số thứ tự trong ngày theo bác sĩ (theo BR-07). Appointment PENDING không được CHECKED_IN; Appointment PENDING đã quá giờ không được CHECKED_IN và không được mở lại để booking online.
•	APT-06: Người đến trực tiếp: Receptionist tìm Patient (chưa có thì tạo), chọn Doctor tiếp nhận, tạo Visit ở trạng thái REGISTERED không cần Appointment và cấp số thứ tự theo ngày và Doctor; không tạo Appointment giả cho Walk-in. Số thứ tự phải duy nhất theo ngày và Doctor (mỗi Doctor có thể bắt đầu từ số 1 riêng) và việc cấp số phải tránh trùng khi có nhiều lượt tiếp nhận đồng thời; số thứ tự không phải module riêng.
•	APT-07: Cấp thông tin xác nhận/phiếu lịch hẹn điện tử. QR là tùy chọn giao diện, không phải điều kiện của mô hình dữ liệu.
•	APT-08: AppointmentStatusHistory ghi lại mọi chuyển trạng thái, thời điểm, tác nhân và lý do nếu có; tác vụ hệ thống tự động được ghi nhận với tác nhân SYSTEM.
EXM — Khám, hồ sơ, đơn thuốc và dịch vụ
•	EXM-01: Doctor xem lịch khám và mở hồ sơ Patient theo quyền.
•	EXM-02: Khi bắt đầu khám, Visit chuyển REGISTERED → IN_PROGRESS; nếu Visit gắn Appointment, Appointment chuyển CHECKED_IN → IN_PROGRESS.
•	EXM-03: Tạo MedicalRecord khi bắt đầu quá trình khám; ghi triệu chứng, thông tin khám, chẩn đoán, hướng xử trí/điều trị, ghi chú và ngày tái khám nếu có. Hoàn chỉnh khi kết thúc lượt khám.
•	EXM-04: Kê đơn gồm thuốc, liều dùng, cách dùng, số lượng và hướng dẫn cần thiết.
•	EXM-06: Tạo ServiceOrder và ServiceOrderDetail khi chỉ định dịch vụ; theo dõi trạng thái ORDERED, IN_PROGRESS, COMPLETED hoặc CANCELLED.
•	EXM-07: Lưu ServiceResult cho dịch vụ cần kết quả; mỗi ServiceOrderDetail có tối đa một ServiceResult; trạng thái thực hiện và kết quả là hai thông tin khác nhau.
•	EXM-08: Khi kết thúc lượt khám, Visit chuyển IN_PROGRESS → COMPLETED; nếu có Appointment, Appointment chuyển IN_PROGRESS → COMPLETED. Các khoản phí hợp lệ được chuyển sang quy trình lập hóa đơn.
•	EXM-09: Cho phép lập lịch tái khám bằng một Appointment mới liên kết cùng Patient; không sửa giờ hẹn cũ để biến nó thành lịch tái khám.
BIL — Hóa đơn và thanh toán
•	BIL-01: Tạo Invoice từ các khoản phí hợp lệ thuộc Visit (VisitCharge, ServiceOrderDetail); mỗi Visit có tối đa một Invoice chính. Invoice phải tồn tại và có số tiền phải thu trước khi tạo Payment; chỉ Invoice ISSUED mới được ghi nhận Payment.
•	BIL-02: InvoiceDetail ghi mô tả, số lượng, đơn giá, thành tiền và đúng một nguồn phí: VisitCharge hoặc ServiceOrderDetail. VisitCharge là khoản phí phát sinh trực tiếp từ Visit, chủ yếu là phí khám. ServiceOrderDetail COMPLETED là trạng thái mặc định đủ điều kiện đưa vào hóa đơn; ORDERED/IN_PROGRESS không mặc nhiên tính phí, CANCELLED không tự động tính phí.
•	BIL-03: Ghi nhận tiền mặt/chuyển khoản hoặc kết quả thanh toán online. Mỗi lần thanh toán là một Payment riêng, có mã tham chiếu, số tiền, phương thức, thời điểm và trạng thái. Chỉ Invoice ISSUED mới được ghi nhận Payment; Payment gốc không bị xóa.
•	BIL-04: Thanh toán online dùng cổng sandbox theo phạm vi đồ án; chỉ xác nhận thu tiền sau khi xác minh kết quả từ cổng. Một thông báo kết quả lặp không được ghi nhận thu trùng.
•	BIL-05: Phân biệt trạng thái chứng từ Invoice (NOT_ISSUED, ISSUED, CANCELLED) với trạng thái thanh toán (UNPAID, PARTIALLY_PAID, PAID, PARTIALLY_REFUNDED, REFUNDED). NOT_ISSUED là Invoice nội bộ chưa phát hành, chưa được ghi nhận thanh toán; Invoice CANCELLED không được tạo Payment mới.
•	BIL-06: Hỗ trợ ghi nhận hoàn tiền bằng Refund riêng, không chỉ đổi trạng thái Payment; mỗi Refund có số tiền, lý do, thời điểm, trạng thái và người xử lý.
•	BIL-07: Hủy hóa đơn/hoàn tiền phải theo quyền và ghi AuditLog. Không xóa lịch sử thanh toán; hóa đơn đã thanh toán không được xử lý như hóa đơn chưa thu tiền.
NTF — Thông báo
•	NTF-01: Gửi nhắc lịch thông thường theo mốc cấu hình, mặc định 24 giờ và 2 giờ trước giờ hẹn.
•	NTF-02: Gửi yêu cầu xác nhận có đến khám trước 5 giờ; đây là thông báo riêng với nhắc lịch thông thường.
•	NTF-03: Lưu từng AppointmentConfirmationRequest gồm Appointment, thời điểm gửi, kênh, phản hồi YES/NO/NO_RESPONSE, thời điểm phản hồi và trạng thái xử lý.
•	NTF-04: YES giữ Appointment ở CONFIRMED. NO yêu cầu người bệnh xác nhận hủy; chỉ hủy online nếu còn ít nhất 2 giờ trước giờ hẹn. Không phản hồi không tự hủy.
•	NTF-05: Thông báo khi lịch được xác nhận/đổi/hủy, khi có hồ sơ khám/đơn thuốc mới và khi cần thông báo bác sĩ; trung tâm thông báo có trạng thái đã đọc/chưa đọc. Patient chưa có User vẫn nhận được thông báo và yêu cầu xác nhận qua kênh liên lạc phù hợp theo thông tin liên hệ của Patient; Notification không bắt buộc phải có User.
REP/SYS — Báo cáo và quản trị
•	REP-01: Báo cáo lượt khám theo ngày/tháng, bác sĩ và chuyên khoa.
•	REP-02: Báo cáo doanh thu theo thời gian và nguồn phí (phí khám, phí dịch vụ), phân biệt: tổng phí ghi nhận trên Invoice, tiền thực thu từ Payment SUCCESS và tiền hoàn từ Refund SUCCESS; Payment PENDING/FAILED không được tính là đã thu.
•	REP-03: Báo cáo tỷ lệ hủy/NO_SHOW và thuốc được kê đơn nhiều nhất.
•	REP-04: Cho phép xuất báo cáo CSV/PDF nếu cần cho đồ án; đây là cách xuất dữ liệu, không làm phát sinh thực thể nghiệp vụ riêng.
•	SYS-01: AuditLog ghi các thao tác nhạy cảm: đăng nhập, thay đổi hồ sơ, chuyển trạng thái quan trọng, chỉnh sửa hồ sơ khám sau hoàn tất, hủy hóa đơn và hoàn tiền. Tác vụ do hệ thống thực hiện (như tự động NO_SHOW) được ghi nhận với tác nhân SYSTEM.
•	SYS-02: Cấu hình các tham số nghiệp vụ: thời lượng khám, sức chứa, hạn đổi/hủy, thời gian nhắc lịch và thời gian chờ trước NO_SHOW.
5. Quy tắc nghiệp vụ bắt buộc
Mã	Chủ đề	Quy tắc
BR-01	Sức chứa TimeSlot	Số Appointment còn hiệu lực trong một TimeSlot không vượt quá capacity. Việc kiểm tra phải được bảo đảm ở Backend/CSDL trong giao dịch đồng thời. Capacity mặc định của TimeSlot là 1 (lịch khám cá nhân); chỉ lớn hơn 1 khi Admin cấu hình và chính sách phòng khám cho phép.
BR-02	Thời hạn đổi/hủy	Patient chỉ tự đổi/hủy online khi còn ít nhất 2 giờ trước scheduled_time. Trường hợp dưới 2 giờ phải liên hệ Receptionist; thao tác của Receptionist cần ghi người thực hiện và lý do.
BR-03	Không điều phối lại	Hủy hoặc NO_SHOW không tự đẩy các bệnh nhân khác lên và không thay đổi scheduled_time của họ.
BR-04	Giải phóng slot	Hủy hợp lệ trước giờ hẹn có thể giải phóng sức chứa nếu slot không bị khóa và còn hợp lệ để đặt. Slot đã qua giờ khám không mở lại cho booking online. Appointment quá giờ không được mở lại cho booking online.
BR-05	NO_SHOW	Appointment CONFIRMED không check-in trong 30 phút sau scheduled_time mặc định thì có thể chuyển NO_SHOW bởi tác vụ hệ thống. Chỉ chuyển nếu trạng thái vẫn CONFIRMED và không có check-in hợp lệ. Không tự động khôi phục NO_SHOW; việc chuyển này được ghi vào AppointmentStatusHistory với tác nhân SYSTEM.
BR-06	Appointment	Trạng thái: PENDING → CONFIRMED → CHECKED_IN → IN_PROGRESS → COMPLETED; PENDING/CONFIRMED → CANCELLED; CONFIRMED → NO_SHOW. Appointment mới được tạo ở PENDING; Receptionist xác nhận để chuyển PENDING → CONFIRMED. Chỉ Appointment CONFIRMED mới được CHECKED_IN; Appointment PENDING không được CHECKED_IN, và nếu đã quá giờ thì không được CHECKED_IN cũng không được mở lại để booking online. Mọi chuyển trạng thái phải được kiểm tra và ghi AppointmentStatusHistory; tác vụ hệ thống tự động ghi tác nhân SYSTEM. Không có trạng thái khác (RESCHEDULED không phải trạng thái của Appointment).
BR-07	Visit	Visit thuộc một Patient, có thể liên kết với tối đa một Appointment hoặc không có Appointment. Appointment CANCELLED/NO_SHOW không tạo Visit khám đã thực hiện. Một Appointment chỉ liên kết tối đa một Visit; không có hai Visit đang hoạt động cho cùng một Appointment. Visit walk-in không có Appointment và không tạo Appointment giả. Mỗi Visit có số thứ tự duy nhất theo ngày và Doctor (mỗi Doctor có thể bắt đầu từ số 1 riêng mỗi ngày); việc cấp số phải tránh trùng khi có nhiều lượt tiếp nhận đồng thời. Số thứ tự là thuộc tính của Visit, không phải đối tượng nghiệp vụ riêng.
BR-08	MedicalRecord	MedicalRecord thuộc Visit; mỗi Visit có tối đa một MedicalRecord. Tạo khi bắt đầu khám, hoàn chỉnh khi kết thúc; chỉnh sửa sau hoàn tất phải có quyền và AuditLog.
BR-09	Thời gian	scheduled_time là giờ hẹn ban đầu và không đổi khi khám sớm. check_in_at, started_at, completed_at ghi các mốc thực tế riêng. Đổi lịch là nghiệp vụ riêng, tạo Appointment mới theo BR-21.
BR-10	Patient/User	Patient có thể tồn tại không có User. Trong phạm vi đồ án, một User Patient liên kết tối đa một hồ sơ Patient và một Patient liên kết tối đa một User; phải xác minh trước khi liên kết. Notification và AppointmentConfirmationRequest không bắt buộc phải có User.
BR-11	Kê đơn thuốc	Kê đơn gồm thuốc, liều dùng, cách dùng, số lượng và hướng dẫn cần thiết; thông tin đơn thuốc được lưu trong Prescription và PrescriptionDetail.
BR-13	Dịch vụ	ServiceOrderDetail có trạng thái ORDERED, IN_PROGRESS, COMPLETED, CANCELLED. ORDERED và IN_PROGRESS không mặc nhiên tính phí; COMPLETED là trạng thái mặc định đủ điều kiện đưa vào hóa đơn; CANCELLED không tự động tính phí. ServiceResult là dữ liệu riêng; mỗi ServiceOrderDetail có tối đa một ServiceResult.
BR-14	Nguồn phí	Mỗi InvoiceDetail tham chiếu đúng một trong hai nguồn: VisitCharge hoặc ServiceOrderDetail; không được thiếu nguồn hoặc đồng thời tham chiếu nhiều nguồn. Không có loại nguồn phí thứ ba. VisitCharge là khoản phí phát sinh trực tiếp từ Visit, chủ yếu là phí khám.
BR-15	Invoice/Payment	Invoice phải tồn tại trước Payment, và chỉ Invoice ISSUED mới được ghi nhận Payment; Invoice NOT_ISSUED (Invoice nội bộ chưa phát hành) chưa được ghi nhận thanh toán và Invoice CANCELLED không được tạo Payment mới. Chỉ Payment SUCCESS được tính vào tổng tiền thu; PENDING/FAILED không được tính là đã thu. Một Visit có tối đa một Invoice chính; không xóa Payment gốc.
BR-16	Hoàn tiền	Refund là giao dịch riêng, không xóa Payment gốc. Tổng hoàn thành công không được vượt quá số tiền đã thanh toán thành công còn có thể hoàn.
BR-17	Chứng từ	Trạng thái phát hành chứng từ và trạng thái thanh toán độc lập. Hủy chứng từ không được xóa lịch sử thanh toán.
BR-18	Xác nhận đến khám	Yêu cầu xác nhận 5 giờ trước lịch không thay thế nhắc lịch 24/2 giờ. NO_RESPONSE không tự hủy; NO chỉ tự hủy online nếu đáp ứng BR-02.
BR-19	Danh sách chờ	WaitlistEntry không phải Appointment. Chỉ tạo Appointment sau khi người bệnh xác nhận trong thời hạn và kiểm tra slot vẫn còn chỗ. Khi TimeSlot có chỗ trống và cần xử lý danh sách chờ, hệ thống ưu tiên các WaitlistEntry đang WAITING theo thứ tự đăng ký và gửi OFFERED cho người đứng trước. Chỉ khi Patient xác nhận trong thời hạn và slot vẫn còn hợp lệ thì mới tạo Appointment và chuyển WaitlistEntry thành BOOKED; nếu Patient từ chối hoặc hết thời hạn thì chuyển DECLINED/EXPIRED và tiếp tục người tiếp theo. Không tự động tạo Appointment khi Patient chưa xác nhận và không đẩy lịch của Patient khác đang có Appointment.
BR-20	Lịch sử	AppointmentStatusHistory, Payment, Refund và AuditLog là dữ liệu truy vết; không xóa cứng khi nghiệp vụ bị hủy/điều chỉnh. Các tác vụ SYSTEM như tự động NO_SHOW được ghi nhận với tác nhân SYSTEM.
BR-21	Đổi lịch	Khi bệnh nhân đổi lịch: kiểm tra slot mới còn hợp lệ, tạo Appointment mới, Appointment cũ chuyển CANCELLED với lý do hủy RESCHEDULED. Không sửa Appointment cũ thành lịch mới, không xóa Appointment cũ, giữ lịch sử và truy vết được quan hệ lịch cũ – lịch mới. Patient chỉ tự đổi lịch online khi còn ít nhất 2 giờ trước scheduled_time (BR-02).

6. Mô hình trạng thái thống nhất
Đối tượng	Trạng thái / luồng	Ghi chú
Appointment	PENDING → CONFIRMED → CHECKED_IN → IN_PROGRESS → COMPLETED; PENDING/CONFIRMED → CANCELLED; CONFIRMED → NO_SHOW	Không tạo hồ sơ khám cho CANCELLED/NO_SHOW. Đổi lịch: Appointment cũ CANCELLED (lý do RESCHEDULED) và tạo Appointment mới; không có trạng thái RESCHEDULED. Appointment mới tạo ở PENDING; Receptionist xác nhận → CONFIRMED; chỉ CONFIRMED được CHECKED_IN.
Visit	REGISTERED → IN_PROGRESS → COMPLETED; REGISTERED → CANCELLED nếu được phép	Visit được tạo khi tiếp nhận; có thể không có Appointment.
ServiceOrderDetail	ORDERED → IN_PROGRESS → COMPLETED; có thể → CANCELLED theo quyền	ServiceResult được lưu riêng khi cần (tối đa một). COMPLETED là trạng thái mặc định đủ điều kiện tính phí; ORDERED/IN_PROGRESS không mặc nhiên tính phí; CANCELLED không tự động tính phí.
Payment	PENDING, SUCCESS, FAILED	Không dùng REFUNDED làm trạng thái thay thế giao dịch hoàn tiền; Refund là bản ghi riêng. Chỉ Invoice ISSUED mới được ghi nhận Payment; chỉ SUCCESS là tiền thực thu.
Refund	PENDING, SUCCESS, FAILED	Chỉ Refund SUCCESS được tính là tiền hoàn.
Invoice — chứng từ	NOT_ISSUED, ISSUED, CANCELLED	NOT_ISSUED là Invoice nội bộ chưa phát hành, chưa được ghi nhận Payment; chỉ ISSUED được ghi nhận Payment; CANCELLED không được tạo Payment mới.
Invoice — thanh toán	UNPAID, PARTIALLY_PAID, PAID, PARTIALLY_REFUNDED, REFUNDED	Trạng thái có thể tính từ Payment/Refund; nếu lưu thì phải cập nhật nhất quán.
WaitlistEntry	WAITING, OFFERED, BOOKED, DECLINED, EXPIRED, CANCELLED	BOOKED nghĩa là đã tạo Appointment thành công. Ưu tiên WAITING theo thứ tự đăng ký; từ chối/hết thời hạn → DECLINED/EXPIRED rồi tiếp tục người tiếp theo.

7. Thực thể dữ liệu đề xuất làm căn cứ ERD

Thực thể	Trách nhiệm dữ liệu
User	Tài khoản đăng nhập, thông tin xác thực, trạng thái tài khoản và vai trò.
Patient	Hồ sơ bệnh nhân; có thể chưa liên kết User.
Doctor	Hồ sơ bác sĩ; liên kết User nếu bác sĩ có tài khoản.
Specialty	Danh mục chuyên khoa.
DoctorSpecialty	Bảng liên kết Doctor–Specialty; Doctor N — N Specialty, không giới hạn một Doctor chỉ có một Specialty.
Room	Phòng khám.
WorkSchedule	Ca/ngày làm việc của bác sĩ, gắn Room.
TimeSlot	Khung giờ đặt lịch, sức chứa (capacity mặc định 1) và trạng thái.
Appointment	Lịch hẹn dự kiến, Patient, TimeSlot, giờ hẹn và trạng thái. Khi đổi lịch, Appointment mới truy vết được Appointment cũ đã CANCELLED (lý do RESCHEDULED).
AppointmentStatusHistory	Lịch sử chuyển trạng thái Appointment.
AppointmentConfirmationRequest	Mỗi yêu cầu xác nhận đến khám: Appointment, thời điểm gửi, kênh, phản hồi YES/NO/NO_RESPONSE, thời điểm phản hồi và trạng thái xử lý; gửi được cho Patient chưa có User.
Visit	Lượt tiếp nhận/khám thực tế; có thể liên kết tối đa một Appointment hoặc là walk-in (không có Appointment); có Doctor tiếp nhận và số thứ tự duy nhất theo ngày và Doctor.
VisitCharge	Khoản phí phát sinh trực tiếp từ Visit, chủ yếu là phí khám; là một trong hai nguồn của InvoiceDetail.
MedicalRecord	Hồ sơ khám thuộc Visit.
Medicine	Danh mục thuốc.
Prescription	Đơn thuốc thuộc MedicalRecord.
PrescriptionDetail	Từng thuốc được kê trong đơn.
Service	Danh mục dịch vụ và giá hiện hành.
ServiceOrder	Nhóm chỉ định dịch vụ thuộc MedicalRecord.
ServiceOrderDetail	Từng dịch vụ được chỉ định, trạng thái và giá áp dụng tại thời điểm phát sinh.
ServiceResult	Kết quả của ServiceOrderDetail khi cần lưu; mỗi ServiceOrderDetail có tối đa một ServiceResult.
Invoice	Hóa đơn chính thuộc Visit (tối đa một Invoice mỗi Visit); trạng thái chứng từ và thanh toán.
InvoiceDetail	Dòng phí có số lượng, đơn giá, thành tiền và đúng một nguồn phí: VisitCharge hoặc ServiceOrderDetail.
Payment	Mỗi lần thử/giao dịch thanh toán.
Refund	Mỗi lần hoàn tiền, có trạng thái và lý do.
WaitlistEntry	Đăng ký chờ cho TimeSlot; không phải Appointment.
Notification	Thông báo gửi đến User hoặc Patient (Patient có thể chưa có User) và trạng thái đọc.
AuditLog	Nhật ký thao tác nhạy cảm.
