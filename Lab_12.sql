-- TAO BANG
CREATE TABLE tblChucvu (
  MaCV nvarchar(50) PRIMARY KEY,
  TenCV NVARCHAR(255)
);

CREATE TABLE tblNhanVien (
  MaNV nvarchar(50) PRIMARY KEY,
  MaCV nvarchar(50),
  TenNV VARCHAR(255),
  NgaySinh DATE,
  LuongCanBan FLOAT,
  NgayCong int,
  PhuCap FLOAT,
  FOREIGN KEY (MaCV) REFERENCES tblChucvu(MaCV)
);

-- Thêm dữ liệu vào bảng tblChucvu
INSERT INTO tblChucvu (MaCV, TenCV)
VALUES
  ('BV', 'Bảo Vệ'),
  ('GD', 'Giám Đốc'),
  ('HC', 'Hành Chính'),
  ('KT', 'Kế Toán'),
  ('TQ', 'Thủ Quỹ'),
  ('VS', 'Vệ Sinh');

-- Thêm dữ liệu vào bảng tblNhanVien
INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
VALUES
  ('NV01', 'BV', 'Nguyễn Văn An', '1977-01-01', 700000, 25, 500000),
  ('NV02', 'GD', 'Bùi Văn Tí', '1978-02-02', 400000, 24, 100000),
  ('NV03', 'VS', 'Trần Thanh Nhật', '1977-03-03', 600000, 26, 400000),
  ('NV04', 'TQ', 'Nguyễn Thị Út', '1980-04-04', 300000, 26, 300000),
  ('NV05', 'KT', 'Lê Thị Hà', '1979-05-05', 500000, 27, 200000);
--- cau a
CREATE PROCEDURE SP_Them_Nhan_Vien (
  @MaNV INT,
  @MaCV INT,
  @TenNV NVARCHAR(50),
  @NgaySinh DATE,
  @LuongCanBan MONEY,
  @NgayCong INT,
  @PhuCap MONEY
)
AS
BEGIN
  -- Kiểm tra MaCV có tồn tại trong bảng tblChucVu hay không
  IF NOT EXISTS (
    SELECT 1 FROM tblChucVu WHERE MaCV = @MaCV
  )
  BEGIN
    PRINT 'Lỗi: Chức vụ không tồn tại.'
    RETURN
  END

  -- Kiểm tra NgayCong có <= 30 hay không
  IF @NgayCong > 30
  BEGIN
    PRINT 'Lỗi: Ngày công không hợp lệ.'
    RETURN
  END

  -- Thêm nhân viên mới
  INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
  VALUES (@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCanBan, @NgayCong, @PhuCap)

  PRINT 'Thêm nhân viên mới thành công.'
END
-- cau b
CREATE PROCEDURE SP_CapNhat_Nhan_Vien (
  @MaNV INT,
  @MaCV INT,
  @TenNV NVARCHAR(50),
  @NgaySinh DATE,
  @LuongCanBan MONEY,
  @NgayCong INT,
  @PhuCap MONEY
)
AS
BEGIN
  -- Kiểm tra MaCV có tồn tại trong bảng tblChucVu hay không
  IF NOT EXISTS (
    SELECT 1 FROM tblChucVu WHERE MaCV = @MaCV
  )
  BEGIN
    PRINT 'Lỗi: Chức vụ không tồn tại.'
    RETURN
  END

  -- Kiểm tra NgayCong có <= 30 hay không
  IF @NgayCong > 30
  BEGIN
    PRINT 'Lỗi: Ngày công không hợp lệ.'
    RETURN
  END

  -- Cập nhật thông tin nhân viên
  UPDATE tblNhanVien SET 
    MaCV = @MaCV,
    TenNV = @TenNV,
    NgaySinh = @NgaySinh,
    LuongCanBan = @LuongCanBan,
    NgayCong = @NgayCong,
    PhuCap = @PhuCap
  WHERE MaNV = @MaNV

  PRINT 'Cập nhật thông tin nhân viên thành công.'
END

-- cau c
CREATE PROCEDURE SP_LuongLN
AS
BEGIN
  SELECT MaNV, TenNV, LuongCanBan*NgayCong+PhuCap AS Luong
  FROM tblNhanVien;
