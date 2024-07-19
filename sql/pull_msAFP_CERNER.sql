-- Pull AFPNP orders
SELECT
    lpad(P.ALIAS, 10, '0') as EMPI,
      P_MRN.ALIAS as HUP_MRN,
      ORDERS.ORDER_ID,
      CA.ACCESSION,
      ORDER_ALIAS.ALIAS ORDER_ALIAS_number,
      RESULT.TASK_ASSAY_CD,
      CV_order.DISPLAY DTA,
      PERFORM_RESULT.PERFORM_RESULT_ID,
      CV_RS.DISPLAY RESULT_STATUS,
      PERFORM_RESULT.ASCII_TEXT,
      PERFORM_RESULT.RESULT_VALUE_NUMERIC,
      PERFORM_RESULT.RESULT_VALUE_ALPHA,
      PERFORM_RESULT.RESULT_VALUE_DT_TM,
      PERFORM_RESULT.LESS_GREAT_FLAG,
      PERFORM_RESULT.PERFORM_DT_TM, --TODO: fix tz -- CCLSQL_UTC_CNVT(PERFORM_RESULT.PERFORM_DT_TM, 1, 126) as PERFORM_DT_TM,
      PERFORM_RESULT.UPDT_DT_TM RESULT_UPDT_DT_TM,
      CV_SR.DISPLAY SERVICE_RESOURCE,
       PERFORM_RESULT.PARENT_PERFORM_RESULT_ID,
      -- CA.ACCESSION_CONTAINER_NBR NBR,
      -- PERFORM_RESULT.CONTAINER_ID,
      RESULT_EVENT.EVENT_DT_TM,
       RESULT_EVENT.EVENT_TYPE_CD,
      C.DRAWN_DT_TM as DRAWN_DT_TM, -- TODO: fix tz -- CCLSQL_UTC_CNVT(C.DRAWN_DT_TM, 1, 126) as DRAWN_DT_TM, -- This is the "Collected" time,
      C.received_dt_tm as RECEIVED_DT_TM -- TODO: fix tz -- CCLSQL_UTC_CNVT(C.received_dt_tm, 1, 126) as RECEIVED_DT_TM, -- Endocrine receives  ENDOCRINE TIME
      -- PRSNL.NAME_FULL_FORMATTED ORDERING_PROV
FROM RESULT
    join ORDERS
      ON ORDERS.ORDER_ID = RESULT.ORDER_ID
    join ORDER_ALIAS
      ON ORDER_ALIAS.ORDER_ID = ORDERS.ORDER_ID
    join PERSON_ALIAS P
      ON P.PERSON_ID = ORDERS.PERSON_ID
    join PERSON_ALIAS P_MRN
      ON P_MRN.PERSON_ID = ORDERS.PERSON_ID
    inner join PERFORM_RESULT
        ON PERFORM_RESULT.RESULT_ID = RESULT.RESULT_ID
    join CONTAINER_ACCESSION CA
        ON CA.CONTAINER_ID = PERFORM_RESULT.CONTAINER_ID
    join CODE_VALUE CV_order
      ON CV_order.CODE_VALUE = RESULT.TASK_ASSAY_CD
    join CODE_VALUE CV_SR
        ON CV_SR.CODE_VALUE = PERFORM_RESULT.SERVICE_RESOURCE_CD
    join CODE_VALUE CV_RS
        ON CV_RS.CODE_VALUE = PERFORM_RESULT.RESULT_STATUS_CD
    join CONTAINER C
        ON CA.CONTAINER_ID = C.CONTAINER_ID
      inner join V500.RESULT_EVENT
        ON RESULT_EVENT.PERFORM_RESULT_ID = PERFORM_RESULT.PERFORM_RESULT_ID
      -- join ORDER_ACTION OA
        -- ON OA.ORDER_ID = ORDERS.ORDER_ID
      -- join PRSNL
        -- ON OA.ORDER_PROVIDER_ID = PRSNL.PERSON_ID
      WHERE
        ORDERS.ORDER_MNEMONIC = 'AFP'
        AND ORDERS.ACTIVE_IND = 1
        AND P.ACTIVE_IND = 1
            AND P.ALIAS_POOL_CD = 4483934 -- CMRN 4488530 --HUP MRN
        AND P_MRN.ACTIVE_IND = 1
            AND P_MRN.ALIAS_POOL_CD = 4488530 --HUP MRN
        AND PERFORM_RESULT.PERFORM_DT_TM >=  to_date('01-JAN-2020','DD-MON-YYYY')
        AND ORDER_ALIAS.ACTIVE_IND = 1
        AND ORDER_ALIAS.END_EFFECTIVE_DT_TM > SYSDATE
          -- AND COMMUNICATION_TYPE_CD = 637915 -- Chosen by guess
         AND RESULT_EVENT.EVENT_TYPE_CD IN (1738, 1723) -- NOT 1733 -- performed
