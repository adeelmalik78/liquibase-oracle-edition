--liquibase formatted sql

--changeset EvanLiao:rfac_ci_202409.204.1.1 labels:rfac_ci_202409 context:DBATEST runOnChange:true
--comment create or replace trigger B_D_OTHER_WTHLDG_DECN for adding the two new columns

create or replace trigger LIQUIBASE_USER.B_D_OTHER_WTHLDG_DECN
   before delete on OTHER_WTHLDG_DECN
   for each row
declare
      e_invalid_userinfo              exception;
begin
   if (global_vars.g_lctn_id is null or 
       global_vars.g_user_id is null OR  
       global_vars.g_obj_id is null) then
      raise e_invalid_userinfo;
   end if;

   insert into JRN_OTHER_WTHLDG_DECN(
       ptcpnt_id_a
      ,ptcpnt_id_b
      ,award_type_cd
      ,decn_dt
      ,begin_dt
      ,other_wthldg_type_cd
      ,other_wthldg_amt
      ,invld_decn_dt
      ,end_dt
      ,decn_id
      ,jrn_dt
      ,jrn_lctn_id
      ,jrn_user_id
      ,jrn_status_type_cd
      ,jrn_obj_id
      ,other_wthldg_reason_descp_txt
      ,total_over_pymt_amt
      ,total_non_recoup_amt
      )
   values (
       :old.ptcpnt_id_a
      ,:old.ptcpnt_id_b
      ,:old.award_type_cd
      ,:old.decn_dt
      ,:old.begin_dt
      ,:old.other_wthldg_type_cd
      ,:old.other_wthldg_amt
      ,:old.invld_decn_dt
      ,:old.end_dt
      ,:old.decn_id
      ,:old.jrn_dt
      ,:old.jrn_lctn_id
      ,:old.jrn_user_id
      ,:old.jrn_status_type_cd
      ,:old.jrn_obj_id
      ,:old.other_wthldg_reason_descp_txt
      ,:old.total_over_pymt_amt
      ,:old.total_non_recoup_amt
      );
   insert into JRN_OTHER_WTHLDG_DECN(
       ptcpnt_id_a
      ,ptcpnt_id_b
      ,award_type_cd
      ,decn_dt
      ,begin_dt
      ,other_wthldg_type_cd
      ,other_wthldg_amt
      ,invld_decn_dt
      ,end_dt
      ,decn_id
      ,jrn_dt
      ,jrn_lctn_id
      ,jrn_user_id
      ,jrn_status_type_cd
      ,jrn_obj_id
      ,other_wthldg_reason_descp_txt
      ,total_over_pymt_amt
      ,total_non_recoup_amt
      )
   values (
       :old.ptcpnt_id_a
      ,:old.ptcpnt_id_b
      ,:old.award_type_cd
      ,:old.decn_dt
      ,:old.begin_dt
      ,:old.other_wthldg_type_cd
      ,:old.other_wthldg_amt
      ,:old.invld_decn_dt
      ,:old.end_dt
      ,:old.decn_id
      ,SYSDATE
      ,global_vars.g_lctn_id
      ,global_vars.g_user_id
      ,'D'
      ,global_vars.g_obj_id
      ,:old.other_wthldg_reason_descp_txt
      ,:old.total_over_pymt_amt
      ,:old.total_non_recoup_amt
      );

exception
   when e_invalid_userinfo then
      raise_application_error (-20002,'Invalid User Information');
   when others then
      raise;
end;
/
