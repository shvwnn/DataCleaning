SELECT *
FROM airbnb_open_data;

-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null Values and Blank Values 
-- 4. Remove unneeded columns 


CREATE TABLE airbnb_staging
LIKE airbnb_open_data;

SELECT *
FROM airbnb_staging;

INSERT airbnb_staging
SELECT * 
FROM airbnb_open_data;

SELECT `NAME`
FROM airbnb_staging
ORDER BY 1;

SELECT DISTINCT country
FROM airbnb_staging;

SELECT *
FROM airbnb_staging 
WHERE `country` LIKE '';

UPDATE airbnb_staging
SET country = 'United States'
WHERE country = '';

SELECT *
FROM airbnb_staging 
WHERE `country code` LIKE '';

SELECT `country code`
FROM airbnb_staging;

UPDATE airbnb_staging
SET `country code` = 'US'
WHERE `country code` = '';


SELECT DISTINCT `neighbourhood`
FROM airbnb_staging
ORDER BY 1;

UPDATE airbnb_staging
SET `neighbourhood` = 'Dumbo'
WHERE `neighbourhood` = 'DUMBO';


SELECT DISTINCT `neighbourhood group`
FROM airbnb_staging
ORDER BY 1;

UPDATE airbnb_staging
SET `neighbourhood group` = 'Brooklyn'
WHERE `neighbourhood group` = 'brookln';

UPDATE airbnb_staging
SET `neighbourhood group` = 'Manhattan'
WHERE `neighbourhood group` = 'manhatan';

UPDATE airbnb_staging
SET `neighbourhood` = 'Dumbo'
WHERE `neighbourhood` = 'DUMBO';

SELECT `neighbourhood group`,`neighbourhood`,lat,`long`
FROM airbnb_staging
WHERE `neighbourhood` = 'Clinton Hill'
;

UPDATE airbnb_staging
SET `neighbourhood group` = 'Brooklyn'
WHERE `neighbourhood` = 'Clinton Hill';

UPDATE airbnb_staging
SET `neighbourhood group` = 'Brooklyn'
WHERE `neighbourhood` = 'Williamsburg';

UPDATE airbnb_staging
SET `neighbourhood group` = 'Manhattan'
WHERE `neighbourhood` = 'East Village';

SELECT `neighbourhood group`,`neighbourhood`
FROM airbnb_staging;

SELECT DISTINCT `host id`,host_identity_verified, `host name`
FROM airbnb_staging
order by 1;

UPDATE airbnb_staging
SET `minimum nights` = 1
WHERE `minimum nights` = -10;


ALTER TABLE airbnb_staging
DROP Column `license`
;

SELECT `last review`,
STR_TO_DATE(`last review`,'%m/%d/%Y')
FROM airbnb_staging;

UPDATE airbnb_staging
SET `last review` = STR_TO_DATE(`last review`,'%m/%d/%Y')
WHERE `last review` IS NOT NULL;
;

SELECT price
FROM airbnb_staging;

UPDATE airbnb_staging
SET `last review` = NULL 
WHERE `last review` = '';

SELECT DISTINCT price, TRIM(TRAILING'' FROM price)
FROM airbnb_staging
ORDER BY 1;
----------------------------------

SELECT `availability 365`
FROM airbnb_staging
WHERE `availability 365` > 365;

UPDATE airbnb_staging
SET `availability 365` = 365
WHERE `availability 365` > 365;

SELECT *
FROM airbnb_staging
WHERE `availability 365` < 0;

SELECT AVG(`minimum nights`) 
FROM airbnb_staging;

SELECT house_rules
FROM airbnb_staging;

SELECT DISTINCT house_rules, TRIM(LEADING' ' FROM house_rules)
FROM airbnb_staging
ORDER BY 1;

UPDATE airbnb_staging
SET house_rules = TRIM(LEADING'-' FROM house_rules);

UPDATE airbnb_staging
SET house_rules = TRIM(LEADING' ' FROM house_rules);

SELECT * 
FROM airbnb_staging;

ALTER TABLE airbnb_staging
RENAME column Listing TO listing_name;

ALTER TABLE airbnb_staging
RENAME column Host_ID TO host_id;

ALTER TABLE airbnb_staging
RENAME column `host name` TO host_name;

ALTER TABLE airbnb_staging
RENAME column `service fee` TO service_fee;

ALTER TABLE airbnb_staging
RENAME column `neighbourhood group` TO neighborhood_group;
ALTER TABLE airbnb_staging
RENAME column `neighbourhood` TO neighborhood;

ALTER TABLE airbnb_staging
DROP COLUMN `country code`;



UPDATE airbnb_staging
SET service_fee = REPLACE(service_fee, '$', '');

UPDATE airbnb_staging AS a
JOIN airbnb_open_data AS b ON a.id = b.id
SET a.service_fee = b.`service fee`;

ALTER TABLE airbnb_staging
MODIFY COLUMN service_fee DECIMAL (10,2);



UPDATE airbnb_staging
SET service_fee = NULL
WHERE service_fee = '';

ALTER TABLE airbnb_staging
MODIFY COLUMN `price` DECIMAL (10,2);

UPDATE airbnb_staging
SET price = NULL
WHERE price = '';

SELECT neighborhood TRI
FROM airbnb_staging;

SELECT DISTINCT neighborhood, TRIM(TRAILING' ' FROM neighborhood)
FROM airbnb_staging
ORDER BY 1;

UPDATE airbnb_staging
SET neighborhood_group = TRIM(TRAILING' ' FROM neighborhood_group);

ALTER TABLE airbnb_staging
RENAME COLUMN min_nights TO minimum_nights;

ALTER TABLE airbnb_staging 
CHANGE COLUMN `minimum_nights` min_nights INT;

ALTER TABLE airbnb_staging 
CHANGE COLUMN `availability 365` days_available INT;

ALTER TABLE airbnb_staging
RENAME COLUMN `reviews per month` TO reviews_a_month;

ALTER TABLE airbnb_staging
RENAME COLUMN `room type` TO room_type;

ALTER TABLE airbnb_staging
RENAME COLUMN `Construction year` TO year_built;

ALTER TABLE airbnb_staging
RENAME COLUMN `number of reviews` TO total_reviews;

ALTER TABLE airbnb_staging
RENAME COLUMN `last review` TO last_review_date;

ALTER TABLE airbnb_staging
RENAME COLUMN `review rate number` TO average_rating;

ALTER TABLE airbnb_staging
RENAME COLUMN `calculated host listings count` TO host_listing_count;

ALTER TABLE airbnb_staging
modify column reviews_a_month INT;


UPDATE airbnb_staging
SET availability_365 = NULL
WHERE availability_365 ='';

UPDATE airbnb_staging
SET instant_bookable = lower(instant_bookable);

SELECT * 
FROM airbnb_staging;

UPDATE airbnb_staging
SET reviews_a_month = 0
WHERE reviews_a_month IS NULL;



