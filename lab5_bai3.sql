create proc ThemPhongBanMoi
	@TenPhg nvarchar(20),@MaPhg int,@TrPhg nvarchar(10), @Ng_NhanChuc date
as
begin
	if exists(select * from PHONGBAN where MAPHG = @MAPHG)
	begin
		print('Mã phòng ban đã tồn tại');
		return;
	end

	Insert into [dbo].[PHONGBAN]
		([TENPHG],[MAPHG],[TRPHG],[NG_NHANCHUC]
	Values
		(@TenPhg,@MaPhg,@TenPhg,@Ng_NhanChuc);
end
exec ThemPhongBanMoi 'IT','11','005','2022-11-29'
-------
create proc sp_CapNhatPhongBan
	@OldTenPHG nvarchar(15),
	@TenPHG nvarchar(15),
	@MaPHG int,
	@TRPHG nvarchar(10),
	@NG_NHANCHUC date
as
begin
	UPDATE [dbo].[PHONGBAN]
	SET 
		[TENPHG] =@TENPHG,
		[MAPHG] = @MAPHG,
		[TRPHG] = @TRPHG,
		[NG_NHANCHUC]=@NG_NHANCHUC
		where TENPHG = @OldTenPHG;
end;
exec [dbo].[sp_CapNhatPhongBan] 'CNTT','IT','10','005','1-1-2020'
---------------------------------------------
create proc sp_insertNV @Ho nvarchar(15),@tenNV nvarchar(15),@MaNV nvarchar(9),@NgaySinh datetime,@diachi nvarchar(30),@phai nvarchar(3),@luong float,@Ma_NQL nvarchar(9),@PHG int
as
begin
	if not exists(select * from PHONGBAN where TENPHG like 'IT')
	begin
		print 'NHAN VIEN phai la phong IT'
	return
end
if @luong < 25000
set @Ma_NQL='009'
else
begin
set @Ma_NQL = '005'
end
declare @age int = datediff(YEAR,@ngaySinh,getDate())
if(@phai like 'nam' and @age > 65 and @age <18)
begin
print 'nam phai tu 18 - 65 '
return 
end
else if(@phai like N'Nữ' and @age > 60 and @age < 18)
begin
print 'nu phai tu 18-60'
return 
end
insert into NHANVIEN(HONV,TENLOT,TENNV,MANV,NGSINH,DCHI,PHAI,LUONG,MA_NQL,PHG)
values(@Ho,@tenNV,@MaNV,@NgaySinh,@diachi,@phai,@luong,@Ma_NQL,@PHG)
end
