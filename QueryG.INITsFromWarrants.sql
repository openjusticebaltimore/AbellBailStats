SELECT DISTINCT
    dbe.case_number 
FROM
    dscr_events de 
    INNER JOIN
        dscr_bail_events AS dbe 
        ON dbe.case_number = de.case_number 
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
        ON ci.case_number = de.case_number 
WHERE
    de.event_name = 'WARS' 
    AND dbe.event_name = 'INIT' 
    AND dbe.DATE >= '2018-1-1' 
    AND dbe.DATE < '2018-1-31' 
    AND de.DATE <= dbe.DATE