;

--Pull pending
SELECT
    lpad(P.ALIAS, 10, '0') as EMPI,
      P_MRN.ALIAS as HUP_MRN,
      ORDERS.ORDER_ID,
--       CA.ACCESSION,
      ORDER_ALIAS.ALIAS ORDER_ALIAS_number,
      RESULT.TASK_ASSAY_CD,
      CV_order.DISPLAY DTA
      -- PERFORM_RESULT.PERFORM_RESULT_ID,
      CV_RS.DISPLAY RESULT_STATUS,
      PERFORM_RESULT.ASCII_TEXT,
      -- PERFORM_RESULT.RESULT_VALUE_NUMERIC,
      PERFORM_RESULT.RESULT_VALUE_ALPHA,
      -- PERFORM_RESULT.RESULT_VALUE_DT_TM,
      -- PERFORM_RESULT.LESS_GREAT_FLAG,
      PERFORM_RESULT.PERFORM_DT_TM, --TODO: fix tz -- CCLSQL_UTC_CNVT(PERFORM_RESULT.PERFORM_DT_TM, 1, 126) as PERFORM_DT_TM,
      PERFORM_RESULT.UPDT_DT_TM RESULT_UPDT_DT_TM,
      CV_SR.DISPLAY SERVICE_RESOURCE
       PERFORM_RESULT.PARENT_PERFORM_RESULT_ID,
      -- CA.ACCESSION_CONTAINER_NBR NBR,
      -- PERFORM_RESULT.CONTAINER_ID,
      -- RESULT_EVENT.EVENT_DT_TM EVENT_DTTM,
--       C.DRAWN_DT_TM as DRAWN_DT_TM, -- TODO: fix tz -- CCLSQL_UTC_CNVT(C.DRAWN_DT_TM, 1, 126) as DRAWN_DT_TM, -- This is the "Collected" time,
--       C.received_dt_tm as RECEIVED_DT_TM -- TODO: fix tz -- CCLSQL_UTC_CNVT(C.received_dt_tm, 1, 126) as RECEIVED_DT_TM, -- Endocrine receives  ENDOCRINE TIME
      -- PRSNL.NAME_FULL_FORMATTED ORDERING_PROV
FROM RESULT
    join ORDERS
      ON ORDERS.ORDER_ID = RESULT.ORDER_ID
    join ORDER_ALIAS
      ON ORDER_ALIAS.ORDER_ID = ORDERS.ORDER_ID
    join PERSON_ALIAS P
      ON P.PERSON_ID = ORDERS.PERSON_ID
    join PERSON_ALIAS P_MRN
      ON P_MRN.PERSON_ID = ORDERS.PERSON_ID
    left join PERFORM_RESULT
        ON PERFORM_RESULT.RESULT_ID = RESULT.RESULT_ID
--     join CONTAINER_ACCESSION CA
--         ON CA.CONTAINER_ID = PERFORM_RESULT.CONTAINER_ID
    join CODE_VALUE CV_order
      ON CV_order.CODE_VALUE = RESULT.TASK_ASSAY_CD
    left join CODE_VALUE CV_SR
--         ON CV_SR.CODE_VALUE = PERFORM_RESULT.SERVICE_RESOURCE_CD
    left join CODE_VALUE CV_RS
