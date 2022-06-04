SELECT distinct_instances, instances AS total_instances, hwob_count, ror_count, hdob_count, first_case, last_case 
FROM
    (
        SELECT
            COUNT(DISTINCT dbe.case_number) AS distinct_instances,
            COUNT(dbe.case_number) AS instances,
            SUM(CASE WHEN dbe.code = 'HWOB' THEN 1 ELSE 0 END) AS hwob_count,
            SUM(CASE WHEN dbe.code = 'ROR' THEN 1 ELSE 0 END) AS ror_count,
            SUM(CASE WHEN dbe.code = 'HDOB' THEN 1 ELSE 0 END) AS hdob_count,
            MIN(dbe.date) AS first_case,
            MAX(dbe.date) AS last_case 
        FROM
            dscr_bail_events dbe
            INNER JOIN
                dscr_bail_events init 
                ON dbe.case_number = init.case_number 
            INNER JOIN
                (
                    SELECT
                        cases.case_number 
                    FROM
                        cases 
                    WHERE
                        court IN 
                        (
                            SELECT DISTINCT
                                court 
                            FROM
                                cases 
                            WHERE
                                query_court = 'BALTIMORE CITY' 
                        )
                )
                AS ci 
                ON ci.case_number = dbe.case_number 
        WHERE
            init.date >= '2018-10-1' 
            AND init.date < '2018-10-31' 
            AND init.date <= dbe.date 
            AND dbe.date <= init.date + INTERVAL '3 days' 
            AND init.event_name = 'INIT' 
            AND 
            (
                init.code = 'HWOB' 
                OR init.code = 'ROR' 
                OR init.code = 'HDOB'
            )
            AND dbe.event_name = 'BALR' 
    )
    AS everything