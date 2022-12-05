-- cau 1a
select YEAR(getDate())-YEAR(NGSINH) as N'Tuổi' from NHANVIEN where MANV = '001'
if OBJECT_ID('fn_TuoiNV') is not null
	drop function fn_TuoiNV
go
create function fn_TuoiNV(@MaNV char(4))
returns int
as
	begin
	return(select YEAR(getdate())-YEAR(NGSINH) as N'Tuổi'
		from NHANVIEN where MANV = @MaNV)
	end
print N'Tuổi nhân viên: '+cast(dbo.fn_TuoiNV('001')as varchar(5))
-- cau 1b
select Ma_NVien,COUNT(MADA) from PHANCONG
group by MA_NVIEN
select COUNT(MADA) from PHANCONG where MA_NVIEN = '004'
if OBJECT_ID('fn_DemDeAnNV') is not null
	drop function fn_DemDeAnMV
go
create function fn_DemDeAnNV(@MaNV varchar(9))
returns int
as
	begin
		return(select COUNT(MADA) from PHANCONG where MA_NVIEN = @MaNV)
	end
print 'So du an nhan vien da lam '+convert(varchar,dbo.fn_DemDeAnNV('004'))
--cau 1c
select * from NHANVIEN
select COUNT(*) from NHANVIEN where PHAI like 'Nam'
select COUNT(*) from NHANVIEN where PHAI like N'Nữ'
create function fn_DemNV_Phai(@Phai nvarchar(5) = N'%')
returns int
as
	begin
		return(select count(*) from NHANVIEN where PHAI like @Phai)
	end
print 'Nhan vien Nam :'+convert(varchar,dbo.fn_DemNV_Phai('Nam'))
print 'Nhan vien Nu :'+convert(varchar,dbo.fn_DemNV_Phai(N'Nữ'))
-- cau 1d
select PHG,TENPHG, AVG(Luong) from NHANVIEN
inner join PHONGBAN on PHONGBAN.MAPHG = NHANVIEN.PHG
group by PHG,TENPHG

select AVG(Luong) from NHANVIEN
inner join PHONGBAN on PHONGBAN.MAPHG = NHANVIEN.PHG
where TENPHG = 'IT'

if OBJECT_ID('fn_Luong_NhanVien_PB') is not null
	drop function fn_Luong_NhanVien_PB
go
create function fn_Luong_NhanVien_PB(@TenPhongBan nvarchar(20))
returns @tbLuongNV table(fullname nvarchar(50),luong float)
as
	begin
		declare @LuongTB float
		select @LuongTB = AVG(LUONG) from NHANVIEN
		inner join PHONGBAN on PHONGBAN.MAPHG = NHANVIEN.PHG
		where TENPHG = 'IT'
		--print 'Luong Trung Binh:'+convert(nvarchar,@LuongTB)
		--insert vao table
		insert into @tbLuongNV
			select HONV +' '+TENLOT+' '+TENNV, LUONG from NHANVIEN
			where LUONG > @LuongTB
		return
	end
select * from dbo.fn_Luong_NhanVien_PB('IT')
-- câu 1e
select TENPHG,TRPHG,HONV+' '+TENLOT+' 'TENNV as 'Ten Truong Phong',COUNT(MADA) as 'SoLuongDeAn'
from PHONGBAN
inner join DEAN on DEAN.PHONG = PHONGBAN.MAPHG
inner join NHANVIEN on NHANVIEN.MANV = PHONGBAN.TRPHG
where PHONGBAN.MAPHG = '001'
group by TENPHG,TRPHG,TENNV,HONV,TENLOT
if OBJECT_ID('fn_SoLuongDeAnTheoPB') is not null
	drop function fn_SoLuongDeAnTheoPB
go
create function fn_SoLuongDeAnTheoPB(@MaPB int)
returns @tbListPB table(TenPB nvarchar(20),MaTB nvarchar(10),TenTP nvarchar(50),SoLuong int)
as
begin
	insert into @tbListPB
	select TENPHG,TRPHG,HONV+' '+TENLOT+' '+TENNV as 'Ten Truong Phong',COUNT(MADA) as 'SoLuongDeAn'
		from PHONGBAN
		inner join DEAN on DEAN.PHONG = PHONGBAN.MAPHG
		inner join NHANVIEN on NHANVIEN.MANV = PHONGBAN.TRPHG
		where PHONGBAN.MAPHG = '001'
		group by TENPHG,TRPHG,TENNV,HONV,TENLOT
	return
end
select * from dbo.fn_SoLuongDeAnTheoPB(1)
---- cau 2a
select HONV,TENNV,TENPHG,DIADIEM from PHONGBAN
inner join DIADIEM_PHG on DIADIEM_PHG.MAPHG = PHONGBAN.MAPHG
inner join NHANVIEN on NHANVIEN.PHG = PHONGBAN.MAPHG

create view v_DD_PhongBan
as
select HONV,TENNV,TENPHG,DIADIEM from PHONGBAN
inner join DIADIEM_PHG on DIADIEM_PHG.MAPHG = PHONGBAN.MAPHG
inner join NHANVIEN on NHANVIEN.PHG = PHONGBAN.MAPHG

select * from v_DD_PhongBan
------ cau 2b
select TENNV,LUONG,YEAR(GETDATE())-YEAR(NGSINH)) as 'Tuoi' from NHANVIEN
create view v_TuoiNV
as
select TENNV,LUONG,YEAR(GETDATE()-YEAR(NGSINH)) as 'Tuoi' from NHANVIEN
select * from v_TuoiNV
------- cau 2c
CREATE VIEW PhongBanDN
as
select a.TENPHG,b.HONV+' '+b.TENLOT+' '+b.TENNV as 'TenTruongPhong'
from PHONGBAN a inner join NHANVIEN b on a.TRPHG = b.MANV
where a.MAPHG in (select PHG from NHANVIEN
		          group by phg having count (manv)=(select top 1 count (manv) as NVCount from NHANVIEN
				  group by phg
				 order by NVCount desc))
select* from PhongBanDN