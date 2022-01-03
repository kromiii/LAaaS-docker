#!/bin/bash

# Create DB for tests

set -e
. .env.testing

createuser -d $DB_LOG_USERNAME -p $DB_LOG_PORT
createdb $DB_LOG_DATABASE -U $DB_LOG_USERNAME -p $DB_LOG_PORT
psql $DB_LOG_DATABASE -U $DB_LOG_USERNAME -p $DB_LOG_PORT << EOSQL
CREATE TABLE execution_logs (
  id SERIAL PRIMARY KEY,
  translated INTEGER NOT NULL,
  failed INTEGER NOT NULL,
  last_id INTEGER NOT NULL,
  date DATE NOT NULL
);

CREATE TABLE failed_logs (
  id SERIAL PRIMARY KEY,
  execution_id INTEGER,
  model VARCHAR(32) NOT NULL,
  model_id TEXT NOT NULL,
  FOREIGN KEY (execution_id) REFERENCES execution_logs(id)
);

CREATE TABLE scorm_scoes_track_execution_logs (
  id SERIAL PRIMARY KEY,
  translated INTEGER NOT NULL,
  failed INTEGER NOT NULL,
  last_id INTEGER NOT NULL,
  date DATE NOT NULL
);

CREATE TABLE scorm_scoes_track_failed_logs (
  id SERIAL PRIMARY KEY,
  execution_id INTEGER,
  model VARCHAR(32) NOT NULL,
  model_id TEXT NOT NULL,
  FOREIGN KEY (execution_id) REFERENCES scorm_scoes_track_execution_logs(id)
);
EOSQL

createuser -d $DB_EPPN_USERNAME -p $DB_EPPN_PORT
createdb $DB_EPPN_DATABASE -U $DB_EPPN_USERNAME -p $DB_EPPN_PORT
psql $DB_EPPN_DATABASE -U $DB_EPPN_USERNAME -p $DB_EPPN_PORT << EOSQL
CREATE TABLE eppn (
  username VARCHAR(256) PRIMARY KEY,
  hash CHAR(64) NOT NULL,
  scope VARCHAR(256) NOT NULL,
  acl VARCHAR(256) NOT NULL
);
EOSQL

createuser -d $DB_USERNAME -p $DB_PORT
createdb $DB_DATABASE -U $DB_USERNAME -p $DB_PORT
psql $DB_DATABASE -U $DB_USERNAME -p $DB_PORT << EOSQL
CREATE TABLE logstore_standard_log (
  id SERIAL PRIMARY KEY,
  eventname VARCHAR(255) NOT NULL DEFAULT '',
  component VARCHAR(100) NOT NULL DEFAULT '',
  action VARCHAR(100) NOT NULL DEFAULT '',
  target VARCHAR(100) NOT NULL DEFAULT '',
  objecttable VARCHAR(50),
  objectid BIGINT,
  crud VARCHAR(1) NOT NULL DEFAULT '',
  edulevel SMALLINT NOT NULL,
  contextid BIGINT NOT NULL,
  contextlevel BIGINT NOT NULL,
  contextinstanceid BIGINT NOT NULL,
  userid BIGINT NOT NULL,
  courseid BIGINT,
  relateduserid BIGINT,
  anonymous SMALLINT NOT NULL DEFAULT 0,
  other TEXT,
  timecreated BIGINT NOT NULL,
  origin VARCHAR(10),
  ip VARCHAR(45),
  realuserid BIGINT
);