--         ON CV_RS.CODE_VALUE = PERFORM_RESULT.RESULT_STATUS_CD
--     join CONTAINER C
--         ON CA.CONTAINER_ID = C.CONTAINER_ID
      -- inner join V500.RESULT_EVENT
      --   ON RESULT_EVENT.PERFORM_RESULT_ID = PERFORM_RESULT.PERFORM_RESULT_ID
      -- join ORDER_ACTION OA
        -- ON OA.ORDER_ID = ORDERS.ORDER_ID
      -- join PRSNL
        -- ON OA.ORDER_PROVIDER_ID = PRSNL.PERSON_ID
      WHERE
        ORDERS.ORDER_MNEMONIC = 'AFP'
        AND ORDERS.ACTIVE_IND = 1
        AND P.ACTIVE_IND = 1
            AND P.ALIAS_POOL_CD = 4483934 -- CMRN 4488530 --HUP MRN
        AND P_MRN.ACTIVE_IND = 1
            AND P_MRN.ALIAS_POOL_CD = 4488530 --HUP MRN
        -- AND PERFORM_RESULT.PERFORM_DT_TM >=  to_date('01-JAN-2020','DD-MON-YYYY')
        AND ORDER_ALIAS.ACTIVE_IND = 1
        AND ORDER_ALIAS.END_EFFECTIVE_DT_TM > SYSDATE
        AND CV_order.DISPLAY = 'AFPI'
          -- AND COMMUNICATION_TYPE_CD = 637915 -- Chosen by guess
--         AND RESULT_EVENT.EVENT_TYPE_CD = 1733 -- performed
;

--Look at specific order
-- ORDER_ID = 2294514259

SELECT
     ORDERS.ORDER_ID,
     CA.ACCESSION,
       RESULT.TASK_ASSAY_CD,
       PERFORM_RESULT.RESULT_VALUE_NUMERIC,
       PERFORM_RESULT.RESULT_VALUE_ALPHA,
       PERFORM_RESULT.RESULT_STATUS_CD,
       PERFORM_RESULT.ASCII_TEXT,
        PERFORM_RESULT.PERFORM_DT_TM,
       PERFORM_RESULT.UPDT_DT_TM,
       PERFORM_RESULT.*
       --        PERFORM_RESULT.ASCII_TEXT,
--       PERFORM_RESULT.RESULT_VALUE_NUMERIC,
--       PERFORM_RESULT.RESULT_VALUE_ALPHA,
--       PERFORM_RESULT.LESS_GREAT_FLAG,
--       PERFORM_RESULT.PERFORM_DT_TM --TODO: fix tz -- CCLSQL_UTC_CNVT(PERFORM_RESULT.PERFORM_DT_TM, 1, 126) as PERFORM_DT_TM,
FROM RESULT
    join ORDERS
      ON ORDERS.ORDER_ID = RESULT.ORDER_ID
    inner join PERFORM_RESULT
        ON PERFORM_RESULT.RESULT_ID = RESULT.RESULT_ID
    inner join CONTAINER_ACCESSION CA
        ON CA.CONTAINER_ID = PERFORM_RESULT.CONTAINER_ID
WHERE
    ORDERS.ORDER_ID = 2964604421
    AND TASK_ASSAY_CD = 4607194
--     CA.ACCESSION = '0000020'
    AND ORDERS.ACTIVE_IND = 1
;

select *
from WORKLIST
where
--       rownum < 1000
        WORKLIST_ID = '659401749'
order by WORKLIST_DT_TM desc

--       upper(WORKLIST_ALIAS) LIKE '%ENDO%'

;

select CV_order.DISPLAY DTA,
       WORKLIST_ELEMENT.*
from WORKLIST_ELEMENT
join CODE_VALUE CV_order
      ON CV_order.CODE_VALUE = WORKLIST_ELEMENT.TASK_ASSAY_CD
where
--       TASK_ASSAY_CD = 4607194
--       CV_order.DISPLAY = 'AFP'
    WORKLIST_ID = '659401749'
;
select *
from WORKLIST_ELEMENTS
;

select *
from WORKLIST_ORDER_R
where WORKLIST_ID = '659401749'
ORDER BY SEQUENCE
;

select *
from WORKLIST_EVENT
-- where WORKLIST_ID = '659401749'
order by EVENT_DT_TM desc
;

