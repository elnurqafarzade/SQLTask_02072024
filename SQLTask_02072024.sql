Create Database DBAcademy
Use DBAcademy

Create Table Academies 
(
Id int Primary Key identity(1,1),
Name Nvarchar(20) not null
)

Insert into Academies
Values 
('PB201'),
('P236'),
('EL221')

Select * from Academies

Create Table Groups 
(
Id int Primary Key identity(1,1),
Name Nvarchar(20) not null default 'Teyin Edilmeyib',
IsDeleted Bit not null,
AcademyId int foreign key references Academies(Id)
)

Insert into Groups 
Values 
('Programming', 0, 1), 
('Beatmaking', 0, 1), 
('Philosophy', 0, 2), 
('English', 0, 3)

Select * from Groups

Create Table Students 
(
Id int Primary Key identity(1,1),
Name Nvarchar(20) not null default 'Teyin Edilmeyib',
Surname Nvarchar(20) not null default 'Teyin Edilmeyib', 
Age int not null,
Adulthood bit,
GroupId int foreign key references Groups(Id)
)

Insert into Students 
Values 
('Inal', 'Guliyev', 24, 1, 1),
('Elcan', 'Shalanov', 22, 1, 1),
('Elnur', 'Rzaev', 20, 1, 4),
('Elnur', 'Bagishov', 21, 1, 3),
('Salahaddin', 'Sahbazov', 17, 0, 2),
('Uzay', 'Mental', 17, 0, 2),
('Ruzi', 'Qafarov', 24, 1, 3)

Select * from Students

Create Table DeletedStudents 
(
Id int,
Name Nvarchar(20),
Surname Nvarchar(20),
GroupId int
)

Create Table DeletedGroups 
(
Id int,
Name Nvarchar(20),
AcademyId int
)



Create view Akademiya as
Select Id, Name from Academies

Create view Qruplar as Select Id, Name, IsDeleted, AcademyId from Groups

Create view Telebeler as Select Id, Name, Surname, Age, Adulthood, GroupId from Students


Create Procedure VerilenAddaQrup 
@Ad Nvarchar(100) as
Select Id, Name, IsDeleted, AcademyId
from Groups
Where Name = @Ad

Create Procedure VerilenYasdanBoyuk
@Yas int as
Select Id, Name, Surname, Age, Adulthood, GroupId
from Students
Where Age > @Yas

Create Procedure VerilenYasdanKicik
@Yas int as
Select Id, Name, Surname, Age, Adulthood, GroupId
fROM Students
Where Age < @Yas

Create Trigger TR_DeleteStudents on Students
for Delete
as
Insert into DeletedStudents (Id, Name, Surname, GroupId)
Select Id, Name, Surname, GroupId from deleted

Create Trigger trg_Students_UpdateAge
on Students
After Update as
Begin
    if Update(Age)
Begin
    Update Students
        Set Adulthood = Case When Age >= 18 Then 1 Else Adulthood end
        Where Id IN (Select Id from inserted)
    End
End


Create Trigger TR_DeleteGroups on Groups
Instead of Delete
as
Update Groups
Set IsDeleted = 1
Where Id = (Select Id from deleted)


Create Trigger TR_AutoUpdate on Students
After Insert as

Update Students
Set Adulthood = Case When Age >= 18 Then 1 Else 0 end
Where Id = (Select Id from inserted)

Create Function GroupTableToId (@GroupId int)
Returns Table as Return
(
Select Id, Name, Surname, Age, Adulthood from Students
Where GroupId = @GroupId
)

Create Function GroupTableToAcademyId(@AcademyId int)
Returns Table as Return
(
Select Id, Name, IsDeleted from Groups
Where AcademyId = @AcademyId
)


