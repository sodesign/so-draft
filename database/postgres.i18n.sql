/** i18n
 * i18n - internationalization 国际化
 * l10n - localization 本地化
 * g11n - globalization 全球化 i18n+l10n
 * m17n - multilingualization
 */

-- 删表
drop table if exists i18n_msg;
drop table if exists i18n_local;


-- 建表
create table i18n_local (
	id_ integer not null,
	name_ character(20) not null,
	lang_ character(2) not null,
	country_ character(2) not null,
	default_ boolean not null,
	constraint pk_i18n_local primary key (id_),
	constraint uk_i18n_local unique (lang_, country_)
);
comment on table i18n_local is '国际化语言';
comment on column i18n_local.name_ is '名称';
comment on column i18n_local.lang_ is '由 iso-639 定义的小写、两字母语言代码';
comment on column i18n_local.country_ is '由 iso-3166 定义的大写、两字母国家代码';

create table i18n_msg (
	local_ integer not null,
	base_ character varying(100) not null,
	key_ character varying(100) not null,
	value_ character varying(1000) not null,
	constraint uk_i18n_msg unique (local_, base_, key_)
);
comment on table i18n_msg is '国际化资源';
comment on column i18n_msg.local_ is '所属语言';
comment on column i18n_msg.base_ is '资源类别';
comment on column i18n_msg.key_ is '资源键';
comment on column i18n_msg.value_ is '资源值';
alter table i18n_msg add constraint fk_i18n_msg_local foreign key (local_)
	references i18n_local (id_) on update restrict on delete cascade;


-- 初始化数据
-- 国际化语言 select * from i18n_local order by lang_, id_
delete from i18n_local;
insert into i18n_local(id_, default_, lang_, country_, name_) values
	-- en
	(10, true, 'en', '', 'English'),
	(11, false, 'en', 'gb', 'US'),
	(12, false, 'en', 'uk', 'UK'),
	(13, false, 'en', 'ca', 'Canada'),
	-- zh
	(20, true, 'zh', '', 'Chiness'),
	(21, false, 'zh', 'cn', 'SimplifiedChinese'),
	(22, false, 'zh', 'tw', 'TraditinalChinese'),
	(23, false, 'zh', 'hk', 'HongKongChinese');
	
-- 国际化资源 select * from i18n_msg s inner join i18n_local l on l.id_ = s.local_ order by l.lang_, s.base_, s.key_
delete from i18n_msg;
insert into i18n_msg(local_, base_, key_, value_) values
	-- table.comment: i18n_msg en
	((select id_ from i18n_local where lang_ = 'en' and default_ = true)
		, 'table.comment', 'i18n_msg', 'i18n local'),
	((select id_ from i18n_local where lang_ = 'en' and default_ = true)
		, 'table.comment', 'i18n_msg.lang_', 'iso-639 language shortcut'),
	((select id_ from i18n_local where lang_ = 'en' and default_ = true)
		, 'table.comment', 'i18n_msg.country_', 'iso-3166 country shortcut'),
	((select id_ from i18n_local where lang_ = 'en' and default_ = true)
		, 'table.comment', 'i18n_msg.default_', 'if default within same language'),

	-- table.comment: i18n_msg zh
	((select id_ from i18n_local where lang_ = 'zh' and default_ = true)
		, 'table.comment', 'i18n_msg', '国际化语言'),
	((select id_ from i18n_local where lang_ = 'zh' and default_ = true)
		, 'table.comment', 'i18n_msg.lang_', '由 iso-639 定义的小写、两字母语言代码'),
	((select id_ from i18n_local where lang_ = 'zh' and default_ = true)
		, 'table.comment', 'i18n_msg.country_', '由 iso-3166 定义的大写、两字母国家代码'),
	((select id_ from i18n_local where lang_ = 'zh' and default_ = true)
		, 'table.comment', 'i18n_msg.default_', '是否是相同语言代码下的默认语言'),

	-- root message: en
	((select id_ from i18n_local where lang_ = 'en' and default_ = true), '', 'key', 'key'),
	((select id_ from i18n_local where lang_ = 'en' and default_ = true), '', 'value', 'value'),

	-- root message: zh
	((select id_ from i18n_local where lang_ = 'zh' and default_ = true), '', 'key', '键'),
	((select id_ from i18n_local where lang_ = 'zh' and default_ = true), '', 'value', '值');
