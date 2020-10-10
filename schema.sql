-- COMP3311 20T3 Assignment 1
-- Calendar schema
-- Written by INSERT YOUR NAME HERE

-- Types

create type AccessibilityType as enum ('read-write','read-only','none');
create type InviteStatus as enum ('invited','accepted','declined');
-- create type AdminPrivelege as enum ('admin','regular-user');
create type VisibilityType as enum ('public', 'private');
create type DayOfWeekType as enum ('Mon','Tue','Wed','Thur','Fri','Sat','Sun');

-- add more types/domains if you want

-- Tables

create table Users (
	id          	serial,
	email       	text not null unique,
	name			text not null,
	passwd			text not null,
	is_admin		boolean default false,
	member			serial,
	primary key 	(id)
--	foreign key		(member_of) references Groups(id)
);

create table Groups (
	id          	serial,
	name        	text not null,
	owner			serial not null,
	primary key 	(id),
	foreign key		(owner) references Users(id)
);

create table Calendars (
	id				serial,
	name			text,
	color			text not null,
	default_access 	AccessibilityType not null default 'read-write',
--	accessibility 	AccessibilityType,
--	subscribe_color text,
	owner			serial not null,
	primary key		(id),
	foreign key		(owned_by) references Users(id)
);

create table Accessibilities (
	calendar_id		serial references Calendars(id),
	user_id			serial references Users(id),
	accessibility 	AccessibilityType,
	primary key		(user_id, calendar_id)
);

create table Subscribers (
	calendar_id		serial references Calendars(id),
	user_id			serial references Users(id),
	color			text,
	primary key		(calendar_id, user_id)
);

create table Events (
	id				serial,
	title			text,
	start_time		time,
	visibility 		VisibilityType,
	location		text,
	end_time		time,
	created_by		serial not null,
	part_of			serial not null,
	primary key		(id),
	foreign key		(created_by) references Users(id),
	foreign key		(part_of) references Calendars(id)
);


create table Alarms (
	event_id		serial references Events(id),
	time_before		integer,
	primary key		(event_id, time_before)
);

create table Invites (
	id 				serial,
	event_id		serial not null,
	invited_person	serial not null,
	status			InviteStatus not null default 'invited',
	primary key 	(id),
	foreign key		(event_id) references Events(id),
	foreign key		(invited_person) references Users(id)
);

create table One_Day_Events (
	id				serial,
	date_of_event	date,
	primary key		(id),
	foreign key		(id) references Events(id)
);

create table Spanning_Events (
	id				serial,
	start_date		date,
	end_date		date,
	primary key		(id),
	foreign key		(id) references Events(id)
);

create table Recurring_Events (
	id				serial,
	start_date		date,
	end_date		date,
	no_of_repeats	integer,
	primary key		(id),
	foreign key		(id) references Events(id)
);

create table Weekly_Events (
	id				serial,
	day_of_week		DayOfWeekType,
	frequency		integer,
	primary key		(id),
	foreign key		(id) references Recurring_Events(id)
);

create table Monthly_by_Day_Events (
	id				serial,
	day_of_week		DayOfWeekType,
	week_in_month	integer check (week_in_month between 1 and 5),
	primary key		(id),
	foreign key		(id) references Recurring_Events(id)
);

create table Monthly_by_Date_Events (
	id				serial,
	date_in_month	integer check (date_in_month between 1 and 31),
	primary key		(id),
	foreign key		(id) references Recurring_Events(id)
);

create table Annual_Events (
	id				serial,
	date_of_event	date,
	primary key		(id),
	foreign key		(id) references Recurring_Events(id)
);

alter table Users add foreign key (member_of) references Groups(id);

-- etc. etc. etc.
