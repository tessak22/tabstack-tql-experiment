-- Self-describing table: booleans from the extraction schema, numeric sizes, an approximate date.
-- extract.json returns null instead of false for booleans, so coalesce them.
set variable extracted_on = date '2026-10-20';
create temp table raw as select unnest(models) m from read_json('library-v2.json', maximum_object_size = 50000000);
create temp table sizes as
select m.name, case when t like '%m' then try_cast(rtrim(t, 'm') as double) / 1000 else try_cast(rtrim(t, 'b') as double) end as billions
from (select m, unnest(coalesce(m.size_tags, [])) t from raw);
create or replace table models as
select m.name, m.description,
  coalesce(m.supports_tools, false) as supports_tools,
  coalesce(m.supports_vision, false) as supports_vision,
  coalesce(m.supports_thinking, false) as supports_thinking,
  coalesce(m.is_embedding_model, false) as is_embedding_model,
  coalesce(m.is_cloud_model, false) as is_cloud_model,
  (select min(billions) from sizes s where s.name = m.name) as smallest_size_billions_of_params,
  (select max(billions) from sizes s where s.name = m.name) as largest_size_billions_of_params,
  m.size_tags,
  cast(round(case
    when m.pulls_label like '%B' then cast(rtrim(m.pulls_label, 'B') as double) * 1e9
    when m.pulls_label like '%M' then cast(rtrim(m.pulls_label, 'M') as double) * 1e6
    when m.pulls_label like '%K' then cast(rtrim(m.pulls_label, 'K') as double) * 1e3
    else try_cast(replace(m.pulls_label, ',', '') as double) end) as bigint) as total_pulls,
  m.tag_count,
  cast(getvariable('extracted_on') - (case
    when m.updated_label like '%hour%' or m.updated_label like '%minute%' then 0
    when m.updated_label like 'yesterday%' then 1
    else coalesce(try_cast(regexp_extract(m.updated_label, '(\d+)', 1) as int), 1) * case
      when m.updated_label like '%day%' then 1 when m.updated_label like '%week%' then 7
      when m.updated_label like '%month%' then 30 when m.updated_label like '%year%' then 365 end
    end) * interval 1 day as date) as last_updated_approx_date
from raw;
alter table models add primary key (name);
