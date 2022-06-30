/*
Data Cleaning

Skills Used: Alter-Update Statements, Case Statement, Aggregate Functions, Joins, Windows Functions, CTEs, Convert Data Types

*/

-- Standardize data format

SELECT  *
FROM PortfolioProject..NashvilleHousing

-- Standardize date Format
-- Changing date from time - date format to date format

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

Update PortfolioProject..NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)



-- Populate Property Address Data

SELECT PropertyAddress, ParcelID
FROM PortfolioProject..NashvilleHousing
--WHERE PropertyAddress IS NULL

SELECT  tab1.ParcelID, tab1.PropertyAddress, tab2.ParcelID, tab2.PropertyAddress, ISNULL(tab1.PropertyAddress,tab2.PropertyAddress)
FROM PortfolioProject..NashvilleHousing tab1
JOIN PortfolioProject..NashvilleHousing tab2
ON tab1.ParcelID = tab2.ParcelID
AND tab1.[UniqueID ] <> tab2.[UniqueID ]
WHERE tab1.PropertyAddress IS NULL
   --To Update PropertyAddress NULL values 
Update tab1
SET PropertyAddress = ISNULL(tab1.PropertyAddress,tab2.PropertyAddress)
FROM PortfolioProject..NashvilleHousing tab1
JOIN PortfolioProject..NashvilleHousing tab2
ON tab1.ParcelID = tab2.ParcelID
AND tab1.[UniqueID ] <> tab2.[UniqueID ]
WHERE tab1.PropertyAddress IS NULL



-- Breaking Address column into Address, City and State Columns
 
   -- Dividing Property Address column into two columns - Address and City

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing

SELECT PropertyAddress, 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+2,LEN(PropertyAddress)) AS City
FROM PortfolioProject..NashvilleHousing
   
    -- Creating a col for address and storing address data
ALTER TABLE NashvilleHousing
ADD PropertyAddress_split NVARCHAR(255);

--ALTER TABLE NashvilleHousing
--DROP COLUMN PropertyAddress_split

Update PortfolioProject..NashvilleHousing
SET PropertyAddress_split = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

    -- Creating a col for City and storing city data
ALTER TABLE NashvilleHousing
ADD PropertyCity_split NVARCHAR(255);

Update PortfolioProject..NashvilleHousing
SET PropertyCity_split = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+2,LEN(PropertyAddress))

SELECT Top 10 *
FROM PortfolioProject..NashvilleHousing

   -- Dividing Owner address column into Address, City and State columns

SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing

SELECT OwnerAddress, PARSENAME(REPLACE(OwnerAddress,',','.'),3) AS Address,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) AS City,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) AS State
FROM PortfolioProject..NashvilleHousing

       -- Creating a col for address and storing address data
ALTER TABLE NashvilleHousing
ADD OwnerAddress_split NVARCHAR(255);

Update PortfolioProject..NashvilleHousing
SET OwnerAddress_split = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

       -- Creating a col for city and storing city data
ALTER TABLE NashvilleHousing
ADD OwnerCity_split NVARCHAR(255);

Update PortfolioProject..NashvilleHousing
SET OwnerCity_split = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

       -- Creating a col for state and storing state data
ALTER TABLE NashvilleHousing
ADD OwnerState_split NVARCHAR(255);

Update PortfolioProject..NashvilleHousing
SET OwnerState_split = PARSENAME(REPLACE(OwnerAddress,',','.'),1)



-- Change Y and N to Yes and No in Sold As Vacant column

SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant

SELECT SoldAsVacant,
 CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM PortfolioProject..NashvilleHousing

Update PortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END


-- Remove duplicates 

SELECT *,
ROW_NUMBER() OVER (PARTITION BY ParcelID, Propertyaddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) AS row_num
FROM PortfolioProject..NashvilleHousing
ORDER BY ParcelID

WITH rownum AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY ParcelID, Propertyaddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) AS row_num
FROM PortfolioProject..NashvilleHousing
--ORDER BY ParcelID
)

SELECT *
FROM rownum
WHERE row_num > 1

--DELETE 
--FROM rownum
--WHERE row_num > 1



-- Delete unused columns


SELECT *
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, SaleDate