CREATE TABLE "user" (
  id SERIAL PRIMARY KEY,
  auth VARCHAR(20) NOT NULL DEFAULT 'manual',
  confirmed SMALLINT NOT NULL DEFAULT 0,
  policyagreed SMALLINT NOT NULL DEFAULT 0,
  deleted SMALLINT NOT NULL DEFAULT 0,
  suspended SMALLINT NOT NULL DEFAULT 0,
  mnethostid BIGINT NOT NULL DEFAULT 0,
  username VARCHAR(256) NOT NULL DEFAULT '',
  password VARCHAR(255) NOT NULL DEFAULT '',
  idnumber VARCHAR(255) NOT NULL DEFAULT '',
  firstname VARCHAR(100) NOT NULL DEFAULT '',
  lastname VARCHAR(100) NOT NULL DEFAULT '',
  email VARCHAR(100) NOT NULL DEFAULT '',
  emailstop SMALLINT NOT NULL DEFAULT 0,
  icq VARCHAR(15) NOT NULL DEFAULT '',
  skype VARCHAR(50) NOT NULL DEFAULT '',
  yahoo VARCHAR(50) NOT NULL DEFAULT '',
  aim VARCHAR(50) NOT NULL DEFAULT '',
  msn VARCHAR(50) NOT NULL DEFAULT '',
  phone1 VARCHAR(20) NOT NULL DEFAULT '',
  phone2 VARCHAR(20) NOT NULL DEFAULT '',
  institution VARCHAR(255) NOT NULL DEFAULT '',
  department VARCHAR(255) NOT NULL DEFAULT '',
  address VARCHAR(255) NOT NULL DEFAULT '',
  city VARCHAR(120) NOT NULL DEFAULT '',
  country VARCHAR(2) NOT NULL DEFAULT '',
  lang VARCHAR(30) NOT NULL DEFAULT 'en',
  calendartype VARCHAR(30) NOT NULL DEFAULT 'gregorian',
  theme VARCHAR(50) NOT NULL DEFAULT '',
  timezone VARCHAR(100) NOT NULL DEFAULT '99',
  firstaccess BIGINT NOT NULL DEFAULT 0,
  lastaccess BIGINT NOT NULL DEFAULT 0,
  lastlogin BIGINT NOT NULL DEFAULT 0,
  currentlogin BIGINT NOT NULL DEFAULT 0,
  lastip VARCHAR(45) NOT NULL DEFAULT '',
  secret VARCHAR(15) NOT NULL DEFAULT '',
  picture BIGINT NOT NULL DEFAULT 0,
  url VARCHAR(255) NOT NULL DEFAULT '',
  description TEXT,
  descriptionformat SMALLINT NOT NULL DEFAULT 1,
  mailformat SMALLINT NOT NULL DEFAULT 1,
  maildigest SMALLINT NOT NULL DEFAULT 0,
  maildisplay SMALLINT NOT NULL DEFAULT 2,
  autosubscribe SMALLINT NOT NULL DEFAULT 1,
  trackforums SMALLINT NOT NULL DEFAULT 0,
  timecreated BIGINT NOT NULL DEFAULT 0,
  timemodified BIGINT NOT NULL DEFAULT 0,
  trustbitmask BIGINT NOT NULL DEFAULT 0,
  imagealt VARCHAR(255),
  lastnamephonetic VARCHAR(255),
  firstnamephonetic VARCHAR(255),
  middlename VARCHAR(255),
  alternatename VARCHAR(255),
  moodlenetprofile VARCHAR(255)
);

CREATE TABLE assign_submission (
  id SERIAL PRIMARY KEY,
  assignment BIGINT NOT NULL DEFAULT 0,
  userid BIGINT NOT NULL DEFAULT 0,
  timecreated BIGINT NOT NULL DEFAULT 0,
  timemodified BIGINT NOT NULL DEFAULT 0,
  status VARCHAR(10),
  groupid BIGINT NOT NULL DEFAULT 0,
  attemptnumber BIGINT NOT NULL DEFAULT 0,
  latest SMALLINT NOT NULL DEFAULT 0
);

