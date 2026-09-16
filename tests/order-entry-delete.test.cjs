const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const source = fs.readFileSync('WebPortal/Scripts/Search/OrderEntry.js', 'utf8');
function fixture() {
  let options, finish, requests = [], alerts = [], removed = [], messages = [], disabled;
  const row = {OrderID:123, CanDelete:true, ClientOrderNo:'ORDER-123', BName:'Borrower <test>', ProjectNumber:'380-001'};
  const $ = () => ({on(){return this;},prop(k,v){disabled=v;return this;},val(){return 'token';},modal(){return this;}});
  $.ajax = o => {requests.push(o); return Promise.resolve({d:1});};
  const Swal = {fire(o){options=o;return new Promise(resolve => {finish=resolve;});},isLoading(){return false;},showValidationMessage(t){messages.push(t);}};
  const c = {console, $, Swal, window:{Swal},Number,JSON};
  vm.createContext(c);vm.runInContext(source,c);
  c.orderentry_table = {row(){return {data:()=>row};},rows(predicate){if(predicate(0,row))removed.push(row.OrderID);return {remove(){return this;},draw(reset){assert.equal(reset,false);}};}};
  c.orderEntryAlert=(...a)=>alerts.push(a);c.orderEntryResetForm=()=>{c.edit_OrderID=0;};
  return {c,row,$,requests,alerts,removed,messages,get options(){return options;},get disabled(){return disabled;},finish:r=>finish(r)};
}
(async()=>{
  let f=fixture(); f.c.delete_order(123,0);
  assert.equal(f.requests.length,0);assert.equal(f.disabled,true);
  assert.match(f.options.text,/ORDER-123/);assert.match(f.options.text,/Borrower <test>/);assert.match(f.options.text,/380-001/);
  assert.equal(f.options.html,undefined); // Untrusted order text is never HTML.
  f.finish({isConfirmed:false});await Promise.resolve();assert.equal(f.requests.length,0);assert.equal(f.disabled,false);
  f=fixture();f.c.delete_order(123,0);const first=f.options;f.c.delete_order(123,0);assert.equal(f.options,first);
  assert.equal(await first.preConfirm(),true);assert.deepEqual(JSON.parse(f.requests[0].data),{OrderID:123});
  assert.equal(f.requests[0].headers['X-Order-Delete-Token'],'token');
  f.c.edit_OrderID=123;f.finish({isConfirmed:true});await Promise.resolve();assert.deepEqual(f.removed,[123]);assert.equal(f.c.edit_OrderID,0);assert.equal(f.alerts[0][0],'success');
  for(const result of [0,-1]) {f=fixture();f.$.ajax=()=>Promise.resolve({d:result});f.c.delete_order(123,0);assert.equal(await f.options.preConfirm(),false);assert.equal(f.removed.length,0);assert.equal(f.messages.length,1);}
  f=fixture();f.$.ajax=()=>Promise.reject(new Error('network'));f.c.delete_order(123,0);assert.equal(await f.options.preConfirm(),false);assert.equal(f.removed.length,0);
  for(const id of [0,-1,1.5,'abc',2147483648,999]) {f=fixture();f.c.delete_order(id,0);assert.equal(f.requests.length,0);assert.equal(f.options,undefined);assert.equal(f.alerts[0][0],'error');}
  f=fixture();f.row.CanDelete=false;f.c.delete_order(123,0);assert.equal(f.options,undefined);
  f=fixture();let edited;f.c.edit_order=(...args)=>{edited=args;};const menu={value:'edit'};f.c.orderEntryAction(menu,123,4);assert.deepEqual(edited,[123,4]);assert.equal(menu.value,'');
  console.log('PASS: edit dispatch, cancel, confirmation details, exact ID/token, success, failure, network error, invalid IDs, unauthorized row, duplicate-dialog guard, and editing-state reset.');
})().catch(e=>{console.error(e);process.exitCode=1;});
