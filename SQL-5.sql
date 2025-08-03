create database inputs;
use inputs;

create table inputs(
id int primary key,
content text
);

 create table ai_decisions(
 input_id int,
 decision varchar(10),
 confidence decimal(5,2),
 foreign key(input_id) references inputs(id)
 );
 
 create table human_decisions(
 input_id int,
 decision varchar(10),
 user_id int,
 foreign key(input_id) references inputs(id)
 );
 
 create table evaluation(
 input_id int,
 accuracy_score decimal(5,2),
 decision_match boolean,
 foreign key(input_id) references inputs(id)
 );
 
INSERT INTO inputs VALUES 
(1, 'Loan Request: ₹50,000, Salary: ₹30,000, Age: 30'),
(2, 'Loan Request: ₹10,000, Salary: ₹12,000, Age: 24');

INSERT INTO ai_decisions VALUES 
(1, 'approve', 92.5),
(2, 'reject', 80.0);

INSERT INTO human_decisions VALUES 
(1, 'approve', 101),
(2, 'approve', 102);

insert into evaluation values
(1,95.0,true),
(2,78.0,false);

select * from ai_decisions;
select * from human_decisions;
select * from evaluation;

select 
i.id as input_id,
ai.decision as ai_decisions,
hd.decision as human_decisions,
case
when ai.decision=hd.decision then true
else false
end as decision_match
from inputs i
join ai_decisions ai on i.id=ai.input_id
join human_decisions hd on i.id=hd.input_id;

SELECT 
    ROUND(100.0 * SUM(CASE WHEN decision_match THEN 1 ELSE 0 END) / COUNT(*), 2) AS match_percentage
FROM evaluation;

SELECT 
    ROUND(AVG(confidence), 2) AS avg_confidence
FROM ai_decisions;

SELECT 
    i.id, i.content, ai.decision AS ai_decision, hd.decision AS human_decision
FROM inputs i
JOIN ai_decisions ai ON i.id = ai.input_id
JOIN human_decisions hd ON i.id = hd.input_id
JOIN evaluation e ON i.id = e.input_id
WHERE e.decision_match = FALSE;