CREATE TABLE assign (
  id SERIAL PRIMARY KEY,
  course BIGINT NOT NULL DEFAULT 0,
  name VARCHAR(255) NOT NULL DEFAULT '',
  intro TEXT NOT NULL,
  introformat SMALLINT NOT NULL DEFAULT 0,
  alwaysshowdescription SMALLINT NOT NULL DEFAULT 0,
  nosubmissions SMALLINT NOT NULL DEFAULT 0,
  submissiondrafts SMALLINT NOT NULL DEFAULT 0,
  sendnotifications SMALLINT NOT NULL DEFAULT 0,
  sendlatenotifications SMALLINT NOT NULL DEFAULT 0,
  duedate BIGINT NOT NULL DEFAULT 0,
  allowsubmissionsfromdate BIGINT NOT NULL DEFAULT 0,
  grade BIGINT NOT NULL DEFAULT 0,
  timemodified BIGINT NOT NULL DEFAULT 0,
  requiresubmissionstatement SMALLINT NOT NULL DEFAULT 0,
  completionsubmit SMALLINT NOT NULL DEFAULT 0,
  cutoffdate BIGINT NOT NULL DEFAULT 0,
  gradingduedate BIGINT NOT NULL DEFAULT 0,
  teamsubmission SMALLINT NOT NULL DEFAULT 0,
  requireallteammemberssubmit SMALLINT NOT NULL DEFAULT 0,
  teamsubmissiongroupingid BIGINT NOT NULL DEFAULT 0,
  blindmarking SMALLINT NOT NULL DEFAULT 0,
  revealidentities SMALLINT NOT NULL DEFAULT 0,
  attemptreopenmethod VARCHAR(10) NOT NULL DEFAULT 'none',
  maxattempts INTEGER NOT NULL DEFAULT -1,
  markingworkflow SMALLINT NOT NULL DEFAULT 0,
  markingallocation SMALLINT NOT NULL DEFAULT 0,
  sendstudentnotifications SMALLINT NOT NULL DEFAULT 1,
  preventsubmissionnotingroup SMALLINT NOT NULL DEFAULT 0,
  hidegrader SMALLINT NOT NULL DEFAULT 0
);

