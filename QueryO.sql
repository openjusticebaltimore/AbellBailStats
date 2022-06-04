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
    dbe.event_name = 'BALR' 
    AND dbe.date >= '2018-10-1' 
    AND dbe.date < '2018-10-31' 
    AND de.event_name = 'BOND' 
    AND de.date >= dbe.date 
    AND de.date <= dbe.date + INTERVAL '5 days' 
    AND de.case_number IN 
    (
        SELECT
            balr.case_number 
        FROM
            dscr_bail_events balr 
            INNER JOIN
                dscr_bail_events init 
                ON balr.case_number = init.case_number 
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
                ON ci.case_number = balr.case_number 
        WHERE
            init.date >= '2018-10-1' 
            AND init.date < '2018-10-31' 
            AND init.date <= balr.date 
            AND balr.date <= init.date + INTERVAL '5 days' 
            AND init.event_name = 'INIT' 
            AND 
            (
                init.code = 'HWOB' 
                OR init.code = 'ROR' 
                OR init.code = 'HDOB' 
            )
            AND balr.event_name = 'BALR' 
    )