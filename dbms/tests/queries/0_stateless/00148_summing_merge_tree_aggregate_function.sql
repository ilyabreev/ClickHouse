drop table if exists test.summing_merge_tree_aggregate_function;

-- sum + uniq + uniqExact
create table test.summing_merge_tree_aggregate_function (
	d materialized today(),
	k UInt64,
	c UInt64,
	u AggregateFunction(uniq, UInt8),
	ue AggregateFunction(uniqExact, UInt8)
) engine=SummingMergeTree(d, k, 8192);

insert into test.summing_merge_tree_aggregate_function select 1, 1, uniqState(1), uniqExactState(1);
insert into test.summing_merge_tree_aggregate_function select 1, 1, uniqState(2), uniqExactState(2);
insert into test.summing_merge_tree_aggregate_function select 1, 1, uniqState(3), uniqExactState(2);
insert into test.summing_merge_tree_aggregate_function select 1, 1, uniqState(1), uniqExactState(1);
insert into test.summing_merge_tree_aggregate_function select 1, 1, uniqState(2), uniqExactState(2);
insert into test.summing_merge_tree_aggregate_function select 1, 1, uniqState(3), uniqExactState(3);

select
	k, sum(c),
	uniqMerge(u), uniqExactMerge(ue)
from test.summing_merge_tree_aggregate_function group by k;

optimize table test.summing_merge_tree_aggregate_function;

select
	k, sum(c),
	uniqMerge(u), uniqExactMerge(ue)
from test.summing_merge_tree_aggregate_function group by k;

drop table test.summing_merge_tree_aggregate_function;

-- sum + topK
create table test.summing_merge_tree_aggregate_function (d materialized today(), k UInt64, c UInt64, x AggregateFunction(topK(2), UInt8)) engine=SummingMergeTree(d, k, 8192);

insert into test.summing_merge_tree_aggregate_function select 1, 1, topKState(2)(1);
insert into test.summing_merge_tree_aggregate_function select 1, 1, topKState(2)(2);
insert into test.summing_merge_tree_aggregate_function select 1, 1, topKState(2)(2);
insert into test.summing_merge_tree_aggregate_function select 1, 1, topKState(2)(3);
insert into test.summing_merge_tree_aggregate_function select 1, 1, topKState(2)(3);
insert into test.summing_merge_tree_aggregate_function select 1, 1, topKState(2)(3);
select k, sum(c), topKMerge(2)(x) from test.summing_merge_tree_aggregate_function group by k;
optimize table test.summing_merge_tree_aggregate_function;
select k, sum(c), topKMerge(2)(x) from test.summing_merge_tree_aggregate_function group by k;

drop table test.summing_merge_tree_aggregate_function;

-- avg
create table test.summing_merge_tree_aggregate_function (d materialized today(), k UInt64, x AggregateFunction(avg, Float64)) engine=SummingMergeTree(d, k, 8192);

insert into test.summing_merge_tree_aggregate_function select 1, avgState(0.0);
insert into test.summing_merge_tree_aggregate_function select 1, avgState(0.1);
insert into test.summing_merge_tree_aggregate_function select 1, avgState(0.2);
insert into test.summing_merge_tree_aggregate_function select 1, avgState(0.3);
insert into test.summing_merge_tree_aggregate_function select 1, avgState(0.4);
insert into test.summing_merge_tree_aggregate_function select 1, avgState(0.5);
insert into test.summing_merge_tree_aggregate_function select 1, avgState(0.6);
insert into test.summing_merge_tree_aggregate_function select 1, avgState(0.7);
insert into test.summing_merge_tree_aggregate_function select 1, avgState(0.8);
insert into test.summing_merge_tree_aggregate_function select 1, avgState(0.9);
insert into test.summing_merge_tree_aggregate_function select 1, avgState(1.0);
select k, avgMerge(x) from test.summing_merge_tree_aggregate_function group by k;
optimize table test.summing_merge_tree_aggregate_function;
select k, avgMerge(x) from test.summing_merge_tree_aggregate_function group by k;

drop table test.summing_merge_tree_aggregate_function;

-- quantile
create table test.summing_merge_tree_aggregate_function (d materialized today(), k UInt64, x AggregateFunction(quantile(0.1), Float64)) engine=SummingMergeTree(d, k, 8192);

insert into test.summing_merge_tree_aggregate_function select 1, quantileState(0.1)(0.0);
insert into test.summing_merge_tree_aggregate_function select 1, quantileState(0.1)(0.1);
insert into test.summing_merge_tree_aggregate_function select 1, quantileState(0.1)(0.2);
insert into test.summing_merge_tree_aggregate_function select 1, quantileState(0.1)(0.3);
insert into test.summing_merge_tree_aggregate_function select 1, quantileState(0.1)(0.4);
insert into test.summing_merge_tree_aggregate_function select 1, quantileState(0.1)(0.5);
insert into test.summing_merge_tree_aggregate_function select 1, quantileState(0.1)(0.6);
insert into test.summing_merge_tree_aggregate_function select 1, quantileState(0.1)(0.7);
insert into test.summing_merge_tree_aggregate_function select 1, quantileState(0.1)(0.8);
insert into test.summing_merge_tree_aggregate_function select 1, quantileState(0.1)(0.9);
insert into test.summing_merge_tree_aggregate_function select 1, quantileState(0.1)(1.0);
select k, quantileMerge(0.1)(x) from test.summing_merge_tree_aggregate_function group by k;
optimize table test.summing_merge_tree_aggregate_function;
select k, quantileMerge(0.1)(x) from test.summing_merge_tree_aggregate_function group by k;

drop table test.summing_merge_tree_aggregate_function;