END
--d
CREATE FUNCTION TBL_LuongTB()
RETURNS TABLE 
AS
RETURN
(
  SELECT tblNhanVien.MaNV, tblNhanVien.TenNV, tblChucvu.TenCV, tblNhanVien.LuongCanBan*CASE WHEN NgayCong >= 25 THEN NgayCong*2 ELSE NgayCong END + PhuCap AS Luong
  FROM tblNhanVien
  INNER JOIN tblChucvu ON tblNhanVien.MaCV = tblChucvu.MaCV
  GROUP BY tblNhanVien.MaNV, tblNhanVien.TenNV, tblChucvu.TenCV, tblNhanVien.LuongCanBan, tblNhanVien.NgayCong, tblNhanVien.PhuCap
)
--1
CREATE PROCEDURE SP_ThemNhanVien
  @MaNV VARCHAR(10),
  @MaCV VARCHAR(2),
  @TenNV NVARCHAR(50),
  @NgaySinh DATE,
  @LuongCB FLOAT,
  @NgayCong INT,
  @PhucCap FLOAT
AS
BEGIN
  DECLARE @Count INT;
  SELECT @Count = COUNT(*) FROM ChucVu WHERE MaCV = @MaCV;
  IF @Count = 0
  BEGIN
    SELECT 'Mã chức vụ không tồn tại' AS ThongBao;
  END
  ELSE
  BEGIN
    SELECT @Count = COUNT(*) FROM NhanVien WHERE MaNV = @MaNV;
    IF @Count > 0
    BEGIN
      SELECT 'Mã nhân viên đã tồn tại' AS ThongBao;
    END
    ELSE
    BEGIN
      INSERT INTO NhanVien(MaNV, MaCV, TenNV, NgaySinh, LuongCB, NgayCong, PhucCap)
      VALUES (@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCB, @NgayCong, @PhucCap);
      SELECT 'Thêm thành công' AS ThongBao;
    END
  END
END

--2
CREATE PROCEDURE SP_Them_NhanVien
  @MaNV VARCHAR(10),
  @MaCV VARCHAR(2),
  @TenNV NVARCHAR(50),
  @NgaySinh DATE,
  @LuongCB FLOAT,
  @NgayCong INT,
  @PhucCap FLOAT
AS
BEGIN
  DECLARE @Count INT;
  SELECT @Count = COUNT(*) FROM ChucVu WHERE MaCV = @MaCV;
  IF @Count = 0
  BEGIN
    SELECT 'Mã chức vụ không tồn tại' AS ThongBao;
  END
  ELSE
  BEGIN
    SELECT @Count = COUNT(*) FROM NhanVien WHERE MaNV = @MaNV;
    IF @Count > 0
    BEGIN
      SELECT 'Mã nhân viên đã tồn tại' AS ThongBao;
    END
    ELSE
    BEGIN
      INSERT INTO NhanVien(MaNV, MaCV, TenNV, NgaySinh, LuongCB, NgayCong, PhucCap)
      VALUES (@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCB, @NgayCong, @PhucCap);
      SELECT 'Thêm thành công' AS ThongBao;
    END
  END
END

--3
CREATE PROCEDURE SP_CapNhatNgaySinh
  @MaNV VARCHAR(10),
  @NgaySinh DATE
AS
BEGIN
  DECLARE @Count INT;
  SELECT @Count = COUNT(*) FROM NhanVien WHERE MaNV = @MaNV;
  IF @Count = 0
  BEGIN
    SELECT 'Không tìm thấy bản ghi cần cập nhật' AS ThongBao;
  END
  ELSE
  BEGIN
    UPDATE NhanVien SET NgaySinh = @NgaySinh WHERE MaNV = @MaNV;
    SELECT 'Cập nhật thành công' AS ThongBao;
  END
END

--4
CREATE PROCEDURE SP_TongSoNhanVienTheoNgayCong
  @NgayCong1 INT,
  @NgayCong2 INT
AS
BEGIN
  SELECT COUNT(*) AS TongSoNhanVien
  FROM NhanVien
  WHERE NgayCong BETWEEN @NgayCong1 AND @NgayCong2;
END

--5
CREATE PROCEDURE SP_TongSoNhanVienTheoChucVu
  @TenCV NVARCHAR(50)
AS
BEGIN
  SELECT COUNT(*) AS TongSoNhanVien
  FROM NhanVien
  WHERE MaCV IN (SELECT MaCV FROM ChucVu WHERE TenCV = @TenCV);
END