-- Some sample data to prime the database...
-- base-data.sql should be processed before this

INSERT INTO usr ( user_no, active, email_ok, updated, username, password, fullname, email )
    VALUES( 2, TRUE, current_date, current_date, 'andrew', '**x', 'Andrew McMillan', 'andrew@catalyst.net.nz' );
INSERT INTO role_member (user_no, role_no) VALUES( 2, 1);


INSERT INTO usr ( user_no, active, email_ok, updated, username, password, fullname, email )
    VALUES( 10, TRUE, current_date, current_date, 'user1', '**user1', 'User 1', 'user1@example.net' );
INSERT INTO usr ( user_no, active, email_ok, updated, username, password, fullname, email )
    VALUES( 11, TRUE, current_date, current_date, 'user2', '**user2', 'User 2', 'user2@example.net' );
INSERT INTO usr ( user_no, active, email_ok, updated, username, password, fullname, email )
    VALUES( 12, TRUE, current_date, current_date, 'user3', '**user3', 'User 3', 'user3@example.net' );
INSERT INTO usr ( user_no, active, email_ok, updated, username, password, fullname, email )
    VALUES( 13, TRUE, current_date, current_date, 'user4', '**user4', 'User 4', 'user4@example.net' );
INSERT INTO usr ( user_no, active, email_ok, updated, username, password, fullname, email )
    VALUES( 14, TRUE, current_date, current_date, 'user5', '**user5', 'User 5', 'user5@example.net' );
INSERT INTO usr ( user_no, active, email_ok, updated, username, password, fullname, email )
    VALUES( 15, TRUE, current_date, current_date, 'User Six', '**user6', 'User 6', 'user6@example.net' );

INSERT INTO usr ( user_no, active, email_ok, updated, username, password, fullname, email )
    VALUES( 20, TRUE, current_date, current_date, 'manager1', '**manager1', 'Manager 1', 'manager1@example.net' );

INSERT INTO usr ( user_no, active, email_ok, updated, username, password, fullname, email )
    VALUES( 30, TRUE, current_date, current_date, 'assistant1', '**assistant1', 'Assistant 1', 'assistant1@example.net' );


INSERT INTO usr ( user_no, active, email_ok, updated, username, password, fullname, email )
    VALUES( 100, TRUE, current_date, current_date, 'resource1', '*salt*unpossible', 'Resource 1', 'resource1@example.net' );
INSERT INTO usr ( user_no, active, email_ok, updated, username, password, fullname, email )
    VALUES( 101, TRUE, current_date, current_date, 'resource2', '*salt*unpossible', 'Resource 2', 'resource2@example.net' );

INSERT INTO usr ( user_no, active, email_ok, updated, username, password, fullname, email )
    VALUES( 200, TRUE, current_date, current_date, 'resmgr1', '*salt*unpossible', 'Resource Managers', 'resource-managers@example.net' );
INSERT INTO role_member (user_no, role_no) VALUES( 200, 2);

INSERT INTO usr ( user_no, active, email_ok, updated, username, password, fullname, email )
    VALUES( 300, TRUE, current_date, current_date, 'teamclient1', '*salt*unpossible', 'Team for Client1', 'team-client1@example.net' );
INSERT INTO role_member (user_no, role_no) VALUES( 300, 2);

SELECT setval('usr_user_no_seq', 1000);

INSERT INTO collection (user_no, parent_container, dav_name, dav_etag,
                 dav_displayname, is_calendar, created, modified,
                 public_events_only, publicly_readable, collection_id)
    SELECT user_no, '/' || username || '/',  '/' || username || '/home/', md5(username),
           username || ' home', TRUE, current_timestamp, current_timestamp,
           FALSE, FALSE, user_no FROM usr;

SELECT setval('dav_id_seq', 1000);

-- Set the insert sequence to the next number, with a minimum of 1000
SELECT setval('relationship_type_rt_id_seq', (SELECT 10 UNION SELECT rt_id FROM relationship_type ORDER BY 1 DESC LIMIT 1) );

-- The resources for meetings
INSERT INTO relationship ( from_user, to_user, rt_id ) VALUES( 200, 100, 1 );
INSERT INTO relationship ( from_user, to_user, rt_id ) VALUES( 200, 101, 1 );

-- The people who administer meetings
INSERT INTO relationship ( from_user, to_user, rt_id ) VALUES( 10, 200, 1 );
INSERT INTO relationship ( from_user, to_user, rt_id ) VALUES( 11, 200, 1 );
INSERT INTO relationship ( from_user, to_user, rt_id ) VALUES( 30, 200, 1 );

-- Between a PA and their Manager
INSERT INTO relationship ( from_user, to_user, rt_id ) VALUES( 30,  20, 2 );
INSERT INTO relationship ( from_user, to_user, rt_id ) VALUES( 30,  10, 2 );

-- Between a team
INSERT INTO relationship ( from_user, to_user, rt_id ) VALUES( 20, 300, 3 );
INSERT INTO relationship ( from_user, to_user, rt_id ) VALUES( 10, 300, 3 );
INSERT INTO relationship ( from_user, to_user, rt_id ) VALUES( 30, 300, 3 );

-- Granting explicit free/busy permission
INSERT INTO relationship ( from_user, to_user, rt_id ) VALUES( 11,  10, 4 );
INSERT INTO relationship ( from_user, to_user, rt_id ) VALUES( 10,  11, 4 );
