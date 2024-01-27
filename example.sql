select * from jc_country_struct where area_id like '__0000000000' and area_id <> ' ';
select * from jc_country_struct where area_id like '02___0000000' and area_id <> '020000000000';
select * from jc_country_struct where area_id like '02001___0000' and area_id <> '020010000000';
select * from jc_country_struct where area_id like '02001001____' and area_id <> '020010010000';
