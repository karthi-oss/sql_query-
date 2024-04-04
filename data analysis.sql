-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company and age greater than 18 and termdate is 0000:00:00?

       select gender,count(gender) from hr
       where age >= 18 and termdate ='0000:00:00'
       group by gender;
       
       
-- 2. What is the race breakdown of employees in the company?
       
       select race,count(*) as count from hr  
       where age >= 18 and termdate = '0000:00:00'
       group by race
       order by count desc;
-- 3. What is the age distribution of employees in the company?
		select min(age) as young,max(age) as old from hr
        where age >= 18 ;
        
select 
		case
			    when age >= 18 and age <= 24 then '18-24'
                when age >=25 and age <= 34 then '25-34'
                when age >=35 and age <=44 then '35-44'
                when age >=45 and age <= 54 then '45-54'
                when age >=55 and age <= 64 then '55-64'
                else '65+'
                end as age_group, gender,count(*) as count
                from hr
                where age >= 18
                group by age_group,gender
                order by age_group,gender;
                
                

-- 4. How many employees work at headquarters versus remote locations?
			select location,count(*) as count from hr 
            where age >= 18
            group by location;
            
-- 5. What is the average length of employment for employees who have been terminated?
				SELECT ROUND(AVG(DATEDIFF(termdate, hire_date))/365,0) AS avg_length_of_employment FROM hr
				WHERE termdate <> '0000-00-00' AND termdate <= CURDATE() AND age >= 18;
-- 6. How does the gender distribution vary across departments and job titles?
				SELECT department, gender, COUNT(*) as count
				FROM hr
				WHERE age >= 18
				GROUP BY department, gender
				ORDER BY department;

-- 7. What is the distribution of job titles across the company?
					SELECT jobtitle,department, COUNT(*) as count
					FROM hr
					WHERE age >= 18
					GROUP BY jobtitle,department
					ORDER BY jobtitle DESC;
                    select * from hr;

-- 8. Which department has the highest turnover rate?

	SELECT department, COUNT(*) as total_count, 
    SUM(CASE WHEN termdate <= CURDATE() AND termdate <> '0000-00-00' THEN 1 ELSE 0 END) as terminated_count, 
    SUM(CASE WHEN termdate = '0000-00-00' THEN 1 ELSE 0 END) as active_count,
    (SUM(CASE WHEN termdate <= CURDATE() THEN 1 ELSE 0 END) / COUNT(*)) as termination_rate
		FROM hr
		WHERE age >= 18
		GROUP BY department
		ORDER BY termination_rate DESC;
-- 9. What is the distribution of employees across locations by city and state?

			SELECT location_state, COUNT(*) as count
			FROM hr
			WHERE age >= 18
			GROUP BY location_state
			ORDER BY count DESC;
-- 10. How has the company's employee count changed over time based on hire and term dates?
	SELECT 
    YEAR(hire_date) AS year, 
    COUNT(*) AS hires, 
    SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations, 
    COUNT(*) - SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS net_change,
    ROUND(((COUNT(*) - SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END)) / COUNT(*) * 100),1) AS net_change_percent
FROM 
    hr
WHERE age >= 18
GROUP BY 
    YEAR(hire_date)
ORDER BY 
    YEAR(hire_date) ASC;
-- 11. What is the tenure distribution for each department?

SELECT department, ROUND(AVG(DATEDIFF(CURDATE(), termdate)/365),0) as avg_tenure
FROM hr
WHERE termdate <= CURDATE() AND termdate <> '0000-00-00' AND age >= 18
GROUP BY department