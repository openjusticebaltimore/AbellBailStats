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
    (
        dbe.event_name = 'INIT' 
        AND dbe.code = 'HDOB' 
        AND dbe.DATE >= '2018-1-1' 
        AND dbe.DATE < '2018-5-31' 
        AND de.event_name = 'BOND' 
        AND de.DATE >= dbe.DATE 
        AND de.DATE <= '2018-2-2'
    )
    AND dbe.case_number NOT IN 
    (
        SELECT
            case_number 
        FROM
            dscr_bail_events 
        WHERE
            event_name = 'BALR' 
            AND DATE >= '2018-1-2' 
            AND DATE < '2018-2-2'
    )