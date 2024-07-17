Select *
From [Portfolio Projects].[dbo].[Student Background]

Select *
From [Portfolio Projects].[dbo].[Student Education]

Select *
From [Portfolio Projects].[dbo].[Student Performance Data]

--Looking at GPA vs StudyTimeWeekly
--Shows reflection of GPA based on time spent studying

Select StudyTimeWeekly, Absences, Tutoring, Extracurricular, GPA, (GPA/StudyTimeWeekly) as StudyRate
From [Portfolio Projects].[dbo].[Student Education]
where GPA > 3.0
order by 5

--Looking at GPA vs Absenses
--Shows reflection of GPA based on Attendance (Higher the attendance rate, the worse the attendance)

Select StudyTimeWeekly, Absences, Tutoring, Extracurricular, GPA, (Absences/GPA) as AttendanceRate
From [Portfolio Projects].[dbo].[Student Education]
where GPA > 3.0
order by 5

--Looking at Students who are most studious based on Tutoring

Select StudyTimeWeekly, Tutoring, MAX(GPA) as HighestGPACount, MAX((Tutoring*GPA)) as MostStudious
From [Portfolio Projects].[dbo].[Student Education]
--where GPA > 3.0
Group by StudyTimeWeekly, Tutoring
order by MostStudious desc

--Showing Students with the Highest Study Rate per GPA

Select StudyTimeWeekly, MAX(GPA) as TotalStudyCount
From [Portfolio Projects].[dbo].[Student Education]
--where GPA > 3.0
Group by StudyTimeWeekly
order by TotalStudyCount desc


--LET'S BREAK THINGS DOWN BY TUTORING

Select Tutoring, MAX(GPA) as TotalStudyCount
From [Portfolio Projects].[dbo].[Student Education]
--where GPA > 3.0
Group by Tutoring
order by TotalStudyCount desc

--Showing Tutoring with HighestGPACount

Select Tutoring, MAX(GPA) as TotalStudyCount
From [Portfolio Projects].[dbo].[Student Education]
--where GPA > 3.0
Group by Tutoring
order by TotalStudyCount desc




--Looking at Number of Students vs HighGPA

Select *
From [Portfolio Projects].[dbo].[Student Background] Bkgd
Join [Portfolio Projects].[dbo].[Student Performance Data] Pfmc
    On Bkgd.Age = Pfmc.Age
	and Bkgd.Ethnicity = Pfmc.Ethnicity

Select Bkgd.StudentID, Bkgd.Ethnicity, Pfmc.ParentalSupport, Pfmc.GPA
, SUM(Pfmc.ParentalSupport) OVER (Partition by bkgd.Ethnicity) as BackgroundEffect
--, (ParentalSupport/BackgroundEffect)*100
From [Portfolio Projects].[dbo].[Student Background] Bkgd
Join [Portfolio Projects].[dbo].[Student Performance Data] Pfmc
    On Bkgd.Age = Pfmc.Age
	and Bkgd.Ethnicity = Pfmc.Ethnicity
order by 2,3



--USE CTE

With StuNumvsGPA (StudentID, Ethnicity, ParentalSupport, GPA, BackgroundEffect)
as 
(
Select Bkgd.StudentID, Bkgd.Ethnicity, Pfmc.ParentalSupport, Pfmc.GPA
, SUM(Pfmc.ParentalSupport) OVER (Partition by bkgd.Ethnicity) as BackgroundEffect
--, (ParentalSupport/BackgroundEffect)*100
From [Portfolio Projects].[dbo].[Student Background] Bkgd
Join [Portfolio Projects].[dbo].[Student Performance Data] Pfmc
    On Bkgd.Age = Pfmc.Age
	and Bkgd.Ethnicity = Pfmc.Ethnicity
--order by 2,3
)
Select *, (ParentalSupport/BackgroundEffect)*100
From StuNumvsGPA

-- TEMP TABLE

--DROP Table if exists #PercentHighestGPA
Create Table #PercentHighestGPA
(
StudentID nvarchar(255),
Ethnicity nvarchar (255),
ParentalSupport nvarchar(255),
GPA numeric,
BackgroundEffect numeric
)

Insert into #PercentHighestGPA
Select Bkgd.StudentID, Bkgd.Ethnicity, Pfmc.ParentalSupport, Pfmc.GPA
, SUM(Pfmc.ParentalSupport) OVER (Partition by bkgd.Ethnicity) as BackgroundEffect
--, (ParentalSupport/BackgroundEffect)*100
From [Portfolio Projects].[dbo].[Student Background] Bkgd
Join [Portfolio Projects].[dbo].[Student Performance Data] Pfmc
    On Bkgd.Age = Pfmc.Age
	and Bkgd.Ethnicity = Pfmc.Ethnicity

Select *, (ParentalSupport/BackgroundEffect)*100
From #PercentHighestGPA



Select * from [Portfolio Projects].[dbo].[Student Background];

Create View [Age Background] AS
Select StudentID, Age
from [Portfolio Projects].[dbo].[Student Background]
where Age = '15'

Select * from [Age Background]

Create View [Ethnic Background] AS
Select StudentID, Ethnicity
from [Portfolio Projects].[dbo].[Student Background]
where Ethnicity = '2'

Select * from [Ethnic Background]
Select * from [Age Background]

DROP VIEW [Age Background]

