/*
Cleaning data in SQL queries
*/

Select * 
From [Portfolio Project].dbo.HousingPrices

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Standarise Date format

Select SaleDate,CONVERT(Date,SaleDate)
From [Portfolio Project].dbo.HousingPrices

Update HousingPrices
Set SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE [Portfolio Project].dbo.HousingPrices
ADD SalesDateConverted Date

Update HousingPrices
Set SalesDateConverted = CONVERT(Date,SaleDate)

Select *
From [Portfolio Project].dbo.HousingPrices


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Populate Property Address Data

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
From [Portfolio Project].dbo.HousingPrices a
JOIN [Portfolio Project].dbo.HousingPrices b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project].dbo.HousingPrices a
JOIN [Portfolio Project].dbo.HousingPrices b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress IS NULL

Select *
From [Portfolio Project].dbo.HousingPrices
where PropertyAddress = NULL

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Breaking out address (Address city,state)

ALTER TABLE  [Portfolio Project].dbo.HousingPrices
ADD PropertySplitAddress VARCHAR(250),
 PropoertCity VARCHAR(250)
 

SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(' ',PropertyAddress)-1) as ADDRESS
 FROM [Portfolio Project].dbo.HousingPrices


 UPDATE [Portfolio Project].dbo.HousingPrices
 SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) ,
     PropoertCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
 FROM [Portfolio Project].dbo.HousingPrices
 
ALTER TABLE  [Portfolio Project].dbo.HousingPrices
ADD OwnerspiltAddress VARCHAR(250),
 Ownercity VARCHAR(250),
 OwnerState VARCHAR(250)

UPDATE [Portfolio Project].dbo.HousingPrices
SET OwnerspiltAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3),
Ownercity = PARSENAME(REPLACE(OwnerAddress,',','.'),2),
OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From [Portfolio Project].dbo.HousingPrices

 Select *
From [Portfolio Project].dbo.HousingPrices


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Change Y or N to Yes or No in "SoldAsVacant"

Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
From [Portfolio Project].dbo.HousingPrices
GROUP BY SoldAsVacant

UPDATE [Portfolio Project].dbo.HousingPrices
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
                        when SoldAsVacant = 'N' then 'No'
						else SoldAsVacant
						end
From [Portfolio Project].dbo.HousingPrices

 Select *
From [Portfolio Project].dbo.HousingPrices


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Remove Duplicates

WITH  RowNumCTE As(
Select *, ROW_NUMBER() Over(
			Partition by ParcelId,
						 Propertyaddress,
						 SalePrice,
						 SaleDate,
						 LegalReference
						 Order by UniqueID)row_num
From [Portfolio Project].dbo.HousingPrices
)
DELETE
From RowNumCTE
where row_num >1
--Order By PropertyAddress


 Select *
From [Portfolio Project].dbo.HousingPrices


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Delete unused columns

ALTER TABLE [Portfolio Project].dbo.HousingPrices
DROP COLUMN PropertyAddress,OwnerAddress,SaleDate,TaxDistrict

 Select *
From [Portfolio Project].dbo.HousingPrices

