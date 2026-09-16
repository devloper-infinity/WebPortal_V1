import sys,copy
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from unittest.mock import Mock
from app import create_app
from scrub.masters import Masters
from waitress import serve
meta=dict(is_active=True,added_by=1,added_date="2026-09-11",updated_by=None,updated_date=None,deleted_date=None,revision=1)
report=dict(meta,id=1,name="ASF",source_sheet="ASF",description="Browser test",display_order=1)
column=dict(meta,id=1,report_type_id=1,header="Originator",expected_letter="E",description="",is_required=False,display_order=1)
rule=dict(meta,id=1,report_type_id=1,column_id=1,code=1,name="Originator Code",description="Missing originator",output_comment="Missing Originator Code",comment_required=True,combine_mode="any",mapping_status="Ready",reason="",group_name="ASF",output_sheet="ASF",output_row=3,fields=[dict(alias="value",column_id=1)],conditions=[dict(id=1,validation_text="Originator is blank",is_active=True,expression={"op":"blank","args":[{"op":"field","name":"value"}]})])
data=dict(reports=[report],columns=[column],rules=[rule],output_targets=Masters.output_targets())
master=Mock();master.lists.side_effect=lambda:copy.deepcopy(data);master.counts.return_value=dict(reports=1,columns=1,rules=1)
def save(kind,body,actor,record_id=None):
 body=copy.deepcopy(body);body.update(id=record_id or 2,added_by=actor,added_date="2026-09-11",updated_by=actor,updated_date="2026-09-11",deleted_date=None,revision=1)
 data[kind]=[r for r in data[kind] if r['id']!=body['id']]+[body]
 return body
master.save.side_effect=save;master.get.side_effect=lambda kind,id:next(r for r in data[kind] if r['id']==id)
repo=Mock();repo.dashboard.return_value=dict(jobs=[],total=0,today=0,completed=0,review_count=0,failed=0)
app=create_app(dict(TESTING=True,SECRET_KEY="browser-fixture-only",SESSION_COOKIE_SECURE=False,REQUIRE_HTTPS=False),repo,lambda *a:dict(employee_id=1,username="Browser test",roles=["Admin"]),master)
serve(app,host="127.0.0.1",port=8018)
