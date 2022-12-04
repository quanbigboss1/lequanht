
-------------lab6-------
--------------BAI1----
-------CAU 1---------
create trigger Them_NV ON NHANVIEN FOR INSERT AS
IF (SELECT LUONG FROM inserted )< 15000
    BEGIN
		PRINT 'luong phai >15000'
		ROLLBACK TRANSACTION
END
  INSERT INTO NHANVIEN VALUES (N'Nguyễn', N'Công ' , N'Trường', '010' , N'2002/06/26' , N'148 doan van bo , Tp HCM', N'Nam', 100, '005' ,1 )

  ---------------CAU 2---------
create trigger Them_NV2 ON NHANVIEN FOR INSERT AS
DECLARE @age int
set @age =year(getdate())-(select YEAR(NgSinh) from inserted)
if (@age <18 and @age >65)
    BEGIN
		PRINT 'tuoi phai trong khoang 18->65'
		ROLLBACK TRANSACTION
END
  INSERT INTO NHANVIEN VALUES (N'Nguyễn', N'Công' , N'Trường', '011' , N'2010/06/26' , N'148 doan văn bơ, Tp HCM', N'Nam', 100, '005' ,1 )

  ---------------CAU 3---
create trigger update_nv1 ON NHANVIEN FOR UPDATE AS
if (SELECT DChi from inserted)like '%TP.HCM%'
    BEGIN
		PRINT 'Không duoc cap nhat nhan vien ở tphcm'
		ROLLBACK TRANSACTION
	END
UPDATE NHANVIEN SET TENNV ='Trường' where MANV ='004'
select* from NHANVIEN

  ----------------bai 2----------
  --------CAU1-------
create trigger bai2_1  ON NHANVIEN after INSERT AS
BEGIN
select count(case when upper(PHAI)=N'Nam' then 1 end)  Nam,
       count(case when upper(PHAI)=N'Nữ' then 1 end)  NỮ
		from NHANVIEN

END
  INSERT INTO NHANVIEN VALUES (N'Nguyễn', N'Công ' , N'Trường', '018' , N'2002/06/26' , N'148 đoàn văn bơ, Tp HCM', N'Nam', 100, '005' ,1 )
 select* from NHANVIEN
 ------------CAU2----------
create trigger Bai2_2  ON NHANVIEN after UPDATE AS
BEGIN
if update(PHAI)
	begin
		select count(case when upper(PHAI)=N'Nam' then 1 end)  Nam,
       count(case when upper(PHAI)=N'Nữ' then 1 end)  NỮ
		from NHANVIEN
	end
END
  UPDATE NHANVIEN SET PHAI ='Nam' where MANV ='001'
 select* from NHANVIEN

 ---------------CAU3-----------
create trigger bai2_3  ON DEAN after DELETE AS
BEGIN
		SELECT MA_NVIEN,count(MADA) as So_De_An from PHANCONG
		group by MA_NVIEN
END
  delete DEAN where MADA = 5

  ----------Bai3-------------
  -----------Cau1-----------
create trigger Bai3_1  ON NHANVIEN instead of DELETE AS
BEGIN
		delete from THANNHAN WHERE MA_NVIEN IN (SELECT MANV FROM DELETED)
		delete from NHANVIEN WHERE MANV IN (SELECT MANV FROM DELETED)
END
  delete NHANVIEN WHERE MANV ='016'
  -----------Cau2---------- 
create trigger bai3_2  ON NHANVIEN after insert AS
BEGIN
		insert into PHANCONG values((select MANV from inserted),1,1,123)
END
INSERT INTO NHANVIEN VALUES (N'Nguyễn', N'Công ' , N'Trường ', '011' , N'2002/06/26' , N'148 đoàn văn bơ, Tp HCM', N'Nam', 100, '005' ,1 )
  
