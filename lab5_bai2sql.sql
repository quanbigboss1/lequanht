--cau a
create proc bai2a @MANV varchar(3)
as
begin
	select * from NHANVIEN where MANV = @MANV
end
exec bai2a '009'
-- cau b
create proc bai2_b @MANV int
as
begin
	select count(MANV) as 'so luong' ,MADA,TENPHG FROM NHANVIEN
	inner join PHONGBAN ON NHANVIEN.PHG = PHONGBAN.MAPHG
	inner join DEAN ON DEAN.PHONG = PHONGBAN.MAPHG
	where MADA = @manv
	group by TENPHG,MADA
end
-- cau c
go
CREATE PROCEDURE BAI2_c @MaDA varchar(3),@Ddiem_DA nvarchar(50)
as
	begin
	select count(MANV) as 'so luong', MADA,DDIEM_DA from NHANVIEN
	INNER JOIN PHONGBAN ON NHANVIEN.PHG=PHONGBAN.MAPHG
	INNER JOIN DEAN ON DEAN.PHONG=PHONGBAN.MAPHG
	WHERE MADA=@MaDA and DDIEM_DA=@Ddiem_DA
	group by MADA,DDIEM_DA
	end
go
go
exec BAI2_c 10,N'Hà Nội'
go
-- cau d
create proc bai2_d @MATP varchar(5)
as
begin
	select HONV,TENNV,TENPHG,NHANVIEN.MANV,THANNHAN.*
	from NHANVIEN
	inner join PHONGBAN on PHONGBAN.MAPHG = NHANVIEN.PHG
	left outer join THANNHAN on THANNHAN.MA_NVIEN = NHANVIEN.MANV
	where THANNHAN.MA_NVIEN is null and TRPHG = @MATP
end
exec bai2_d '008'
-- cau e
create proc bai2_e @MANV varchar(5),@MAPB varchar(5)
as
begin
	if exists(select * from NHANVIEN where MANV = @MANV and PHG = @MAPB)
	print 'NHAN VIEN : '+@MANV +' co trong phong ban : '+@MaPB
else
	print('NHAN VIEN : '+@MANV +' khong co trong phong ban : '+@MaPB
end
exec bai2_e '001'


