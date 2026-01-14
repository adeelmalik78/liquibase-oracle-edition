
create or replace trigger LIQUIBASE_USER.B_U_OTHER_WTHLDG_DECN
   before update on OTHER_WTHLDG_DECN
   for each row
declare
   e_award_type                       exception;
   e_other_wthldg_type                exception;
begin

   if type_package.check_type_cd (:new.award_type_cd,'AWARD_TYPE') = 0  then
         raise e_award_type;
   end if;

   if type_package.check_type_cd (:new.other_wthldg_type_cd,'OTHER_WTHLDG_TYPE') = 0  then
         raise e_other_wthldg_type;
   end if;

   :new.jrn_lctn_id        := global_vars.g_lctn_id;
   :new.jrn_user_id        := global_vars.g_user_id;
   :new.jrn_obj_id         := global_vars.g_obj_id;
   :new.jrn_dt             := SYSDATE;
   :new.jrn_status_type_cd := 'U';

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
      );

exception
   when e_award_type then
      raise_application_error (-20001,'Invalid data for AWARD_TYPE_CD = '
         ||:new.award_type_cd);
   when e_other_wthldg_type then
      raise_application_error (-20001,'Invalid data for OTHER_WTHLDG_TYPE_CD = '
         ||:new.other_wthldg_type_cd);
   when others then
      raise;
end;
/
