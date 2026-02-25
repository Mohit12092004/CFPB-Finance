show databases;
SHOW VARIABLES LIKE 'secure_file_priv';
USE project;

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

CREATE TABLE complaints_data (
    date_received DATE,
    product VARCHAR(150),
    sub_product VARCHAR(150),
    issue VARCHAR(255),
    sub_issue VARCHAR(255),
    company VARCHAR(200),
    state VARCHAR(10),
    tags VARCHAR(150),
    company_response_to_consumer VARCHAR(255),
    timely_response INT,
    complaint_id BIGINT PRIMARY KEY,
    processing_delay_days INT,
    month VARCHAR(20),
    year INT
);
SHOW VARIABLES LIKE 'secure_file_priv';
alter table complaints_data modify state varchar(40);

select @@secure_file_priv;
USE project;

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Project_2_updated.csv'
INTO TABLE complaints_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@date_received, product, sub_product, issue, sub_issue, company, state, tags,
 company_response_to_consumer, timely_response, complaint_id,
 processing_delay_days, month, year)
SET date_received = STR_TO_DATE(@date_received, '%m/%d/%Y');


# State is unkown
select product,company,count(complaint_id) as total_complaints 
from complaints_data where state="None" 
group by product,company order by total_complaints DESC limit 6;

#Top issue complaints%
select company,issue,round(count(complaint_id)/228697*100,2) as Complaint_Percentage
from complaints_data 
group by company,issue,timely_response,processing_delay_days
order by Complaint_Percentage DESC limit 7;

select issue,round(count(complaint_id)/228697*100,2) as Complaint_Percentage
from complaints_data 
group by issue order by Complaint_Percentage desc limit 5;



select company,issue,count(complaint_id) as Complaint_count
from complaints_data
group by company,issue order by Complaint_count desc limit 20;


# Maximum Complaints by state
select product,state,company,count(complaint_id) as Total_Complaints
from complaints_data where state<> "None" 
group by product,state,company
order by Total_Complaints DESC limit 6;

#Total complaints
select count(complaint_id) from complaints_data;

#Total timely responded 
select count(timely_response) from complaints_data where timely_response=1;

select processing_delay_days from complaints_data;


select count(complaint_id) from complaints_data where state="None";

#Managin an account issue 
select issue ,company,count(complaint_id) as total_complaints from complaints_data 
where issue="Managing an account" group by issue,company 
order by total_complaints DESC limit 5;


#Checking the highest processing delays 
select avg(processing_delay_days) as Avg_delays,company,issue,count(complaint_id) from complaints_data 
where tags="Older American" 
group by company,issue 
having count(complaint_id)>=50
order by Avg_delays
 DESC limit 5;
select * from complaints_sata;



