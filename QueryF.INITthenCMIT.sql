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
    dbe.event_name = 'INIT' 
    AND dbe.DATE >= '2018-1-1' 
    AND dbe.DATE < '2018-1-31' 
    AND de.event_name = 'CMIT' 
    AND de.DATE >= dbe.DATE 
    AND de.DATE < '2018-2-1' 
    AND dbe.case_number NOT IN 
    (
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
                dscr_bail_events balr 
                ON balr.case_number = ci.case_number 
            INNER JOIN
                dscr_events AS rels 
                ON rels.case_number = ci.case_number 
            INNER JOIN
                dscr_events AS bond 
                ON bond.case_number = ci.case_number 
        WHERE
            dbe.event_name = 'INIT' 
            AND dbe.DATE >= '2018-1-1' 
            AND dbe.DATE < '2018.1.31' 
            AND rels.event_name = 'CMIT' 
            AND rels.DATE >= dbe.DATE 
            AND rels.DATE < '2018-2-1' 
            AND 
            (
                (
                    bond.event_name = 'BOND' 
                    AND bond.DATE >= dbe.DATE 
                    AND bond.DATE < '2018-2-1'
                ) 
                OR 
                (
                    balr.event_name = 'BALR' 
                    AND balr.DATE >= dbe.DATE 
                    AND balr.DATE < '2018-2-1'
                )
            )
    )