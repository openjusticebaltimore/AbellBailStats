SELECT
  instances AS instances,
  hwob_count,
  round (hwob_count::NUMERIC / instances*100, 1) AS hwob_pc,
  ror_count,
  round(ror_count::NUMERIC / instances*100, 1) AS ror_pc,
  hdob_count,
  round(hdob_count::NUMERIC / instances*100, 1) AS hdob_pc,
  first_case,
  last_case 
FROM
  (
    SELECT
      COUNT(dscr_bail_events.case_number) AS instances,
      SUM(CASE WHEN code = 'HWOB' THEN 1 ELSE 0 END) AS hwob_count,
      SUM(CASE WHEN code = 'ROR' THEN 1 ELSE 0 END) AS ror_count,
      SUM(CASE WHEN code = 'HDOB' THEN 1 ELSE 0 END) AS hdob_count,
      MIN(DATE) AS first_case,
      MAX(DATE) AS last_case 
    FROM
      dscr_bail_events 
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
        ON ci.case_number = dscr_bail_events.case_number 
    WHERE
      DATE >= '2018-1-1' 
      AND DATE < '2018-5-31' 
      AND 
      (
        code = 'HWOB' 
        OR code = 'ROR' 
        OR code = 'HDOB'
      )
      AND event_name = 'BALR'
  )
  AS everything;