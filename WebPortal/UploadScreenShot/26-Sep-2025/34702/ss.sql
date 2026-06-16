

Select * from Login Where Username IN( 'tyo','CHJ','GDK')


select Code, Type, Count(Type) as Cnt, Version  FROM dbo.StampPaperDetails
Where Type In ('Agreement')--, 'Addendum', 'ClientList')
Group By Type , Code, Version
Order By Cnt, Type, code


	Select Distinct Version From dbo.StampPaperDetails Where   Type In ('ClientList')
    
	Select * From dbo.StampPaperDetails Where  Code = 'ICG'  and  Type In ('Agreement')  --and Code = 'ICG'  And    order BY Type, Version  And Type In ('Addendum')   -- order BY Type desc and Type In ('Agreement')

	select * from StampPaperClause where Code='ICG'  order BY AddedDate desc

	--Delete  From dbo.StampPaperDetails Where StampID IN (6562)  Code = 'ICG' and Type In ('Agreement')
