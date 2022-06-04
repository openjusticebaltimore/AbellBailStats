SELECT DISTINCT
    dbe.case_number 
FROM
    dscr_bail_events dbe 
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
    INNER JOIN
        dscr_events AS de 
        ON ci.case_number = de.case_number 
WHERE
    dbe.event_name = 'BALR' 
    AND dbe.DATE >= '2018-1-1' 
    AND dbe.DATE < '2018-1-31' 
    AND de.event_name = 'BOND' 
    AND de.DATE >= dbe.DATE 
    AND de.DATE <= dbe.DATE + INTERVAL '5 days'