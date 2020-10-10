-- COMP3311 20T3 Assignment 1
-- Calendar schema
-- Written by INSERT YOUR NAME HERE

-- Types

create type AccessibilityType as enum ('read-write','read-only','none');
create type InviteStatus as enum ('invited','accepted','declined');
create type AdminPrivelege as enum ('admin','regular-user');
create type VisibilityType as enum ('public', 'private');
create type DayOfWeekType as enum ('Mon','Tue','Wed','Thur','Fri','Sat','Sun');

-- add more types/domains if you want

-- Tables

create table Users (
	id          	serial,
	email       	text not null unique,
	name			text not null,
	password		text not null,
	is_admin		AdminPrivelege,
	member_of		serial,
	primary key 	(id),
	foreign key		(member_of) references Groups(id),
);

create table Groups (
	id          	serial,
	name        	text not null,
	owned_by		serial,
	primary key 	(id),
	foreign key		(owned_by) references Users(id),
);

create table Calendars(
	id				serial,
	name			text,
	color			text not null,
	default_access 	AccessibilityType not null,
	accessibility 	AccessibilityType,
	subscribe_color text,
	owned_by		serial,
	primary key		(id),
	foreign key		(owned_by) references Users(id),
);


create table Events(
	id				serial,
	title			text,
	start_time		time,
	visibility 		VisibilityType,
	location		text,
	end_time		time,
	created_by		serial not null,
	part_of			serial not null,
	foreign key		(created_by) references Users(id),
	foreign key		(part_of) references Calendars(id),
);


create table Alarms(
	event_id		serial references Events(id),
	time_before		integer,
	primary key		(event_id, time_before)
);

create table Invites(
	id 				serial,
	event_id		serial not null,
	invited_person	serial not null,
	status			InviteStatus,
	primary key 	(id),
	foreign key		(event_id) references Events(id),
	foreign key		(invited_person) references Users(id)
);

create table One_Day_Events(
	id				serial,
	date_of_event	date,
	primary key		(id),
	foreign key		(id) references Events(id),
);

create table Spanning_Events(
	id				serial,
	start_date		date,
	end_date		date,
	primary key		(id),
	foreign key		(id) references Events(id),
);

create table Recurring_Events(
	id				serial,
	start_date		date,
	end_date		date,
	no_of_repeats	integer,
	primary key		(id),
	foreign key		(id) references Events(id),
);

create table Weekly_Events(
	id				serial,
	day_of_week		DayOfWeekType,
	frequency		integer,
	primary key		(id),
	foreign key		(id) references Recurring_Events(id),
);

create table Monthly_by_Day_Events(
	id				serial,
	day_of_week		DayOfWeekType,
	week_in_month	integer,
	primary key		(id),
	foreign key		(id) references Recurring_Events(id),
	Constraint valid_week check(week_in_month >= 1  && week_in_month =< 5),
);

create table Monthly_by_Day_Events(
	id				serial,
	date_in_month	integer,
	primary key		(id),
	foreign key		(id) references Recurring_Events(id),
	Constraint valid_date check(date_in_month >= 1  && date_in_month =< 31),
);


create table Monthly_by_Day_Events(
	id				serial,
	date_of_event	date,
	primary key		(id),
	foreign key		(id) references Recurring_Events(id),
);





-- etc. etc. etc.
