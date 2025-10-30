-- PROCEDURE: teenpay.get_person(json, json)

-- DROP PROCEDURE IF EXISTS teenpay.get_person(json, json);

CREATE OR REPLACE PROCEDURE teenpay.get_person(
	IN pi_data json,
	INOUT po_data json)
LANGUAGE 'plpgsql'
    SECURITY DEFINER 
AS $BODY$
DECLARE
  v_id bigint;
BEGIN
  v_id := nullif((pi_data->>'ID')::bigint, 0);

  IF v_id IS NULL THEN
  po_data := json_build_object('status','bad_request','message','ID is required');
  RETURN;
END IF;

  SELECT row_to_json(u) INTO po_data
  FROM teenpay.users u
  WHERE u.id = v_id;

END;
$BODY$;
ALTER PROCEDURE teenpay.get_person(json, json)
    OWNER TO postgres;

COMMENT ON PROCEDURE teenpay.get_person(json, json)
    IS 'Get persons data by ID';
