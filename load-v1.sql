-- Raw table: capability and size tags as lists, update time as the page's relative label.
create or replace table models as
select m.name, m.description, m.capabilities, m.sizes, m.pulls as pulls_label,
  cast(round(case
    when m.pulls like '%B' then cast(rtrim(m.pulls, 'B') as double) * 1e9
    when m.pulls like '%M' then cast(rtrim(m.pulls, 'M') as double) * 1e6
    when m.pulls like '%K' then cast(rtrim(m.pulls, 'K') as double) * 1e3
    else try_cast(replace(m.pulls, ',', '') as double) end) as bigint) as pulls,
  m.tag_count, m.updated
from (select unnest(models) m from read_json('library.json', maximum_object_size = 50000000));
alter table models add primary key (name);
