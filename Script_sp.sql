USE [Mock]
GO
/****** Object:  StoredProcedure [dbo].[GetCustomerList]    Script Date: 5/8/2018 8:03:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Exec GetCustomerList 1,1000,0
ALTER PROCEDURE [dbo].[GetCustomerList]	
	@PageIndex INT, -- Page no
	@PageSize INT, -- 10 records per page
	@TotalRecords INT OUTPUT -- Server side 0
AS
BEGIN
	DECLARE @FirstRec INT
	DECLARE @LastRec INT  
	DECLARE @Sql NVARCHAR(MAX)
	DECLARE @Query NVARCHAR(MAX)
	
	SET @Query='SELECT @TotalRecords = COUNT(1) FROM DEMO 
INNER JOIN CART 
ON DEMO.ID = CART.CART_ID '
--GROUP BY
--DEMO.NAME,DEMO.ADDRESS,DEMO.EMAIL,DEMO.PHONE,CART.CART_ID ' ---+ @WhereClause 
	EXEC sp_executesql @Query, N'@TotalRecords INT OUTPUT', @TotalRecords OUTPUT;

	IF @PageIndex = -1
		BEGIN
		   SET @FirstRec = 0 
		   SET @LastRec = @TotalRecords
		END 
	ELSE IF @PageSize > 0 		
		BEGIN
			SET @FirstRec = ( @PageIndex - 1 ) * @PageSize  
			SET @LastRec =  @PageSize 		
		END
	IF @LastRec = 0  
		BEGIN
			SET @LastRec =  1
		END

	IF(@LastRec<0)
		BEGIN
			SET @Sql='SELECT CART.CART_ID,DEMO.NAME,DEMO.ADDRESS,DEMO.EMAIL,DEMO.PHONE,COUNT(CART.QUANTITY) AS TOTAL_QUANTITY, SUM(CART.TOTAL) AS TOTAL_PRICE
					FROM DEMO 
					INNER JOIN CART 
					ON DEMO.ID = CART.CART_ID  
					GROUP BY
					DEMO.NAME,DEMO.ADDRESS,DEMO.EMAIL,DEMO.PHONE,CART.CART_ID'
		END
	ELSE
		BEGIN
			SET @Sql='SELECT CART.CART_ID,DEMO.NAME,DEMO.ADDRESS,DEMO.EMAIL,DEMO.PHONE,COUNT(CART.QUANTITY) AS TOTAL_QUANTITY, SUM(CART.TOTAL) AS TOTAL_PRICE
					FROM DEMO 
					INNER JOIN CART 
					ON DEMO.ID = CART.CART_ID  
					GROUP BY
					DEMO.NAME,DEMO.ADDRESS,DEMO.EMAIL,DEMO.PHONE,CART.CART_ID ORDER BY CART.CART_ID' +
			' OFFSET ' + CAST(@FirstRec AS NVARCHAR(10)) +
			' ROWS FETCH NEXT ' + CAST(@LastRec AS NVARCHAR(10)) + ' ROWS ONLY '
		END
		---print(@Sql)
		---print(@TotalRecords)
	EXEC (@Sql) 		
END
