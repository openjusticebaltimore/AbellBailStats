SELECT
    * 
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
        ON ci.case_number = dbe.case_number 
WHERE
    dbe.event_name = 'INIT' 
    AND dbe.code = 'HDOB' 
    AND dbe.DATE >= '2018-1-1' 
    AND dbe.DATE < '2018-6-30' 
    AND de.event_name = 'BOND' 
    AND de.DATE >= dbe.DATE 
    AND de.DATE <= '2018-7-2' 
    AND dbe.case_number NOT IN 
    (
        SELECT
            case_number 
        FROM
            dscr_bail_events 
        WHERE
            event_name = 'BALR' 
            AND DATE >= '2018-1-1' 
            AND DATE < '2018-7-2' 
    )