CREATE TABLE assign_grades (
  id SERIAL PRIMARY KEY,
  assignment BIGINT NOT NULL DEFAULT 0,
  userid BIGINT NOT NULL DEFAULT 0,
  timecreated BIGINT NOT NULL DEFAULT 0,
  timemodified BIGINT NOT NULL DEFAULT 0,
  grader BIGINT NOT NULL DEFAULT 0,
  grade NUMERIC(10,5) DEFAULT 0,
  attemptnumber BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE assignfeedback_comments (
  id SERIAL PRIMARY KEY,
  assignment BIGINT NOT NULL DEFAULT 0,
  grade BIGINT NOT NULL DEFAULT 0,
  commenttext TEXT,
  commentformat SMALLINT NOT NULL DEFAULT 0
);

CREATE TABLE forum (
  id SERIAL PRIMARY KEY,
  course BIGINT NOT NULL DEFAULT 0,
  type VARCHAR(20) NOT NULL DEFAULT 'general',
  name VARCHAR(255) NOT NULL DEFAULT '',
  intro TEXT NOT NULL,
  introformat SMALLINT NOT NULL DEFAULT 0,
  assessed BIGINT NOT NULL DEFAULT 0,
  assesstimestart BIGINT NOT NULL DEFAULT 0,
  assesstimefinish BIGINT NOT NULL DEFAULT 0,
  scale BIGINT NOT NULL DEFAULT 0,
  maxbytes BIGINT NOT NULL DEFAULT 0,
  maxattachments BIGINT NOT NULL DEFAULT 1,
  forcesubscribe SMALLINT NOT NULL DEFAULT 0,
  trackingtype SMALLINT NOT NULL DEFAULT 1,
  rsstype SMALLINT NOT NULL DEFAULT 0,
  rssarticles SMALLINT NOT NULL DEFAULT 0,
  timemodified BIGINT NOT NULL DEFAULT 0,
  warnafter BIGINT NOT NULL DEFAULT 0,
  blockafter BIGINT NOT NULL DEFAULT 0,
  blockperiod BIGINT NOT NULL DEFAULT 0,
  completiondiscussions INTEGER NOT NULL DEFAULT 0,
  completionreplies INTEGER NOT NULL DEFAULT 0,
  completionposts INTEGER NOT NULL DEFAULT 0,
  displaywordcount SMALLINT NOT NULL DEFAULT 0,
  lockdiscussionafter BIGINT NOT NULL DEFAULT 0,
  duedate BIGINT NOT NULL DEFAULT 0,
  cutoffdate BIGINT NOT NULL DEFAULT 0,
  grade_forum BIGINT NOT NULL DEFAULT 0,
  grade_forum_notify SMALLINT NOT NULL DEFAULT 0
);

CREATE TABLE forum_subscriptions (
  id SERIAL PRIMARY KEY,
  userid BIGINT NOT NULL DEFAULT 0,
  forum BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE forum_discussions (
  id SERIAL PRIMARY KEY,
  course BIGINT NOT NULL DEFAULT 0,
  forum BIGINT NOT NULL DEFAULT 0,
  name VARCHAR(255) NOT NULL DEFAULT '',
  firstpost BIGINT NOT NULL DEFAULT 0,
  userid BIGINT NOT NULL DEFAULT 0,
  groupid BIGINT NOT NULL DEFAULT -1,
  assessed SMALLINT NOT NULL DEFAULT 1,
  timemodified BIGINT NOT NULL DEFAULT 0,
  usermodified BIGINT NOT NULL DEFAULT 0,
  timestart BIGINT NOT NULL DEFAULT 0,
  timeend BIGINT NOT NULL DEFAULT 0,
  pinned SMALLINT NOT NULL DEFAULT 0,
  timelocked BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE quiz (
  id SERIAL PRIMARY KEY,
  course BIGINT NOT NULL DEFAULT 0,
  name VARCHAR(255) NOT NULL DEFAULT '',
  intro TEXT NOT NULL,
  introformat SMALLINT NOT NULL DEFAULT 0,
  timeopen BIGINT NOT NULL DEFAULT 0,
  timeclose BIGINT NOT NULL DEFAULT 0,
  timelimit BIGINT NOT NULL DEFAULT 0,
  overduehandling VARCHAR(16) NOT NULL DEFAULT 'autoabandon',
  graceperiod BIGINT NOT NULL DEFAULT 0,
  preferredbehaviour VARCHAR(32) NOT NULL DEFAULT '',
  canredoquestions SMALLINT NOT NULL DEFAULT 0,
  attempts INTEGER NOT NULL DEFAULT 0,
  attemptonlast SMALLINT NOT NULL DEFAULT 0,
  grademethod SMALLINT NOT NULL DEFAULT 1,
  decimalpoints SMALLINT NOT NULL DEFAULT 2,
  questiondecimalpoints SMALLINT NOT NULL DEFAULT -1,
  reviewattempt INTEGER NOT NULL DEFAULT 0,
  reviewcorrectness INTEGER NOT NULL DEFAULT 0,
  reviewmarks INTEGER NOT NULL DEFAULT 0,
  reviewspecificfeedback INTEGER NOT NULL DEFAULT 0,
  reviewgeneralfeedback INTEGER NOT NULL DEFAULT 0,
  reviewrightanswer INTEGER NOT NULL DEFAULT 0,
  reviewoverallfeedback INTEGER NOT NULL DEFAULT 0,
  questionsperpage BIGINT NOT NULL DEFAULT 0,
  navmethod VARCHAR(16) NOT NULL DEFAULT 'free',
  shuffleanswers SMALLINT NOT NULL DEFAULT 0,
  sumgrades NUMERIC(10,5) NOT NULL DEFAULT 0,
  grade NUMERIC(10,5) NOT NULL DEFAULT 0,
  timecreated BIGINT NOT NULL DEFAULT 0,
  timemodified BIGINT NOT NULL DEFAULT 0,
  password VARCHAR(255) NOT NULL DEFAULT '',
  subnet VARCHAR(255) NOT NULL DEFAULT '',
  browsersecurity VARCHAR(32) NOT NULL DEFAULT '',
  delay1 BIGINT NOT NULL DEFAULT 0,
  delay2 BIGINT NOT NULL DEFAULT 0,
  showuserpicture SMALLINT NOT NULL DEFAULT 0,
  showblocks SMALLINT NOT NULL DEFAULT 0,
  completionattemptsexhausted SMALLINT DEFAULT 0,
  completionpass SMALLINT DEFAULT 0,
  allowofflineattempts SMALLINT DEFAULT 0
);

CREATE TABLE quiz_attempts (
  id SERIAL PRIMARY KEY,
  quiz BIGINT NOT NULL DEFAULT 0,
  userid BIGINT NOT NULL DEFAULT 0,
  attempt INTEGER NOT NULL DEFAULT 0,
  uniqueid BIGINT NOT NULL DEFAULT 0,
  layout TEXT NOT NULL,
  currentpage BIGINT NOT NULL DEFAULT 0,
  preview SMALLINT NOT NULL DEFAULT 0,
  state VARCHAR(16) NOT NULL DEFAULT 'inprogress',
  timestart BIGINT NOT NULL DEFAULT 0,
  timefinish BIGINT NOT NULL DEFAULT 0,
  timemodified BIGINT NOT NULL DEFAULT 0,
  timemodifiedoffline BIGINT NOT NULL DEFAULT 0,
  timecheckstate BIGINT DEFAULT 0,
  sumgrades NUMERIC(10,5)
);

CREATE TABLE course (
  id SERIAL PRIMARY KEY,
  category BIGINT NOT NULL DEFAULT 0,
  sortorder BIGINT NOT NULL DEFAULT 0,
  fullname VARCHAR(254) NOT NULL DEFAULT '',
  shortname VARCHAR(255) NOT NULL DEFAULT '',
  idnumber VARCHAR(100) NOT NULL DEFAULT '',
  summary TEXT,
  summaryformat SMALLINT NOT NULL DEFAULT 0,
  format VARCHAR(21) NOT NULL DEFAULT 'topics',
  showgrades SMALLINT NOT NULL DEFAULT 1,
  newsitems INTEGER NOT NULL DEFAULT 1,
  startdate BIGINT NOT NULL DEFAULT 0,
  enddate BIGINT NOT NULL DEFAULT 0,
  marker BIGINT NOT NULL DEFAULT 0,
  maxbytes BIGINT NOT NULL DEFAULT 0,
  legacyfiles SMALLINT NOT NULL DEFAULT 0,
  showreports SMALLINT NOT NULL DEFAULT 0,
  visible SMALLINT NOT NULL DEFAULT 1,
  visibleold SMALLINT NOT NULL DEFAULT 1,
  groupmode SMALLINT NOT NULL DEFAULT 0,
  groupmodeforce SMALLINT NOT NULL DEFAULT 0,
  defaultgroupingid BIGINT NOT NULL DEFAULT 0,
  lang VARCHAR(30) NOT NULL DEFAULT '',
  calendartype VARCHAR(30) NOT NULL DEFAULT '',
  theme VARCHAR(50) NOT NULL DEFAULT '',
  timecreated BIGINT NOT NULL DEFAULT 0,
  timemodified BIGINT NOT NULL DEFAULT 0,
  requested SMALLINT NOT NULL DEFAULT 0,
  enablecompletion SMALLINT NOT NULL DEFAULT 0,
  completionnotify SMALLINT NOT NULL DEFAULT 0,
  cacherev BIGINT NOT NULL DEFAULT 0,
  relativedatesmode SMALLINT NOT NULL DEFAULT 0
);

CREATE TABLE course_categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL DEFAULT '',
  idnumber VARCHAR(100),
  description TEXT,
  descriptionformat SMALLINT NOT NULL DEFAULT 0,
  parent BIGINT NOT NULL DEFAULT 0,
  sortorder BIGINT NOT NULL DEFAULT 0,
  coursecount BIGINT NOT NULL DEFAULT 0,
  visible SMALLINT NOT NULL DEFAULT 1,
  visibleold SMALLINT NOT NULL DEFAULT 1,
  timemodified BIGINT NOT NULL DEFAULT 0,
  depth BIGINT NOT NULL DEFAULT 0,
  path VARCHAR(255) NOT NULL DEFAULT '',
  theme VARCHAR(50)
);

CREATE TABLE scorm (
  id SERIAL PRIMARY KEY,
  course BIGINT NOT NULL DEFAULT 0,
  name VARCHAR(255) NOT NULL DEFAULT '',
  scormtype VARCHAR(50) NOT NULL DEFAULT 'local',
  reference VARCHAR(255) NOT NULL DEFAULT '',
  intro TEXT NOT NULL,
  introformat SMALLINT NOT NULL DEFAULT 0,
  version VARCHAR(9) NOT NULL DEFAULT '',
  maxgrade DOUBLE PRECISION NOT NULL DEFAULT 0,
  grademethod SMALLINT NOT NULL DEFAULT 0,
  whatgrade BIGINT NOT NULL DEFAULT 0,
  maxattempt BIGINT NOT NULL DEFAULT 1,
  forcecompleted SMALLINT NOT NULL DEFAULT 0,
  forcenewattempt SMALLINT NOT NULL DEFAULT 0,
  lastattemptlock SMALLINT NOT NULL DEFAULT 0,
  masteryoverride SMALLINT NOT NULL DEFAULT 1,
  displayattemptstatus SMALLINT NOT NULL DEFAULT 1,
  displaycoursestructure SMALLINT NOT NULL DEFAULT 0,
  updatefreq SMALLINT NOT NULL DEFAULT 0,
  sha1hash VARCHAR(40),
  md5hash VARCHAR(32) NOT NULL DEFAULT '',
  revision BIGINT NOT NULL DEFAULT 0,
  launch BIGINT NOT NULL DEFAULT 0,
  skipview SMALLINT NOT NULL DEFAULT 1,
  hidebrowse SMALLINT NOT NULL DEFAULT 0,
  hidetoc SMALLINT NOT NULL DEFAULT 0,
  nav SMALLINT NOT NULL DEFAULT 1,
  navpositionleft BIGINT DEFAULT -100,
  navpositiontop BIGINT DEFAULT -100,
  auto SMALLINT NOT NULL DEFAULT 0,
  popup SMALLINT NOT NULL DEFAULT 0,
  options VARCHAR(255) NOT NULL DEFAULT '',
  width BIGINT NOT NULL DEFAULT 100,
  height BIGINT NOT NULL DEFAULT 600,
  timeopen BIGINT NOT NULL DEFAULT 0,
  timeclose BIGINT NOT NULL DEFAULT 0,
  timemodified BIGINT NOT NULL DEFAULT 0,
  completionstatusrequired SMALLINT,
  completionscorerequired BIGINT,
  completionstatusallscos SMALLINT,
  displayactivityname SMALLINT NOT NULL DEFAULT 1,
  autocommit SMALLINT NOT NULL DEFAULT 0
);

CREATE TABLE scorm_scoes (
  id SERIAL PRIMARY KEY,
  scorm BIGINT NOT NULL DEFAULT 0,
  manifest VARCHAR(255) NOT NULL DEFAULT '',
  organization VARCHAR(255) NOT NULL DEFAULT '',
  parent VARCHAR(255) NOT NULL DEFAULT '',
  identifier VARCHAR(255) NOT NULL DEFAULT '',
  launch TEXT NOT NULL,
  scormtype VARCHAR(5) NOT NULL DEFAULT '',
  title VARCHAR(255) NOT NULL DEFAULT '',
  sortorder BIGINT NOT NULL DEFAULT 0
);

CREATE TABLE scorm_scoes_track (
  id SERIAL PRIMARY KEY,
  userid BIGINT NOT NULL DEFAULT 0,
  scormid BIGINT NOT NULL DEFAULT 0,
  scoid BIGINT NOT NULL DEFAULT 0,
  attempt BIGINT NOT NULL DEFAULT 1,
  element VARCHAR(255) NOT NULL DEFAULT '',
  value TEXT NOT NULL,
  timemodified BIGINT NOT NULL DEFAULT 0
);
EOSQL
