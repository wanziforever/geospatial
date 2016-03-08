--
-- check_postgis_installed
--

\c trjregression

SET client_min_messages TO warning;

-- step 1: Add a column
SELECT trajectory.AddTrajectoryColumns('taxi', 'speed real DEFAULT 0.0');
SELECT trajectory.AddTrajectoryColumns('taxi', 'direction real DEFAULT 0.0 CHECK (direction <= 360)');

-- query it now
\d trajectory.taxi

-- step 2: Append with old function
SELECT trajectory.AppendTrajectory('taxi', 'B124', LOCALTIMESTAMP(2), ST_GeomFromText('POINT(119.4 39.4)', 4326));

-- step 3: Append with new function
SELECT trajectory.AppendTrajectoryWithAttr('taxi', 'B124', LOCALTIMESTAMP(2), ST_GeomFromText('POINT(119.4 39.4)', 4326), '1.1' );
SELECT trajectory.AppendTrajectoryWithAttr('taxi', 'B124', LOCALTIMESTAMP(2), ST_GeomFromText('POINT(119.4 39.4)', 4326), '2.2', '20' );
SELECT trajectory.AppendTrajectoryWithAttr('taxi', 'B124', LOCALTIMESTAMP(2), ST_GeomFromText('POINT(119.4 39.4)', 4326), '3.3', '30', '30' );

-- query it now
SELECT id,time,speed,direction FROM trajectory.taxi ORDER BY id;

-- step 4: Drop a column
SELECT trajectory.DropTrajectoryColumns('taxi', 'speed');

-- query it now
\d trajectory.taxi

-- step 5: Append with new function
SELECT trajectory.AppendTrajectoryWithAttr('taxi', 'B124', LOCALTIMESTAMP(2), ST_GeomFromText('POINT(119.4 39.4)', 4326), '40' );

-- step 6: error test
SELECT trajectory.AppendTrajectoryWithAttr('taxi', 'B124', LOCALTIMESTAMP(2), ST_GeomFromText('POINT(119.4 39.4)', 4326), '500' );

-- query it now
SELECT id,time,direction FROM trajectory.taxi ORDER BY id;
