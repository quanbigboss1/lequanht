--Câu a
create procedure bai1_a @name nvarchar(20)
as 
begin
	print'xin chào : ' +@name
	end;
exec bai1_a N'Quân'

--Câu b
create procedure bai1_b @a int,@b int
as
begin
	declare @tong int = 0
	set @tong = @a + @b
	print @tong
	end
exec bai1_b 4,5
--Câu c
create procedure bai1_c @n int 
as
begin
	declare @tong int = 0 , @i int = 0
	while @i<@n
		begin
			set @tong = @tong + @i
			set @i = @i+ 2
		end
	print @tong
	end

exec bai1_c 10

--Câu d
create procedure bai1_d @a int ,@b int 
as
begin
	
	while (@a != @b)
		begin
			if (@a > @b)
				set	@a  = @a - @b
			else 
				set @b = @b - @a
		end
		return @a	
end


declare @c int
exec @c = bai1_d 30,40
print @c 
